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

$(document).load(ready);

$(document).on("page:load", ready);

$(document).ready(ready);

function ready(){

  $(".nojs").hide();
  $(".js").show();

  $(".dropdown-button").dropdown({
    belowOrigin: true,
    hover: true,
    constrain_width: false
  });

  var pushpinLogo = function(){
    if($(window).scrollTop() > $("header").children("img").outerHeight())
    {
      $("nav").css({
        position: "fixed",
        top: 0
      });
      $("[class='brand-logo']").hide();
      $("[class='brand-logo small']").show();
    }else if($(window).scrollTop() === 0){
      $("nav").css({
        position: "relative",
        top: "auto"
      });
      $("[class='brand-logo']").show();
      $("[class='brand-logo small']").hide();
    }
  };

  pushpinLogo();

  $(window).scroll(pushpinLogo);

  animatedOnce = false;

  $(":file").change(function(){
    if(this.files && this.files[0]){
      var reader = new FileReader();
      reader.onload = function(event){
        var div = $(".preview");
        div.children("#flash").show();
        div.children("img").detach();
        div.append($("<img />", { src: event.target.result }));
        $(".moving-left.reverse").animate({
          opacity: 1,
          paddingRight: "-=120"
        }, 2400);
      }
      reader.readAsDataURL(this.files[0]);
    }
  })

}