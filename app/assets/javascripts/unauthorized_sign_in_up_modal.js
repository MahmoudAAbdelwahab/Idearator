// Show sign in/up modal dialog on ajax unauthorized error
// Author: Amina Zoheir
$(document).bind("ajaxError", function (e, xhr) {
  if (xhr.status === 401) {
    $('#signedout').modal('show');
  }
});

// Adds event handler on click for sign in and sign up buttons to show their forms
// Author: Amina Zoheir
$(document).ready(function() {
  $('#unauth-sign-in-button').click(function () {
    $('.unauth-huge').addClass('unauth-right', 500);
  });
  $('#unauth-sign-up-button').click(function () {
    $('.unauth-huge').removeClass('unauth-right', 500);
  });
  $('.post-an-idea').click(function (e) {
    e.preventDefault();
    $('#signedout').modal('show');
  });
});