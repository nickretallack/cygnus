readyFunctions.push(function(){
  $(":file").change(function(){
    if(this.files && this.files[0]){
      var reader = new FileReader();
      reader.onload = function(event){
        var div = $("[class$='preview']"),
            image = $("<img />", { src: event.target.result });
        image.load(function(){
          pic = $(this)[0]
          div.children("#flash").show();
          if(div.hasClass("thumb-preview")){
            div.html($("<div />", {
              class: "thumbnail success"
            }).append(image));
          }else{
            div.find("img").replaceWith(image);
          }
          $("label[for $= '_upload_explicit']").addClass("danger");
        });
      }
      reader.readAsDataURL(this.files[0]);
    }
  });

  $(".preview-button").off("click");

  $(".preview-button").on("click", function(event){
    pauseEvent(event);
    var message = $($(this).prevAll("textarea")[0]),
        previewArea = $($(message.next(".preview")[0]));
    previewArea.html($("<div />", {
      class: "card"
    }).append($("<div />", {
      class: "card-content"
    }).append(markdown.toHTML(message.val()))));
  });
});