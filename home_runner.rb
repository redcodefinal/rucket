require_relative "./lib/rucket"

r = Rucket.new
r.add_light(:main, 6)
r.add_fan(:exhaust, 13)
r.add_fan(:heatsink_fan, 19)
r.add_fan(:intake, 26)

r.add_module(:timer, Timer.new(r))
r.add_module(:dht, DHT11Reader.new(r, 5))

r.run_loop
