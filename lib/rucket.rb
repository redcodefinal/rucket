require "rpi_gpio"
require "require_all"
require "time"

require_relative "rucket/version"

class Rucket
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
    @fans = {}
    @lights = {}
  end

  def add_fan(name, pin)
    fans[name] = Fan.new(pin)
  end

  def add_fan_pwm(name, pin, pwm_pin)
    fans[name] = FanPWM.new(pin, pwm_pin)
  end

  def add_light(name, pin)
    lights[name] = Light.new(pin)
  end

  def add_light_pwm(name, pin)
    lights[name] = LightPWM.new(pin, pwm_pin)
  end

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
    if (start_time..end_time).cover?(Time.now) and off?
      turn_on
    elsif !(start_time..end_time).cover?(Time.now) and on?
      turn_off
    end

    
  end
end
