readyFunctions.push(function(){
  //event listener (sse)
  //
  // if(typeof source === "undefined"){
  //   source = new EventSource("/message_listener")
  //   source.onmessage = function(event){
  //     $("#comments").append(event.data);
  //   };
  // }

  //polling
  window["poller"] = undefined;

  var pollNow = function(){
    $.get("/message_poller",
      {
        submission_id: (function(){
          if(/\/submissions\/\d+/.test(window.location.pathname)) return parseInt(window.location.pathname.replace("/submissions/", ""));
          return -1;
        })(),
        count: $("#messages").find(".message").length
      },
      function(data){
        if(data !== ""){
          data = JSON.parse(data);
          var newMessage = $(data.message);
          if(newMessage.is(".minimal")){
            Materialize.toast(newMessage.text(), 4000);
            if(/Activity$/.test($(".header").text())) $("#messages").prepend(newMessage.clone().addClass("fade-in"));
            $(".circular-button").find("div").text(parseInt($(".circular-button").find("div").text())+1)
            poller = setTimeout(pollNow, data.pollAgain? 2000 : 10000);
          }else{
            placeMessage((function(){
              if(!newMessage.is("[class *= reply]")) return undefined;
              return $("#"+/reply-\d+/.exec(newMessage.attr("class"))[0].replace("reply-", ""));
            })(), newMessage);
            poller = setTimeout(pollNow, 10000);
          }
        }else{
          console.log("polled");
          poller = setTimeout(pollNow, 10000);
        }
      });
  };

  if(poller === undefined) pollNow();
});

readyFunctions.push(function(){
  previewButton = function(button){
    button = $(button);
    button.on("click.preview", function(event){
      pauseEvent(event);
      var message = $(button.prevAll("textarea")[0]),
          previewArea = $($(message.nextAll(".preview")[0]));
      previewArea.html($("<div />", {
        class: "card"
      }).append($("<div />", {
        class: "card-content"
      }).append(markdown.toHTML(message.val()))));
    });
  };

  $(".preview-button").each(function(index, button){
    previewButton(button);;
  });

  var originalNewMessage = $("#main").children(".new");
  clonableNewMessage = originalNewMessage.clone();
  clonableNewMessage.find("[name = 'message[accept_text_reply]']").remove();
  if(/conversations/.test(window.location.pathname) && !/conversations\/./.test(window.location.pathname)) originalNewMessage.remove();

  replyButton = function(reply){
    reply = $(reply);
    
    reply.css({
      cursor: "pointer"
    });
    reply.on("click.reply", function(){
      var message = reply.parents(".message");
      message.find(".errors").remove();
      if(message.find("form").length === 0){
        message.append($("<div />", {
          class: "col s12"
        }).css({
          marginBottom: 10
        }).append(clonableNewMessage.clone())).find("[name = post]").attr("value", function(index, value){
          return "Reply to "+message.find("h5").text()+" "+(value.replace(/Post\s/, "").wrap("("));
        }).before($("<input />", {
          type: "hidden",
          name: "message[message_id]",
          id: "message_message_id",
          value: message.attr("id")
        }));
        message.find("[name = 'message[subject]']").remove();
        previewButton(message.find("[name = preview]"));
        postMessage(message.find("form"));
        doRemote(message.find("form"));
      }
    });
  };

  $(".reply").each(function(index, reply){
    replyButton(reply);
  });
  
  postMessage = function(form){
    form = $(form);
    form.on("submit.message", function(event){
      clearTimeout(poller);
      form.parent(".new").before($("<div />", {
        class: "progress"
      }).append($("<div />", {
        class: "indeterminate"
      })));
    });
  };

  $(".new_message").each(function(index, form){
    postMessage(form);
  });

});

function placeMessage(message, newMessage){
  console.log(newMessage);
  if(!newMessage.is("[class *= reply]")){
    $("#messages").append(newMessage);
    $("#main").children(".progress").remove();
    $("#main").find(".new").find("[name = 'message[content]']").val("");
  }else{
    var getIndent = function(element){
      return parseInt(/indent-\d+/.exec(element.attr("class"))[0].replace("indent-", ""));
    };
    var setIndent = function(className, indentLevel){
      return className.replace(/indent-\d+/, "indent-"+indentLevel.toString());
    };
    newMessage.attr("class", function(index, className){
      return setIndent(className, getIndent(message)+1);
    });
    var nonReplies = message.nextAll(".message").filter(function(){
      return getIndent($(this)) === getIndent(message);
    });
    if(nonReplies.length === 0){
      var element = (function(){
        if($(".hidable").length === 0) return $("#messages");
        return message.parents(".hidable");
      })();
      element.append(newMessage);
    }else{
      nonReplies.first().before(newMessage);
    }
    message.find(".new").parent().remove();
  }
  hideAndShow(newMessage);
  newMessage.addClass("fade-in");
  replyButton(newMessage.find(".reply"));
  var form = $("#main").children(".new").children("form");
  doRemote(form);
  postMessage(form);
  previewButton(form.find("[name = preview]"));
  if(newMessage.is(".hidable")) initHidable(newMessage);
}