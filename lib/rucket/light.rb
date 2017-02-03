class Light
  attr_reader :pin
  
  def initialize(pin)
    @on = false
    @pin = GPIOPin.new(pin, :output)
  end

  def turn_on
    @pin.set_low
    @on = true
  end

  def turn_off
    @pin.set_high
    @on = false
  end

  def off?
    not @on
  end

  def on?
    @on
  end  
end