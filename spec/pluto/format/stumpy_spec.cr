require "../../spec_helper"

describe Pluto::Format::Stumpy do
  describe ".from_stumpy" do
    it "works with ImageGA" do
      canvas = StumpyPNG.read("lib/pluto_samples/pluto.png")
      image = Pluto::ImageGA.from_stumpy(canvas)
      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
    end

    it "works with ImageRGBA" do
      canvas = StumpyPNG.read("lib/pluto_samples/pluto.png")
      image = Pluto::ImageRGBA.from_stumpy(canvas)
      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
    end
  end

  describe "#to_stumpy" do
    it "works with ImageGA" do
      image = ga_sample
      io = IO::Memory.new
      StumpyPNG.write(image.to_stumpy, io)
      digest(io.to_s).should eq "0250c2ea91650a7d33b70e34efae6515fbd0a5d8"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      io = IO::Memory.new
      StumpyPNG.write(image.to_stumpy, io)
      digest(io.to_s).should eq "c83720b2338da0753a78fd27c33eb84f467a2179"
    end
  end
end
