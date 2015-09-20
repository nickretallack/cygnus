readyFunctions.push(function(){
  var fields = $("[class $= index-field]");

  $.each(fields, function(index, field){
    field = $(field);
    field.css({
      height: 170
    });
    var pool = field.children(".col");
    pool.css({
      width: "80%",
      height: 163,
      overflow: "hidden"
    });
    $(window).resize(function(){ pool.children().show() });
    var move = function(direction){
      var moved = pool.children(":hidden").toArray();
      switch(direction){
        case "left":
          $(moved.last()).show();
          break;
        case "right":
          if(moved.length < pool.children().length - Math.floor(pool.width()/170)) (moved.last() === undefined? pool.children(":nth-child(1)") : $(moved.last()).next()).hide();
          break;
      }
    };
    field.append($("<div />", {
      class: "col vc"
    }).css({
      width: "10%",
      userSelect: "none"
    }).append($("<i />", {
      class: "material-icons medium",
      text: "play_arrow"
    }).on("click", function(){
      move("right");
    }))).prepend($("<div />", {
      class: "col vc"
    }).css({
      width: "10%",
      userSelect: "none"
    }).append($("<i />", {
      class: "material-icons medium",
      text: "play_arrow"
    }).on("click", function(){
      move("left");
    }).css({
      transform: "scaleX(-1)"
    })));
  });
});