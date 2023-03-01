require "../../spec_helper"

describe Pluto::Operation::BilinearResize do
  describe "#bilinear_resize" do
    it "works with GrayscaleImage" do
      image = grayscale_sample
      downsized_image = image.bilinear_resize(480, 360)
      upsized_image = image.bilinear_resize(800, 600)

      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest downsized_image, "e99a957526b32dfbfabff4b580335944a1659b67"
      expect_digest upsized_image, "9fe83c54452750e436da32b42a9cad5e8a904c1b"
    end

    it "works with RGBAImage" do
      image = rgba_sample
      downsized_image = image.bilinear_resize(480, 360)
      upsized_image = image.bilinear_resize(800, 600)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest downsized_image, "7a18aea5a8a33fbb74cd12182172fd266f8b9c60"
      expect_digest upsized_image, "4091684fe7b44c6d9a61ff732ab8d6f26b129e88"
    end
  end

  describe "#bilinear_resize!" do
    it "works with GrayscaleImage" do
      image = grayscale_sample
      image.bilinear_resize!(480, 360)
      expect_digest image, "e99a957526b32dfbfabff4b580335944a1659b67"

      image = grayscale_sample
      image.bilinear_resize!(800, 600)
      expect_digest image, "9fe83c54452750e436da32b42a9cad5e8a904c1b"
    end

    it "works with RGBAImage" do
      image = rgba_sample
      image.bilinear_resize!(480, 360)
      expect_digest image, "7a18aea5a8a33fbb74cd12182172fd266f8b9c60"

      image = rgba_sample
      image.bilinear_resize!(800, 600)
      expect_digest image, "4091684fe7b44c6d9a61ff732ab8d6f26b129e88"
    end
  end
end
