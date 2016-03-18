function pause(event){
  if(event.stopPropagation) event.stopPropagation();
  if(event.preventDefault) event.preventDefault();
  event.cancelBubble = true;
  event.returnValue = false;
}

Key = {
  keys: {
    ret: 13,
    esc: 27
  }
}

$.each(Key.keys, function(key, value){
  Key[key] = function(event){
    return event.keyCode && event.keyCode === value;
  }
});

Screen = {
  widthTester: ".widthTester",
  widths: {
    tiny: 0,
    small: 363,
    medium: 801,
    large: 993,
    huge: 1921
  }
}

$.each(Screen.widths, function(key, value){
  Screen[key] = function(){
    return $(Screen.widthTester) && $(Screen.widthTester).css("width") === value + "px";
  }
});

Init = {
  js: {
    ".nojs": function(elements){ elements.hide(); },
    ".js": function(elements){ elements.show(); },
    ".remote": function(elements){ elements.attr("data-remote", "true"); }
  },
  classes: { // in order of load
    AddableAttachment: ".attachment-area",
    AddableField: ".addable-field",
    ButtonSubmit: ".button-submit",
    Comment: ".comment",
    ExpandableImage: ".image.medium > img, .image.bordered > img",
    ImagePreview: ".image-preview",
    IndexField: "[class *= index-field]",
    Message: "#unread .message",
    Nav: "header nav",
    OrderForm: ".order-form",
    ViewAnyway: ".adult.image",
    Workboard: ".top-card",

    // keep these last so contents are loaded already
    Destroyable: ".destroyable",
    Hidable: ".hidable"
  }
};

bleatr = [];

function initialize(){
  currentUser = $("#current-user").text();
  $.each(Init.js, function(key, value){
    value($(key));
  });
  $.each(Init.classes, function(key, value){
    $(value).each(function(index, element){
      element = $(element);
      if(!element.hasClass("objectified") && !element.is(".hide") && !element.closest(".hide").exists()){
        bleatr.push(new window[key](element));
        element.addClass("objectified");
      }
    });
  });
  $(".dropdown-button").trigger("mouseout");
  if(window["lastClicked"] !== undefined && lastClicked["area"] !== undefined) lastClicked.area.returnAreaFromSpinner();
}