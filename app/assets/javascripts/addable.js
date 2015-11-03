function initAddableIcons(){
  addableIcon = $("<i />", {
    class: "material-icons medium-small",
    text: "add",
    css: {
      marginLeft: ".3rem",
      cursor: "pointer",
      fontSize: "150%"
    }
  });
}

function initAddableAttachmentAreas(areas){
  areas.each(function(){ addableAttachmentArea($(this)); })
}

function addableAttachmentArea(area){
  var parent = area.attr("id").split("-");
  area.prepend(addableIcon.clone().selectionMenu({
    imageAttachment: function(){
      $.get("/attachments/new", {
        "parent_model": parent[0],
        "parent_id": parent[1],
        "child_model": "image"
      },
      function(data){
        data = JSON.parse(data);
        $(data.attachment).appendTo(area.children("#image"));
      })
    }
  }));
}

loadFunctions.push(initAddableIcons);
loadFunctions.push(function(){ initAddableAttachmentAreas($(".addable-attachment-area")); });