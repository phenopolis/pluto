require "../../spec_helper"

describe Pluto::Operation::VerticalBlur do
  describe "#vertical_blur" do
    it "works with GrayscaleImage" do
      image = grayscale_sample
      blurred_image = image.vertical_blur(10)

      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest blurred_image, "45b4a49232674ed4e33c06e09c19ba22e0baa3c3"
    end

    it "works with RGBAImage" do
      image = rgba_sample
      blurred_image = image.vertical_blur(10)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest blurred_image, "d50bbaba05b5a42ccd1b3c8e14092b10075b07e9"
    end

    it "doesn't cause arithmetic overload" do
      with_sample("problem_images/28_arithmetic_overflow_in_blur.jpg") do |io|
        image = Pluto::RGBAImage.from_jpeg(io)
        expect_digest image.vertical_blur(10), "64039b39a57fc260bfd433d3fc298a8ac5366938"
      end
    end
  end

  describe "#vertical_blur!" do
    it "works with GrayscaleImage" do
      image = grayscale_sample
      image.vertical_blur!(10)

      expect_digest image, "45b4a49232674ed4e33c06e09c19ba22e0baa3c3"
    end

    it "works with RGBAImage" do
      image = rgba_sample
      image.vertical_blur!(10)

      expect_digest image, "d50bbaba05b5a42ccd1b3c8e14092b10075b07e9"
    end
  end
end
