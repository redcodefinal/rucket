class RucketModule
  attr_reader :rucket
  
  def initialize(rucket)
    @rucket = rucket
    @disabled = false
  end

  def disable
    @disabled = true
  end

  def enable
    @disabled = false
  end

  def disabled?
    @disabled
  end  

  def toggle
    if disabled?
      disable
    else
      enable
    end
end