Poller = (function(){

  var Poller = function(){

    var self = this;

    self.submissionId = (function(){
      if(/\/submissions\/\d+/.test(window.location.pathname)){
        return parseInt(window.location.pathname.replace("/submissions/", ""));
      }else{
        return -1;
      }
    })();
    self.unreadCounter = $("#unread-messages-count");
    self.displayTime = 4000;
    self.pollingInterval = 30000;
    self.pollAgain = {
      min: 2000,
      max: 10000
    }

    if(currentUser !== "") self.poll();

  };

  Make.extend(Poller.prototype, {

    poll: function(){
      var self = this;
      $.ajax({
        url: "/message_poller",
        success: function(data){
          data = JSON.parse(data);
          if(data !== null){
            self.unreadCounter.text(function(index, text){
              return parseInt(text) + 1;
            });
            Materialize.toast(data, self.displayTime, "", function(){
              setTimeout(function(){
                self.poll();
              }, Math.rndint(self.pollAgain.min, self.pollAgain.max));
            });
          }else{
            setTimeout(function(){
              self.poll();
            }, self.pollingInterval);
          }
        }
      });
    }

  });

  return Poller;

})();