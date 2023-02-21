require "../../spec_helper"

Spectator.describe Pluto::Format::PPM do
  include SpecHelper

  describe ".from_ppm and #to_ppm" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("pluto.ppm")
      image = Pluto::RGBAImage.from_ppm(data)

      digest(image).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
    end

    it "works with GrayscaleImage" do
      data = SpecHelper.read_sample("pluto.ppm")
      image = Pluto::GrayscaleImage.from_ppm(data)

      digest(image).should eq "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
    end
  end
end
