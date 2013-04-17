$(function () {
    var currentPage;

    $(document).bind('deck.change', function (event, from, to) {
        currentPage = to;
    });

    var roomId = $('[data-room]').data('room')
    var liveUrl = "/view/" + roomId + "/progress"

    var source = new EventSource(liveUrl);
    source.addEventListener('message', function (e) {
        data = JSON.parse(e.data)
        console.log("SSE: [" + e.type + "] " + e.data);
        page = parseInt(data.to, 10);
        if (data.to != currentPage) {
            $.deck('go', page);
        }
    });

    source.addEventListener('refresh', function(e) {
        window.location.reload(true);
    });
});
