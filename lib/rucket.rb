require "rpi_gpio"
require "require_all"
require "time"
require "ascii_charts"

require_rel "rucket/*"

class Rucket
  MAX_ENTRIES = 24
  attr_reader :fans
  attr_reader :lights

  attr_reader :dht
  attr_reader :last_dht_update
  attr_accessor :dht_update_time

  attr_reader :on
  alias_method :on, :on?

  attr_accessor :start_time
  attr_accessor :end_time
  
  def initialize(options = {})
    #RPi::GPIO.set_warnings false
    RPi::set_numbering :bcm
    @on = options[:on] || true
    @dht_update_time = options[:dht_update_time] || 60*15
    @last_dht_update = Time.now - dht_update_time
    @start_time = options[:start_time] || Time.parse("8:00")
    @end_time = options[:end_time] || Time.parse("24:00")
    @dht = DHT11.new(0)
    @fans = {}
    @lights = {}
  end

  def add_fan(name, pin)
    fans[name] = Fan.new(pin)
  end

  # def add_fan_pwm(name, pin, pwm_pin)
  #   fans[name] = FanPWM.new(pin, pwm_pin)
  # end

  def add_light(name, pin)
    lights[name] = Light.new(pin)
  end

  # def add_light_pwm(name, pin)
  #   lights[name] = LightPWM.new(pin, pwm_pin)
  # end

  def off?
    not on?
  end

  def turn_on
    @on = true
    fans.each(&:turn_on)
    lights.each(&:turn_on)
  end

  def turn_off
    @on = false
    fans.each(&:turn_on)
    lights.each(&:turn_on)
  end

  def run_loop
    Signal.trap("INT") do
      puts "CAUGHT SIGINT!"
      RPi::GPIO.clean_up
      exit
    end

    begin
      if (start_time..end_time).cover?(Time.now) and off?
        turn_on
      elsif !(start_time..end_time).cover?(Time.now) and on?
        turn_off
      end

      if (Time.now - last_dht_update) > dht_update_time
        @temps ||= [] 
        @temps << (temp = dht.get_temp)
        @temps.slice!(0) if @temps.count > MAX_ENTRIES

        @humids ||= [] 
        @humids << (humid = dht.get_humidity)
        @humids.slice!(0) if @humids.count > MAX_ENTRIES

        graph1 = AsciiCharts::Cartesian.new((0...MAX_ENTRIES).to_a.map{|x| [x, @temps.reverse[x]]}, bar: true, title: "TEMP", y_step_size: 10, max_y_vals: 10).draw
        graph2 = AsciiCharts::Cartesian.new((0...MAX_ENTRIES).to_a.map{|x| [x, @humids.reverse[x]]}, bar: true, title: "HUMID", y_step_size: 10, max_y_vals: 10).draw
        
        puts graph1
        puts graph2
        puts "TEMP: #{temp}F HUMID: #{humid}%"
        puts "Time: #{Time.now}"
      end
    ensure
      RPi::GPIO.clean_up
    end
  end
end
