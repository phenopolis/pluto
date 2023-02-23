require "../../spec_helper"

describe Pluto::Format::PPM do
  describe ".from_ppm" do
    it "works with RGBAImage" do
      data = SpecHelper.pluto_ppm
      image = Pluto::RGBAImage.from_ppm(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "d7a21c69034175411176d404b7e1c03e4a50a938"
    end

    it "works with GrayscaleImage" do
      data = SpecHelper.pluto_ppm
      image = Pluto::GrayscaleImage.from_ppm(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "413b301c494bef9b80aab18b2f6cfd649780832f"
    end
  end

  describe "#to_ppm" do
    it "works with RGBAImage" do
      data = SpecHelper.pluto_ppm
      image = Pluto::RGBAImage.from_ppm(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "d7a21c69034175411176d404b7e1c03e4a50a938"
    end

    it "works with GrayscaleImage" do
      data = SpecHelper.pluto_ppm
      image = Pluto::GrayscaleImage.from_ppm(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "413b301c494bef9b80aab18b2f6cfd649780832f"
    end
  end
end
