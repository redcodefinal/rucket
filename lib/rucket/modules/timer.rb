require_relative '../rucket_module'

class Timer < RucketModule
  attr_accessor :start_time
  attr_accessor :end_time

  def initialize(start_time = "08:00", end_time = "23:59")
    @start_time = start_time
    @end_time = end_time
  end  

  def main_loop
    time = Time.now
    #Have to remake time every time because cover also covers dates.
    new_start_time = Time.parse(start_time)
    new_end_time = Time.parse(end_time)

    if (new_start_time..new_end_time).cover?(Time.now) and rucket.off?
      rucket.turn_on
    elsif !(new_start_time..new_end_time).cover?(Time.now) and rucket.on?
      rucket.turn_off
    end
  end
end