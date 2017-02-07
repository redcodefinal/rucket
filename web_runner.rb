require_relative "./lib/rucket/rucket_server"

RucketServer.new do
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
