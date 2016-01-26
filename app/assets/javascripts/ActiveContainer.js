Destroyable = function(){

    var destroyable = new ActiveContainer();

    destroyable.hidable.css({
        marginTop: 2
    });
    destroyable.content = destroyable.title;

    destroyable.hidable.append(destroyable.buttonTable);
    destroyable.buttonTable.append(destroyable.closeButton);

    $(window).on("resize.destroyable", function(){
        destroyable.size();
    });
    destroyable.size();

    return destroyable;

};

Hidable = function(element){

    var hidable = new ActiveContainer(element);

    hidable.hidable.prepend(hidable.buttonTable);
    hidable.buttonTable.append(hidable.minimizeButton);
    hidable.buttonTable.append(hidable.closeButton);
    hidable.content = hidable.buttonTable.nextAll(":not(.hidable-title)");

    $(window).on("resize.hidable", function(){
        hidable.size();
    });
    hidable.size();

    return hidable;

};

ActiveContainer = (function(){

    var self;

    var ActiveContainer = function(element){

        self = this;

        self.hidable = element;
        self.title = this.hidable.children(".hidable-title").safeAdd();

        self.buttonTable =  $("<div />", {
                                class: "button-table",
                                css: {
                                    display: "table",
                                    float: "right",
                                    overflow: "hidden",
                                    userSelect: "none",
                                    fontSize: "14px"
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

        self.initialize();
        self.initializeAssociatedField();

    };

    Make.extend(ActiveContainer.prototype, {

        initialize: function(){

            this.title.css({
                float: "left",
                lineHeight: "1rem",
                paddingLeft: 10,
                userSelect: "none",
                cursor: "default",
                textAlign: "left"
            });

            this.hidable.prepend($("<div />", {
                class: "row"
            }).append(this.buttonTable).append(this.title));

        },

        minimize: function(){
            var self = this;
            this.hidable.removeClass("max").addClass("min");
            this.minimizeButton.css({
                top: -5
            });
            this.content.hide();
            this.hidable.animate({
                height: self.title.css("lineHeight")
            });
            if(Screen.tiny()){
                this.title.off("click.hidable");
                this.title.on("click.hidable", function(){ self.maximize(); });
            }else{
                this.minimizeButton.off("click.hidable");
                this.minimizeButton.on("click.hidable", function(){ self.maximize(); });
            }
        },

        maximize: function(){
            var self = this;
            this.hidable.removeClass("min").addClass("max");
            this.minimizeButton.css({
                top: 5
            });
            this.content.show();
            this.hidable.animate({
                height: self.title.outerHeight() + this.content.outerHeight()
            }, 1000, "easeOutExpo");
            if(!this.minimizable){
                this.title.addClass("vc");
                this.buttonTable.addClass("vc");
            }
            if(Screen.tiny()){
                this.title.off("click.hidable");
                this.title.on("click.hidable", function(){ self.minimize(); });
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
                this.title.css({
                    paddingLeft: 0,
                    width: "100%"
                });
                this.minimizeButton.off("click.hidable");
                this.closeButton.off("click.hidable");
            }else{
                this.buttonTable.show();
                this.title.css({
                    paddingLeft: 10,
                    width: "calc(100% - 49px)"
                });
                this.title.off("click.hidable");
                this.minimizeButton.off("click.hidable").on("click.hidable", function(){ self.switch(); });
                this.closeButton.off("click.hidable").on("click.hidable", function(){ self.destroy(); });
            }
            this.title.off("click.hidable").on("click.hidable", function(){ self.switch(); });
            this.resize();
        },

        switch: function(){
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

    return ActiveContainer;

})();