require "../../spec_helper"

describe Pluto::Operation::Contrast do
  describe "#contrast" do
    it "works" do
      original_data = SpecHelper.read_sample("pluto.ppm")
      positive_data = SpecHelper.read_sample("pluto_contrast_positive.ppm")
      negative_data = SpecHelper.read_sample("pluto_contrast_negative.ppm")

      original_image = Pluto::Image.from_ppm(original_data)
      positive_image = original_image.contrast(128)
      negative_image = original_image.contrast(-128)

      original_image.to_ppm.should eq original_data
      positive_image.to_ppm.should eq positive_data
      negative_image.to_ppm.should eq negative_data
    end
  end

  describe "#contrast!" do
    it "works" do
      original_data = SpecHelper.read_sample("pluto.ppm")
      positive_data = SpecHelper.read_sample("pluto_contrast_positive.ppm")
      negative_data = SpecHelper.read_sample("pluto_contrast_negative.ppm")

      image = Pluto::Image.from_ppm(original_data)
      image.contrast!(128)
      image.to_ppm.should eq positive_data

      image = Pluto::Image.from_ppm(original_data)
      image.contrast!(-128)
      image.to_ppm.should eq negative_data
    end
  end
end
