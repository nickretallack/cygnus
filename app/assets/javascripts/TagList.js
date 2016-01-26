TagList = (function(){

    var self;

    var TagList = function(element){

        self = this;

        self.list = element;
        self.field = $("[name = '"+list.attr("id")+"']").safeAdd();

        self.initialize();

    };

    Make.extend(TagList.prototype, {

        add: function(tag){
            var div =   $("<div />", {
                            class: "destroyable"
                        }).append($("<div />", {
                            class: "hidable-title",
                            text: tag
                        }));
            self.list.append(div);
            var destroyable = new destroyable(div);
            destroyable.buttonTable.css({
                float: "left",
                marginRight: 5,
                marginTop: 1
            });
            destroyable.hidable.css({
                backgroundColor: "azure",
                border: "1px solid black",
                paddingRight: 5,
                float: "left",
                marginRight: 5
            });
            destroyable.closeButton.on("click.tagList", function(){
                self.update();
            });
            self.update();
        },

        update: function(){
            var text = self.list.text().replace("clear", "");
            self.field.attr("value", self.field.attr("value").replace(new RegExp("(, )*"+text+"$|"+text+"(, )*"), ""));
        },

        initialize: function(){
            var text = self.list.text();
            self.list.text("");
            $.each(text.split(", "), function(index, tag){
               self.add(tag); 
            });
        }

    });

    return TagList;

})();