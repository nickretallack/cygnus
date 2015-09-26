readyFunctions.push(function(){
  source = new EventSource("/message_listener")
  source.onmessage = function(event){
    $("#comments").append(event.data);
  };
});