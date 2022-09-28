require "../../spec_helper"

describe Pluto::Formats::JPEG do
  describe ".from_jpeg" do
    it "works" do
      data = File.read("samples/pluto.jpg")
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
      data_before = File.read("samples/pluto.jpg")
      data_after = Pluto::Image.from_jpeg(data_before).to_jpeg

      data_after.size.should eq 61830
      data_after.includes?("JFIF").should be_true
    end
  end
end
