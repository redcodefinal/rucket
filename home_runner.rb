require "rucket"

r = Rucket.new
r.add_light(:main, 6)
r.add_fan(:exhaust, 13)
r.add_fan(:heatsink_fan, 19)
r.add_fan(:intake, 26)
r.run_loop
