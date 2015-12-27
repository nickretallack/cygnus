loadFunctions.push(function(){

    var imagePreviews = $(".preview").has("img");

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
                    fontSize: "80%",
                    border: "2px solid black",
                    borderRadius: "8px",
                    cursor: "pointer"
                });

                this.spans.css({
                    marginTop: 5
                });

                this.associatedField.on("change.imagePreview", function(event){
                    if(this.files && this.files[0]){
                        var reader = new FileReader();
                        reader.onload = function(event){
                            self.imagePreview.find("img").attr("src", event.target.result);
                            self.imagePreview.on("mouseenter.imagePreview", function(){
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

    imagePreviews.each(function(index, element){ new ImagePreview($(element)); })

});

// function initImagePreviewAreas(areas){
//   areas.each(function(){ imagePreviewArea($(this)) });
// }

// function imagePreviewArea(area){
//   if(area.is(".bordered")){
//     area.children().hide();
//     area.append($("<div />", {
//       class: "thumbnail success",
//       css: {
//         cursor: "pointer"
//       }
//     }).on("click.imagePreview", function(){
//       area.find(":file").trigger("click");
//     }).append($("<div />", {
//       class: "vc",
//       text: "Click to load image",
//       css: {
//         width: "100%",
//         textAlign: "center",
//         fontSize: "14px",
//         color: "darkslategrey"
//       }
//     })));

//     $(":file").change(function(){

//     if(this.files && this.files[0]){
//       var reader = new FileReader();
//       reader.onload = function(event){
//       area.find(".thumbnail").html($("<img />", {
//         src: event.target.result
//       }));
//       }
//       reader.readAsDataURL(this.files[0]);
//     }
//   });
//   }
// }

// loadFunctions.push(function(){ initImagePreviewAreas($(".image-preview")); });