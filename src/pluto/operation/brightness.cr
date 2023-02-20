module Pluto::Operation::Brightness
  def brightness(value : Float64) : self
    clone.brightness!(value)
  end

  def brightness!(value : Float64) : self
    each_channel do |channel|
      size.times do |index|
        channel.unsafe_put(index, Math.min(255, (channel.unsafe_fetch(index) * value)).to_u8)
      end
    end
    self
  end
end
