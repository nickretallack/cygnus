Poller = (function(){

    var self;

    var Poller = function(){

        self = this;
        self.submissionId = (function(){
            if(/\/submissions\/\d+/.test(window.location.pathname)){
                return parseInt(window.location.pathname.replace("/submissions/", ""));
            }else{
                return -1;
            }
        })();
        self.count = $("#messages").find(".message").length;
        self.displayTime = 4000;
        self.shortTime = Math.rndint(2000, 10000);
        self.longTime = 60000;

    };

    Make.extend(Poller.prototype, {

        poll: function(){
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