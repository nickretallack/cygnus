//$(".kanban-card").parents(".card").find("#kanban_list_order").attr("value", "20,21");

function onReady(){
  $(".kanban-card").mouseenter(function(){
    $(this).css("outline", "4px dashed slategrey");
    $(this).on("mousedown", function(event){
      pauseEvent(event);
      held = $(this);
      $("<div />", {
        class: "card thing"
      }).css({
        backgroundColor: held.css("background-color"),
        color: held.find("#kanban_card_title").css("color")
      }).append($("<h3 />", {
        text: held.find("#kanban_card_title").attr("value")
      })).appendTo($(document.body));
      $(".thing").css({
        color: held.find("#kanban_card_title").css("color"),
        position: "absolute",
        top: event.pageY,
        left: event.pageX,
        pointerEvents: "none"
      });
      $(".thing").css({
        marginLeft: $(".thing").outerWidth()/-2,
        marginTop: $(".thing").outerHeight()/-4
      });
      $(window).on("mousemove", function(event){
        $(".thing").css({
          top: event.pageY,
          left: event.pageX
        });
      });
    });
  }).mouseleave(function(){
    $(this).css("outline", "none");
  });

  $(window).mouseup(function(event){
    $(".thing").remove();
    var card = $(event.target).parents(".kanban-card");
    card.css("outline", "none");
    if(held.prevAll(".kanban-card").toArray().contains(card[0])){
      held.insertBefore(card);
    }else if(held.nextAll(".kanban-card").toArray().contains(card[0])){
      held.insertAfter(card);
    }
    var arr = $(".kanban-card").toArray();
    $(".kanban-card").parents(".card").find("#kanban_list_order").attr("value",
      [].fill(arr.length, function(index){return parseInt(arr[index].id);}).toString()
    );
    $(window).off("mousemove");
  });
}