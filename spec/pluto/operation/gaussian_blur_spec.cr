require "../../spec_helper"

describe Pluto::Operation::GaussianBlur do
  describe "#gaussian_blur" do
    it "works with GrayscaleImage" do
      image = grayscale_sample
      blurred_image = image.gaussian_blur(10)

      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest blurred_image, "b1b30bdb0dc41f759ac74195349a3c3e3f88ac87"
    end

    it "works with RGBAImage" do
      image = rgba_sample
      blurred_image = image.gaussian_blur(10)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest blurred_image, "05159a180871f9416c1fdb600a38c21f51bbcb6e"
    end
  end

  describe "#gaussian_blur!" do
    it "works with GrayscaleImage" do
      image = grayscale_sample
      image.gaussian_blur!(10)

      expect_digest image, "b1b30bdb0dc41f759ac74195349a3c3e3f88ac87"
    end

    it "works with RGBAImage" do
      image = rgba_sample
      image.gaussian_blur!(10)

      expect_digest image, "05159a180871f9416c1fdb600a38c21f51bbcb6e"
    end
  end
end
