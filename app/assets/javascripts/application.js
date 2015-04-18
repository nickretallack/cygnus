// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .

function ready(){
	header = $("#top-nav");
	main = $("main");
	adjustForHeader();
	adjustForScrollBar();

	ex = function(obj){
		return typeof obj !== "undefined";
	};

	detachPoint = $("#detach-point");

	make = function me(hash, attachPoint){
		if(!ex(attachPoint)) return;
		$.each(hash, function(key, value){
			tag = ex(value.tag)? "<"+value.tag+" />" : "<div />";
			klass = ex(value.klass)? value.klass : "";
			text = ex(value.text)? value.text : "";
			css = ex(value.css)? value.css : {};
			children = ex(hash[key].children)? hash[key].children : {}
			element = $("#"+key);
			element = ex(element[0])? element :
				$(tag, {
					class: klass,
					id: key,
					text: text
				});
			console.log(key, value.before);

			if(ex(value.before)) element.insertBefore($(value.before));
			else element.appendTo(attachPoint);

			me(children,
				element
				.css("display", "flex")
				.css(css)
			);
			
			
		});
	};

	make(layout, $("#attach-point"));
	detachPoint.remove();

	// attachPoint = $("#attach-point");
	// if(typeof attachPoint !== "undefined"){
	// 	attachPoint
	// 	.append($("#detach").css({
	// 		"display": "flex",
	// 		"justify-content": "space-around",
	// 		"margin": "2% 0"
	// 	}))
	// 	.append($("#save-button"));
	// 	$("#detach-point").detach();
	// }
}

$(document).ready(ready);
$(document).on('page:load', ready);

$(window).resize(function(){
	adjustForHeader();
	adjustForScrollBar();
});

function adjustForHeader(){
	height = header.css("height");
	main.css("margin-top", height);
}

function adjustForScrollBar(){
	if($("body").hasScrollBar()){
		$(".navbar-right").css("margin-right", "2px");
	}else{
		$(".navbar-right").css("margin-right", "0");
	}
}

(function($) {
    $.fn.hasScrollBar = function() {
        return $(document).height() > $(window).height();
    }
})(jQuery);
