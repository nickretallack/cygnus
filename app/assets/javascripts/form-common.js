/* Common functions component */

// Fills 'elements' with the elements defined in 'ids' for quicker lookup
var elements = {};
function fillElements(ids) {
  // Check ids parameter
  if(typeof ids === "undefined") throw new Error("IDs not defined");
  if(!ids instanceof Array) throw new Error("IDs is not an array");

  var id, ele;
  for(var i = 0; i < ids.length; i++) {
    id = ids[i];
    ele = document.getElementById(id);
    if(ele != null) elements[id] = ele;
  }
}

// Helper for document.createElement
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

// Helpers for localStorage
function lsGetValue(key, defval) {
  var p = window.localStorage.getItem(key);
  if(!p && defval != null) return defval;

  switch(typeof defval) {
    case "object":
      if(defval == null) return null;
      return JSON.parse(p);

    case "boolean":
      return (p != "false");

    case "number":
      return parseFloat(p);

    default:
      return p;
  }
}

function lsSetValue(key, val) {
  window.localStorage.setItem(key, val);
}

/* qrle: Quick RLE (Run-Length Encoding) compressor and decompressor.
 *   to:   Takes an input string (preferably Base64'd), compresses it using RLE and returns the result.
 *   from: Takes an input string previously used on 'qrle.to', decompresses it and returns the expanded result */
var qrle = {
  to:function(s){var r="",n=1;for(var i=1;i<s.length+1;i++){var c=s[i-1];if(c==s[i])n++;else{r+=c;if(n==2)r+=c;else{while(n>128){r+=String.fromCharCode(258-n);n-=128;}if(n>1)r+=String.fromCharCode(258-n);}n=1;}}return r;},
  from:function(s){var r="",p=0,c,k,n;while(p<s.length){k=s.charCodeAt(p);if(k<128)r+=(c=s[p]);else for(n=0;n<(257-k);n++)r+=c;p++;}return r;}
};