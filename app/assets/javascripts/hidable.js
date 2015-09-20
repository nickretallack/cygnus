loadFunctions.push(function(){
  $(".nojs").hide();
  $(".js").show();

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
      minimize = function(element, height){
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
        buttonTable.nextAll().hide();
        hidable.css({
          height: 29
        });
        if(parseInt(widthTester.css("width")) < 363){
          hidableTitle.off("click");
          hidableTitle.on("click", function(event){ maximize(element, height); });
        }else{
          minimizeButton.off("click");
          minimizeButton.on("click", function(){ maximize(element, height) });
        }
      },
      maximize = function(element, height){
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
        buttonTable.nextAll().show();
        hidable.css({
          height: height
        });
        if(parseInt(widthTester.css("width")) < 363){
          hidableTitle.off("click");
          hidableTitle.on("click", function(event){ minimize(element, height); });
        }else{
          minimizeButton.off("click");
          minimizeButton.on("click", function(){ minimize(element, height); });
        }
      },
      destroy = function(element){
        element.remove();
      },
      sizeHidable = function(height){
        if(parseInt(widthTester.css("width")) < 363){
          $(".button-table").hide();
          $(".hidable-title").css({
            paddingLeft: 0
          });
          $(".hidable-title").off("click").on("click", function(event){ minmax($(event.target).parent(), height); });
          $(".minimize-button").off("click");
          $(".close-button").off("click");
        }else{
          $(".button-table").show();
          $(".hidable-title").css({
            paddingLeft: 10
          });
          $(".hidable-title").off("click");
          $(".minimize-button").off("click").on("click", function(event){ minmax($(event.target).parent().parent(), height); });
          $(".close-button").off("click").on("click", function(event){ destroy($(event.target).parent().parent()); });
        }
      },
      minmax = function(element, height){
        if((element).hasClass("max")){
          minimize(element, height);
        }else if(element.hasClass("min")){
          maximize(element, height);
        }
      };

  hidable.prepend(buttonTable.clone().append(minimizeButton.clone()).append(closeButton.clone()));
  destroyable.append(buttonTable.clone().append(closeButton.clone()).css({
    marginTop: 2
  }));

  $.each(hidable, function(index, element){
    var hidable = $(element),
        height = hidable.outerHeight();
    hidable.prepend($("<div />", {
        class: "hidable-title",
        text: (hidable.attr("id")[0].toUpperCase() + hidable.attr("id").slice(1)).replace("_", " ")
      }).css({
        float: "left",
        lineHeight: "18px",
        fontSize: "16px",
        paddingLeft: 10,
        marginTop: -5,
        userSelect: "none",
        cursor: "default"
      }));
    
    sizeHidable(height);
    minmax(hidable, height);
    $(window).resize(function(){ sizeHidable(height) });
  });
});