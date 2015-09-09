readyFunctions.push(function(){
  $(":file").change(function(){
    if(this.files && this.files[0]){
      var reader = new FileReader();
      reader.onload = function(event){
        var div = $(".preview");
        div.children("#flash").show();
        div.children("img").remove();
        div.append($("<img />", { src: event.target.result }));
        $("label[for = 'user_upload_explicit']").addClass("danger");
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