//event listener (sse)
//
// if(typeof source === "undefined"){
//   source = new EventSource("/message_listener")
//   source.onmessage = function(event){
//     $("#comments").append(event.data);
//   };
// }

Message = (function(){

  var Message = function(element){

    var self = this;

    self.message = element;
    self.container = new ActiveContainer(element);
    self.unreadList = $("#unread");
    self.readList = $("#read");

    self.message.find(".name").text(function(index, text){
      return text === currentUser()? "you" : text;
    });

    self.container.buttonTable.append(self.container.closeButton);

    self.container.closeButton.on("click.Destroyable", function(){
      self.container.destroy();
      self.message.prependTo(self.readList);
      self.container.buttonTable.remove();
      var parentHidable = self.readList.parents(".hidable");
      if(parentHidable.hasClass("max")){
        bleatr.where(function(element){
          return element["container"] !== undefined && element.container["container"] !== undefined && element.container.container.get(0) == parentHidable.get(0);
        }).first().container.maximize(false);
      }
    });

  };

  Make.extend(Message.prototype, {

  });

  return Message;

})();

previewButton = function(button){
  button = $(button);
  button.on("click.preview", function(event){
    pauseEvent(event);
    var message = $(button.prevAll("textarea")[0]),
        previewArea = $($(message.nextAll(".message-preview")[0]));
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

function placeMessage(message, newMessage){
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
      return getIndent($(this)) <= getIndent(message);
    });
    if(nonReplies.length === 0){
      var element = (function(){
        if(message.parents(".hidable").length === 0) return $("#messages");
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
  $(".message-preview").html("");
}