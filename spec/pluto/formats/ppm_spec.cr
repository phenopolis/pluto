require "../../spec_helper"

describe Pluto::Formats::PPM do
  describe ".from_ppm" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")
      image = Pluto::Image.from_ppm(data)

      image.red[image.width * 240 + 320].should eq 238
      image.green[image.width * 240 + 320].should eq 195
      image.blue[image.width * 240 + 320].should eq 153
      image.width.should eq 640
      image.height.should eq 480
    end
  end

  describe "#to_ppm" do
    it "works" do
      original_data = SpecHelper.read_sample("pluto.ppm")

      ppm_data = Pluto::Image.from_ppm(original_data).to_ppm
      ppm_data.size.should eq 888901
      ppm_data.includes?("P6").should be_true
    end
  end
end
