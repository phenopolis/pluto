require "../../spec_helper"

describe Pluto::Operation::BilinearResize do
  describe "#bilinear_resize" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::RGBImage.from_ppm(data)
      downsized_image = original_image.bilinear_resize(480, 360)
      upsized_image = original_image.bilinear_resize(800, 600)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      Digest::SHA1.hexdigest(downsized_image.to_ppm).should eq "7a18aea5a8a33fbb74cd12182172fd266f8b9c60"
      Digest::SHA1.hexdigest(upsized_image.to_ppm).should eq "4091684fe7b44c6d9a61ff732ab8d6f26b129e88"
    end
  end

  describe "#bilinear_resize!" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::RGBImage.from_ppm(data)
      image.bilinear_resize!(480, 360)
      Digest::SHA1.hexdigest(image.to_ppm).should eq "7a18aea5a8a33fbb74cd12182172fd266f8b9c60"

      image = Pluto::RGBImage.from_ppm(data)
      image.bilinear_resize!(800, 600)
      Digest::SHA1.hexdigest(image.to_ppm).should eq "4091684fe7b44c6d9a61ff732ab8d6f26b129e88"
    end
  end
end
