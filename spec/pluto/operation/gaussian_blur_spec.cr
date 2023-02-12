require "../../spec_helper"

describe Pluto::Operation::GaussianBlur do
  describe "#gaussian_blur" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::RGBImage.from_ppm(data)
      blurred_image = original_image.gaussian_blur(10)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      Digest::SHA1.hexdigest(blurred_image.to_ppm).should eq "245b54db2a7b075bf5404dc34d8b96357349f4d2"
    end
  end

  describe "#gaussian_blur!" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::RGBImage.from_ppm(data)
      image.gaussian_blur!(10)

      Digest::SHA1.hexdigest(image.to_ppm).should eq "245b54db2a7b075bf5404dc34d8b96357349f4d2"
    end
  end
end
