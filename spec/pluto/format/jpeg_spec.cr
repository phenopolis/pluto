require "../../spec_helper"

describe Pluto::Format::JPEG do
  describe ".from_jpeg" do
    it "works" do
      data = SpecHelper.read_sample("pluto.jpg")
      image = Pluto::Image.from_jpeg(data)

      image.red[image.width * 240 + 320].should eq 238
      image.green[image.width * 240 + 320].should eq 195
      image.blue[image.width * 240 + 320].should eq 153
      image.width.should eq 640
      image.height.should eq 480
    end
  end

  describe "#to_jpeg" do
    it "works" do
      original_data = SpecHelper.read_sample("pluto.jpg")

      jpeg_data = Pluto::Image.from_jpeg(original_data).to_jpeg
      jpeg_data.size.should eq 61830
      jpeg_data.includes?("JFIF").should be_true
    end
  end
end
