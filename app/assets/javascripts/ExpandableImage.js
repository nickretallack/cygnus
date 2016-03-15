ExpandableImage = (function(){

  var ExpandableImage = function(element){

    var self = this;

    self.image = element;
    if(self.image.parents(".image-preview, a").exists()) return;
    if(/-1/.test(self.image.attr("src"))) return;

    self.image.css({
      cursor: "zoom-in"
    });

    self.image.on("click.ExpandableImage", function(event){
      pause(event);
      $("html").css({
        height: "100%",
        overflow: "hidden"
      });
      self.overlay =  $("<div />", {
                        css: {
                          width: "100%",
                          height: "100%",
                          backgroundColor: "rgba(0, 0, 0, 0.9)",
                          position: "fixed",
                          top: 0,
                          zIndex: 2
                        },
                        html: $("<img />", {
                          src: self.image.attr("src").replace(/bordered|limited|medium/, "full"),
                          css: {
                            height: "100%"
                          }
                        })
                      });
      $("body").append(self.overlay);
      self.overlay.on("click.ExpandableImage", function(event){
        var target = $(event.target);
        if(target.is("div")){
          self.exit();
        }
      });
      $(window).on("keyup.ExpandableImage", function(event){
        if(Key.esc(event) && self.overlay.is(":visible")){
          self.exit();
        }
      })
    });

  };

  Make.extend(ExpandableImage.prototype, {

    exit: function(){
      var self = this;
      self.overlay.hide();
      self.image.off("click.ExpandableImage").on("click.ExpandableImage", function(){
        $("html").css({
          height: "100%",
          overflow: "hidden"
        });
        self.overlay.show();
      });
      $("html").css({
        height: "auto",
        overflow: "auto"
      });
    }

  });

  return ExpandableImage;

})();