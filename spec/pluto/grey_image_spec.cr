require "../spec_helper"

def grey_image : Pluto::GreyImage
  grey = [
    255, 0u8, 255,
    0u8, 1u8, 0u8,
    255, 255, 255,
  ] of UInt8
  width = 3
  height = 3

  Pluto::GreyImage.new(grey, width, height)
end

describe Pluto::GreyImage do
  it "initializes" do
    grey_image.should be_truthy
  end

  it "saves to ppm" do
    Digest::SHA1.hexdigest(grey_image.to_ppm).should eq "d3d3803d051156efd9fc1ef73e016a0ed4f16f66"
  end

  it "saves to jpeg" do
    Digest::SHA1.hexdigest(grey_image.to_jpeg).should eq "9698e917d5b0582ad4f361b458a8127cb5ee3558"
  end
end
