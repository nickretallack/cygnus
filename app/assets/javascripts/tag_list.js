readyFunctions.push(function(){
  var tagList = $(".taglist");

  $.each(tagList, function(index, list){
    list = $(list);
    var text = list.text();
    list.text("");
    $.each(text.split(", "), function(index, tag){
      $("<span />", {
        class: "destroyable",
        text: tag
      }).appendTo(list);
    });
  });
});

loadFunctions.push(function(){
  var tagList = $(".taglist");

  $.each(tagList, function(index, list){
    list = $(list);
    var field = $("[name = '"+list.attr("id")+"']");
    $.each(list.children().children(".button-table"), function(index, table){
      table = $(table);
      table.css({
        float: "left",
        marginRight: 5,
        marginTop: 1
      }).parent().css({
        backgroundColor: "azure",
        border: "1px solid black",
        paddingRight: 5,
        float: "left",
        marginRight: 5
      });
      button = table.children();
      button.on("click", function(){
        var text = table.parent().text().replace("clear", "");
        field.attr("value", field.attr("value").replace(new RegExp("(, )*"+text+"$|"+text+"(, )*"), ""));
      });
    })
  });
})