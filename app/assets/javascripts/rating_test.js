
function handleKeyPress(e){
 var key=e.keyCode || e.which;
  if (key==13){
    var y = $('#key').val
    var x = $('#keywords').val();
    var prespective =$('<li></li>').text($('#keywords').val());
    $('ul#rating').append(prespective);
    $('#keywords').val("");
  }
}