require "rpi_gpio"
require "require_all"
require "time"

require_rel "rucket/*.rb"
require_rel "rucket/modules/*.rb"

class Rucket
  class RucketMeta
    attr_reader :rucket
    
    def initialize(rucket)
      @rucket = rucket
    end

    def fan(name, gpio_pin, pwm_pin = nil)
      rucket.add_fan name, gpio_pin
    end

    def light(name, gpio_pin, pwm_pin = nil)
      rucket.add_light name, gpio_pin
    end

    def rmodule(name, klass, *args)
      rucket.add_module name, klass.new(rucket, *args)
    end
  end

  private_constant :RucketMeta

  MAX_ENTRIES = 30
  attr_reader :fans
  attr_reader :lights
  
  def initialize(options = {}, &block)
    #RPi::GPIO.set_warnings false
    RPi::GPIO.set_numbering :bcm
    
    @fans = {}
    @lights = {}
    @modules = {}

    if block_given?
      RucketMeta.new(self).instance_exec(&block)
    end
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


  def update
    @modules.values.each(&:main_loop)
  end

  def [] i
    @modules[i]
  end

  def run_loop
    Signal.trap("INT") do
      puts "CAUGHT SIGINT!"
      exit
    end

    begin
      loop { update }
    ensure
      RPi::GPIO.clean_up
    end
  end
end


