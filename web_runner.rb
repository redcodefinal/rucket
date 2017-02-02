require_relative "./lib/rucket"

$r = Rucket.new do
  light :main, 26
  fan :exhaust, 19
  fan :heatsink_fan, 6
  fan :intake, 13

  on_proc = -> do
      rucket.turn_on_fans
      rucket.turn_on_lights
    end
  off_proc = -> do
      rucket.turn_on_fans
      rucket.turn_off_lights
    end

  rmodule :timer, Timer, on_proc, off_proc
  rmodule :dht, DHT11Reader, 5
end

begin
  require 'sinatra'
  require 'erb'

  get '/' do
    $r.update
    erb :index
  end
ensure
  RPi::GPIO.clean_up
  puts "Cleaned up!"
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
