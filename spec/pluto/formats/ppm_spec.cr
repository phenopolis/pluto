require "../../spec_helper"

describe Pluto::Formats::PPM do
  describe ".from_ppm" do
    it "works" do
      data = File.read("samples/pluto.ppm")
      image = Pluto::Image.from_ppm(data)

      image.pixels[240][320].should eq 4005796096
      image.width.should eq 640
      image.height.should eq 480
      image.type.should eq Image::Type::RGB
    end
  end

  describe "#to_ppm" do
    it "works" do
      data_before = File.read("samples/pluto.ppm")
      data_after = Pluto::Image.from_ppm(data_before).to_ppm

      data_after.should eq data_before
    end
  end
end
