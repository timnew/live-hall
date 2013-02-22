(function () {
    var roomId = $('[data-room]').data('room')
    var liveUrl = "/live/" + roomId

    var source = new EventSource(liveUrl);

    source.addEventListener('message', function (e) {
        data = JSON.parse(e.data)
        console.log("SSE: [" + e.type + "] " + e.data);

        Reveal.slide(data.h, data.v);
    });
})();
