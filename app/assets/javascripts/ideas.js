$(document).ready(function() {

$('.btn-success.add-rating').click(function(){
    $('.add-ratings').show();
  });
  // When The user clicks on facebook share or twitter share button, this method
  // gets the current URL of the current page and apends it to the default facebook
  // and twitter sharing URLs.
  // This page's URl is then shared on The user's facebook or twitter account.
  // Author: Mohamed Sameh

  var prePopulate = [];

  $("#idea-tags .idea-tag input:checked").each(function(i, checkbox) {
    checkbox = $(checkbox);
    prePopulate.push({id: checkbox.val(), name: checkbox.data("tag-name")});
  });

  $("#idea-tags").html('<input type="text" id="tag_token_input" name="blah2" />')

  $("#tag_token_input").tokenInput('/tags/ajax', {
    theme: "facebook",
    preventDuplicates: true,
    tokenLimit: 5,
    tokenFormatter: function(item){
      return "<li>" + item.name
           + "<input id='ideas_tags_tags_' type='hidden' value='" + item.id + "' name='idea[tag_ids][]' />"
           + "</li>";
    },
    prePopulate: prePopulate
  });

  $('.best_in_place').best_in_place();
  $('.best_in_place').bind("ajax:success", function(){
    $('#edited-check-mark').remove();
    $(this).append("<i class='icon-ok pull-right' id ='edited-check-mark'></i>");
  });

  (function(d, s, id) {
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) return;
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=446451938769749";
    fjs.parentNode.insertBefore(js, fjs);
  }(document, 'script', 'facebook-jssdk'));

  function sendAjax(idea_id){
    var list = "";
    var i=0;
    $('.token-input-list-facebook li p').each(function(){
      list += "rating[]="+$(this).text()+"&";
      i=i+1;

    });

    $.ajax("/ideas/" + idea_id + "/add_rating?"+list);
  }

  $("input, select, textarea").on("focus", function(){
   $(this).siblings("span").css("display", "inline");
   }).on("blur", function(){
   $(this).siblings("span").css("display", "none");
  });
});

