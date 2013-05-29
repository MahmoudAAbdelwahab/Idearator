// This method handles the visibility of the tags
// of which the user can choose from, depending on
// the state of checkbox (checked-is committee or unchecked-is not committee)
// Params: committee
// Author: Menna Amr
function toggle_all_tags(committee) {

  if (!committee){

    $("#all-tags").slideUp();
  }
  else {

    $("#all-tags").slideDown();
  }

}

$(document).ready(function() {

  $('.best_in_place').best_in_place();

  $('.best_in_place').bind("ajax:success", function(){
    $('#edited-check-mark').remove();
    $(this).append("<i class='icon-ok pull-right' id ='edited-check-mark'></i>");
  });

  $.datepicker.setDefaults({
    dateFormat: 'yy/mm/dd', changeMonth: true,
    changeYear: true, yearRange: 'c-65:c+10'
  });

  // This method checks if the "Sign up as committee" ckeckbox
  // has been checked and sends its status to the toggle_all_tags method
  // params: #is-committee
  // Author: Menna Amr
  $("#is-committee").on("change", function(){
    c = $(this).is(":checked");
    toggle_all_tags(c);
  });

});
