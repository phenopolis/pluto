require "../../spec_helper"

describe Pluto::Format::PPM do
  describe ".from_ppm" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")
      image = Pluto::RGBImage.from_ppm(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "d7a21c69034175411176d404b7e1c03e4a50a938"
    end
  end

  describe "#to_ppm" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")
      image = Pluto::RGBImage.from_ppm(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "d7a21c69034175411176d404b7e1c03e4a50a938"
    end
  end
end
