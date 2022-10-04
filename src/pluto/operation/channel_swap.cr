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
    when {Channel::Red, Channel::Blue}, {Channel::Blue, Channel::Red}
      @red, @blue = @blue, @red
    end
    self
  end
end
