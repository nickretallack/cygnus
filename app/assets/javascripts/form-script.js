var main_workspace;

function initFormGenerator() {
  VWorkspace.setupAll();
  main_workspace = document.getElementById("form_generator"); // Find workspace
}

function addItem(src) {
  if(typeof src === "string") { // Using mobile or small layout
    // To avoid recursion, since small version resets value to empty string
    if(src === "") return;
  } else {
    // In case the user poked the icon, scale up one level
    if(src.nodeName === "I") src = src.parentNode;
    src = src.name;
  }

  if(typeof src === "undefined") return; // wat?

  if(src === "saveform") {// Save the form
    var formdata = [], items = main_workspace.children;
    for(var i = 0; i < items.length; i++) formdata.push(items[i].dataset.json);
    document.getElementById("formdata").value = "[" + formdata.join(", ") + "]";
    document.getElementById("formcreator_result").submit();
    return;
  }

  var item = createItem(src);

  switch(src) {
    case "text":
      createElement("input", {type:"text", name:"text", value:"Text"}, item).onchange = updateItemJSON;
      break;

    case "multiline":
      var ta = createElement("textarea", {name:"content", value:"Text"}, item);
      ta.onchange = updateItemJSON;
      ta.onkeydown = function() {
        // Try to expand according to lines
        this.style.height = Math.min(Math.max(50, this.scrollHeight), 150) + "px";
      };
      break;

    case "linklist":
      var list = createElement("ul", {className:"list"}, item);
      addLink(list);
      createElement("input", {type:"button", className:"btn no-effects", onclick:function(){addLink(list);}, value:"Add"}, item);
      break;

    case "chooser":
      var list = createElement("ul", {className:"list"}, item);
      addOption(list, "radio");
      createElement("input", {type:"button", className:"btn no-effects", onclick:function(){addOption(list, "radio");}, value:"Add"}, item);
      break;

    case "selector":
      var list = createElement("ul", {className:"list"}, item);
      addOption(list, "checkbox");
      createElement("input", {type:"button", className:"btn no-effects", onclick:function(){addOption(list, "checkbox");}, value:"Add"}, item);
      break;

    case "image":
      createElement("input", {type:"file", accept:"image/*", form:"formcreator_result"}, item).onchange = function() {
        var file = this.files[0], fr = new FileReader();
        fr.onloadend = function() {img.src = fr.result;};
        fr.readAsDataURL(file);
      };
      var img = createElement("img", {src:"images/icon.png", title:"Click to change", onclick:function(){this.previousElementSibling.click()}, onerror:function(){this.src="images/icon.png"}}, item);
      createElement("div", {innerHTML:"Click to change", onclick:function(){this.previousElementSibling.click()}}, item);
      break;

    case "fileup":
      createElement("input", {type:"file", accept:"*/*", form:"formcreator_result"}, item);
      break;
  }
}

function createItem(typ) {
  var num = main_workspace.children.length; // Item number

  var item = createElement("div", {className:"item workspace_element " + typ}, main_workspace);
  createElement("div", {className:"handle"}, item);
  var itemName = "item_" + typ + num;
  var content = createElement("div", {className:"content", name:itemName}, item);
  createElement("input", {type:"text", name:"title", onchange:updateItemJSON, value:"Title"}, content);
  createElement("div", {className:"remove", onclick:function() {main_workspace.removeChild(item);}, innerHTML:"&#10006;"}, item);

  // "Required" checkbox
  createElement("input", {type:"checkbox", id:itemName + "_required", onclick:function() {updateItemJSON(this, "required", this.checked);}, innerHTML:"&#10006;"}, item);
  createElement("label", {className:"item-required", innerHTML:"Required", htmlFor:itemName + "_required"}, item);

  item.dataset.json = JSON.stringify({type:typ});
  return content;
}

function addLink(list) {
  var updateFunc = function() {
    var links = [];

    for(var i = 0; i < list.children.length; i++) {
      var child = list.children[i];

      links.push({
        url:child.children[0].value,
        text:child.children[1].value
      });
    }

    updateItemJSON(list, "links", links);
  };

  var link = createElement("li", {}, list);
  createElement("input", {type:"url", placeholder:"http://www.example.com/"}, link).onchange = updateFunc;
  createElement("input", {type:"text", placeholder:"Example.com"}, link).onchange = updateFunc;
  createElement("div", {className:"remove", onclick:function(){list.removeChild(link);}, innerHTML:"&#10006;"}, link);
}

function addOption(list, type) {
  var updateFunc = function() {
    var options = [];

    for(var i = 0; i < list.children.length; i++) {
      var child = list.children[i];

      options.push({
        label:child.children[2].value,
        checked:child.children[0].checked
      });
    }

    updateItemJSON(list, "options", options);
  };

  var link = createElement("li", {}, list), num = list.children.length;
  var name = list.parentNode.name, newid = name + "_option_" + num;

  createElement("input", {type:type, name:name, id:newid}, link).onchange = updateFunc;
  createElement("label", {htmlFor:newid}, link);
  createElement("input", {type:"text", placeholder:"Option " + num}, link).onchange = updateFunc;
  createElement("div", {className:"remove", onclick:function(){list.removeChild(link);}, innerHTML:"&#10006;"}, link);
}

function updateItemJSON(item, k, v) {
  if(item instanceof Event) item = this; // Function was called from an event
  var key = k || item.name, value = v || item.value || item.innerHTML;
  while(item.className.indexOf("item") == -1) item = item.parentNode;
  var j = JSON.parse(item.dataset.json);
  j[key] = value;
  item.dataset.json = JSON.stringify(j);
}

function createElement(tag, attrs, appendTo) {
  if(!tag) throw new SyntaxError("'tag' not defined");

  var ele = document.createElement(tag), attrName, styleName, dataName;
  if(attrs) for(attrName in attrs) {
    if(attrName === "style") for(styleName in attrs.style) {ele.style[styleName] = attrs.style[styleName];} else
    if(attrName === "dataset") for(dataName in attrs.dataset) {ele.dataset[dataName] = attrs.dataset[dataName];} else
      ele[attrName] = attrs[attrName];
  }

  if(appendTo) appendTo.appendChild(ele);
  return ele;
}

window.onload = function() {
	initFormGenerator();
}