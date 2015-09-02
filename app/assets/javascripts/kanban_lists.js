//$(".kanban-card").parents(".card").find("#kanban_list_order").attr("value", "20,21");

function onReady(){
  var maxHeight = $(document).height();

  $(".kanban-card").on("mouseenter", function(){
    $(this).css("outline", "4px dashed slategrey");
    $(this).on("mousedown", function(event){
      pauseEvent(event);
      held = $(this);
      if($.extend($(".submit"), $("[type='submit']")).toArray().contains(event.target)) return;
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
        y = event.pageY;
        if(event.pageY-$(window).scrollTop() > $(window).height()*.8){
          if(typeof scrollTimer !== "undefined") clearInterval(scrollTimer);
          scrollTimer = setInterval(function(){
            if(y < $("footer").offset().top){
              $(window).scrollTop($(window).scrollTop()+3);
              y += 3;
              $(".thing").css({
                top: y
              });
            }
          }, 5);
        }else if(event.pageY-$(window).scrollTop() < $("header").height()*2){
          if(typeof scrollTimer !== "undefined") clearInterval(scrollTimer);
          scrollTimer = setInterval(function(){
            $(window).scrollTop($(window).scrollTop()-3);
            y -= 3;
            $(".thing").css({
              top: y
            });
          }, 5);
        }else{
          if(typeof scrollTimer !== "undefined") clearInterval(scrollTimer);
        }
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