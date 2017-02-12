require "chartkick"
require "dht-sensor-ffi"

require_relative '../rucket_module'

class DHT11Reader < RucketModule
  MAX_ENTRIES = 50

  CHART_OPTIONS = {
    xtitle: "Time",
    ytitle: "Value",
    legend: "bottom",
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

  def initialize(name, pin = 4, update_time = 60*30)
    super name

    @pin = pin
    @update_time = update_time
    @last_update = Time.now - update_time
    main_loop
  end

  def main_loop
    if (Time.now - last_update) > update_time
      @last_update = Time.now
      @temps ||= {}
      @temps[last_update] = (temp = DhtSensor.read(pin, 11).temp_f)
      @temps.delete(@temps.first.first) if @temps.count > MAX_ENTRIES

      @humids ||= {}
      @humids[last_update] = (humid = DhtSensor.read(pin, 11).humidity)
      @humids.delete(@humids.first.first) if @humids.count > MAX_ENTRIES

      @temp = temp
      @humidity = humid
      Rucket::LOG.info "DHT11Reader[#{name}]: Temp: #{temp} Humidity: #{humid}"
    end
  end
end
