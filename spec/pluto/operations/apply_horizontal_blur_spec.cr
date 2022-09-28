require "../../spec_helper"

describe Pluto::Operations::ApplyHorizontalBlur do
  describe "#apply_horizontal_blur" do
    it "works" do
      data = File.read("samples/pluto.ppm")
      blurred_data = File.read("samples/pluto_horizontal_blur_10.ppm")
      image = Pluto::Image.from_ppm(data)
      blurred_image = image.apply_horizontal_blur(10)

      image.to_ppm.should eq data
      blurred_image.to_ppm.should eq blurred_data
    end
  end

  describe "#apply_horizontal_blur!" do
    it "works" do
      data = File.read("samples/pluto.ppm")
      blurred_data = File.read("samples/pluto_horizontal_blur_10.ppm")
      image = Pluto::Image.from_ppm(data)
      image.apply_horizontal_blur!(10)

      image.to_ppm.should eq blurred_data
    end
  end
end
