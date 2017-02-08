require "require_all"
require_rel "./lib"

RucketServer.start do
  light :main, 26
  fan :exhaust, 19
  fan :heatsink_fan, 6
  fan :intake, 13

  on_proc = -> do
      rucket.fans[:intake].turn_on
      rucket.fans[:exhaust].turn_on

      rucket.fans[:heatsink_fan].turn_on
      rucket.lights[:main].turn_on
    end
  off_proc = -> do
      rucket.fans[:intake].turn_on
      rucket.fans[:exhaust].turn_on

      rucket.fans[:heatsink_fan].turn_off
      rucket.lights[:main].turn_off
    end

  rmodule :timer, Timer, on_proc, off_proc
  rmodule :dht, DHT11Reader, 5
end

run RucketServer::App