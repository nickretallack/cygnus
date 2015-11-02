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
  area.prepend(addableIcon.clone().selectionMenu({
    image: function(){
      
    }
  }));
  area.children("div").each(function(){
    var div = $(this);
    console.log(div);
  });
}

loadFunctions.push(initAddableIcons);
loadFunctions.push(function(){ initAddableAttachmentAreas($(".addable-attachment-area")); });