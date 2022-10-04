require "../../spec_helper"

describe Pluto::Operation::Brightness do
  describe "#brightness" do
    it "works" do
      original_data = SpecHelper.read_sample("pluto.ppm")
      brightened_data = SpecHelper.read_sample("pluto_brightness_brightened.ppm")
      darkened_data = SpecHelper.read_sample("pluto_brightness_darkened.ppm")

      original_image = Pluto::Image.from_ppm(original_data)
      brightened_image = original_image.brightness(1.4)
      darkened_image = original_image.brightness(0.6)

      original_image.to_ppm.should eq original_data
      brightened_image.to_ppm.should eq brightened_data
      darkened_image.to_ppm.should eq darkened_data
    end
  end

  describe "#brightness!" do
    it "works" do
      original_data = SpecHelper.read_sample("pluto.ppm")
      brightened_data = SpecHelper.read_sample("pluto_brightness_brightened.ppm")
      darkened_data = SpecHelper.read_sample("pluto_brightness_darkened.ppm")

      image = Pluto::Image.from_ppm(original_data)
      image.brightness!(1.4)
      image.to_ppm.should eq brightened_data

      image = Pluto::Image.from_ppm(original_data)
      image.brightness!(0.6)
      image.to_ppm.should eq darkened_data
    end
  end
end
