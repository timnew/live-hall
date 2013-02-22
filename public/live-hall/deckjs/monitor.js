$(function(){
    var roomId = $('[data-room]').data('room')
    var liveUrl = "/live/" + roomId

    $(document).bind('deck.change', function(event, from, to) {

        var data = {
            from: from,
            to: to
        };

        $.post(liveUrl, data);
    });
})
