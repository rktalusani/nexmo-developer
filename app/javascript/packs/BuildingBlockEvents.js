export default () => {
    let hasTriggeredCopyStat = {};
    let hasTriggeredLinkStat = {};

    // Track copy to clipboard usage
    var clipboard = new Clipboard('.copy-button',{
        text: function(trigger) {
            const lang = $(trigger).attr("data-lang");
            return $(".copy-to-clipboard." + lang).text();
        }
    });

    clipboard.on('success', function(e) {
        let trigger = $(e.trigger);

        let params = {
            "language": trigger.attr("data-lang"),
            "block": trigger.attr("data-block"),
            "event": "copy"
        };

        // We only want to track each copy once per page load
        if (hasTriggeredCopyStat[params['language']]) { return true; }

        trigger.find('span').text('Copied');

        fetch(createRequest(params))
            .then((response) => {
                if (response.ok) { return response.json() }
                return Promise.reject({ message: 'Bad response from server', response })
            })
            .then((payload) => {
                hasTriggeredCopyStat[params['language']] = true;
            })
    });


    clipboard.on('error', function(e) {
        console.error('Action:', e.action);
        console.error('Trigger:', e.trigger);
    });

    // Track source link usage
    $(document).on('mousedown', '.source-link', function(e){
        if (e.which === 3) { return; }
        let trigger = $(this);

        let type = trigger.attr("data-type");

        let params = {
            "language": trigger.attr("data-lang"),
            "block": trigger.attr("data-block"),
            "event": "source-" + type
        };

        hasTriggeredLinkStat[params['language']] = hasTriggeredLinkStat[params['language']] || {};

        if (hasTriggeredLinkStat[params['language']][type]) { return true; }

        fetch(createRequest(params))
            .then((response) => {
                if (response.ok) { return response.json() }
                return Promise.reject({ message: 'Bad response from server', response })
            })
            .then((payload) => {
                hasTriggeredLinkStat[params['language']][type] = true;
            })
    });
};

function createRequest(params) {
    return new Request('/usage/building_block', {
        method: 'POST',
        credentials: 'same-origin',
        body: JSON.stringify(params),
        headers: {
            'Content-Type': 'application/json'
        }
    });
}
