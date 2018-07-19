require 'diffy'

class RepoDiff

  @cache_dir = "#{Rails.root}/tmp/foo"
  @pre_dir = "original"
  @post_dir = "updated"

  def self.run
    @output = []

    # What path are we running a diff against?
    path = ".repos"

    # Generate before
    self.generate(path, @pre_dir)
    # Update the repos
    Repos.update
    # Generate after
    self.generate(path, @post_dir)

    # Perform a diff between each file
    self.run_diff(path)
    self.check_for_new_files(path)

    self.report_cli
  end

  def self.run_diff(path)
    files = Dir.glob("#{@cache_dir}/#{@pre_dir}/#{path}/**/*").select { |file_name| File.file?(file_name) }

    files.each do |f|
      rel_path = f.gsub("#{@cache_dir}/#{@pre_dir}/", "")

      base_document = "#{@cache_dir}/#{@pre_dir}/#{rel_path}"
      compare_document = "#{@cache_dir}/#{@post_dir}/#{rel_path}"

      diff_response = Diffy::Diff.new(base_document, compare_document, context: 0, source: 'files').to_s("text")
      unless diff_response.empty? || diff_response == "\n"
        @output << {
          path: rel_path,
          diff: diff_response,
        }
      end
    end
  end

  def self.check_for_new_files(path)
    # It may be the case that something was added. We need to check if it exists in post_dir but not pre_dir
    files = Dir.glob("#{@cache_dir}/#{@post_dir}/#{path}/**/*").select { |file_name| File.file?(file_name) }
    files.each do |f|
      rel_path = f.gsub("#{@cache_dir}/#{@post_dir}/", "")

      base_document = "#{@cache_dir}/#{@pre_dir}/#{rel_path}"
      compare_document = "#{@cache_dir}/#{@post_dir}/#{rel_path}"
      unless File.exist?(base_document)
        @output << {
          path: rel_path,
          diff: "- \n+ #{File.read(compare_document).split("\n").join("\n+ ")}"
        }
      end
    end

  end

  def self.generate(path, mode)

    diff_dir = "#{@cache_dir}/#{mode}"

    # Delete the old diff directory if it exists
    # We use force here to prevent an exception if the dir doesn't exist
    FileUtils.rm_r diff_dir, :force => true

    ####################################################
    # We're now in a position to start running things!
    ####################################################

    # Grab all files (and files only)
    files = Dir.glob("#{Rails.root}/#{path}/**/*").select { |file_name| File.file?(file_name) }

    # Make a copy of each file (we *could* run through the markdown pipeline, but we don't need to yet)
    files.each do |f|
      next unless f.include? ("nexmo-php-quickstart")
      # Remove the base path
      rel_path = f.gsub("#{Rails.root}", "")

      # Get the directory name and ensure the same path exists in our diff directory
      fp = File.dirname(rel_path)
      fn = File.basename(rel_path)
      FileUtils.mkdir_p "#{diff_dir}/#{fp}"

      # Copy the file
      FileUtils.cp(f, "#{diff_dir}/#{fp}/#{fn}")
    end
  end


  def self.report_cli
    if @output.any?
      puts "#{@output.size} changes detected".colorize(:light_red)
      @output.reject.each do |result|
        puts <<~HEREDOC
#{result[:path]}
#{result[:diff]}
        HEREDOC
      end

      exit 1
    else
      puts 'No changes detected'.colorize(:green)
    end
  end
end
