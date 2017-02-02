require_relative '../rucket_module'

class Timer < RucketModule
  attr_accessor :start_time
  attr_accessor :end_time

  attr_accessor :on_proc, :off_proc

  attr_reader :on
  alias_method :on?, :on

  def initialize(rucket, on_proc, off_proc, start_time = "08:00", end_time = "23:59")
    super rucket
    @on_proc = on_proc
    @off_proc = off_proc
    @start_time = start_time
    @end_time = end_time
  end  

  def off?
    not on?
  end

  def main_loop
    time = Time.now
    #Have to remake time every time because cover also covers dates.
    new_start_time = Time.parse(start_time)
    new_end_time = Time.parse(end_time)

    if (new_start_time..new_end_time).cover?(Time.now) and off?
      instance_exec &on_proc
    elsif !(new_start_time..new_end_time).cover?(Time.now) and on?
      instance_exec &off_proc
    end
  end
end