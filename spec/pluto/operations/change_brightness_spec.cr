require "../../spec_helper"

describe Pluto::Operations::ChangeBrightness do
  describe "#change_brightness" do
    it "works" do
      data = File.read("samples/pluto.ppm")
      image = Pluto::Image.from_ppm(data)
      brightened_image = image.change_brightness(1.4)
      darkened_image = image.change_brightness(0.6)

      image.red[image.width * 240 + 320].should eq 238
      image.green[image.width * 240 + 320].should eq 195
      image.blue[image.width * 240 + 320].should eq 153

      brightened_image.red[image.width * 240 + 320].should eq 255
      brightened_image.green[image.width * 240 + 320].should eq 255
      brightened_image.blue[image.width * 240 + 320].should eq 214

      darkened_image.red[image.width * 240 + 320].should eq 142
      darkened_image.green[image.width * 240 + 320].should eq 117
      darkened_image.blue[image.width * 240 + 320].should eq 91
    end
  end

  describe "#change_brightness!" do
    it "works" do
      data = File.read("samples/pluto.ppm")
      image = Pluto::Image.from_ppm(data)

      image.red[image.width * 240 + 320].should eq 238
      image.green[image.width * 240 + 320].should eq 195
      image.blue[image.width * 240 + 320].should eq 153

      image.change_brightness!(1.4)
      image.red[image.width * 240 + 320].should eq 255
      image.green[image.width * 240 + 320].should eq 255
      image.blue[image.width * 240 + 320].should eq 214

      image.change_brightness!(0.6)
      image.red[image.width * 240 + 320].should eq 153
      image.green[image.width * 240 + 320].should eq 153
      image.blue[image.width * 240 + 320].should eq 128
    end
  end
end
