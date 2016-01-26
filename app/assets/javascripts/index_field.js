IndexField = (function(){

  var IndexField = function(element){

    this.indexField = element;
    this.pool = this.indexField.children(".col");
    this.iconWidth = 56;
    this.initialize();

  };

  Make.extend(IndexField.prototype, {

    initialize: function(){

      $.extend(this, {

        indexFieldCss: {
          height: 170
        },

        arrow: function(direction){
          var self = this;

          return $("<div />", {
            class: "col"
          }).css({
            width: this.iconWidth,
            height: "100%",
            margin: 0,
            userSelect: "none",
            padding: "0 1px"
          }).append($("<i />", {
            class: "material-icons medium vc",
            text: direction === "left"? "keyboard_arrow_left" : "keyboard_arrow_right"
          }).on("click.indexField", function(){
            self.move(direction === "left"? "left" : "right")
          }));
        }

      });

      this.indexField.css(this.indexFieldCss);
      this.resize();
      this.pool.html($("<div />", {
        class: "vc",
        html: this.pool.html()
      }));
      this.pool.before(this.arrow("left"));
      this.pool.after(this.arrow("right"));

      var self = this;

      $(window).resize(function(){ self.resize(); });

    },

    move: function(direction){
      var moved = this.pool.children(":hidden").toArray();
      switch(direction){
        case "left":
          $(moved.last()).show();
          break;
        case "right":
          if(moved.length < this.pool.children().length - Math.floor(this.pool.width()/170)) (moved.last() === undefined? this.pool.children(":nth-child(1)") : $(moved.last()).next()).hide();
          break;
      }
    },

    resize: function(){
      this.pool.css({
        width: this.indexField.width() - (this.iconWidth + 2) * 2,
        height: "100%",
        margin: 0,
        overflow: "hidden"
      });
    }

  });

  return IndexField;

})();