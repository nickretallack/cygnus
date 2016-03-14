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
    self.unreadHidable = self.unreadList.parents(".hidable");
    self.readHidable = self.readList.parents(".hidable");
    self.unreadCounter = $("#unread-messages-count");

    self.message.find(".name").filter(function(index, element){
      return $(element).text() === currentUser;
    }).text("you");

    self.container.buttonTable.append(self.container.closeButton);

    self.container.closeButton.on("click.Destroyable", function(){
      self.destroy();
    });

  };

  Make.extend(Message.prototype, {

    initialize: function(){
      var self = this;
      self.unreadHidableObject = bleatr.where(function(element){
        return element["container"] !== undefined && element.container["container"] !== undefined && element.container.container.get(0) === self.unreadHidable.get(0);
      }).first();
      self.readHidableObject = bleatr.where(function(element){
        return element["container"] !== undefined && element.container["container"] !== undefined && element.container.container.get(0) === self.readHidable.get(0);
      }).first();
    },

    destroy: function(){
      var self = this;
      self.container.destroy();
      self.message.prependTo(self.readList);
      self.container.buttonTable.remove();
      self.unreadHidableObject.container.maximize(false);
      if(self.readHidable.hasClass("max")){
        self.readHidableObject.container.maximize(false);
      }
      self.unreadCounter.text(function(index, text){
        return parseInt(text) - 1;
      });
    }

  });

  return Message;

})();

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