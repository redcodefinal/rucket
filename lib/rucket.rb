require "rpi_gpio"
require "require_all"
require "time"
require "logger"
require "fileutils"

require_rel "rucket/*.rb"
require_rel "rucket/modules/*.rb"

module Rucket
  FileUtils.mkdir_p(File.dirname(__FILE__) + '/../log/')
  LOG_FILE = File.new(File.dirname(__FILE__) + '/../log/' + name + '.log', 'w')
  LOG = Logger.new(LOG_FILE)
  FORMAT = Logger::Formatter.new
  MAX_LOG_LINES = 100
  LOG.formatter = proc { |severity, datetime, progname, msg|
    log_line = Rucket::FORMAT.call(severity, datetime, progname, msg.dump)
    Rucket.log_lines.unshift log_line
    Rucket.log_lines.slice!(Rucket.log_lines.count-1) if Rucket.log_lines.count > MAX_LOG_LINES
    log_line
  }

  extend self

  module RucketMeta
    extend self

    def fan(name, gpio_pin, pwm_pin = nil)
      Rucket.add_fan name, gpio_pin
    end

    def light(name, gpio_pin, pwm_pin = nil)
      Rucket.add_light name, gpio_pin
    end

    def rmodule(name, klass, *args)
      Rucket.add_module name, klass.new(name, *args)
    end
  end

  private_constant :RucketMeta
  attr_reader :log_lines

  attr_reader :fans
  attr_reader :lights
  attr_reader :modules
  
  def start(&block)
    #RPi::GPIO.set_warnings false
    RPi::GPIO.set_numbering :bcm
    RPi::GPIO.clean_up
    @log_lines = []
 
    @fans = {}
    @lights = {}
    @modules = {}

    if block_given?
      RucketMeta.instance_exec(&block)
    end

    LOG.info "Rucket created!"
  end

  def add_module(name, mod)
    @modules[name] = mod
    LOG.info "Module #{name} added! #{mod}"
  end

  def add_fan(name, pin)
    fans[name] = Fan.new(pin)
    LOG.info "Fan #{name} added! pin#: #{pin}"    
  end

  # def add_fan_pwm(name, pin, pwm_pin)
  #   fans[name] = FanPWM.new(pin, pwm_pin)
  # end

  def add_light(name, pin)
    lights[name] = Light.new(pin)
    LOG.info "Light #{name} added! pin#: #{pin}"
  end

  # def add_light_pwm(name, pin)
  #   lights[name] = LightPWM.new(pin, pwm_pin)
  # end


  def update
    @modules.values.each do |mod|
      mod.main_loop unless mod.disabled?
    end  
  end

  def [] i
    @modules[i]
  end

  def run_loop
    Signal.trap("INT") do
      puts "CAUGHT SIGINT!"
      LOG.warning "SIGINT CAUGHT!"
      exit
    end

    begin
      loop { update }
    ensure
      RPi::GPIO.clean_up
      LOG.warning "GPIO cleaned up"
    end
  end
end


