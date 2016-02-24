/**
 *  VWorkspace: Workspace for vertical layouts
 *    Author: Xch3l
 *    Version Datecode: 150914
 *    Mofified Feb. 2016 by TwilightStormshi
 */

function VWorkspace(element) {
  var ws = {children:[], dragData:{element: null, placeHolder: null, offsetY:0, originalY:0}};

  element.workspace = ws;

  var events; // Events to hook up to. Will depend on if there's touchscreen support
  if(typeof document.ontouchstart === "undefined")
    events = ["mousedown", "mouseup", "mousemove"];
  else
    events = ["touchstart", "touchend", "touchmove"];

  element.addEventListener(events[0], VWorkspace.onMouseDown);
  element.addEventListener(events[1], VWorkspace.onMouseUp);
  element.addEventListener(events[2], VWorkspace.onMouseMove);
}

VWorkspace.setupAll = function() {
  var w = document.querySelectorAll(".workspace");
  for(var i = 0; i < w.length; i++)
    VWorkspace(w[i]);
}

VWorkspace.onMouseDown = function(event) {
  var t = event.target, w = event.currentTarget, ws = w.workspace, dd = ws.dragData;
  if(t.className.indexOf("handle") == -1) return;
  var eventY = event.clientY || event.touches[0].clientY; // Prepare in case of touch event
  event.preventDefault();

  // Set Y offset in relation to the handle position
  var rect = getRect(t);
  dd.offsetY = (eventY - rect.y);

  // Scale up to parent container
  do {
    t = t.parentNode;
    if(t == w) return;
  } while(t.className.indexOf("workspace_element") == -1);

  // Update workspace children
  ws.children = [];
  for(var i = 0; i < w.children.length; i++) {
    var child = w.children[i];
    ws.children.push({rect:getRect(child), element:child, moved:false});
  }

  // Create placeholder
  dd.element = t;
  rect = getRect(t);
  dd.originalY = (eventY - rect.y);
  dd.placeHolder = VWorkspace.createElement("div", {style:{width:rect.contentWidth + "px", height:rect.contentHeight + "px"}}, w);
  w.insertBefore(dd.placeHolder, t);

  // Set up target to display as "floating"
  t.style.width = rect.contentWidth + "px";
  t.className += " floating";
  w.className += " holding";

  // Update target position by relaying this event to onMouseMove
  VWorkspace.onMouseMove(event);
};

VWorkspace.onMouseUp = function(event) {
  var t = event.target, w = event.currentTarget, ws = w.workspace, dd = ws.dragData;
  if(dd.element == null) return; // Stop if we are not dragging anything by its handle
  event.preventDefault();

  w.insertBefore(dd.element, dd.placeHolder);
  dd.element.className = dd.element.className.replace(" floating", "");
  w.className = w.className.replace(" holding", "");
  dd.element.style.width = "";
  dd.element.style.left = "";
  dd.element.style.top = "";

  // Remove place holder and stop dragging
  w.removeChild(dd.placeHolder);
  dd.placeHolder = null;
  dd.element = null;
};

VWorkspace.onMouseMove = function(event) {
  var t = event.target, w = event.currentTarget, ws = w.workspace, dd = ws.dragData;
  if(dd.element == null) return; // Stop if we are not dragging anything by its handle
  var eventY = event.clientY || event.touches[0].clientY; // Prepare in case of touch event
  event.preventDefault();

  var rect = getRect(w);
  var ny = rect.paddingTop + (eventY - dd.offsetY) - rect.y;
  dd.element.style.top = ny + "px";

  var my = eventY - rect.y;
  for(var i = 0; i < ws.children.length; i++) {
    var child = ws.children[i];

    if(dd.element != child.element) {
      var yy = (child.rect.y - rect.y), offs = (child.rect.h / 2), oy = yy + offs;

      if(!child.moved) { // Prevent flickering of tall items
        if(my > yy && my < (yy + offs)) {
          w.insertBefore(child.element, dd.placeHolder);
          child.rect = getRect(child.element);
          child.moved = true;
        }

        if(my > (yy + offs) && my < (yy + child.rect.h)) {
          w.insertBefore(dd.placeHolder, child.element);
          child.rect = getRect(child.element);
          child.moved = true;
        }
      } else
      if(my < yy || my > (yy + child.rect.h)) {
        child.moved = false;
      }
    }
  }
};

VWorkspace.createElement = function(tag, attrs, appendTo) {
  if(!tag) throw new SyntaxError("'tag' not defined");

  var ele = document.createElement(tag), attrName, styleName, dataName;
  if(attrs) for(attrName in attrs) {
    if(attrName === "style") for(styleName in attrs.style) {ele.style[styleName] = attrs.style[styleName];} else
    if(attrName === "dataset") for(dataName in attrs.dataset) {ele.dataset[dataName] = attrs.dataset[dataName];} else
      ele[attrName] = attrs[attrName];
  }

  if(appendTo) appendTo.appendChild(ele);
  return ele;
};

function getRect(e) {
  var s = window.getComputedStyle(e);
  var r = e.getBoundingClientRect();

  var o = {
    x: (r.left + parseInt(s.marginLeft)),
    y: (r.top  + parseInt(s.marginTop)),
    w: (r.clientWidth  + parseInt(s.borderLeftWidth) + parseInt(s.borderRightWidth)),
    h: (e.clientHeight + parseInt(s.borderTopWidth) + parseInt(s.borderBottomWidth)),

    contentLeft: r.left, contentTop: r.top,
    contentWidth: r.width, contentHeight: r.height,

    paddingLeft: parseInt(s.paddingLeft), paddingTop: parseInt(s.paddingTop),
    marginLeft: parseInt(s.marginLeft), marginTop: parseInt(s.marginTop)
  };

  return o;
}