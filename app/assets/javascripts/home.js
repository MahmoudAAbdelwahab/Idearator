$(document).ready(function () {

  if ($('.token-input-list-facebook').length === 0) {
    $('#click').click(function () {
      $('#fil').toggleClass('hidden');
    });

    $("#input-facebook-theme").tokenInput('/tags/ajax', {
      theme: "facebook",
      preventDuplicates: true,
      tokenLimit: 5
    });

    $('#filter').click(function () {
      var array = [];
      var i = 0;

      $('.token-input-list-facebook li p').each(function () {
        array[i] = $(this).text();
        i += 1;
      });

      if (array.length > 0) {
        $.ajax({
          type: 'POST',
          url: '/ideas/filter',
          data: { myTags : array },
          beforeSend: function () {
            // this is where we append a loading image
            //$('#ajax-panel').html('<div class="loading"><img src="/images/loading.gif" alt="Loading..." /></div>');
          },
          success: function (array) {
          },
          error: function () {
            // failed request; give feedback to user
            alert('failure');
          }
        });
      }

    });
  } else {
    alert('Please choose a tag');
  }
});
