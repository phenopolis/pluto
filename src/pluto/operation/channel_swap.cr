module Pluto::Operation::ChannelSwap
  def channel_swap(a : Channel, b : Channel) : Image
    clone.channel_swap!(a, b)
  end

  def channel_swap!(a : Channel, b : Channel) : Image
    case {a, b}
    when {Channel::Red, Channel::Green}, {Channel::Green, Channel::Red}
      @red, @green = @green, @red
    when {Channel::Green, Channel::Blue}, {Channel::Blue, Channel::Green}
      @green, @blue = @blue, @green
    when {Channel::Blue, Channel::Red}, {Channel::Red, Channel::Blue}
      @red, @blue = @blue, @red
    when {Channel::Alpha, Channel::Red}, {Channel::Red, Channel::Alpha}
      @alpha, @red = @red, @alpha
    when {Channel::Alpha, Channel::Green}, {Channel::Green, Channel::Alpha}
      @alpha, @green = @green, @alpha
    when {Channel::Alpha, Channel::Blue}, {Channel::Blue, Channel::Alpha}
      @alpha, @blue = @blue, @alpha
    end
    self
  end
end
