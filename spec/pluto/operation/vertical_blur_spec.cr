require "../../spec_helper"

describe Pluto::Operation::VerticalBlur do
  describe "#vertical_blur" do
    it "works" do
      original_data = SpecHelper.read_sample("pluto.ppm")
      blurred_data = SpecHelper.read_sample("pluto_vertical_blur.ppm")

      original_image = Pluto::Image.from_ppm(original_data)
      blurred_image = original_image.vertical_blur(10)

      original_image.to_ppm.should eq original_data
      blurred_image.to_ppm.should eq blurred_data
    end
  end

  describe "#vertical_blur!" do
    it "works" do
      original_data = SpecHelper.read_sample("pluto.ppm")
      blurred_data = SpecHelper.read_sample("pluto_vertical_blur.ppm")

      image = Pluto::Image.from_ppm(original_data)
      image.vertical_blur!(10)

      image.to_ppm.should eq blurred_data
    end
  end
end
