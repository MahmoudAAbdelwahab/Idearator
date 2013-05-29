$(document).ready(function () {
  $(".scrollshow").hide();
  $(window).scroll(function() {
    if ($(this).scrollTop() > 650) {
        $(".scrollshow").slideDown("fast");
    } else {
        $(".scrollshow").slideUp("fast");
    }
  });
});