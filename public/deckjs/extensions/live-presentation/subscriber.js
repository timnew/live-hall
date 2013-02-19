$(function(){
  var source = new EventSource('/live');
  source.addEventListener('message', function (e){
    data = JSON.parse(e.data)
    console.log("SSE: [" + e.type + "] "+ e.data);
    page = parseInt(data.to, 10);
    $.deck('go', page);
  });
});
