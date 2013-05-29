var Page = 1;

function apply_script(){
  $('.aTag').click(function(){
    Page = 1 ;
    var array = ["a"];
    var flag = false ;
    var i = 1;
    var text = $(this).text();
    if($('.tag').length > 0){
     $('.tag').each(function () {
      array[i] = $(this).text();
      if(array[i] == text )
        flag = true ;
        i += 1;
    });
   }
   array[i] = $(this).text();

   if (flag)
    return;
  $.ajax({
    type: 'get',
    url: '/competitions',
    data: {
      tags: array,
      types :type
    },
    beforeSend: function () {
        // this is where we append a loading image
        //$('#ajax-panel').html('<div class="loading"><img src="/images/loading.gif" alt="Loading..." /></div>');
      },
      success: function (array) {
        loading = false;
      },
      error: function () {
          // failed request; give feedback to user
        }

      });

});

  $('.delete-token').click(function(){
    Page = 1 ;
    var array = ["a"];
    var i = 1;
    $(this).parent().remove();
    if($('.tag').length > 0){
     $('.tag').each(function () {
      array[i] = $(this).text();
      i += 1;
    });
   }
   $.ajax({
    type: 'get',
    url: '/competitions',
    data: {
      tags: array,
      types: type
    },
    beforeSend: function () {
    },
    success: function (array) {
      loading = false;
    },
    error: function () {
    }

  });

 });
}
function nearBottomOfPage() {
  return $(window).scrollTop() > $(document).height() - $(window).height() - 100;
}

function passedPage1() {
  return $(window).scrollTop() > 600;
}

function backToTop() {
  return $(window).scrollTop() < 600;
}

var loading = false;

$(window).scroll(function () {
  if (loading) {
    return;
  }
  if (passedPage1()) {
    $('.backtotop').show();
  }
  if (backToTop()) {
    $('.backtotop').hide();
  }
  if (nearBottomOfPage() && $("#search").val() === '') {
    loading = true;
    Page += 1;

    var array = ["a"];
    var i = 1;
    if($('.tag').length > 0){
     $('.tag').each(function () {
      array[i] = $(this).text();
      i += 1;
    });
   }

   $.ajax({
    type: 'get',
    url: '/competitions',
    data: {
      myPage: Page,
      tags: array,
      types : type
    },
    beforeSend: function () {
        // this is where we append a loading image
        //$('#ajax-panel').html('<div class="loading"><img src="/images/loading.gif" alt="Loading..." /></div>');
      },
      success: function (array) {
        loading = false;
      },
      error: function () {
          // failed request; give feedback to user
        }

      });
 }
});

apply_script();