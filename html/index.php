<!DOCTYPE html>
<html lang="de">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Außentemperatur</title>

    <!-- Google charts -->
      <script type="text/javascript" src="https://www.google.com/jsapi"></script>
      <script type="text/javascript">
      google.load('visualization', '1.0', {packages:['controls']});
      google.setOnLoadCallback(drawDashboard);
      function drawDashboard() {
        var data = google.visualization.arrayToDataTable([
       
          ['Zeit', 'Luftfeuchte', 'Temperatur']
          <?php
			#create your database before
			#sqlite3 test.db "CREATE TABLE IF NOT EXISTS data (id INTEGER PRIMARY KEY,time INT,temp REAL,hum REAL);"
		$sqlite="/var/www/test.db";
		$query="select time,hum,temp from data";
		$db = new PDO('sqlite:/var/www/test.db');
		$result = $db->query("select time,temp,hum from data"); 
		while($row=$result->fetch(PDO::FETCH_ASSOC)) {
			$hum=$row['hum'];
			$temp=$row['temp'];
			$timestamp=$row['time'];
			$day=date("d",$timestamp);
			$month=date("m",$timestamp)-1;
			$year=date("Y",$timestamp);
			$hour=date("H",$timestamp);
			$minute=date("i",$timestamp);
			echo ",";
			echo "[new Date($year, $month, $day, $hour, $minute, 00), $hum, $temp]";
		}
          ?>
        ],false);
        
      var dashboard = new google.visualization.Dashboard(
            document.getElementById('dashboard_div'));
           var RangeSlider = new google.visualization.ControlWrapper({
          'controlType': 'ChartRangeFilter',
          'containerId': 'filter_div',
          'options': {
            'filterColumnLabel': 'Zeit'
          }
        });
              var lineChart = new google.visualization.ChartWrapper({
   		chartType: 'LineChart',
          containerId: 'chart_div',
          options: {'title': 'Außen'
		}
        });
        dashboard.bind(RangeSlider, lineChart);
        dashboard.draw(data);
        
      }
    	</script>
  
  </head>
  <body>
	<div >
		<h1>Außentemperatur</h1>
	</div>
	<div>
	<?php
		$sqlite="/var/www/test.db";
		$query="select time,hum,temp from data";
		$db = new PDO('sqlite:/var/www/test.db');
		$result = $db->query("select time,temp,hum from data");
		while($row=$result->fetch(PDO::FETCH_ASSOC)) {
			$hum=$row['hum'];
			$temp=$row['temp'];
			$timestamp=$row['time'];
			$day=date("d",$timestamp);
			$month=date("m",$timestamp)-1;
			$year=date("Y",$timestamp);
			$hour=date("H",$timestamp);
			$minute=date("i",$timestamp);
		# echo "[new Date($year, $month, $day, $hour, $minute, 00), $hum, $temp]";
 }
	?>
	</div>
    <div id="dashboard_div">
     <!--Divs that will hold each control and chart-->
      <div id="chart_div" style="width: 1200px; height: 500px"></div>
      <div id="filter_div" style="width: 1200px; height: 250px"></div>
    </div>
  </body>
</html>
