readyFunctions.push(function(){
  topCard = $(".top-card");
  if(topCard === []){
    delete topCard;
    return;
  }
  topCard.find("[class$='-mode']").hide();
  topCard.find
  $(".trigger").on("click", function(){
    switchToWorklistMode($(this).html().toLowerCase().replace(" mode", ""));
  });
  switchToWorklistMode("view");
});

function switchToWorklistMode(toMode){
  if(typeof mode !== "undefined"){
    topCard.find("[class *= -mode]").hide();
    topCard.find(".card").off();
  }
  mode = toMode;
  topCard.find($("."+mode+"-mode")).show();
  if(typeof window[mode+"Worklist"] === "function") window[mode+"Worklist"]();
}

function viewWorklist(){
  topCard.children(".card-content").css({
    paddingTop: 5
  });
}

function editWorklist(){
  topCard.children(".card-content").css({
    paddingTop: 20
  });
}

function reorderWorklist(){
  topCard.children(".card-content").css({
    paddingTop: 5
  });
  topCard.find(".card").on("mouseenter", function(){
    hover = $(this);
    hover.find("h4", "h5").css({
      cursor: "default"
    })
    $(this).css("outline", "4px dashed slategrey");
    $(this).on("mousedown", function(event){
      held = $(this);
      var title = held.find("#title");
      pauseEvent(event);
      $("<div />", {
        class: "card thing"
      }).css({
        backgroundColor: held.css("background-color"),
        color: title.css("color")
      }).append($("<"+title.prop("tagName")+" />", {
        text: title.html()
      })).appendTo($(document.body));
      $(".thing").css({
        position: "absolute",
        top: event.pageY,
        left: event.pageX,
        pointerEvents: "none",
        padding: "10px"
      });
      $(".thing").css({
        marginLeft: $(".thing").outerWidth()/-2,
        marginTop: $(".thing").outerHeight()/-4
      });
      $(window).on("mousemove", function(event){
        if(typeof scrollTimer !== "undefined") clearInterval(scrollTimer);
        y = event.pageY;
        if(event.pageY-$(window).scrollTop() > $(window).height()*.8){
          scrollTimer = setInterval(function(){
            if(y < $("footer").offset().top && $(window).scrollTop() < $(window).height() - 5){
              $(window).scrollTop($(window).scrollTop()+3);
              y += 3;
              $(".thing").css({
                top: y
              });
            }
          }, 5);
        }else if(event.pageY-$(window).scrollTop() < $("header").height()*2){
          scrollTimer = setInterval(function(){
            if($(window).scrollTop() > 5){
              $(window).scrollTop($(window).scrollTop()-3);
              y -= 3;
              $(".thing").css({
                top: y
              });
            }
          }, 5);
        }
        $(".thing").css({
          top: event.pageY,
          left: event.pageX
        });
      });
    });
  }).on("mouseleave", function(){
    $(this).css("outline", "none");
  });

  $(window).on("mouseup", function(event){
    if($(event.target).prop("tagName") === "INPUT") return;
    $(window).off("mousemove");
    $(".thing").remove();
    if(typeof hover !== "undefined") hover.css("outline", "none");
    if(typeof held !== "undefined"){
      if($(held.parents(".card")[0]).hasClass("list")){
        if(hover.hasClass("list")){
          held.appendTo($(hover.find(".card-title")[0]));
        }else{
          if(held.prevAll(".card").toArray().contains(hover[0])){
            held.insertBefore(hover);
          }else{
            held.insertAfter(hover);
          }
        }
      }else if(hover.hasClass("list")){
        if(held.prevAll(".card").toArray().contains(hover[0])){
          held.insertBefore(hover);
        }else{
          held.insertAfter(hover);
        }
      }
    }
    fillWorklistOrderField();
  });
}

function fillWorklistOrderField(){
  var lists = $(".list");
  $("#card_order").attr("value",
  ("{"+$(".top-card").attr("id")+"=>["+[].fill(lists.length, function(index){
      return lists.length > 0? lists[index].id : "";
    }).join(", ")+"]").replace(/'/g, "\"")+
  (function(){
    var append = "";
    $.each(lists, function(index, list){
      list = $(list);
      var cards = list.find(".card");
      append += (", "+list.attr("id")+"=>["+[].fill(cards.length, function(index){
          return cards.length > 0? cards[index].id : "";
        }).join(", ")+"]").replace(/'/g, "\"");
    });
    return append+"}";
  })());
}