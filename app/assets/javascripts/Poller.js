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
    },

    pollOld: function(){
      $.get("/message_poller",
        {
          submission_id: self.submissionId,
          count: self.count
        },
        function(data){
          if(data !== ""){
            data = JSON.parse(data);
            var newMessage = $(data.message);
            if(newMessage.is(".minimal")){
              if(newMessage.text().contains("commissions status")){
                var text = newMessage.text().replace(/set their commissions status.*/, "updated their commission statuses.");
              }else{
                var text = newMessage.text();
              }
              Materialize.toast(text, self.displayTime);
              if(/Activity$/.test($(".header").text())) $("#messages").prepend(newMessage.clone().addClass("fade-in"));
              $(".circular-button").find("div").text(parseInt($(".circular-button").find("div").text())+1)
              poller = setTimeout(pollNow, data.pollAgain? self.shortTime : self.longTime);
            }else{
              if(messageSync instanceof MessageSync){
                placeMessage((function(){
                  if(!newMessage.is("[class *= reply]")) return undefined;
                  return $("#"+/reply-\d+/.exec(newMessage.attr("class"))[0].replace("reply-", ""));
                })(), newMessage);
                poller = setTimeout(pollNow, self.longTime);
              }
            }
          }else{
            poller = setTimeout(pollNow, self.longTime);
          }
        }
      );
    }

  });

  return Poller;

})();