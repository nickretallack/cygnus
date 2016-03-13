IndexField = (function(){

  var IndexField = function(element){

    var self = this;

    self.indexField = element;

    self.indexField.closest(".content").css({
      width: "100%",
      overflow: "hidden"
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
      var self = this;
      if(direction === "right"){
        if(!self.end()) self.pool.children(":not(:hidden)").first().hide();
      }else if(direction === "left"){
        self.pool.children(":hidden").last().show();
      }
    },

    resize: function(){
      var self = this,
          size = self.size();
      self.pool.css({
        width: self.indexField.width() - (self.iconWidth + 2) * 2
      });
      if(self.size() < size){
        self.move("right");
      }else if(self.size() > size){
        self.move("left");
      }
    },

    size: function(){
      var self = this;
      return Math.floor(self.pool.width() / (self.pool.children().eq(0).width() + 10));
    },

    end: function(){
      var self = this;
      return self.pool.children(":not(:hidden)").length - 1 < self.size();
    }

  });

  return IndexField;

})();