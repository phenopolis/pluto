require "../spec_helper"

describe Pluto::ImageRGBA do
  it "initializes" do
    red = [0u8, 1u8]
    green = [2u8, 3u8]
    blue = [4u8, 5u8]
    alpha = [6u8, 7u8]
    width = 2
    height = 1

    Pluto::ImageRGBA.new(red, green, blue, alpha, width, height).should be_truthy
  end

  it "constructs from stumpycr canvas" do
    canvas = StumpyPNG.read("lib/pluto_samples/pluto.png")
    image = Pluto::ImageRGBA.new(canvas)
    expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
  end

  it "converts to stumpycr canvas" do
    image = rgba_sample
    io = IO::Memory.new
    StumpyPNG.write(image.to_stumpy, io)
    digest(io.to_s).should eq "c83720b2338da0753a78fd27c33eb84f467a2179"
  end
end
