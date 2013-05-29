// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require ideas/popover
//= require bootstrap
//= require bootstrap-tooltip
//= require jquery.purr
//= require best_in_place
//
//= require notifications
//= require jquery-star-rating
//
//= require accountsettings
//= require unauthorized_sign_in_up_modal
//
//= require profile_modal
//= require poller.js
//= require search-stream
//= require jquery.tokeninput
//= require jquery-star-rating
//= require jquery.cookie
//


function popupCenter(url, width, height, name) {
  var left = (screen.width / 2) - (width / 2);
  var top = (screen.height / 2) - (height / 2);
  return window.open(url, name, "menubar=no,toolbar=no,status=no,width=" + width +
    ",height=" + height + ",toolbar=no,left=" + left +
    ",top=" + top);
}


$(document).ready(function() {
  apply_tooltip_handlers();  
});

function apply_tooltip_handlers(){
  $(".fbk").tooltip({
    toggle: "tooltip",
    title: "Share on Facebook",
  });

  $(".tw").tooltip({
    toggle: "tooltip",
    title: "Share on Twitter"
  });

  $(".pin").tooltip({
    toggle: "tooltip",
    title: "Share on pinterest",
  });
}