$(document).bind('deck.change', function(event, from, to) {
   var data = {
     from: from,
     to: to
   };

   $.post('/live', data);
});