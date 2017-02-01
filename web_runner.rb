require 'sinatra'
require 'erb'
require_relative "./lib/rucket"

$r = Rucket.new
$r.add_light(:main, 19)
$r.add_fan(:exhaust, 13)
$r.add_fan(:heatsink_fan, 6)
$r.add_fan(:intake, 26)
$r.fans.each {|n, fan| fan.turn_on}
$r.turn_on

$r.add_module(:timer, Timer.new($r))
$r.add_module(:dht, DHT11Reader.new($r, 5))

get '/' do
  $r.update
  erb :index
end

__END__

@@ index
<html>
  <head>
    <title>SINATRA TEST!</title>
    <meta http-equiv="refresh" content="600">
  </head>
  <body>
    <img src="chart.png"></img>
    <p>TEMP: <%= $r[:dht].temp %>F   HUMIDITY: <%= $r[:dht].humidity %>%  </p>
    <p>TIME: <%= Time.now %></p>
  </body>
</html>
