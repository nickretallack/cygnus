Destroyable = function(element){

    var destroyable = new ActiveContainer(element);
    if(destroyable === undefined) return;

    destroyable.buttonTable.append(destroyable.closeButton);

    destroyable.top.css({
        height: "1rem"
    });

    destroyable.closeButton.on("click.ActiveContainer", function(){
        destroyable.destroy();
    });

    $(window).on("resize.hidable", function(){
        destroyable.maximize(false);
        destroyable.title.css({
            marginTop: "-0.15rem"
        });
    });

    destroyable.maximize(false);

    destroyable.title.css({
        marginTop: "-0.15rem"
    });

    return destroyable;

};

Hidable = function(element){

    var hidable = new ActiveContainer(element);
    if(hidable === undefined) return;

    hidable.buttonTable.append(hidable.minimizeButton);
    hidable.buttonTable.append(hidable.closeButton);

    hidable.title.on("mouseenter.ActiveContainer", function(){
        hidable.minimizeButton.addClass("icon-hover");
    });

    hidable.title.on("mouseleave.ActiveContainer", function(){
        hidable.minimizeButton.removeClass("icon-hover");
    });

    hidable.minimizeButton.on("click.ActiveContainer", function(){
        hidable.switch(true);
    });
    hidable.closeButton.on("click.ActiveContainer", function(){
        hidable.destroy();
    });
    hidable.title.on("click.ActiveContainer", function(){
        hidable.switch(true);
    });

    $(window).on("resize.hidable", function(){
        hidable.size();
        hidable.same(false);
    });

    hidable.size();
    hidable.same(true);

    return hidable;

};

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
                            top: "0.1rem"
                        }
                    });

        self.divider =  $("<hr />", {
                            css: {
                                margin: 0,
                                display: "inline-block"
                            }
                        });

        self.initialize();
        self.initializeAssociatedField();

    };

    Make.extend(ActiveContainer.prototype, {

        initialize: function(){

            var self = this;

            self.title.append(self.divider);

            self.container.prepend(self.top);
            self.top.append(self.title, self.buttonTable);

            self.title.addClass("vc");
            self.buttonTable.addClass("vc");

        },

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