/*
* Relies:
*
* Jquery
* Underscore
* Ring
*
*/

(function(){
  var Make = {};

  Make.extend = function(obj, propName, func){
    if(typeof propName !== "string")
      $.each(propName, function(key, value){
        Make.extend(obj, key, value);
      });
    Object.defineProperty(obj, propName, {
      value: func,
      writable: true,
      configurable: true,
      enumerable: false
    });
  }

  window.Make = Make;
})();

Make.extend(String.prototype, {

  reverse: function(){
    var regexSymbolWithCombiningMarks = /([\0-\u02FF\u0370-\u1DBF\u1E00-\u20CF\u2100-\uD7FF\uDC00-\uFE1F\uFE30-\uFFFF]|[\uD800-\uDBFF][\uDC00-\uDFFF]|[\uD800-\uDBFF])([\u0300-\u036F\u1DC0-\u1DFF\u20D0-\u20FF\uFE20-\uFE2F]+)/g;
    var regexSurrogatePair = /([\uD800-\uDBFF])([\uDC00-\uDFFF])/g;
    var unreversed = this.replace(regexSymbolWithCombiningMarks, function($0, $1, $2) {
        return $2.reverse() + $1;
    }).replace(regexSurrogatePair, '$2$1');
    var result = "";
    var index=unreversed.length;do{
      result += unreversed.charAt(index);
    }while(index-- > 0);
    var brackets = {
      "(": ")",
      "{": "}",
      "[": "]",
      "<": ">"
    };
    $.each(brackets, function(key, value){
      result = result.replace(key, value);
    });
    return result;
  },

  prefix: function(prefix){
    prefix = String(prefix);
    return prefix + this;
  },

  contains: function(substring){
    return this.indexOf(substring) > -1;
  },

  splice: function(index, remove, string){
    return this.slice(0, index) + string + this.slice(index + Math.abs(remove));
  },

  wrap: function(wrapper, tag){
    if(tag) return this.prefix(wrapper)+wrapper.splice(1, 0, "/");
    return this.prefix(wrapper)+wrapper.reverse();
  },

  parens: function(){
    return this.wrap("(");
  },

  stringify: function(){
    return this.wrap("'");
  },

  url: function(){
    return this.stringify().parens().prefix("url");
  },

  capitalize: function(){
    return this.slice(0, 1).toUpperCase() + this.slice(1);
  },

  humanize: function(){
    return this.replace(/([a-z])([A-Z])/g, '$1'+" "+'$2').replace(/([A-Z])([A-Z])([a-z])/g, '$1'+" "+'$2'+'$3').replace(/([A-Z])(I|A)(?=\s)/g, '$1'+" "+'$2');
  }

});

Make.extend(Object.prototype, {

  isDictionary: function(){
    if(!this) return false;
    if(this.isArray()) return false;
    if(this.constructor != Object) return false;
    return true;
  },

  isArray: function(){
    return Array.isArray(this);
  },

  is: function(something){
    return Object.is(this, something);
  },

  matches: function(something){
    if(typeof something === "undefined") return false;
    if(this.is(something)) return true;
    j=0;do{
      if(typeof something[something.keys()[j]] === "undefined" || this[this.keys()[j]] !== something[something.keys()[j]]) return false;
      return true;
    }while(++j<this.keys().length);
  },

  toArray: function(){
    if(!this.isDictionary()) return [this];
    return this.values();
  },

  has: function(property){
    return typeof this[property] !== "undefined";
  },

  keys: function(){
    array = [];
    i=0;do{
      array[i] = Object.keys(this)[i]
    }while(++i<Object.keys(this).length);
    return array;
  },

  values: function(){
    if(!this.isDictionary()) return;
    keys = this.keys();
    values = [];
    keys.forEach(function(key){
      values.push(this[key]);
    });
    return values;
  },

  keysOf: function(value){
    return this.invert()[value];
  },

  invert: function(){
    if(!this.isDictionary()) return;
    comparitor = [];
    multiples = {};
    values = this.values();
    keys = this.keys();
    index=0;do{
      if(comparitor.contains(values[index])){
        if(typeof multiples[values[index]] === "undefined"){
          multiples[values[index]] = [keys[index]];
          multiples[values[index]].splice(0, 0, keys[values.indexOf(values[index])]);
        }else{
          multiples[values[index]].add(keys[index]);
        }
      }else{
        comparitor.add(values[index]);
      }
    }while(++index<values.length);
    comp=0;do{
      if(typeof multiples[comparitor[comp]] === "undefined")
        multiples[comparitor[comp]] = keys[values.indexOf(comparitor[comp])];
    }while(++comp<comparitor.length);
    return multiples;
  }
});

Make.extend(Math, {

  clamp: function(value, min, max){
    return Math.min(Math.max(value, min), max);
  },

  range: function(min, max){
    array = Array.apply(null, Array(Math.abs(max-min+1))).map(function (_, i) {return i;});
    index=0;do{
      array[index] += min;
    }while(++index<array.length);
    return array;
  },

  roundTo: function(value, step){
    return Math.round(value/step)*step;
  },

  rndint: function(min, max){
    return Math.floor(Math.random() * (max + 1 - min) + min);
  }

});

