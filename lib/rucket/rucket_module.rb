class RucketModule
  attr_reader :name
  def initialize(name)
    @name = name
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