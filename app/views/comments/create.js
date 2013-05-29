$('.best_in_place').bind("ajax:success");
$('#like').html('<%= escape_javascript(render(partial: 'like')) %>');
$('#comment_content').val('');