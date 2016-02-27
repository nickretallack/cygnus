IndexField = (function(){

  var self;

  var IndexField = function(element){

    self = this;

    self.indexField = element;
    self.pool = self.indexField.children(".content");
    self.content = self.indexField.parent(".content");
    if(!self.pool.exists()) return;
    self.iconWidth = 56;
    
    var arrow = function(direction){
        return $("<div />", {
          class: "col"
        }).css({
          width: self.iconWidth,
        }).append($("<i />", {
          class: "material-icons medium",
          text: direction === "left"? "keyboard_arrow_left" : "keyboard_arrow_right"
        }).on("click.indexField", function(){
          self.move(direction === "left"? "left" : "right")
        }));
    };

    self.resize();
    self.pool.html($("<div />", {
      html: self.pool.html()
    }));
    self.pool.before(arrow("left"));
    self.pool.after(arrow("right"));

    $(window).resize(function(){ self.resize(); });

  };

  Make.extend(IndexField.prototype, {

  move: function(direction){
    var moved = self.pool.children(":hidden").toArray();
    switch(direction){
    case "left":
      $(moved.last()).show();
      break;
    case "right":
      if(moved.length < self.pool.children().length - Math.floor(self.pool.width()/170)) (moved.last() === undefined? self.pool.children(":nth-child(1)") : $(moved.last()).next()).hide();
      break;
    }
  },

  resize: function(){
    self.pool.css({
      width: self.indexField.width() - (self.iconWidth + 2) * 2
    });
  }

  });

  return IndexField;

})();