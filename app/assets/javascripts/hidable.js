loadFunctions.push(function(){
  Hidable = {};
  Hidable.titleCss = {
    float: "left",
    lineHeight: "19px",
    fontSize: "18px",
    paddingLeft: 10,
    marginTop: -5,
    userSelect: "none",
    cursor: "default",
  };
  Hidable.buttonTable = $("<div />", {
    class: "button-table"
  }).css({
    marginTop: -12,
    display: "table",
    float: "right"
  }).css({
    overflow: "hidden",
    userSelect: "none",
    fontSize: "14px"
  });
  Hidable.closeButton = $("<i />", {
    class: "material-icons clickable-icon close-button",
    text: "clear"
  }).css({
    cursor: "pointer",
    verticalAlign: "sub"
  });
  Hidable.minimizeButton = $("<i />", {
    class: "material-icons clickable-icon minimize-button",
    text: "remove"
  }).css({
    cursor: "pointer",
    verticalAlign: "middle"
  });
  Hidable.minimize = function(element){
    element.removeClass("max").addClass("min");
    var buttonTable = element.children(".button-table"),
        hidableTitle = element.children(".hidable-title");
    var closeButton = buttonTable.children(".close-button"),
        minimizeButton = buttonTable.children(".minimize-button");
    buttonTable.css({
      marginTop: -12
    })
    closeButton.css({
      verticalAlign: "middle"
    });
    minimizeButton.css({
      verticalAlign: "sub"
    });
    buttonTable.nextAll(":not(.hidable-title)").hide();
    element.animate({
      height: 29
    });
    if(parseInt(widthTester.css("width")) < 363){
      hidableTitle.off("click");
      hidableTitle.on("click", function(event){ maximize(element); });
    }else{
      minimizeButton.off("click");
      minimizeButton.on("click", function(){ maximize(element) });
    }
  };
  Hidable.maximize = function(element){
    element.removeClass("min").addClass("max");
    var buttonTable = element.children(".button-table"),
        hidableTitle = element.children(".hidable-title");
    var closeButton = buttonTable.children(".close-button"),
        minimizeButton = buttonTable.children(".minimize-button"),
        content = element.children(":not(.hidable-title):not(.button-table)");
    buttonTable.css({
      marginTop: -7
    })
    closeButton.css({
      verticalAlign: "sub"
    });
    minimizeButton.css({
      verticalAlign: "middle"
    });
    buttonTable.nextAll().show();
    element.animate({
      height: 29+content.outerHeight()
    }, 1000, "easeOutExpo");
    if(parseInt(widthTester.css("width")) < 363){
      hidableTitle.off("click");
      hidableTitle.on("click", function(event){ minimize(element); });
    }else{
      minimizeButton.off("click");
      minimizeButton.on("click", function(){ minimize(element); });
    }
  };
  Hidable.destroy = function(element){
    element.remove();
  };
  Hidable.size = function(element){
    var buttonTable = element.children(".button-table"),
        hidableTitle = element.children(".hidable-title");
    var closeButton = buttonTable.children(".close-button"),
        minimizeButton = buttonTable.children(".minimize-button");
    if(parseInt(widthTester.css("width")) < 363){
      buttonTable.hide();
      hidableTitle.css({
        paddingLeft: 0,
        width: "100%"
      });
      minimizeButton.off("click");
      closeButton.off("click");
    }else{
      buttonTable.show();
      hidableTitle.css({
        paddingLeft: 10,
        width: "calc(100% - 49px)"
      });
      hidableTitle.off("click");
      minimizeButton.off("click").on("click", function(event){ minmax(element); });
      closeButton.off("click").on("click", function(event){ destroy(element); });
    }
    hidableTitle.off("click").on("click", function(event){ minmax(element); });
    resize(element);
  };
  Hidable.switch = function(element){
    if((element).hasClass("max")){
      minimize(element);
    }else if(element.hasClass("min")){
      maximize(element);
    }
  };
  Hidable.resize = function(element){
    if((element).hasClass("min")){
      minimize(element);
    }else if(element.hasClass("max")){
      maximize(element);
    }
  };

  $(".destroyable").each(function(){
    var destroyable = $(this);
    destroyable.append(Hidable.buttonTable.clone().append(Hidable.closeButton.clone()).css({
      marginTop: 2
    }));
    sizeHidable(destroyable);
    $(window).resize(function(){ sizeHidable(destroyable); });
  })

  $(".hidable").each(function(){
    var hidable = $(this);
    hidable.children(".hidable-title").css(Hidable.titleCss);
    hidable.prepend(buttonTable.clone().append(minimizeButton.clone()).append(closeButton.clone()));
    sizeHidable(hidable);
    minmax(hidable);
    $(window).resize(function(){ sizeHidable(hidable) });
    if(hidable.is("[associated-field]")){
      $("#"+hidable.attr("associated-field")).on("keyup.hidable", function(event){
        pauseEvent(event);
        if(event.keyCode !== 13 && hidable.hasClass("min")){
          maximize(hidable);
        }
      })
    }
  }
});