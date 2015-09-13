readyFunctions.push(function(){
  topCard = $(".top-card");
  if(topCard === []){
    delete topCard;
    return;
  }
  topCard.find("[class$='-mode']").hide();
  $(".trigger").on("click", function(){
    switchToWorklistMode($(this).html().toLowerCase().replace(" mode", ""));
  });
  switchToWorklistMode("view");
});

function switchToWorklistMode(toMode){
  if(typeof mode !== "undefined"){
    var elements = topCard.find("."+mode+"-mode");
    elements.hide();
    elements.off();
  }
  mode = toMode;
  topCard.find($("."+mode+"-mode")).show();
  window[mode+"Worklist"]();
}

function viewWorklist(){
  topCard.children(".card-content").css({
    paddingTop: "5px"
  });
}

function editWorklist(){

}

function reorderWorklist(){
  if(!$(".kanban-card") === []){
    $(".kanban-card").on("mouseenter", function(){
      $(this).css("outline", "4px dashed slategrey");
      $(this).on("mousedown", function(event){
        held = $(this);
        if(!$(event.target).is("label") && !$(event.target).is("input") && !$(event.target).is("img")){
          pauseEvent(event);
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
        }
      });
    }).mouseleave(function(){
      $(this).css("outline", "none");
    });

    $(window).mouseup(function(event){
      $(".thing").remove();
      var card = $(event.target).parents(".kanban-card");
      card.css("outline", "none");
      if(typeof held !== "undefined"){
        if(held.prevAll(".kanban-card").toArray().contains(card[0])){
          held.insertBefore(card);
        }else if(held.nextAll(".kanban-card").toArray().contains(card[0])){
          held.insertAfter(card);
        }
      }
      var arr = $(".kanban-card").toArray();
      $(".kanban-card").parents(".card").find("#kanban_list_order").attr("value",
        [].fill(arr.length, function(index){return parseInt(arr[index].id);}).toString()
      );
      $(window).off("mousemove");
    });
  }
}

function deleteWorklist(){

}