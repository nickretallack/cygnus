function imagePreviewAreas(){
  $(".image-preview").each(function(){ imagePreviewArea($(this)) });
}

loadFunctions.push(imagePreviewAreas);

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
      //   var div = $(".preview"),
      //       image = $("<img />", { src: event.target.result });
      //   image.load(function(){
      //     div.children("#flash").show();
      //     if(div.hasClass("thumb-preview")){
      //       div.html($("<div />", {
      //         class: "thumbnail success"
      //       }).append(image));
      //     }else{
      //       if(div.find("img").length < 1){
      //         div.append(image);
      //       }else{
      //         div.find("img").replaceWith(image);
      //       }
      //     }
      //     $("label[for $= '_upload_explicit']").addClass("danger");
      //   });
      // }
      area.find(".thumbnail").html($("<img />", {
        src: event.target.result
      }));
      }
      reader.readAsDataURL(this.files[0]);
    }
  });
  }
}