loadFunctions.push(function(){

  var hidables = $(".hidable"),
      destroyables = $(".destroyable");  

  Hidable = (function(){

    var Hidable = function(element, minimizable){

      this.hidable = element;
      this.minimizable = minimizable;
      this.initialize();

    };

    Make.extend(Hidable.prototype, {

      initialize: function(){

        var self = this;

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

        });

        if(this.minimizable){
          this.hidableTitle = this.hidable.children(".hidable-title").css(this.titleCss);
          this.hidable.prepend(this.buttonTable);
          this.buttonTable.append(this.minimizeButton);
          this.buttonTable.append(this.closeButton);
          this.content = this.buttonTable.nextAll(":not(.hidable-title)");
          this.size();
          $(window).on("resize.hidable", function(){ self.size(); });
          this.resize();
          this.initializeAssociatedField();
        }else{
          this.hidable.css({
            marginTop: 2
          });
          this.hidable.append(this.buttonTable);
          this.buttonTable.append(this.closeButton);
          this.size();
          $(window).on("resize.hidable", function(){ self.size(); });
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
        this.content.hide();
        this.hidable.animate({
          height: 29
        });
        if(Screen.tiny()){
          this.hidableTitle.off("click.hidable");
          this.hidableTitle.on("click.hidable", function(){ self.maximize(); });
        }else{
          this.minimizeButton.off("click.hidable");
          this.minimizeButton.on("click.hidable", function(){ self.maximize(); });
        }
      },

      maximize: function(){
        var self = this;
        this.hidable.removeClass("min").addClass("max");
        this.buttonTable.css({
          marginTop: -7
        })
        this.closeButton.css({
          verticalAlign: "sub"
        });
        this.minimizeButton.css({
          verticalAlign: "middle"
        });
        this.content.show();
        this.hidable.animate({
          height: 29 + this.content.outerHeight()
        }, 1000, "easeOutExpo");
        if(Screen.tiny()){
          this.hidableTitle.off("click.hidable");
          this.hidableTitle.on("click.hidable", function(){ self.minimize(); });
        }else{
          this.minimizeButton.off("click.hidable");
          this.minimizeButton.on("click.hidable", function(){ self.minimize(); });
        }
      },

      destroy: function(){
        this.hidable.remove();
      },

      size: function(){
        var self = this;
        if(Screen.tiny()){
          this.buttonTable.hide();
          this.hidableTitle.css({
            paddingLeft: 0,
            width: "100%"
          });
          this.minimizeButton.off("click.hidable");
          this.closeButton.off("click.hidable");
        }else{
          this.buttonTable.show();
          this.hidableTitle.css({
            paddingLeft: 10,
            width: "calc(100% - 49px)"
          });
          this.hidableTitle.off("click.hidable");
          this.minimizeButton.off("click.hidable").on("click.hidable", function(){ self.switch(); });
          this.closeButton.off("click.hidable").on("click.hidable", function(){ self.destroy(); });
        }
        this.hidableTitle.off("click.hidable").on("click.hidable", function(){ self.switch(); });
        this.resize();
      },

      switch: function(){
        console.log(this);
        if(this.hidable.hasClass("max")){
          this.minimize();
        }else if(this.hidable.hasClass("min")){
          this.maximize();
        }
      },

      resize: function(){
        if(this.hidable.hasClass("min")){
          this.minimize();
        }else if(this.hidable.hasClass("max")){
          this.maximize();
        }
      },

      initializeAssociatedField: function(){
        var self = this;
        if(this.hidable.is("[associated-field]")){
          $("#"+this.hidable.attr("associated-field")).on("keyup.hidable", function(event){
            pauseEvent(event);
            if(event.keyCode !== 13 && self.hidable.hasClass("min")){
              self.maximize();
            }
          })
        }
      }

    });

    return Hidable;

  })();

  $(".hidable").each(function(index, element){ new Hidable($(element), true); });
  $(".destroyable").each(function(index, element){  new Hidable($(element), false); });

});