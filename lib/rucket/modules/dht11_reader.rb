require "chartkick"
require "dht-sensor-ffi"

require_relative '../rucket_module'

class DHT11Reader < RucketModule
  MAX_ENTRIES = 50
  CHART_OPTIONS = {
    xtitle: "Time",
    ytitle: "Value",
    legend: true,
    height: "150px",
    width: "400px",
    colors: ["red", "blue"],
    min: 0,
    max: 100
  }
  attr_reader :pin
  attr_reader :last_update
  attr_accessor :update_time
  attr_reader :temp, :humidity
  attr_reader :temps, :humids

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
      @temps ||= {}
      @temps[Time.now] = (temp = DhtSensor.read(pin, 11).temp_f)
      @temps.delete(@temps.first.first) if @temps.count > MAX_ENTRIES

<<<<<<< HEAD
      @humids ||= {}
      @humids[Time.now] = (humid = DhtSensor.read(pin, 11).humidity)
      @humids.delete(@humids.first.first) if @humids.count > MAX_ENTRIES
=======
      @humids ||= []
      @humids << (humid = DhtSensor.read(pin, 11).humidity)
      @humids.slice!(0) if @humids.count > MAX_ENTRIES
      
      
      begin 
        chart = Gchart.new(type: "line",
                   title: "DHT",
                   data: [@temps, @humids],
                   size: "400x150",
                   filename: "/home/pi/rucket/lib/rucket/public/chart.png",
                   line_colors: 'ff0000,0000ff',
                   legend: ["Tempurature", "Humidity"],
                   axis_with_labels: ['Time', 'Value'],
                   axis_labels: [0..30].to_a,
                   max: 100)
        chart.file
      rescue
      end
>>>>>>> 6fd4ada3da8afef43cf4fe7ab2c4a6bb7f27cae9

      @temp = temp
      @humidity = humid
    end
  end
end
