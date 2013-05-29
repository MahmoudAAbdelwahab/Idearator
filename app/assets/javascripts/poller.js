// Does long polling on Coolsters server.
// Author: Amina Zoheir

function poll() {
  $.ajax({
    url: 'http://' + COOLSTER_URL + '/poll',
    dataType: "script",
    tryCount : 0,
    retryLimit : 5,
    success: function(data, textStatus, jXHR){
      $.ajax(this);
        return;
    },
    error: function(jXHR, textStatus, errorThrown){
      if(errorThrown == 'timeout'){
        $.ajax(this);
        return;
      }else{
        tryCount ++;
        if(tryCount <= retryLimit){
          {setTimeout(poll, 10000)}
        }else{
          alert('You\'ve been disconnected');
          return;
        }
      }
    },
    timeout: 60000
  });
}

$(function () {
  setTimeout(poll, 1000);
});
