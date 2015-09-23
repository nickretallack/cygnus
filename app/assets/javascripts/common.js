var readyFunctions = [],
    loadFunctions = [];

$(document).on("page:load", function(){
  ready();
  load();
});

$(document).ready(ready);

$(window).load(load);

function ready(){
  $.each(readyFunctions, function(index, func){ func(); });
}

function load(){
  $.each(loadFunctions, function(index, func){ func(); });
}

function pauseEvent(event){
  if(event.stopPropagation) event.stopPropagation();
  if(event.preventDefault) event.preventDefault();
  event.cancelBubble = true;
  event.returnValue = false;
}

function hideAndShow(){
  $(".nojs").hide();
  $(".js").show();
}

readyFunctions.push(hideAndShow);

readyFunctions.push(function(){
  $(".expandable").find("img").addClass("materialboxed").attr("height", "400").css("max-height", "none");
});
