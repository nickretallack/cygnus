Poller = (function(){

  var Poller = function(){

    var self = this;

    self.submissionId = (function(){
      if(/\/submission\/(\d+)/.test(window.location.pathname)){
        return parseInt(RegExp.$1);
      }else{
        return -1;
      }
    })();
    self.comments = $("#comments");
    self.pms = $("#pms");
    self.unreadCounter = $("#unread-messages-count");
    self.unreadPMCounter = $("#unread-pms-count");
    self.displayTime = 4000;
    self.pollingInterval = 2000;
    self.pollAgain = {
      min: 2000,
      max: 2000
    }
    self.disableToasting = $("[disable-toasting]").attr("disable-toasting");
    self.disableToasting = self.disableToasting === "true"? true : false;

    if(currentUser !== "") self.poll();

  };

  Make.extend(Poller.prototype, {

    poll: function(){
      var self = this;
      $.ajax({
        url: "/message_poller",
        data: {
          submission_id: self.submissionId,
          comments: $(".comment").length,
          pms: parseInt(/\d+/.exec(self.unreadPMCounter.text()))
        },
        success: function(data){
          data = JSON.parse(data);
          if(data.activity !== null){
            self.unreadCounter.text(function(index, text){
              return parseInt(text) + 1;
            });
            if(self.disableToasting){
              setTimeout(function(){
                self.poll();
              }, Math.rndint(self.pollAgain.min, self.pollAgain.max));
            }else{
              Materialize.toast(data.activity, self.displayTime, "", function(){
                setTimeout(function(){
                  self.poll();
                }, Math.rndint(self.pollAgain.min, self.pollAgain.max));
              });
            }
          }else{
            setTimeout(function(){
              self.poll();
            }, self.pollingInterval);
          }
          if(data.comments.length > 0){
            $.each(data.comments, function(index, comment){
              self.placeComment($(comment[0]), self.comments.find("#" + comment[1]));
            })
          }
          console.log(data.pms);
          if(data.pms.length > 0){
            self.unreadPMCounter.text(function(index, text){
              return "PMs: " + (parseInt(/\d+/.exec(text)[0]) + 1);
            });
            if(self.pms.exists()){
              $.each(data.pms, function(index, pm){
                console.log(pm[2]);
                self.placePM($(pm[0]), $(pm[1]), self.pms.find("#" + pm[2]));
              });
            }
          }
        }
      });
    },

    placeComment: function(comment, parent){
      var self = this;
      if(parent.exists()){
        var parentObject = parent.commentObject();
        parentObject.conversation().last().after(comment);
        initialize();
        comment.addClass("fade-in").addClass("unread");
        setTimeout(function(){
          comment.commentObject().setIndent(parentObject.indent() + 1);
        }, 500);
      }else{
        comment.addClass("fade-in");
        self.comments.append(comment);
        initialize();
      }
    },

    placePM: function(summary, pm, parent){
      var self = this;
      console.log(parent);
      if(parent.exists()){
        pm.addClass("unread");
        parent.after(pm);
        initialize();
      }else{
        summary.addClass("fade-in").addClass("unread").find(".pm").addClass("unread");
        self.pms.append(summary);
        initialize();
      }
    }

  });

  return Poller;

})();