widthTester = $(".widthTester");

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

function hideAndShow(element){
  if(element === undefined){
    $(".nojs").hide();
    $(".js").show();
  }else{
    element.find(".nojs").hide();
    element.find(".js").show();
  }
}

readyFunctions.push(hideAndShow);

function doRemote(element){
  if(element === undefined){
    $(".remote").attr("data-remote", "true")
  }else{
    if(element.hasClass("remote")) element.attr("data-remote", "true");
  }
}

readyFunctions.push(doRemote);