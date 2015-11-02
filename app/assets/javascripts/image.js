function initImagePreviewAreas(areas){
  areas.each(function(){ imagePreviewArea($(this)) });
}

function imagePreviewArea(area){
  if(area.is(".bordered")){
    area.children().hide();
    area.append($("<div />", {
      class: "thumbnail success",
      css: {
        cursor: "pointer"
      }
    }).on("click.imagePreview", function(){
      area.find(":file").trigger("click");
    }).append($("<div />", {
      class: "vc",
      text: "Click to load image",
      css: {
        width: "100%",
        textAlign: "center",
        fontSize: "14px",
        color: "darkslategrey"
      }
    })));

    $(":file").change(function(){

    if(this.files && this.files[0]){
      var reader = new FileReader();
      reader.onload = function(event){
      area.find(".thumbnail").html($("<img />", {
        src: event.target.result
      }));
      }
      reader.readAsDataURL(this.files[0]);
    }
  });
  }
}

loadFunctions.push(function(){ initImagePreviewAreas($(".image-preview")); });