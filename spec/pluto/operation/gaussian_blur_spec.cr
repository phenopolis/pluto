require "../../spec_helper"

describe Pluto::Operation::GaussianBlur do
  describe "#gaussian_blur" do
    it "works with GrayscaleImage" do
      image = grayscale_sample
      blurred_image = image.gaussian_blur(10)

      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest blurred_image, "df13de316f347c955309abcada06657d00b55bf5"
    end

    it "works with RGBAImage" do
      image = rgba_sample
      blurred_image = image.gaussian_blur(10)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest blurred_image, "245b54db2a7b075bf5404dc34d8b96357349f4d2"
    end
  end

  describe "#gaussian_blur!" do
    it "works with GrayscaleImage" do
      image = grayscale_sample
      image.gaussian_blur!(10)

      expect_digest image, "df13de316f347c955309abcada06657d00b55bf5"
    end

    it "works with RGBAImage" do
      image = rgba_sample
      image.gaussian_blur!(10)

      expect_digest image, "245b54db2a7b075bf5404dc34d8b96357349f4d2"
    end
  end
end
