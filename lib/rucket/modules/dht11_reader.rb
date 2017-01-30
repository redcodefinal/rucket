require "googlecharts"
require "dht-sensor-ffi"
require "tty"

require_relative '../rucket_module'

class DHT11Reader < RucketModule
  MAX_ENTRIES = 50
  attr_reader :pin
  attr_reader :last_update
  attr_accessor :update_time
  attr_reader :temp, :humidity

  def initialize(rucket, pin = 4, update_time = 60*30)
    super rucket
    @pin = pin
    @update_time = update_time
    @last_update = Time.now - update_time
    main_loop
  end

  def main_loop
    if (Time.now - last_update) > update_time
      @last_update = Time.now
      @temps ||= []
      @temps << (temp = DhtSensor.read(pin, 11).temp_f)
      @temps.slice!(0) if @temps.count > MAX_ENTRIES

      @humids ||= []
      @humids << (humid = DhtSensor.read(pin, 11).humidity)
      @humids.slice!(0) if @humids.count > MAX_ENTRIES
      
      chart = Gchart.new(type: "line",
                   title: "DHT",
                   data: [@temps, @humids],
                   size: "400x225",
                   filename: "/home/pi/rucket/public/chart.png",
                   line_colors: 'ff0000,0000ff',
                   legend: ["Tempurature", "Humidity"],
                   axis_with_labels: ['Time', 'Value'],
                   axis_labels: [0..30].to_a,
                   max: 100)
      chart.file

      @temp = temp
      @humidity = humid
    end
  end
end