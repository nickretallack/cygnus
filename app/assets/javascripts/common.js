var readyFunctions = [];

$(window).load(size);

$(document).load(ready);

$(document).on("page:load", ready);

$(document).ready(ready);

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
}

readyFunctions.push(size);

function ready(){
  $.each(readyFunctions, function(index, func){ func(); });
}

function pauseEvent(event){
  if(event.stopPropagation) event.stopPropagation();
  if(event.preventDefault) event.preventDefault();
  event.cancelBubble = true;
  event.returnValue = false;
}

readyFunctions.push(function(){
  var nav = $("nav"),
      banner = $("header").children("img"),
      menu = $("li").children(".dropdown-button"),
      sideMenu = $(".button-collapse"),
      logo = $(".brand-logo"),
      widthTester = $(".widthTester"),
      gallery = $(".gallery"),
      galleryTable = $(".gallery").children("table");

  $(".nojs").hide();
  $(".js").show();

  menu.dropdown({
    belowOrigin: true,
    hover: true,
    constrain_width: false
  });

  $(window).keydown(function(event){
    if(event.keyCode === 27) sideMenu.sideNav("hide");
  });

  sideMenu.sideNav();

  var pushpinNav = function(){
    if($(window).scrollTop() > banner.outerHeight())
    {
      $("nav").css({
        position: "fixed",
        top: 0
      });
    }else if($(window).scrollTop() === 0){
      $("nav").css({
        position: "relative",
        top: "auto"
      });
    }
  };

  pushpinNav();

  $(window).scroll(pushpinNav);

  $(window).resize(size);
});