loadFunctions.push(function(){

  Hidable = (function(){

    var Hidable = function(element, minimizable){

      this.hidable = element;
      this.minimizable = minimizable;
      this.initialize();

    };

    Make.extend(Hidable.prototype, {

      initialize: function(){

        $.extend(this, {

          titleCss: {
            float: "left",
            lineHeight: "19px",
            fontSize: "18px",
            paddingLeft: 10,
            marginTop: -5,
            userSelect: "none",
            cursor: "default",
          },

          buttonTable: $("<div />", {
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

          closeButton: $("<i />", {
            class: "material-icons clickable-icon close-button",
            text: "clear"
          }).css({
            cursor: "pointer",
            verticalAlign: "sub"
          }),

          minimizeButton: $("<i />", {
            class: "material-icons clickable-icon minimize-button",
            text: "remove"
          }).css({
            cursor: "pointer",
            verticalAlign: "middle"
          })

        };

        if(this.minimizable){
          this.hidableTitle = hidable.children(".hidable-title").css(this.titleCss);
          this.hidable.prepend(this.buttonTable);
          this.buttonTable.append(this.minimizeButton);
          this.buttonTable.append(this.closeButton);
          this.size();
          $(window).on("resize.hidable", this.size);
          this.resize();
          this.initializeAssociatedField();
        }else{
          this.hidable.css({
            marginTop: 2
          });
          this.hidable.append(this.buttonTable);
          this.buttonTable.append(this.closeButton);
          this.size();
          $(window).on("resize.hidable", this.size);
        }
      },

      minimize: function(){
        var self = this;
        this.hidable.removeClass("max").addClass("min");
        this.buttonTable.css({
          marginTop: -12
        });
        this.closeButton.css({
          verticalAlign: "middle"
        });
        this.minimizeButton.css({
          verticalAlign: "sub"
        });
        this.buttonTable.nextAll(":not(.hidable-title)").hide();
        this.hidable.animate({
          height: 29
        });
        if(parseInt(widthTester.css("width")) < 363){
          this.hidableTitle.off("click.hidable");
          this.hidableTitle.on("click.hidable", self.maximize);
        }else{
          this.minimizeButton.off("click.hidable");
          this.minimizeButton.on("click.hidable", self.maximize });
        }
      },

      maximize: function(element){
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
      },

      destroy: function(element){
        element.remove();
      },

      size = function(element){
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
      },

      switch: function(element){
        if((element).hasClass("max")){
          minimize(element);
        }else if(element.hasClass("min")){
          maximize(element);
        }
      },

      resize: function(element){
        if((element).hasClass("min")){
          minimize(element);
        }else if(element.hasClass("max")){
          maximize(element);
        }
      },

      initializeAssociatedField: function(){
        var self = this;
        if(hidable.is("[associated-field]")){
          $("#"+hidable.attr("associated-field")).on("keyup.hidable", function(event){
            pauseEvent(event);
            if(event.keyCode !== 13 && hidable.hasClass("min")){
              self.maximize();
            }
          })
        }
      }

    });

    return Hidable;

  })();

  $(".hidable").each(function(index, element){ new Hidable(element, true); });
  $(".destroyable").each(function(index, element){  new Hidable(element, false); });

});