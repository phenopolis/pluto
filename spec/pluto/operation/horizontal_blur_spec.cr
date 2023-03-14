require "../../spec_helper"

describe Pluto::Operation::HorizontalBlur do
  describe "#horizontal_blur" do
    it "works with ImageGA" do
      image = grayscale_sample
      blurred_image = image.horizontal_blur(10)

      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest blurred_image, "7d889ea6f8e71edf06024706774b6d430977a2ab"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      blurred_image = image.horizontal_blur(10)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest blurred_image, "3441fa29b711daddecb8df015d03a3ce40312011"
    end

    it "doesn't cause arithmetic overload" do
      with_sample("problem_images/28_arithmetic_overflow_in_blur.jpg") do |io|
        image = Pluto::ImageRGBA.from_jpeg(io)
        expect_digest image.horizontal_blur(10), "20247bbe9560acdc857f59957c121d964ac09549"
      end
    end
  end

  describe "#horizontal_blur!" do
    it "works with ImageGA" do
      image = grayscale_sample
      image.horizontal_blur!(10)

      expect_digest image, "7d889ea6f8e71edf06024706774b6d430977a2ab"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.horizontal_blur!(10)

      expect_digest image, "3441fa29b711daddecb8df015d03a3ce40312011"
    end
  end
end
