Destroyable = function(element){

    var destroyable = new ActiveContainer(element);
    if(destroyable === undefined) return;

    destroyable.buttonTable.append(destroyable.closeButton);
    destroyable.content = destroyable.title;
    destroyable.maxHeight = destroyable.content.outerHeight();
    destroyable.top.css({
        top: ".65rem"
    });

    $(window).on("resize.destroyable", function(){
        destroyable.size();
    });
    destroyable.size();

    return destroyable;

};

Hidable = function(element){

    var hidable = new ActiveContainer(element);
    if(hidable === undefined) return;

    hidable.buttonTable.append(hidable.minimizeButton);
    hidable.buttonTable.append(hidable.closeButton);
    hidable.maxHeight = hidable.title.outerHeight() + hidable.top.outerHeight() + hidable.content.outerHeight();
    hidable.top.css({
        top: ".1rem"
    });

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

        self.container = element;
        self.title = self.container.children(".title").safeAdd();
        self.content = self.container.children(".content").safeAdd();
        if(self.title === undefined || self.content == undefined) return;

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
                            height: "auto",
                            position: "relative"
                        }
                    });

        self.initialize();
        self.initializeAssociatedField();

    };

    Make.extend(ActiveContainer.prototype, {

        initialize: function(){

            self.title.css({
                lineHeight: "1.5rem",
                float: "left",
                textAlign: "left",
                paddingLeft: 10,
                cursor: "pointer"
            });

            self.title.append($("<hr />", {
                css: {
                    margin: 0
                }
            }));

            self.title.on("mouseenter.ActiveContainer", function(){
                self.minimizeButton.addClass("icon-hover");
            });

            self.title.on("mouseleave.ActiveContainer", function(){
                self.minimizeButton.removeClass("icon-hover");
            });

            self.container.prepend(self.top);
            self.top.append(self.title, self.buttonTable);

            self.title.addClass("vc");
            self.buttonTable.addClass("vc");

        },

        minimize: function(){
            var self = this;
            this.container.removeClass("max").addClass("min");
            this.minimizeButton.css({
                top: -5
            });
            this.content.hide();
            this.container.animate({
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
            this.container.removeClass("min").addClass("max");
            this.minimizeButton.css({
                top: 5
            });
            this.content.show();
            this.container.animate({
                height: self.maxHeight
            }, 1000, "easeOutExpo");
            if(Screen.tiny()){
                this.title.off("click.hidable");
                this.title.on("click.hidable", function(){ self.minimize(); });
            }else{
                this.minimizeButton.off("click.hidable");
                this.minimizeButton.on("click.hidable", function(){ self.minimize(); });
            }
        },

        destroy: function(){
            this.container.remove();
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
            if(this.container.hasClass("max")){
                this.minimize();
            }else if(this.container.hasClass("min")){
                this.maximize();
            }
        },

        resize: function(){
            if(this.container.hasClass("min")){
                this.minimize();
            }else if(this.container.hasClass("max")){
                this.maximize();
            }
        },

        initializeAssociatedField: function(){
            var self = this;
            if(this.container.is("[associated-field]")){
                $("#"+this.container.attr("associated-field")).on("keyup.hidable", function(event){
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