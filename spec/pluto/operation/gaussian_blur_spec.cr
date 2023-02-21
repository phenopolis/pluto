require "../../spec_helper"

Spectator.describe Pluto::Operation::GaussianBlur do
  describe "#gaussian_blur" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::RGBAImage.from_ppm(data)
      blurred_image = original_image.gaussian_blur(10)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      Digest::SHA1.hexdigest(blurred_image.to_ppm).should eq "245b54db2a7b075bf5404dc34d8b96357349f4d2"
    end

    it "works with GrayscaleImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::GrayscaleImage.from_ppm(data)
      blurred_image = original_image.gaussian_blur(10)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      Digest::SHA1.hexdigest(blurred_image.to_ppm).should eq "df13de316f347c955309abcada06657d00b55bf5"
    end
  end

  describe "#gaussian_blur!" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::RGBAImage.from_ppm(data)
      image.gaussian_blur!(10)

      Digest::SHA1.hexdigest(image.to_ppm).should eq "245b54db2a7b075bf5404dc34d8b96357349f4d2"
    end

    it "works with GrayscaleImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::GrayscaleImage.from_ppm(data)
      image.gaussian_blur!(10)

      Digest::SHA1.hexdigest(image.to_ppm).should eq "df13de316f347c955309abcada06657d00b55bf5"
    end
  end
end
