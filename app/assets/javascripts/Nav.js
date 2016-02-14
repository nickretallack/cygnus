Nav = (function(){

    var self;

    var Nav = function(element){

        self = this;

        self.nav = element;
        self.banner = self.nav.parents("header").children("img").safeAdd();
        self.dropdownButton = self.nav.find(".dropdown-button").safeAdd();
        self.collapseButton = self.nav.find(".button-collapse").safeAdd();

        self.initialize();

    };

    Make.extend(Nav.prototype, {

        pushpin: function(){
            if(!self.banner) return;
            var scrollHeight = $(window).scrollTop();
            if(scrollHeight > self.banner.outerHeight()){
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
        },

        initialize: function(){
            self.dropdownButton.dropdown({
                belowOrigin: true,
                hover: true,
                constrain_width: false
            });
            $(".dropdown-button").off("click");
            $(".dropdown-button").trigger("mouseover");
            $(".dropdown-button").trigger("mouseout");

            self.collapseButton.sideNav({
                closeOnClick: true,
                menuWidth: 550
            });

            $(window).on("scroll.nav", function(){
                self.pushpin();
            });

            $(window).keydown(function(event){
                if(Key.esc(event)) self.collapseButton.sideNav("hide");
            });

            self.pushpin();
        }

    });

    return Nav;

})();