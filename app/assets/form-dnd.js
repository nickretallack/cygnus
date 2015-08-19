/* Drag and drop component */
var dndData = null;

function dndStart(event) {
  event.preventDefault();
  var target = event.target.parentNode, tparent = target.parentNode, tstyle = target.style, cstyle = getComputedStyle(target);
  var placeholder = createElement("div", {style:{display:"block", width:target.offsetWidth + "px", height:target.offsetHeight + "px"}, className:"placeholder"}, tparent);

  dndData = {ele:target, ph:placeholder, ox:(2 - window.scrollX), oy:(target.offsetTop - event.clientY) - window.scrollY, oz:cstyle.zIndex, op:cstyle.position};

  tstyle.position = "fixed";
  tstyle.zIndex = 12500;
  tstyle.opacity = 0.5;
  tparent.insertBefore(placeholder, target);
  dndMove(event);
  document.body.style.cursor = "move";
}

function dndMove(event) {
  if(dndData == null) return;
  var target = dndData.ele, tstyle = target.style;
  tstyle.left = (event.clientX + dndData.ox) + "px";
  tstyle.top = (event.clientY + dndData.oy) + "px";
}

function dndEnd() {
  if(dndData == null) return;
  var target = dndData.ele, tstyle = target.style;
  tstyle.zIndex = dndData.oz;
  tstyle.position = dndData.op;
  tstyle.left = tstyle.top = "0px";
  tstyle.opacity = 1;

  var placeholder = dndData.ph;
  placeholder.parentNode.removeChild(placeholder);

  dndData = null;
  document.body.style.cursor = "";
}