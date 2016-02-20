Destroyable = function(element){

  var self = new ActiveContainer(element);
  if(self === undefined) return;

  self.buttonTable.append(self.closeButton);

  self.top.css({
    height: "1rem"
  });

  self.closeButton.on("click.Destroyable", function(){
    self.destroy();
  });

  $(window).on("resize.Destroyable", function(){
    self.maximize(false);
    self.title.css({
      marginTop: "-0.15rem"
    });
  });

  self.maximize(false);

  self.title.css({
    marginTop: "-0.15rem"
  });

  return self;

};

Hidable = (function(){

  var Hidable = function(element){

    var self = new ActiveContainer(element);

    self.buttonTable.append(self.minimizeButton);
    self.buttonTable.append(self.closeButton);

    self.title.on("mouseenter.Hidable", function(){
      self.minimizeButton.addClass("icon-hover");
    });

    self.title.on("mouseleave.Hidable", function(){
      self.minimizeButton.removeClass("icon-hover");
    });

    self.minimizeButton.on("click.Hidable", function(){
      self.switch(true);
    });
    self.closeButton.on("click.Hidable", function(){
      self.destroy();
    });
    self.title.on("click.Hidable", function(){
      self.switch(true);
    });

    $(window).on("resize.Hidable", function(){
      self.size();
      self.same(false);
    });

    self.size();
    self.same(true);

  };

  return Hidable;

})();

ActiveContainer = (function(){

  var ActiveContainer = function(element){

    var self = this;

    self.container = element;
    self.title = self.container.children(".title").safeAdd();
    self.content = self.container.children(".content");
    if(self.title === undefined) return;

    self.title.css  ({
              height: "1.5rem",
              float: "left",
              textAlign: "left",
              paddingLeft: 10,
              cursor: "pointer",
              marginTop: "0.4rem"
            });

    self.buttonTable =  $("<div />", {
                class: "button-table",
                css: {
                  display: "table",
                  float: "right",
                  overflow: "hidden",
                  lineHeight: "1.5rem"
                }
              });

    self.closeButton =  $("<i />", {
                class: "material-icons clickable-icon close-button",
                text: "clear",
                css: {
                  cursor: "pointer"
                }
              });

    self.minimizeButton =   $("<i />", {
                  class: "material-icons clickable-icon minimize-button",
                  text: "remove",
                  css: {
                    cursor: "pointer",
                    position: "relative"
                  }
                });

    self.top =  $("<div />", {
            class: "row",
            css: {
              userSelect: "none",
              cursor: "default",
              width: "100%",
              height: 0,
              position: "relative",
              top: "0.1rem",
              fontSize: 18
            }
          });

    self.divider =  $("<hr />", {
              css: {
                margin: 0,
                display: "inline-block"
              }
            });

    self.title.append(self.divider);

    self.container.prepend(self.top);
    self.top.append(self.title, self.buttonTable);

    self.title.addClass("vc");
    self.buttonTable.addClass("vc");
    
    self.initializeAssociatedField();

  };

  Make.extend(ActiveContainer.prototype, {

    minimize: function(animate){
      var self = this;
      self.container.removeClass("max").addClass("min");
      self.minimizeButton.css({
        top: -5
      });
      self.divider.hide();
      self.title.css({
        marginTop: 0
      })
      self.content.hide();
      if(animate){
        self.container.animate({
          height: "1.5rem"
        });
      }else{
        self.container.css({
          height: "1.5rem"
        });
      }
    },

    maximize: function(animate){
      var self = this;
      self.container.removeClass("min").addClass("max");
      self.minimizeButton.css({
        top: 5
      });
      self.divider.show();
      self.title.css({
        marginTop: 1
      })
      self.content.show();
      if(animate){
        self.container.animate({
          height: self.title.outerHeight() + self.content.outerHeight()
        }, 1000, "easeOutExpo");
      }else{
        self.container.css({
          height: self.title.outerHeight() + self.content.outerHeight()
        })
      }
    },

    destroy: function(){
      var self = this;
      self.container.remove();
    },

    size: function(){
      var self = this;
      if(Screen.tiny()){
        self.buttonTable.hide();
        self.title.css({
          paddingLeft: 0,
          width: "100%"
        });
      }else{
        self.buttonTable.show();
        self.title.css({
          width: "calc(100% - 49px)"
        });
      }
    },

    switch: function(animate){
      var self = this;
      if(self.container.hasClass("max")){
        self.minimize(animate);
      }else if(self.container.hasClass("min")){
        self.maximize(animate);
      }
    },

    same: function(animate){
      var self = this;
      if(self.container.hasClass("min")){
        self.minimize(animate);
      }else if(self.container.hasClass("max")){
        self.maximize(animate);
      }
    },

    initializeAssociatedField: function(){
      var self = this;
      if(self.container.is("[associated-field]")){
        $("#"+self.container.attr("associated-field")).on("keyup.ActiveContainer", function(event){
          pause(event);
          if(!Key.ret(event) && self.container.hasClass("min")){
            self.maximize();
          }
        })
      }
    }

  });

  return ActiveContainer;

})();