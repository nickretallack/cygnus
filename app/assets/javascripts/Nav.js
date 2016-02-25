Nav = (function(){

  var self;

  var Nav = function(element){

    self = this;

    self.nav = element;
    self.banner = self.nav.parents("header").children("img").safeAdd();
    self.dropdownButton = self.nav.find(".dropdown-button").safeAdd();
    self.collapseButton = self.nav.find(".button-collapse").safeAdd();
    self.footerHeight = $("footer").height();

    self.dropdownButton.dropdown({
      belowOrigin: true,
      hover: true,
      constrain_width: false
    });
    self.dropdownButton.off("click");

    self.collapseButton.sideNav({
      closeOnClick: true,
      menuWidth: 550
    });

    $(window).on("scroll.Nav", function(){
      self.pushpin();
    });

    $(window).on("resize.Nav", function(){
      $(window).trigger("scroll.Nav");
    });

    $(window).keydown(function(event){
      if(Key.esc(event)) self.collapseButton.sideNav("hide");
    });

    self.initialize();
    self.pushpin();

  };

  Make.extend(Nav.prototype, {

    initialize: function(){
      self.dropdownButton.trigger("mouseout");
    },

    pushpin: function(){
      if(!self.banner || !self.nav) return;
      if($(window).scrollTop() > self.banner.outerHeight()){
        self.nav.css({
          position: "fixed",
          top: 0
        });
      }else{
        self.nav.css({
          position: "relative",
          top: "auto"
        });
      }
    }

  });

  return Nav;

})();