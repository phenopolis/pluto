module Pluto::Operation::ChannelSwap
  def channel_swap(a : Channel, b : Channel) : Image
    clone.channel_swap!(a, b)
  end

  def channel_swap!(a : Channel, b : Channel) : Image
    case {a, b}
    when {Channel::Red, Channel::Green}, {Channel::Green, Channel::Red}
      @pixels.map! do |pixel|
        RGBA.new(pixel.green, pixel.red, pixel.blue, pixel.alpha)
      end
    when {Channel::Green, Channel::Blue}, {Channel::Blue, Channel::Green}
      @pixels.map! do |pixel|
        RGBA.new(pixel.red, pixel.blue, pixel.green, pixel.alpha)
      end
    when {Channel::Blue, Channel::Red}, {Channel::Red, Channel::Blue}
      @pixels.map! do |pixel|
        RGBA.new(pixel.blue, pixel.green, pixel.red, pixel.alpha)
      end
    when {Channel::Alpha, Channel::Red}, {Channel::Red, Channel::Alpha}
      @pixels.map! do |pixel|
        RGBA.new(pixel.alpha, pixel.green, pixel.blue, pixel.red)
      end
    when {Channel::Alpha, Channel::Green}, {Channel::Green, Channel::Alpha}
      @pixels.map! do |pixel|
        RGBA.new(pixel.red, pixel.alpha, pixel.blue, pixel.green)
      end
    when {Channel::Alpha, Channel::Blue}, {Channel::Blue, Channel::Alpha}
      @pixels.map! do |pixel|
        RGBA.new(pixel.red, pixel.green, pixel.alpha, pixel.blue)
      end
    end
    self
  end
end
