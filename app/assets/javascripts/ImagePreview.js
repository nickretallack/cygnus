ImagePreview = (function(){

    var ImagePreview = function(element){

        this.imagePreview = element;
        this.associatedField = $("#"+this.imagePreview.attr("associated-field"));
        this.spans = this.imagePreview.find("span");
        this.explicitLabel = $("#"+this.imagePreview.attr("explicit-label"));
        this.initialize();

    };

    Make.extend(ImagePreview.prototype, {

        initialize: function(){
            var self = this;

            this.imagePreview.css({
                fontSize: "12px",
                lineHeight: "12px",
                color: "black",
                border: "2px solid black",
                borderRadius: "8px",
                cursor: "pointer"
            });

            this.spans.css({
                marginTop: 5
            }).addClass("inline");

            hideAndShow(this.imagePreview);
            this.associatedField.parents(".file-field").hide();
            this.spans.eq(0).show();

            this.associatedField.on("change.imagePreview", function(event){
                if(this.files && this.files[0]){
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
                    reader.readAsDataURL(this.files[0]);
                };
            });
            if(this.associatedField.exists()){
                this.imagePreview.on("click.imagePreview", function(){
                    self.associatedField.trigger("click");
                });
            }
        }

    });

    return ImagePreview;

})();