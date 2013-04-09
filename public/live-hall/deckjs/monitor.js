$(function(){
    var roomId = $('[data-room]').data('room')
    var liveUrl = "/view/" + roomId + "/progress"

    $(document).bind('deck.change', function(event, from, to) {

        var data = {
            from: from,
            to: to
        };

        $.post(liveUrl, data);
    });
})
