AddableField = (function(){

    var self;

    var AddableField = function(element){

        self = this;

        // self.field = element;
        // self.button = $("#"+self.field.attr("button")).safeAdd();

        //self.initialize();

    };

    Make.extend(AddableField.prototype, {

        initialize: function(){
            self.field.css({
                width: "calc(100% - 2.1rem)"
            });
            self.button.css({
                marginLeft: ".3rem",
                cursor: "pointer",
                fontSize: "150%"
            })
        },

        add: function(){
            $(this).remove();
            var newAddable = clonable.clone();
            newAddable.insertAfter(addable.parent());
            var name = $(".addable").attr("name").replace(/]/g, "").split("[");
            var index = parseInt(name[2]);
            newAddable.children().attr("name", addable.attr("name").replace(index.toString(), (index+1).toString()));
            newAddable.children().attr("id", addable.attr("id").replace(index.toString(), (index+1).toString()));
            addableFunc(newAddable.children());
            categorizeForm(newAddable.children("[class *= categorized]"));
        }

    });

    return AddableField;

})();