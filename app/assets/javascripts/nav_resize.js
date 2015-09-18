loadFunctions.push(function(){
  var size = function(){
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
  
  size();

  $(window).resize(size);
});