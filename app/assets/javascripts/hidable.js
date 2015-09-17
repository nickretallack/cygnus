readyFunctions.push(function(){
  $(".nojs").hide();
  $(".js").show();

  var hidable = $(".hidable"),
      destroyable = $(".destroyable"),
      buttonTable = $("<div />", {
        class: "button-table"
      }).css({
        marginTop: -5,
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
      });

  var minimize = function(element){
    var buttonTable = element.children(".button-table");
    var closeButton = buttonTable.children(".close-button"),
        minimizeButton = buttonTable.children(".minimize-button");
    buttonTable.css({
      marginTop: -10
    })
    closeButton.css({
      verticalAlign: "middle"
    });
    minimizeButton.css({
      verticalAlign: "sub"
    });
    var hidableHeight = hidable.outerHeight();
    buttonTable.nextAll().hide();
    hidable.css({
      height: 29
    });
    minimizeButton.off("click");
    minimizeButton.on("click", function(){
      (function(){
        buttonTable.css({
          marginTop: -5
        })
        closeButton.css({
          verticalAlign: "sub"
        });
        minimizeButton.css({
          verticalAlign: "middle"
        });
        buttonTable.nextAll().show();
        hidable.css({
          height: hidableHeight
        });
        minimizeButton.off("click");
        minimizeButton.on("click", function(){ minimize(element); });
      })(element);
    })
  },
      destroy = function(element){
    element.remove();
  };

  hidable.prepend(buttonTable.clone().append(minimizeButton.clone()).append(closeButton.clone()));
  destroyable.append(buttonTable.clone().append(closeButton.clone()));

  $(".minimize-button").on("click", function(event){ minimize($(event.target).parent().parent()); });
  $(".close-button").on("click", function(event){ destroy($(event.target).parent().parent()); });

  $.each(hidable, function(index, element){
    var hidable = $(element);
    hidable.prepend($("<div />", {
        text: (hidable.attr("id")[0].toUpperCase() + hidable.attr("id").slice(1)).replace("_", " ")
      }).css({
        float: "left",
        lineHeight: "21px",
        paddingLeft: 10
      }));
    if(hidable.hasClass("min")) hidable.children(".button-table").children(".minimize-button").trigger("click");
  });
});