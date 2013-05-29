function add_rating_handler() {
  // Submits the form (saves data) after user makes a change.
  $('input.rating_button').rating({
    callback: function(value, link){
      this.form.submit();
    }
  });

  // Removes Cancel Rating Button
  $('.rating-cancel').remove();
}

$(document).ready(add_rating_handler);