/* Main script */
var types = ["text", "button", "radio", "checkbox", "image"];

function init() {
  fillElements(["form", "output", "formdata"]);
}

function addComponent(type) {
  var ntype = types[type];
  var item = createElement("div", {className:"item " + ntype, dataset:{kind:ntype}, onmouseup:checkDrop}, elements.form);
  var title = createElement("div", {className:"title", title:"Click to edit", contentEditable:true}, item);
  var contents = createElement("div", {className:"content", id:types[type] + elements.form.children.length}, item);
  createElement("div", {className:"handle", onmousedown:dndStart}, item);
  createElement("div", {className:"remove", title:"Remove", innerHTML:"\u2716"}, item).onclick = function() {
    var p = this.parentNode;
    p.parentNode.removeChild(p);
  };

  switch(type) {
    case 0: {
      title.innerHTML = "Text";
      createElement("input", {type:"text", size:80}, contents);
      break;
    }

    case 1: {
      title.innerHTML = "Button";
      createElement("input", {type:"text", value:"Button"}, contents);
      break;
    }

    case 2: {
      title.innerHTML = "Single option list";
      addOption("radio", contents);
      addOption("radio", contents);
      addOption("radio", contents);
      createElement("input", {type:"button", value:"Add", onclick:function(){addOption("radio", contents);}}, item);
      createElement("input", {type:"button", value:"Remove", onclick:function(){if(contents.children.length == 0)return;contents.removeChild(contents.lastElementChild)}}, item);
      break;
    }

    case 3: {
      title.innerHTML = "Multiple option list";
      addOption("checkbox", contents);
      addOption("checkbox", contents);
      addOption("checkbox", contents);
      createElement("input", {type:"button", value:"Add", onclick:function(){addOption("checkbox", contents);}}, item);
      createElement("input", {type:"button", value:"Remove", onclick:function(){if(contents.children.length == 0)return;contents.removeChild(contents.lastElementChild)}}, item);
      break;
    }

    case 4: {
      title.innerHTML = "Image";
      createElement("img", {src:"images/nu.png", style:{cursor:"pointer"}, title:"Click to change", onclick:function(){this.nextElementSibling.click()}, onerror:function(){this.src="images/nu.png"}}, contents);
      createElement("input", {style:{visibility:"hidden"}, type:"file", accept:"image/*"}, contents).onchange = function() {
        var file = this.files[0], fr = new FileReader(), img = this.previousElementSibling;
        fr.onloadend = function() {
          var blob = new Blob([fr.result], {type:file.type});
          img.src = URL.createObjectURL(blob);
        }
        fr.readAsArrayBuffer(file);
      };
      break;
    }
  }
}

function addOption(type, to) {
  var eid = to.childNodes.length + 1;
  var holder = createElement("div", {}, to);
  createElement("input", {type:type, name:to.id}, holder);
  createElement("label", {contentEditable:true, innerHTML:"Option " + eid}, holder);
}

function saveForm() {
  var items = document.querySelectorAll("#form .item"), o = [];
  for(var i = 0; i < items.length; i++) {
    var item = items[i], data = item.children[1].children;
    var title = item.children[0].innerHTML;
    var type = item.dataset.kind;
    var contents;

    switch(type) {
      case "text": // Text
        contents = data[0].value;
        break;

      case "button": // Button
        contents = data[0].value;
        break;

      case "radio": // Radio
        contents = [];
        for(var r = 0; r < data.length; r++) {
          var rb = data[r].children;
          contents.push([rb[0].checked, rb[1].innerHTML]);
        }
        break;

      case "checkbox": // Checkbox
        contents = [];
        for(var c = 0; c < data.length; c++) {
          var cb = data[c].children;
          contents.push([cb[0].checked, cb[1].innerHTML]);
        }
        break;

      case "image": // Image
        contents = data[0].src;
        break;
    }

    o.push({"title":title, "type":type, "contents":contents});
  }

  elements.formdata.value = JSON.stringify(o, null, 2);
  lsSetValue("formData", JSON.stringify(o));
  document.getElementById("saveform").submit();
}

function checkDrop(event) {
  if(dndData == null) return;
  var t = event.target;
  while(t.className.indexOf("item") == -1 && t.nodeName == "DIV") t = t.parentNode;

  if(event.clientY < (t.offsetTop + (t.offsetHeight / 2)))
    t.parentNode.insertBefore(dndData.ele, t);
  else
    t.parentNode.insertBefore(t, dndData.ele);
}

$(window).load(init)