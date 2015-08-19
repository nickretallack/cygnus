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
//= require turbolinks
//= require_tree .
//= require_self

$(window).load(function(){

  $(".nojs").hide();
  $(".js").show();

});

$(window).ready(function(){

  $("nav").pushpin({
    top: $("header").children("img").outerHeight()
  });

  $(".dropdown-button").dropdown({
    belowOrigin: true,
    hover: true
  });

  var pushpinLogo = function(){
    if($(window).scrollTop() > $("header").children("img").outerHeight()){
      $("[class='brand-logo']").hide();
      $("[class='brand-logo small']").show();
    }else{
      $("[class='brand-logo']").show();
      $("[class='brand-logo small']").hide();
    }
  };

  pushpinLogo();

  $(window).scroll(pushpinLogo);

});