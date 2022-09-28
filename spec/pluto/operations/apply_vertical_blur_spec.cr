require "../../spec_helper"

describe Pluto::Operations::ApplyVerticalBlur do
  describe "#apply_vertical_blur" do
    it "works" do
      data = File.read("samples/pluto.ppm")
      blurred_data = File.read("samples/pluto_vertical_blur_10.ppm")
      image = Pluto::Image.from_ppm(data)
      blurred_image = image.apply_vertical_blur(10)

      image.to_ppm.should eq data
      blurred_image.to_ppm.should eq blurred_data
    end
  end

  describe "#apply_vertical_blur!" do
    it "works" do
      data = File.read("samples/pluto.ppm")
      blurred_data = File.read("samples/pluto_vertical_blur_10.ppm")
      image = Pluto::Image.from_ppm(data)
      image.apply_vertical_blur!(10)

      image.to_ppm.should eq blurred_data
    end
  end
end
