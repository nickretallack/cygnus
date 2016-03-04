IndexField = (function(){

  var self;

  var IndexField = function(element){

    self = this;

    self.indexField = element;

    self.indexField.parents(".content").css({
      width: "100%"
    });

    self.pool = self.indexField.children(".col");
    self.iconWidth = 72;
    
    var arrow = function(direction){
        return $("<div />", {
          class: "col"
        }).css({
          width: self.iconWidth
        }).append($("<i />", {
          class: "material-icons",
          text: direction === "left"? "keyboard_arrow_left" : "keyboard_arrow_right",
          css: {
            fontSize: "72px"
          }
        }).on("click.indexField", function(){
          self.move(direction === "left"? "left" : "right")
        }));
    };

    self.resize();
    self.pool.before(arrow("left"));
    self.pool.after(arrow("right"));

    $(window).resize(function(){ self.resize(); });

  };

  Make.extend(IndexField.prototype, {

  move: function(direction){
    if(direction === "right"){
      self.pool.children(":not(:hidden)").first().hide();
    }else if(direction === "left"){
      self.pool.children(":hidden").last().show();
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