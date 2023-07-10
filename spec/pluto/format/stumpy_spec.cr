require "../../spec_helper"

describe Pluto::Format::Stumpy do
  describe ".from_stumpy" do
    it "works with ImageGA" do
      canvas = StumpyPNG.read("lib/pluto_samples/desert.png")
      image = Pluto::ImageGA.from_stumpy(canvas)
      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"
    end

    it "works with ImageRGBA" do
      canvas = StumpyPNG.read("lib/pluto_samples/desert.png")
      image = Pluto::ImageRGBA.from_stumpy(canvas)
      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
    end
  end

  describe "#to_stumpy" do
    it "works with ImageGA" do
      image = ga_sample
      io = IO::Memory.new
      StumpyPNG.write(image.to_stumpy, io)
      digest(io.to_s).should eq "954b25934229580dc80e9dc969530c1447557af2"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      io = IO::Memory.new
      StumpyPNG.write(image.to_stumpy, io)
      digest(io.to_s).should eq "d7b06d8d7b8e8542fa4dcc68c3cbe0c2357ec593"
    end
  end
end
