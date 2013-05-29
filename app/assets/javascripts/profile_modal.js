//function to open modal dialog for user profile links
//params: none
//Author: Hisham ElGezeery
$(function() {
  $("#main a[href^='/users/']").each(function(){
    var href = $(this).attr('href');
    var href_url = href.split('/users/');
    if($.isNumeric(href_url[1]) && String(href_url[2])){
      var user_id = href_url[1];
      $(this).attr('href', "/users/profile_modal?id="+user_id+"&remote=true");
      $(this).attr('data-remote', 'true');
      $(this).bind('click', function(event) {
        event.preventDefault();
        $("#user-profile-modal").modal('show');
      });
    }
  });

  $("#modal-close").click(function () {
    $("#user-profile-modal").modal('hide');
  });

});