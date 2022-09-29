require "../../spec_helper"

describe Pluto::Operations::SwapChannels do
  describe "#swap_channels" do
    it "works" do
      original_data = SpecHelper.read_sample("california.ppm")
      bgr_data = SpecHelper.read_sample("california_bgr.ppm")

      original_image = Pluto::Image.from_ppm(original_data)
      bgr_image = original_image.swap_channels(:red, :blue)

      original_image.to_ppm.should eq original_data
      bgr_image.to_ppm.should eq bgr_data
    end
  end

  describe "#swap_channels!" do
    it "works" do
      original_data = SpecHelper.read_sample("california.ppm")
      bgr_data = SpecHelper.read_sample("california_bgr.ppm")

      image = Pluto::Image.from_ppm(original_data)
      image.swap_channels!(:red, :blue)

      image.to_ppm.should eq bgr_data
    end
  end
end
