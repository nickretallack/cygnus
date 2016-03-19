Destroyable = function(element){

  var self = this;

  self.container = new ActiveContainer(element);

  self.container.buttonTable.append(self.container.closeButton);

  self.container.closeButton.on("click.Destroyable", function(){
    self.container.destroy();
  });

  $(window).on("resize.Hidable", function(){
    self.container.size();
    self.container.same(false);
  });

  return self;

};

Hidable = function(element){

  var self = this;

  self.container = new ActiveContainer(element);

  self.container.buttonTable.append(self.container.minimizeButton);
  self.container.buttonTable.append(self.container.closeButton);
  self.container.title.append(self.container.divider);
  self.container.divider.hide();

  self.container.title.on("mouseenter.Hidable", function(){
    self.container.minimizeButton.addClass("icon-hover");
  });

  self.container.title.on("mouseleave.Hidable", function(){
    self.container.minimizeButton.removeClass("icon-hover");
  });

  self.container.minimizeButton.on("click.Hidable", function(){
    self.container.switch(true);
  });
  self.container.closeButton.on("click.Hidable", function(){
    self.container.destroy();
  });
  self.container.title.on("click.Hidable", function(){
    self.container.switch(true);
  });

  $(window).on("resize.Hidable", function(){
    self.container.size();
    self.container.same(false);
  });

  setTimeout(function(){
    self.container.size();
    self.container.same(false);
  }, 100);

};

ActiveContainer = (function(){

  var ActiveContainer = function(element){

    var self = this;

    self.container = element;
    self.title = self.container.children(".title");
    if(!self.title.exists()) return;
    self.content = self.container.children(".content");

    self.buttonTable =  $("<div />", {
                          class: "button-table"
                        });

    self.closeButton =  $("<i />", {
                          class: "material-icons clickable-icon close-button",
                          text: "clear"
                        });

    self.minimizeButton =   $("<i />", {
                              class: "material-icons clickable-icon minimize-button",
                              text: "remove"
                            });

    self.top =  $("<div />", {
                  class: "row top"
                });

    self.divider =  $("<hr />", {
                      class: "divider"
                    });

    self.container.prepend(self.top);
    self.top.append(self.title, self.buttonTable);
    
    if(self.container.is("[associated-field]")) self.initializeAssociatedField();

  };

  Make.extend(ActiveContainer.prototype, {

    minimize: function(animate){
      var self = this,
          parentHidable = self.container.parents(".hidable");
      self.container.removeClass("max").addClass("min");
      self.minimizeButton.css({
        top: -5
      });
      if(animate && !parentHidable.exists()){
        self.container.animate({
          height: self.top.outerHeight()
        }, 1000, "easeOutExpo");
        $(window).trigger("resize");
      }else{
        self.container.css({
          height: self.top.outerHeight()
        });
      }
      self.divider.hide();
      self.content.hide();
      if(parentHidable.exists()){
        bleatr.where(function(element){
          return element["container"] !== undefined && element.container["container"] !== undefined && element.container.container.get(0) == parentHidable.get(0);
        }).first().container.same(false);
      }
    },

    maximize: function(animate){
      var self = this,
          parentHidable = self.container.parents(".hidable");
      self.container.removeClass("min").addClass("max");
      self.minimizeButton.css({
        top: 5
      });
      if(self.content.hasText()) self.divider.show();
      self.content.show();
      if(animate && !parentHidable.exists()){
        self.container.animate({
          height: self.top.outerHeight() + (self["content"] === undefined? 0 : self.content.outerHeight(true))
        }, 1000, "easeOutExpo");
        $(window).trigger("resize");
      }else{
        self.container.css({
          height: self.top.outerHeight() + (self["content"] === undefined? 0 : self.content.outerHeight(true))
        });
      }
      if(parentHidable.exists()){
        bleatr.where(function(element){
          return element["container"] !== undefined && element.container["container"] !== undefined && element.container.container.get(0) == parentHidable.get(0);
        }).first().container.maximize(false);
      }
    },

    destroy: function(){
      var self = this;
      if(self.container.is("[on-destroy]")) self.destroyAttachment();
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
      $("#"+self.container.attr("associated-field")).on("keyup.ActiveContainer", function(event){
        pause(event);
        if(!Key.ret(event) && self.container.hasClass("min")){
          self.maximize();
        }
      })
    },

    destroyAttachment: function(){
      var self = this;
      $.ajax({
        method: "DELETE",
        data: {
          attachment: self.container.attr("on-destroy")
        },
        url: "/" + currentUser + "/attachment"
      });
    }

  });

  return ActiveContainer;

})();