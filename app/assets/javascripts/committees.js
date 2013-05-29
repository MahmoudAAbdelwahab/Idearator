$(document).ready(function() {

  $(".rating_complete").tokenInput('/ratings/ajax', {
    theme: "facebook",
    preventDuplicates: true,
    tokenLimit: 5
  });

  $('.btn-success.add-rating').click(function(){
    $('.btn-success.add-rating').parent().find('div.add-ratings').hide();
    $(this).parent().find('div.add-ratings').show();
  });

});
