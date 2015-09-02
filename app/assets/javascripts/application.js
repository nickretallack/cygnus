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
//= require_tree .
//= require_self

$(document).load(ready);

$(document).on("page:load", ready);

$(document).ready(ready);

function ready(){

  var nav = $("nav"),
      banner = $("header").children("img"),
      menu = $("li").children(".dropdown-button"),
      sideMenu = $(".button-collapse");
      logo = $(".brand-logo"),
      widthTester = $(".widthTester")
      gallery = $(".gallery"),
      galleryTable = $(".gallery").children("table");

  $(".nojs").hide();

  menu.dropdown({
    belowOrigin: true,
    hover: true,
    constrain_width: false
  });

  $(window).keydown(function(event){
    if(event.keyCode === 27) sideMenu.sideNav("hide");
  });

  sideMenu.sideNav();

  var pushpinNav = function(){
    if($(window).scrollTop() > banner.outerHeight())
    {
      $("nav").css({
        position: "fixed",
        top: 0
      });
    }else if($(window).scrollTop() === 0){
      $("nav").css({
        position: "relative",
        top: "auto"
      });
    }
  };

  pushpinNav();

  $(window).scroll(pushpinNav);

  var size = function(){
    switch(widthTester.css("width")){
      case "601px":  //medium
        nav.height(banner.outerHeight());
        logo.width(nav.height()*3);
        break;
      case "993px":  //large
        nav.height(banner.outerHeight() / 1.5);
        logo.width(nav.height()*3);
        break;
      case "1921px": //very large
        nav.height(banner.outerHeight() / 2);
        logo.width(nav.height()*3);
        break;
    }
  };

  size();

  $(window).resize(size);

  animatedOnce = false;

  $(":file").change(function(){
    if(this.files && this.files[0]){
      var reader = new FileReader();
      reader.onload = function(event){
        var div = $(".preview");
        div.children("#flash").show();
        div.children("img").remove();
        div.append($("<img />", { src: event.target.result }));
        $("label[for = 'user_upload_explicit']").addClass("danger");
      }
      reader.readAsDataURL(this.files[0]);
    }
  });
}