require "stumpy_core"

module Pluto::Format::Stumpy
  macro included
    def self.from_stumpy(canvas : StumpyCore::Canvas)
      size = canvas.width * canvas.height

      red = Array(UInt8).new(size)
      green = Array(UInt8).new(size)
      blue = Array(UInt8).new(size)
      alpha = Array(UInt8).new(size)
      width = canvas.width
      height = canvas.height

      canvas.each_row do |row|
        row.each do |rgba|
          red << (rgba.r >> 8).to_u8
          green << (rgba.g >> 8).to_u8
          blue << (rgba.b >> 8).to_u8
          alpha << (rgba.a >> 8).to_u8
        end
      end

      new(red, green, blue, alpha, width, height)
    end
  end

  def to_stumpy : StumpyCore::Canvas
    StumpyCore::Canvas.new(width, height) do |x, y|
      position = y * width + x
      StumpyCore::RGBA.new(
        red[position].to_u16 << 8,
        green[position].to_u16 << 8,
        blue[position].to_u16 << 8,
        alpha[position].to_u16 << 8
      )
    end
  end
end
