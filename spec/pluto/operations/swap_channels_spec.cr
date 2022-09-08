require "../../spec_helper"

describe Pluto::Operations::SwapChannels do
  describe "#swap_channels" do
    it "works" do
      rgb_data = File.read("samples/california_rgb.ppm")
      bgr_data = File.read("samples/california_bgr.ppm")
      rgb_image = Pluto::Image.from_ppm(rgb_data)
      bgr_image = rgb_image.swap_channels(:red, :blue)

      rgb_image.to_ppm.should eq rgb_data
      bgr_image.to_ppm.should eq bgr_data
    end
  end

  describe "#swap_channels!" do
    it "works" do
      rgb_data = File.read("samples/california_rgb.ppm")
      bgr_data = File.read("samples/california_bgr.ppm")
      image = Pluto::Image.from_ppm(rgb_data)
      image.swap_channels!(:red, :blue)

      image.to_ppm.should eq bgr_data
    end
  end
end
