loadFunctions.push(function(){
  var widthTester = $(".widthTester"),
      hidable = $(".hidable"),
      destroyable = $(".destroyable"),
      buttonTable = $("<div />", {
        class: "button-table"
      }).css({
        marginTop: -12,
        display: "table",
        float: "right"
      }).css({
        overflow: "hidden",
        userSelect: "none",
        fontSize: "14px"
      }),
      closeButton = $("<i />", {
        class: "material-icons clickable-icon close-button",
        text: "clear"
      }).css({
        cursor: "pointer",
        verticalAlign: "sub"
      }),
      minimizeButton = $("<i />", {
        class: "material-icons clickable-icon minimize-button",
        text: "remove"
      }).css({
        cursor: "pointer",
        verticalAlign: "middle"
      }),
      minimize = function(element){
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
        element.css({
          height: 29
        });
        if(parseInt(widthTester.css("width")) < 363){
          hidableTitle.off("click");
          hidableTitle.on("click", function(event){ maximize(element); });
        }else{
          minimizeButton.off("click");
          minimizeButton.on("click", function(){ maximize(element) });
        }
      },
      maximize = function(element){
        element.removeClass("min").addClass("max");
        var buttonTable = element.children(".button-table"),
            hidableTitle = element.children(".hidable-title");
        var closeButton = buttonTable.children(".close-button"),
            minimizeButton = buttonTable.children(".minimize-button");
        buttonTable.css({
          marginTop: -7
        })
        closeButton.css({
          verticalAlign: "sub"
        });
        minimizeButton.css({
          verticalAlign: "middle"
        });
        buttonTable.nextAll(":not(.hidable-title)").show();
        element.css({
          height: "auto"
        });
        if(parseInt(widthTester.css("width")) < 363){
          hidableTitle.off("click");
          hidableTitle.on("click", function(event){ minimize(element); });
        }else{
          minimizeButton.off("click");
          minimizeButton.on("click", function(){ minimize(element); });
        }
      },
      destroy = function(element){
        element.remove();
      },
      sizeHidable = function(element){
        var buttonTable = element.children(".button-table"),
            hidableTitle = element.children(".hidable-title");
        var closeButton = buttonTable.children(".close-button"),
            minimizeButton = buttonTable.children(".minimize-button");
        if(parseInt(widthTester.css("width")) < 363){
          buttonTable.hide();
          hidableTitle.css({
            paddingLeft: 0
          });
          hidableTitle.off("click").on("click", function(event){ minmax(element); });
          minimizeButton.off("click");
          closeButton.off("click");
        }else{
          buttonTable.show();
          hidableTitle.css({
            paddingLeft: 10
          });
          hidableTitle.off("click");
          minimizeButton.off("click").on("click", function(event){ minmax(element); });
          closeButton.off("click").on("click", function(event){ destroy(element); });
        }
      },
      minmax = function(element){
        if((element).hasClass("max")){
          minimize(element);
        }else if(element.hasClass("min")){
          maximize(element);
        }
      };

  hidable.prepend(buttonTable.clone().append(minimizeButton.clone()).append(closeButton.clone()));
  destroyable.append(buttonTable.clone().append(closeButton.clone()).css({
    marginTop: 2
  }));

  $.each(hidable, function(index, element){
    var hidable = $(element),
        height = hidable.outerHeight();
    hidable.children(".hidable-title").css({
        float: "left",
        lineHeight: "19px",
        fontSize: "18px",
        paddingLeft: 10,
        marginTop: -5,
        userSelect: "none",
        cursor: "default"
      });
    
    sizeHidable(hidable);
    minmax(hidable);
    $(window).resize(function(){ sizeHidable(hidable) });
  });
});