module Pluto::Operations::SwapChannels
  def swap_channels(a : Image::Channel, b : Image::Channel) : Image
    clone.swap_channels!(a, b)
  end

  def swap_channels!(a : Image::Channel, b : Image::Channel) : Image
    case {a, b}
    when {Image::Channel::Red, Image::Channel::Green}, {Image::Channel::Green, Image::Channel::Red}
      @red, @green = @green, @red
    when {Image::Channel::Green, Image::Channel::Blue}, {Image::Channel::Blue, Image::Channel::Green}
      @green, @blue = @blue, @green
    when {Image::Channel::Red, Image::Channel::Blue}, {Image::Channel::Blue, Image::Channel::Red}
      @red, @blue = @blue, @red
    end
    self
  end
end
