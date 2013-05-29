var last_search = "";
var original;
search_type = false;

$(function() {
  $("#searchdiv input").keyup(function(e){
    e.preventDefault();
    $("#landing").hide();
    $('#landing-stream').show();
  if(e.which != 13){
    var search = $("#search").val();
    var search_in = $("#searchtype").val();
      if($("#search").val()!= ""){
        if(search.length > 2){
        stream_manipulator(1,[],search,"false", search_in);
        $('html, body').animate({scrollTop:0}, 'slow');
        }
      }else{
        $("#landing").show();
        $(".stream-generate-button").hide();
        $("#searchtype").val("false");
        stream_manipulator(1,[],"","false", $("#searchtype").val());
        $('html, body').animate({scrollTop:$('#landing').height()}, 'slow');
      }
    }
  });
});

$(document).bind("ajaxError", function(e, xhr){
  if(xhr.status == 401){
    $('#signedout').modal('show');
  }
});

$(document).ready(function() {

  $("#sign").click(function() {
    window.location= "/users/sign_in";
  });

  $("#user-search-button").click(function remove_button_handler(e) {
    e.preventDefault();
    search_type = true;
    $("#searchtype").val("true");
    $('.user-search-div').addClass('drop-down-item');
    $('.idea-search-div').removeClass('drop-down-item');
    $('#search').attr('placeholder', "Search for users...");
  });

  $("#idea-search-button").click(function remove_button_handler(e) {
    e.preventDefault();
    search_type = false;
    $("#searchtype").val("false");
    $('.user-search-div').removeClass('drop-down-item');
    $('.idea-search-div').addClass('drop-down-item');
    $('#search').attr('placeholder', "Search for ideas...");
  });

  $("a.popup").click(function (e) {
    popupCenter($(this).attr("href"),
                $(this).attr("data-width"), $(this).attr("data-height"), "authPopup");
    e.stopPropagation();
    return false;
  });

  $("#twitter_signin_button").tooltip({
    placement: 'bottom',
    trigger: 'click',
    title: 'Trying to sign in using twitter, please interact with the popup!',
    container: 'header'
  });

  $('#searchdiv').submit(function(e) {
    if (in_stream){
      e.preventDefault();
    }
  });

});