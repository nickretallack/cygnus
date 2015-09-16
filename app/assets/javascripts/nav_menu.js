readyFunctions.push(function(){
  $(".dropdown-button").dropdown({
    belowOrigin: true,
    hover: true,
    constrain_width: false
  });

  $(".dropdown-button").off("click");

  $(".button-collapse").sideNav({
    menuWidth: 530,
    closeOnClick: true
  }); 

  var columnize = function(menu){
    var row = $("<div />", {
      class: "row"
    });
    $.each(menu.children().splitBy("HR"), function(index, array){
      var column = $("<div />", {
        class: "col"
      });
      $.each(array, function(index, element){
        $(element).appendTo(column);
      });
      row.append(column);
    });
    row.appendTo(menu);
    menu.children("hr").remove();
  }

  columnize($(".dropdown-content"));
  columnize($(".side-nav").css({
    height: "296px",
    padding: 0,
    paddingTop: "20px"
  }));

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