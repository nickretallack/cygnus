ImagePreview = (function(){

  var self;

  var ImagePreview = function(element){

    self = this;

    self.imagePreview = element;
    self.fileField = $("#"+self.imagePreview.attr("file-field"));
    self.labels = self.imagePreview.find(".image-labels").children();
    self.explicitBox = $("#"+self.imagePreview.attr("explicit-box"));

    self.fileField.parents(".file-field").hide();
    self.labels.eq(0).show();
    self.labels.eq(1).hide();

    self.fileField.on("change.ImagePreview", function(event){
      if(this.files && this.files[0]){
        var reader = new FileReader();
        reader.onload = function(event){
          image = self.imagePreview.find("img");
          image.attr("src", event.target.result);
          image.on("mouseenter.ImagePreview", function(){
            self.labels.eq(0).show();
            self.labels.eq(1).hide();
          }).on("mouseleave.ImagePreview", function(){
            self.labels.eq(0).hide();
            self.labels.eq(1).show();
          });
          self.imagePreview.trigger("mouseleave.ImagePreview");
        };
        reader.readAsDataURL(this.files[0]);
      };
    });
    self.imagePreview.on("click.ImagePreview", function(){
      self.fileField.trigger("click");
    });

  };

  return ImagePreview;

})();