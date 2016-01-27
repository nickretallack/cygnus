ImagePreview = (function(){

    var self;

    var ImagePreview = function(element){

        self = this;

        self.imagePreview = element;
        self.associatedField = $("#"+self.imagePreview.attr("associated-field"));
        self.spans = self.imagePreview.find("span");
        self.explicitLabel = $("#"+self.imagePreview.attr("explicit-label"));
        self.initialize();

    };

    Make.extend(ImagePreview.prototype, {

        initialize: function(){
            self.imagePreview.css({
                fontSize: "12px",
                lineHeight: "12px",
                color: "black",
                border: "2px solid black",
                borderRadius: "8px",
                cursor: "pointer"
            });

            self.spans.css({
                marginTop: 5
            }).addClass("inline");

            hideAndShow(self.imagePreview);
            self.associatedField.parents(".file-field").hide();
            self.spans.eq(0).show();

            self.associatedField.on("change.imagePreview", function(event){
                if(self.files && self.files[0]){
                    var reader = new FileReader();
                    reader.onload = function(event){
                        image = self.imagePreview.find("img");
                        image.attr("src", event.target.result);
                        image.on("mouseenter.imagePreview", function(){
                            self.spans.eq(0).show();
                            self.spans.eq(1).hide();
                            self.explicitLabel.removeClass("danger");
                        }).on("mouseleave.imagePreview", function(){
                            self.spans.eq(0).hide();
                            self.spans.eq(1).show();
                            self.explicitLabel.addClass("danger");
                        });
                        self.imagePreview.trigger("mouseleave.imagePreview");
                    };
                    reader.readAsDataURL(self.files[0]);
                };
            });
            if(self.associatedField.exists()){
                self.imagePreview.on("click.imagePreview", function(){
                    self.associatedField.trigger("click");
                });
            }
        }

    });

    return ImagePreview;

})();