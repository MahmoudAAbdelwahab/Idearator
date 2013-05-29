$(document).ready(function () {
  var isVisible = false;
  var clickedAway = false;
  $('a[data-popover-idea-id]').click(function (e) {
    e.preventDefault();
    e.stopPropagation();
    var id = $(this).data("popover-idea-id");
    $.getScript('/ideas/'+id+'/popover?id=' + id);
    isVisible = true;

  });
  $(document).click(function(e) {
    if(isVisible & clickedAway)
    {
      $('a[data-popover-idea-id]').popover('destroy')
      isVisible = clickedAway = false
    }
    else
    {
      clickedAway = true
    }
  });
});