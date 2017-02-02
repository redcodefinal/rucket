class Fan
  attr_reader :pin
  
  def initialize(pin)
    @pin = GPIOPin.new(pin, :output) 
  end

  def turn_on
    @pin.set_low
  end

  def turn_off
    @pin.set_high
  end

  def off?
    @pin.low?
  end

  def on?
    @pin.high?
  end  
end