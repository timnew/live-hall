(function () {
    var source = new EventSource('/live');
    source.addEventListener('message', function (e) {
        data = JSON.parse(e.data)
        console.log("SSE: [" + e.type + "] " + e.data);

        Reveal.slide(data.h, data.v);
    });
})();
