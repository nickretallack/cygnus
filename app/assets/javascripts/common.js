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

function size(){
  var nav = $("nav"),
      banner = $("header").children("img"),
      logo = $(".brand-logo"),
      widthTester = $(".widthTester");

  switch(widthTester.css("width")){
    case "601px":  //medium
      nav.height(banner.outerHeight());
      logo.width(nav.height()*3);
      break;
    case "993px":  //large
      nav.height(banner.outerHeight() / 1.5);
      logo.width(nav.height()*3);
      break;
    case "1921px": //very large
      nav.height(banner.outerHeight() / 2);
      logo.width(nav.height()*3);
      break;
  }
};

loadFunctions.push(function(){
  size();

  $(window).resize(size);

  // $(".dropdown-button").off("click");
});

readyFunctions.push(function(){
  $(".nojs").hide();
  $(".js").show();
});