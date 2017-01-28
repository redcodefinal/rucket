require "rpi_gpio"
require "require_all"
require "time"
require "ascii_charts"

require_rel "rucket/*.rb"
require_rel "rucket/modules/*.rb"

class Rucket
  MAX_ENTRIES = 30
  attr_reader :fans
  attr_reader :lights

  attr_reader :on
  alias_method :on?, :on
  
  def initialize(options = {})
    #RPi::GPIO.set_warnings false
    RPi::GPIO.set_numbering :bcm
    @on = options[:on] || false
    @fans = {}
    @lights = {}
    @modules = {}
  end

  def add_module(name, mod)
    @modules[name] = mod
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
    fans.each {|name, fan| fan.turn_on}
    lights.each {|name, light| light.turn_on}
  end

  def turn_off
    @on = false
    fans.each {|name, fan| fan.turn_off}
    lights.each {|name, light| light.turn_off}
  end

  def run_loop
    Signal.trap("INT") do
      puts "CAUGHT SIGINT!"
      exit
    end

    begin
      loop do
        modules.each(&:main_loop)
      end
    ensure
      RPi::GPIO.clean_up
    end
  end
end
