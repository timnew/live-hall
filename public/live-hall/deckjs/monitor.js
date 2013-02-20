$(document).bind('deck.change', function(event, from, to) {
   data = {
     from: from,
     to: to
   };

   $.post('/live', data);
});