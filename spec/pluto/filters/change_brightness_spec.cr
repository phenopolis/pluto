require "../../spec_helper"

describe Pluto::Filters::ChangeBrightness do
  describe "#change_brightness" do
    it "works" do
      data = File.read("samples/pluto.ppm")
      image = Pluto::Image.from_ppm(data)
      brightened_image = image.change_brightness(1.2)
      darkened_image = image.change_brightness(0.8)

      image.pixels[240][320].should eq 4005796096
      brightened_image.pixels[240][320].should eq 4293572352
      darkened_image.pixels[240][320].should eq 3197925888
    end
  end

  describe "#change_brightness!" do
    it "works" do
      data = File.read("samples/pluto.ppm")
      image = Pluto::Image.from_ppm(data)

      image.pixels[240][320].should eq 4005796096
      image.change_brightness!(1.2).pixels[240][320].should eq 4293572352
      image.change_brightness!(0.8).pixels[240][320].should eq 3434844672
    end
  end
end
