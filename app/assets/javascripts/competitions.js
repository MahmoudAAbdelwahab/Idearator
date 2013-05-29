// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

var thispage = 1;
$(document).ready(function() {
  var prePopulate = [];

  $("#competition-tags .competition-tag input:checked").each(function(i, checkbox) {
    checkbox = $(checkbox);
    prePopulate.push({id: checkbox.val(), name: checkbox.data("tag-name")});
  });

  $("#competition-tags").html('<input type="text" id="tag_token_input" name="blah2" />')

  $("#tag_token_input").tokenInput('/tags/ajax', {
    theme: "facebook",
    preventDuplicates: true,
    tokenLimit: 5,
    tokenFormatter: function(item){
      return "<li>" + item.name
           + "<input id='competitions_tags_tags_' type='hidden' value='" + item.id + "' name='competition[tag_ids][]' />"
           + "</li>";
    },
    prePopulate: prePopulate
  });

  $('.best_in_place').best_in_place();
  $('.best_in_place').bind("ajax:success", function(){
    $('#edited-check-mark').remove();
    $(this).append("<i class='icon-ok pull-right' id ='edited-check-mark'></i>");
  });
    $.datepicker.setDefaults({
    dateFormat: 'yy/mm/dd', changeMonth: true,
    changeYear: true, yearRange: '2013:' + (new Date().getFullYear() +8)
  });

   $(window).scroll (function(){
    thispage = call_infinite_scrolling("competitions","",thispage,$("#stream_competition").attr("value"));
  });
});