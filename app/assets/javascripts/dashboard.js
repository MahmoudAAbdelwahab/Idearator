//= require highcharts
//= require highcharts/highcharts-more

 //#Function to choose which graph to be displayed and set barchart as default chart
 //#+params[:tag_id] + id of the tag the user clicks on
 //#Author:Lina Basheer
function graph_chooser(tagid) {
    $('#chart-tabs a:first').tab('show');
    $("a[href='#bubble-chart']").click(initialize_bubblechart(tagid));
    $("a[href='#bar-chart']").click(initialize_barchart(tagid));
  }
//#Function to draw bar chart graph
//#+params[:tag_id] + id of the tag the user clicks on
//#Author:Lina Basheer
function initialize_barchart(tagid) {
  $.get('/dashboard/chart_data/' + tagid+ '.csv', function(data) {
    var options = {
      chart: {
        renderTo: 'bar-chart',
        defaultSeriesType: 'column'
      },
      title: {
        text: 'Number of votes'
      },
      xAxis: {
        categories: []
      },
      yAxis: {
        title: {
          text: 'Units'
        }
      },
      plotOptions: {
        series: {
          cursor: 'pointer',
          point: {
            events: {
              click: function open_new_tab(e) {
                e.preventDefault();
                window.location.href = this.options.url,target="_newtab"
              }
            }
          }
        }
      },
      series:  []
    };

    var lines = data.split('\n');
    $.each(lines, function(lineNo, line) {
      if (line == "") return;
      var items = line.split(',');
      var series = {
        name: items[0],
        data: [{y: parseInt(items[1]), url: '/ideas/' + items[2]}]
      };
      options.series.push(series);
    });
    var chart = new Highcharts.Chart(options);
    console.log(options);
  });
}

//#Function to draw bubble chart graph
//#+params[:tag_id] + id of the tag the user clicks on
//#Author:Lina Basheer
function initialize_bubblechart(tagid) {
 $.get('/dashboard/chart_data/' + tagid + '.csv', function(data) {
  var options = {
    chart: {
      renderTo: 'bubble-chart',
      defaultSeriesType: 'bubble',
      zoomType: 'xy'
    },
    title: {
      text: 'Number of votes'
    },
    xAxis: {
       type: 'integer'
    },
    yAxis: {
      title: {
        text: 'Units'
      }
    },
    plotOptions: {
        series: {
          cursor: 'pointer',
          point: {
            events: {
              click: function() {
                window.location.href = this.options.url,target="_newtab" ;
              }
            }
          }
        }
      },
    series: []
  };
    var lines = data.split('\n');
    $.each(lines, function(lineNo, line) {
      if (line == "") return;
      var items = line.split(',');
      var series = {
        name: items[0],
        data: [{y: parseInt(items[1]),x:parseInt(items[2]), url: '/ideas/' + items[2]}]
      };

      options.series.push(series);
    });

    var chart = new Highcharts.Chart(options);
    console.log(options);
  });
}