require "../spec_helper"

describe Pluto::RGBImage do
  it "initializes" do
    red = [0u8, 1u8]
    green = [2u8, 3u8]
    blue = [4u8, 5u8]
    alpha = [6u8, 7u8]
    width = 2
    height = 1

    Pluto::RGBImage.new(red, green, blue, alpha, width, height).should be_truthy
  end
end
