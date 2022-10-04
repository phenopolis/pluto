require "../../spec_helper"

describe Pluto::Operations::BilinearResize do
  describe "#bilinear_resize" do
    it "works" do
      original_data = SpecHelper.read_sample("pluto.ppm")
      downsized_data = SpecHelper.read_sample("pluto_downsized.ppm")
      upsized_data = SpecHelper.read_sample("pluto_upsized.ppm")

      original_image = Pluto::Image.from_ppm(original_data)
      downsized_image = original_image.bilinear_resize(480, 360)
      upsized_image = original_image.bilinear_resize(800, 600)

      original_image.to_ppm.should eq original_data
      downsized_image.to_ppm.should eq downsized_data
      upsized_image.to_ppm.should eq upsized_data
    end
  end

  describe "#bilinear_resize!" do
    it "works" do
      original_data = SpecHelper.read_sample("pluto.ppm")
      downsized_data = SpecHelper.read_sample("pluto_downsized.ppm")
      upsized_data = SpecHelper.read_sample("pluto_upsized.ppm")

      image = Pluto::Image.from_ppm(original_data)
      image.bilinear_resize!(480, 360)
      image.to_ppm.should eq downsized_data

      image = Pluto::Image.from_ppm(original_data)
      image.bilinear_resize!(800, 600)
      image.to_ppm.should eq upsized_data
    end
  end
end
