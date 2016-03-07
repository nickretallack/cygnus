ImagePreview = (function(){

  var ImagePreview = function(element){

    var self = this;

    self.imagePreview = element;
    self.fileField = self.imagePreview.prev().find("input");
    self.clickArea = self.imagePreview.find(".click-area");
    self.labelsOne = self.imagePreview.find(".labels-1");
    self.labelsTwo = self.imagePreview.find(".labels-2");
    self.explicitBox = self.imagePreview.find("input[type = checkbox]");
    self.image = self.imagePreview.find("img");

    self.fileField.parents(".file-field").hide();
    self.labelsOne.show();
    self.labelsTwo.hide();

    self.fileField.on("change.ImagePreview", function(event){
      if(this.files && this.files[0]){
        var reader = new FileReader();
        reader.onload = function(event){
          self.image.attr("src", event.target.result);
          self.image.on("load.ImagePreview", function(){
            self.image.attr("class", self.image.prop("naturalWidth") > self.image.prop("naturalHeight")? "wide" : "tall");
          })
          self.clickArea.on("mouseenter.ImagePreview", function(){
            self.labelsOne.show();
            self.labelsTwo.hide();
          }).on("mouseleave.ImagePreview", function(){
            self.labelsOne.hide();
            self.labelsTwo.show();
          });
          self.clickArea.trigger("mouseleave.ImagePreview");
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