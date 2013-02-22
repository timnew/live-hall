(function(){
    var roomId = $('[data-room]').data('room')
    var liveUrl = "/live/" + roomId

    Reveal.addEventListener( 'slidechanged', function(e) {
        var data = {
          h: e.indexh,
          v: e.indexv
        };

        $.post(liveUrl, data);
    });
})();