Make.extend(Array.prototype, {

  isEmpty: function(){
    return this.length < 1;
  },

  empty: function(){
    this.length = 0;
  },

  contains: function(item){
    return this.indexOf(item) > -1;
  },

  containsMatch: function(item){
    i=0;do{
      if(typeof this[i] !== "undefined" && this[i].matches(item)) return true;
    }while(++i<this.length);
    return false;
  },

  where: function(rule){
    which = [];
    this.forEach(function(element){ if(rule(element)) which.push(element); });
    return which;
  },

  containsWhere: function(rule){
    contains = false;
    this.forEach(function(element){ if(rule(element)) contains = true; });
    return contains;
  },

  elementsWith: function(attributes){
    var which = [];
    this.forEach(function(element){
      var match = true;
      attributes.keys().forEach(function(key){
        if(!element.has(key) || element[key] !== attributes[key]) match = false;
      });
      if(match) which.push(element);
    });
    return which;
  },

  modify: function(rule){
    index=0;do{
      this[index] = rule(this[index]);
    }while(++index < this.length);
    return this;
  },

  modifyWhere: function(where, mod){
    return this.where(where).modify(mod);
  },

  doWhere: function(where, task){
    this.where(where).forEach(function(element){ task(element); });
  },

  removeWhere: function(where){
    var index = 0;do{
      if(where(this[index])) this.splice(index, 1);
    }while(++index < this.length);
    return this;
  },

  removeAfter: function(item){
    index = this.indexOf(item)+1;
    return this.splice(index, this.length-index);
  },

  cat: function(item){
    array = item.isArray()? item : arguments;
    index=0;do{
      this.push(array[index]);
    }while(++index<array.length);
    return this;
  },

  random: function(){
    return this[Math.rndint(0, this.length-1)];
  },

  removeDupes: function(){
    var array = [];
    this.forEach(function(element){
      if(!array.contains(element)) array.push(element);
    });
    return array;
  },

  between: function(start, end){
    var array = [];
    var index = start;do{
      array.push(this[index]);
    }while(++index < end+1);
    return array;
  },

  sortBy: function(rule){
    sorted = this;
    sorted.sort(function(a, b){
      if (a == b) return 0;
      return rule(a, b) ? -1 : 1;
    });
    return sorted;
  },

  first: function(){
    return this[0];
  },

  last: function(){
    return this[this.length-1];
  },

  fill: function(length, func){
    if(typeof func === "function"){
      var index=0;do{
        this.push(func(index, arguments));
      }while(++index<length);
    }else{
      var index=0;do{
        this.push(func);
      }while(++index<length);
    }
    return this;
  }

});

(function($){

  $.fn.extend({
    collidesWith: function($div2){
      var x1 = $(this).offset().left;
      var y1 = $(this).offset().top;
      var h1 = $(this).outerHeight(true);
      var w1 = $(this).outerWidth(true);
      var b1 = y1 + h1;
      var r1 = x1 + w1;
      var x2 = $div2.offset().left;
      var y2 = $div2.offset().top;
      var h2 = $div2.outerHeight(true);
      var w2 = $div2.outerWidth(true);
      var b2 = y2 + h2;
      var r2 = x2 + w2;

      if (b1 < y2 || y1 > b2 || r1 < x2 || x1 > r2) return false;
      return true;
    },

    splitBy: function(elementName){
      var groups = [],
      elements = this;
      index = -1; do{
        groups.push((function(){
          var array = [];
          while($(elements[++index]).prop("tagName") !== elementName && index < elements.length){
            array.push(elements[index]);
          }
          return array;
        })());
      }while(index < this.length);
      return groups;
    },

    putCursorAtEnd: function(){
      return this.each(function(){
        $(this).focus();
        if(this.setSelectionRange){
          var len = $(this).val().length * 2;
          this.setSelectionRange(len, len);
        } else {
          $(this).val($(this).val());
        }
        this.scrollTop = 999999;
      });
    },

    selectionMenu: function(options){
      var button = $(this);
      var initMenu = $("<div />", {
        css: {
          position: "absolute",
          width: 200,
          height: 200,
          backgroundColor: "white"
        }
      });
      button.on("click.selectionMenu", function(event){
        var menu = initMenu.clone();
        menu.css({
          top: event.pageY - 5,
          left: event.pageX - 5
        }).on("mouseleave.selectionMenu", function(){
          $(this).remove();
        }).appendTo($(document.body));
        $.each(options, function(name, callback){
          if(typeof callback !== "function") return;
          $("<span />", {
            text: name.humanize().capitalize(),
            css: {
              marginLeft: 5,
              cursor: "pointer"
            }
          }).appendTo($("<div />", {
            css: {
              width: 200,
              fontSize: 16,
              border: "2px solid black",
              borderCollapse: "collapse",
              cursor: "pointer"
            }
          }).on("mouseenter.selectionMenu", function(){
            $(this).css({
              backgroundColor: "lightblue",
              color: "white"
            });
          }).on("mouseleave.selectionMenu", function(){
            $(this).css({
              backgroundColor: "white",
              color: "black"
            });
          }).on("click.selectionMenu", function(){
            callback();
          }).appendTo(menu));
        });
      });
      return button;
    }
  });

})(jQuery);