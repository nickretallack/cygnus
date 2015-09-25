readyFunctions.push(function(){
  var forms = $("[class *= categorized]");

  $.each(forms, function(index, form){
    categorizeForm($(form));
  });
});

function categorizeForm(form){
  if(form.length === 0) return;
  var separator = $.grep(form.attr("class").split(" "), function(className){
    return /categorized.+/.test(className);
  })[0].replace("categorized", "")[1];
  var options = {};
  var extrapolate = function(text, hash){
    var parts = text.split(separator);
    var latterParts = text.replace(parts[0]+separator, "");
    if(!hash.has(parts[0])){
      hash[parts[0]] = {};
    }
    hash[parts[0]][latterParts] = undefined;
    if(latterParts.contains(separator)){
      extrapolate(latterParts, hash[parts[0]]);
      delete hash[parts[0]][latterParts];
    }
  };
  $.each(form.children("option"), function(index, option){
    var option = $(option);
    var value = option.attr("value");
    if(value < 0) return;
    extrapolate(option.text(), options);
  });

  var header = form.children("[value = -1]"),
      clonable = $("<div />"),
      toUpdate = $("<input />", {
        type: "hidden",
        name: form.attr("id")
      }).insertBefore(form.parent());
  var fillForm = function(newForm, options){
    var container = clonable.clone();
    if(newForm.next().is("i")){
      newForm.next().after(container);
    }else{
      newForm.after(container);
    }
    var index = 0;
    $.each(options, function(option){
      var tag = $("<option />", {
        value: option,
        text: option
      }).appendTo(newForm);
      if(index++ === 0) tag.attr("selected", true);
    });
    var update = function(){
      var value = "",
          collection = form.parent().find("select").children(":selected");
      collection.each(function(index, element){
        value += $(element).attr("value");
        if(index < collection.length - 1) value += " - ";
      });
      return value;
    };
    var addForm = function(){
      var selected = newForm.children(":selected").text();
      toUpdate.attr("value", update());
      container.html("");
      if(options[selected] !== undefined){
        var select = $("<select />", {
          class: "btn button-with-icon"
        });
        fillForm(select.appendTo(container), options[selected]);
      }
      if(/specify/.test(form.parent().find("select").children(":selected").text())){
        toUpdate.attr("type", "hidden").attr("value", update());
        toUpdate.attr("value", toUpdate.attr("value").split("specify")[0]);
        toUpdate.attr("type", "text").putCursorAtEnd();
      }else{
        toUpdate.attr("type", "hidden").attr("value", update());
      }
    };
    if(newForm !== form) addForm();
    newForm.on("change.categorized", function(){
      addForm();
    });
  };
  form.html("");
  fillForm(form, options);
  if(header.length > 0) form.prepend(header);
}