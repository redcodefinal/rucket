require "open3"

class DHT11
  INDUSTRIAL_IO_DIR = "/sys/bus/iio/devices/"
  TEMP_FILE = "in_temp_input"
  HUMIDITY_FILE = "in_humidity_input"
  DEVICE_NAME = "iio:device"


  # Will run setup to insert industrialio module and modify the /boot/config.txt to 
  # include DHT11 sensors for the included pins.
  def self.run_setup(sensors = {})
    example_sensors = {name: {type: :dht11, pin: 4}}
  end

  def self.find_sensors
    # look thru INDUSTRIAL_IO_DIR's devices to see which ones have
    # in_temp_input and in_humidity_input
  end

  attr_reader :device_path

  def initialize(iio_device_number)
    @device_path = INDUSTRIAL_IO_DIR + DEVICE_NAME + iio_device_number + ?/ 
  end

  def get_temp
    while (temp = Open3.capture3("cat #{DHT_TEMP}").first).empty?
    end

    (temp.chars.first(2).join.to_i*1.8 + 32)
  end

  def get_humidity
    while (humid = Open3.capture3("cat #{DHT_HUMID}").first).empty?
    end

    humid.chars.first(2).join.to_i
  end
end