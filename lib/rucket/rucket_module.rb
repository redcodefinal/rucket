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
      enable
    else
      disable
    end
  end
end