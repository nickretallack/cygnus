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
          $("#messages").html(data);
        }
      });
    //poller = setTimeout(pollNow, 1000);
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

  replyButton = function(reply){
    reply = $(reply);
    var clonable = $("#messages").nextAll(".new").children("form").clone();
    reply.css({
      cursor: "pointer"
    });
    reply.on("click.reply", function(){
      var message = reply.parents(".message");
      if(message.find("form").length === 0){
        message.append($("<div />", {
          class: "col s12"
        }).css({
          marginBottom: 10
        }).append(clonable)).find("[name = post]").attr("value", function(index, value){
          return "Reply to "+message.find("h5").text()+" "+(value.replace("Post ", "").wrap("("));
        }).before($("<input />", {
          type: "hidden",
          name: "message[message_id]",
          id: "message_message_id",
          value: message.attr("id")
        }));
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
      form.parent(".new").replaceWith($("<div />", {
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