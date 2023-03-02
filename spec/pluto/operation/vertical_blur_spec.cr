require "../../spec_helper"

describe Pluto::Operation::VerticalBlur do
  describe "#vertical_blur" do
    it "works with GrayscaleImage" do
      image = grayscale_sample
      blurred_image = image.vertical_blur(10)

      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest blurred_image, "38d71a5c13f46afdca6b13ecbdeb97327cd46dd7"
    end

    it "works with RGBAImage" do
      image = rgba_sample
      blurred_image = image.vertical_blur(10)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest blurred_image, "d7116d6cea0a14e23cc3a23dbc86ad8bf1fecf2f"
    end
  end

  describe "#vertical_blur!" do
    it "works with GrayscaleImage" do
      image = grayscale_sample
      image.vertical_blur!(10)

      expect_digest image, "38d71a5c13f46afdca6b13ecbdeb97327cd46dd7"
    end

    it "works with RGBAImage" do
      image = rgba_sample
      image.vertical_blur!(10)

      expect_digest image, "d7116d6cea0a14e23cc3a23dbc86ad8bf1fecf2f"
    end
  end
end
