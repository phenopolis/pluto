module Pluto::Operations::SwapChannels
  enum Channel
    Red
    Green
    Blue
  end

  def swap_channels(a : Channel, b : Channel) : Image
    self.class.new(
      @red.clone,
      @green.clone,
      @blue.clone,
      @alpha.clone,
      @width,
      @height
    ).swap_channels!(a, b)
  end

  def swap_channels!(a : Channel, b : Channel) : Image
    case {a, b}
    when {Channel::Red, Channel::Green}, {Channel::Green, Channel::Red}
      @red, @green = @green, @red
    when {Channel::Green, Channel::Blue}, {Channel::Blue, Channel::Green}
      @green, @blue = @blue, @green
    when {Channel::Red, Channel::Blue}, {Channel::Blue, Channel::Red}
      @red, @blue = @blue, @red
    end
    self
  end
end
