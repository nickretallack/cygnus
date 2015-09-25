readyFunctions.push(addableFunc);
readyFunctions.push(function(){
  var addable = $(".addable");
  addable.parent().hide();
  addable.parent().prev("a").click(function(){
    $(this).remove();
    addable.parent().show();
  });
});

function addableFunc(addable){
  if(typeof addable === "undefined") addable = $(".addable");
  var clonable = addable.parent().clone();
  addable.css({
    width: "calc(100% - 2.1rem)"
  }).after($("<i />", {
    class: "material-icons",
    text: "add"
  }).css({
    marginLeft: ".3rem",
    cursor: "pointer",
    fontSize: "150%"
  }).on("mouseenter", function(){
    $(this).css({
      marginLeft: ".1rem",
      fontSize: "200%"
    });
  }).on("mouseleave", function(){
    $(this).css({
      marginLeft: ".3rem",
      fontSize: "150%"
    });
  }).on("click.addable", function(event){
    pauseEvent(event);
    $(this).remove();
    var newAddable = clonable.clone();
    newAddable.insertAfter(addable.parent());
    var name = $(".addable").attr("name").replace(/]/g, "").split("[");
    var index = parseInt(name[2]);
    newAddable.children().attr("name", addable.attr("name").replace(index.toString(), (index+1).toString()));
    newAddable.children().attr("id", addable.attr("id").replace(index.toString(), (index+1).toString()));
    addableFunc(newAddable.children());
    categorizeForm(newAddable.children("[class *= categorized]"));
  }));
};