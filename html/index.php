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
      google.load('visualization', '1.0', {packages:['corechart','controls']});
      google.setOnLoadCallback(drawDashboard);
      function drawDashboard() {
		var heute = new Date();
		var gestern = new Date();
		gestern.setTime(gestern.getTime() - 86400000 * 2);
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
				'ui': {
					'chartOptions': {
					'chartArea': {'width': '50%'},
						},
				},
            'filterColumnLabel': 'Zeit'
			},
		'state': {
			'range': {
				'start': gestern , 
				'end': heute
				}
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
	#	$sqlite="/var/www/test.db";
	#	$query="select time,hum,temp from data";
		$db = new PDO('sqlite:/var/www/test.db');
		$resultakt = $db->query("select max(time),temp,hum from data");
		$resultmax = $db->query("select time,max(temp) from data");
		$resultmin = $db->query("select time,min(temp) from data");
		while($row=$resultakt->fetch(PDO::FETCH_ASSOC)) {
			$tempakt=$row['temp'];
			$humakt=$row['hum'];
			$timestampakt=$row['max(time)'];
			$dayakt=date("d",$timestampakt);
			$monthakt=date("m",$timestampakt);
			$yearakt=date("Y",$timestampakt);
			$hourakt=date("H",$timestampakt);
			$minuteakt=date("i",$timestampakt);
}
		while($row=$resultmax->fetch(PDO::FETCH_ASSOC)) {
			$tempmax=$row['max(temp)'];
			$timestampmax=$row['time'];
			$daymax=date("d",$timestampmax);
			$monthmax=date("m",$timestampmax);
			$yearmax=date("Y",$timestampmax);
			$hourmax=date("H",$timestampmax);
			$minutemax=date("i",$timestampmax);
}
		while($row=$resultmin->fetch(PDO::FETCH_ASSOC)) {
			$tempmin=$row['min(temp)'];
			$timestampmin=$row['time'];
			$daymin=date("d",$timestampmin);
			$monthmin=date("m",$timestampmin);
			$yearmin=date("Y",$timestampmin);
			$hourmin=date("H",$timestampmin);
			$minutemin=date("i",$timestampmin);
}
		 echo "<div>Aktuell: $dayakt.$monthakt.$yearakt $hourakt:$minuteakt - $tempakt °C - $humakt % Luftfeuchte</div>";
		 echo "<div>Maximum: $daymax.$monthmax.$yearmax $hourmax:$minutemax - $tempmax °C</div>";
		 echo "<div>Minimum: $daymin.$monthmin.$yearmin $hourmin:$minutemin - $tempmin °C</div>";
	?>
	</div>
    <div id="dashboard_div">
     <!--Divs that will hold each control and chart-->
      <div id="chart_div" style="width: 1200px; height: 500px"></div>
      <div id="filter_div" style="width: 1200px; height: 250px"></div>
    </div>
  </body>
</html>
