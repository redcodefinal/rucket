require "ascii_charts"
require "dht-sensor-ffi"

require_relative '../rucket_module'

class DHT11Reader < RucketModule
  MAX_ENTRIES = 30
  attr_reader :pin
  attr_reader :last_update
  attr_accessor :update_time

  def initialize(rucket, pin = 4, update_time = 60*30)
    super rucket
    @pin = pin
    @update_time = update_time
    @last_update = Time.now - update_time
  end

  def main_loop
    if (Time.now - last_update) > update_time
      @last_update = Time.now
      @temps ||= Array.new(MAX_ENTRIES, 0)
      @temps << (temp = DhtSensor.read(pin, 11).temp_f)
      @temps.slice!(0) if @temps.count > MAX_ENTRIES

      @humids ||= Array.new(MAX_ENTRIES, 0)
      @humids << (humid = DhtSensor.read(pin, 11).humidity)
      @humids.slice!(0) if @humids.count > MAX_ENTRIES

      graph1 = AsciiCharts::Cartesian.new((0...MAX_ENTRIES).to_a.map{|x| [x, @temps.reverse[x]]}, bar: true, title: "TEMP", y_step_size: 10, max_y_vals: 100).draw
      graph2 = AsciiCharts::Cartesian.new((0...MAX_ENTRIES).to_a.map{|x| [x, @humids.reverse[x]]}, bar: true, title: "HUMID", y_step_size: 10, max_y_vals: 100).draw
      
      puts graph1
      puts graph2
      puts "TEMP: #{temp}F HUMID: #{humid}%"
      puts "Time: #{Time.now}"
    end
  end
end