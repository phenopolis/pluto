require "../spec_helper"

describe Pluto::Image do
  it "initializes" do
    pixels = [
      Pluto::RGBA.new(0, 0, 0, 0),
      Pluto::RGBA.new(1, 1, 1, 1),
      Pluto::RGBA.new(2, 2, 2, 2),
      Pluto::RGBA.new(3, 3, 3, 3),
    ]
    width = 2
    height = 1

    Pluto::Image.new(pixels, width, height).should be_truthy
  end
end
