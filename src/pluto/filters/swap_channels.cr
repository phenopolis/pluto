module Pluto::Filters::SwapChannels
  enum Channel
    Red
    Green
    Blue
  end

  def swap_channels(a : Channel, b : Channel) : Image
    self.class.new(@pixels.clone, @width, @height, @type).swap_channels!(a, b)
  end

  def swap_channels!(a : Channel, b : Channel) : Image
    case {a, b}
    when {Channel::Red, Channel::Green}, {Channel::Green, Channel::Red}
      @height.times do |y|
        @width.times do |x|
          pixel = @pixels[y][x]
          red = (pixel & 0xFF000000) >> 8
          green = (pixel & 0x00FF0000) << 8
          blue = (pixel & 0x0000FF00)
          @pixels[y][x] = red | green | blue
        end
      end
    when {Channel::Green, Channel::Blue}, {Channel::Blue, Channel::Green}
      @height.times do |y|
        @width.times do |x|
          pixel = @pixels[y][x]
          red = (pixel & 0xFF000000)
          green = (pixel & 0x00FF0000) >> 8
          blue = (pixel & 0x0000FF00) << 8
          @pixels[y][x] = red | green | blue
        end
      end
    when {Channel::Blue, Channel::Red}, {Channel::Red, Channel::Blue}
      @height.times do |y|
        @width.times do |x|
          pixel = @pixels[y][x]
          red = (pixel & 0xFF000000) >> 16
          green = (pixel & 0x00FF0000)
          blue = (pixel & 0x0000FF00) << 16
          @pixels[y][x] = red | green | blue
        end
      end
    end
    self
  end
end
