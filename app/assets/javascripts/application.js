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
	header = $(".navbar-fixed-top");
	main = $("main");
	adjustForHeader();
	adjustForScrollBar();
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