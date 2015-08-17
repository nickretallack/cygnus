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
//= require prefixfree-rails/prefixfree

$(window).load(function(){
  var affixBanner = function(){
    var navbar = $("header").children(".navbar"),
        separator = $("header").children(".separator");
    if($(window).scrollTop() !== 0){
      navbar.css({
        "position": "fixed",
        "top": 0,
        "width": "100%"      
      });
      separator.css({
        "position": "fixed",
        "top": 50,
        "width": "100%"      
      });
    }else{
      navbar.css("position", "relative");
      separator.css({
        "position": "relative",
        "top": "auto"
      });
    }
  }

  affixBanner();

  $(window).scroll(function(){
    affixBanner();
  });
});