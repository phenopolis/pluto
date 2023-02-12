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

def sample_image
  Pluto::GreyImage.open("lib/pluto_samples/pluto.ppm")
end

def hash(content : String)
  Digest::SHA1.hexdigest(content)
end

describe Pluto::GreyImage do
  it "initializes" do
    grey_image.should be_truthy
  end

  it "saves to ppm" do
    hash(grey_image.to_ppm).should eq "d3d3803d051156efd9fc1ef73e016a0ed4f16f66"
  end

  it "saves to jpeg" do
    hash(grey_image.to_jpeg).should eq "9698e917d5b0582ad4f361b458a8127cb5ee3558"
  end

  it "vertical blurs" do
    hash(sample_image.vertical_blur!(10).to_ppm).should eq "38d71a5c13f46afdca6b13ecbdeb97327cd46dd7"
  end

  it "horizontal blurs" do
    hash(sample_image.horizontal_blur!(10).to_ppm).should eq "b04348fe463d35197cc57b0114596d9b78a20f55"
  end

  it "resizes bilinearly" do
    hash(sample_image.bilinear_resize!(200, 200).to_ppm).should eq "69a273b74830c94e3afde42bad03ca254500900e"
  end

  it "box blurs" do
    hash(sample_image.box_blur!(10).to_ppm).should eq "dc18cddfd3486fa33dae3af028a9da3274facc3e"
  end

  it "increases brightness" do
    hash(sample_image.brightness!(1.4).to_ppm).should eq "16e5ec301a72d75ea53c62c8f7b66b0b583455e4"
  end

  it "changes contrast" do
    hash(sample_image.contrast(128).to_ppm).should eq "5aa2004129f7267c851b8055cdd93da205ab7483"
  end

  it "gaussian blurs" do
    hash(sample_image.gaussian_blur(10).to_ppm).should eq "df13de316f347c955309abcada06657d00b55bf5"
  end
end
