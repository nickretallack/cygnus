ImagePreview = (function(){

  var ImagePreview = function(element){

    var self = this;

    self.imagePreview = element;
    self.fileField = self.imagePreview.prev().find("input");
    self.clickArea = self.imagePreview.find(".click-area");
    self.explicitBox = self.imagePreview.find("input[type = checkbox]");
    self.image = self.imagePreview.find("img");

    self.fileField.on("change.ImagePreview", function(event){
      if(this.files && this.files[0]){
        var reader = new FileReader();
        reader.onload = function(event){
          self.image.attr("src", event.target.result);
          self.image.on("load.ImagePreview", function(){
            self.image.attr("class", self.image.prop("naturalWidth") > self.image.prop("naturalHeight")? "wide" : "tall");
            $(window).trigger("resize.AddableField");
          });
        };
        reader.readAsDataURL(this.files[0]);
      };
    });
    self.clickArea.on("click.ImagePreview", function(){
      self.fileField.trigger("click");
    });

  };

  return ImagePreview;

})();