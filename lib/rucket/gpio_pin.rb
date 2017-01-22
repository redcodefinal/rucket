require "rpi_gpio"

class GPIOPin
  attr_reader :pin
  attr_reader :mode

  def intialize(pin, mode)
    @pin = pin
    @mode = mode

    RPi::GPIO.setup pin, as: mode
  end

  def set_high
    if mode == :output
      RPi::GPIO.set_high pin
    else
      raise "CANNOT SET AN INPUT"
    end
  end

  def set_low
    if mode == :output
      RPi::GPIO.set_low pin
    else
      raise "CANNOT SET AN INPUT"
    end
  end

  def high?
    RPi::GPIO.high? pin
  end
  
  def low?
    RPi::GPIO.low? pin
  end
end