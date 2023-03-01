require "../../spec_helper"

describe Pluto::Format::PPM do
  describe ".from_ppm and .to_ppm" do
    it "works with GrayscaleImage" do
      with_sample("pluto.ppm") do |io|
        image = Pluto::GrayscaleImage.from_ppm(io)
        io = IO::Memory.new
        image.to_ppm(io)

        digest(io.to_s).should eq "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      end
    end

    it "works with RGBAImage" do
      with_sample("pluto.ppm") do |io|
        image = Pluto::RGBAImage.from_ppm(io)
        io = IO::Memory.new
        image.to_ppm(io)

        digest(io.to_s).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      end
    end
  end
end
