loadFunctions.push(function(){

  $(".dropdown-button").dropdown({
    belowOrigin: true,
    hover: true,
    constrain_width: false
  });

  $(".dropdown-button").off("click");
  $(".dropdown-button").trigger("mouseover");
  $(".dropdown-button").trigger("mouseout");

  $(".button-collapse").sideNav({
    closeOnClick: true,
    menuWidth: 550
  });

  var columnize = function(menu){
    var row = $("<div />", {
      class: "row"
    });
    $.each(menu.children().splitBy("HR"), function(index, array){
      var me = $(this)
      var column = $("<div />", {
        class: "col"+(function(){
          if(me.prop("tagName") === "FORM"){
            return "";
          }else{
            return " fl";
          }
        })()
      });
      $.each(array, function(index, element){
        $(element).appendTo(column);
      });
      row.append(column);
    });
    row.appendTo(menu);
    menu.children("hr").remove();
  }

  $(window).keydown(function(event){
    if(event.keyCode === 27) $(".button-collapse").sideNav("hide");
  });

  var pushpinNav = function(){
    if($(window).scrollTop() > $("header").children("img").outerHeight())
    {
      $("nav").css({
        position: "fixed",
        top: 0
      });
    }else if($(window).scrollTop() === 0){
      $("nav").css({
        position: "relative",
        top: "auto"
      });
    }
  };

  pushpinNav();

  $(window).scroll(pushpinNav);
  
});