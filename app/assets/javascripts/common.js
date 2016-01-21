function pauseEvent(event){
  if(event.stopPropagation) event.stopPropagation();
  if(event.preventDefault) event.preventDefault();
  event.cancelBubble = true;
  event.returnValue = false;
}

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
    return $(Screen.widthTester).css("width") === value + "px";
  }
});

Init = {
  js: {
    ".nojs": function(elements){ elements.hide(); },
    ".js": function(elements){ elements.show(); },
    ".remote": function(elements){ elements.attr("data-remote", "true"); }
  },
  classes: {
    AddableAttachment: ".attachment-area",
    Destroyable: ".destroyable",
    Hidable: ".hidable"
  }
};

function initialize(element){
  element = $(element);
  $.each(Init.js, function(key, value){
    value(element.find(key));
  });
  $.each(Init.classes, function(key, value){
    new window[key](element.find(value))
  });
}