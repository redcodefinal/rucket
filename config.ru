require "require_all"
require_rel "./lib"

RucketServer.start do
  light :main, 26
  fan :exhaust, 13
  fan :heatsink_fan, 6
  fan :intake, 19

  on_proc = -> do
      Rucket.fans[:intake].turn_on
      Rucket.fans[:exhaust].turn_on

      Rucket.fans[:heatsink_fan].turn_on
      Rucket.lights[:main].turn_on
    end
  off_proc = -> do
      Rucket.fans[:intake].turn_on
      Rucket.fans[:exhaust].turn_on

      Rucket.fans[:heatsink_fan].turn_off
      Rucket.lights[:main].turn_off
    end

  rmodule :timer, Timer, on_proc, off_proc, "08:00", "20:00"
  rmodule :dht, DHT11Reader, 5
end

run RucketServer::App