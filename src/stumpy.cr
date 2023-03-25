require "./pluto"
require "stumpy_core"

class Pluto::ImageRGBA
  def initialize(canvas : StumpyCore::Canvas)
    size = (@width = canvas.width) * (@height = canvas.height)
    @red = Array(UInt8).new(size)
    @green = Array(UInt8).new(size)
    @blue = Array(UInt8).new(size)
    @alpha = Array(UInt8).new(size)

    canvas.each_row do |row|
      row.each do |rgba|
        @red << (rgba.r >> 8).to_u8
        @green << (rgba.g >> 8).to_u8
        @blue << (rgba.b >> 8).to_u8
        @alpha << (rgba.a >> 8).to_u8
      end
    end
  end

  def to_stumpy : StumpyCore::Canvas
    StumpyCore::Canvas.new(width, height) do |x, y|
      index = y * width + x
      StumpyCore::RGBA.new(
        red[index].to_u16 << 8,
        green[index].to_u16 << 8,
        blue[index].to_u16 << 8,
        alpha[index].to_u16 << 8
      )
    end
  end
end
