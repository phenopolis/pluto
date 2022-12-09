struct Pluto::RGBA
  getter red : UInt8
  getter green : UInt8
  getter blue : UInt8
  getter alpha : UInt8

  def initialize(@red, @green, @blue, @alpha)
  end

  def clone
    self.class.new(@red, @green, @blue, @alpha)
  end
end
