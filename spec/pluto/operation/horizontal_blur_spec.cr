require "../../spec_helper"

describe Pluto::Operation::HorizontalBlur do
  describe "#horizontal_blur" do
    it "works with GrayscaleImage" do
      image = grayscale_sample
      blurred_image = image.horizontal_blur(10)

      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest blurred_image, "b04348fe463d35197cc57b0114596d9b78a20f55"
    end

    it "works with RGBAImage" do
      image = rgba_sample
      blurred_image = image.horizontal_blur(10)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest blurred_image, "625be82cf07186fde56a81059c8149bc192bb1c9"
    end
  end

  describe "#horizontal_blur!" do
    it "works with GrayscaleImage" do
      image = grayscale_sample
      image.horizontal_blur!(10)

      expect_digest image, "b04348fe463d35197cc57b0114596d9b78a20f55"
    end

    it "works with RGBAImage" do
      image = rgba_sample
      image.horizontal_blur!(10)

      expect_digest image, "625be82cf07186fde56a81059c8149bc192bb1c9"
    end
  end
end
