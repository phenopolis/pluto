require "../../spec_helper"

describe Pluto::Formats::PPM do
  describe ".from_ppm" do
    it "works" do
      data = File.read("samples/pluto.ppm")
      image = Pluto::Image.from_ppm(data)

      image.red[240][320].should eq 238
      image.green[240][320].should eq 195
      image.blue[240][320].should eq 153
      image.width.should eq 640
      image.height.should eq 480
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
