require "../../spec_helper"

describe Pluto::Format::PPM do
  describe ".from_ppm and #to_ppm" do
    it "works with ImageGA" do
      with_sample("desert.ppm") do |io|
        image = Pluto::ImageGA.from_ppm(io)
        io = IO::Memory.new
        image.to_ppm(io)

        digest(io.to_s).should eq "91fd39e895dac79f13501d32efbb6301c3558462"
      end
    end

    it "works with ImageRGBA" do
      with_sample("desert.ppm") do |io|
        image = Pluto::ImageRGBA.from_ppm(io)
        io = IO::Memory.new
        image.to_ppm(io)

        digest(io.to_s).should eq "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      end
    end
  end
end
