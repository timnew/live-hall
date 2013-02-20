(function(){
    Reveal.addEventListener( 'slidechanged', function(e) {
        var data = {
          h: e.indexh,
          v: e.indexv
        };

        $.post('/live', data);
    });
})();

