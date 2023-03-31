require "../../spec_helper"

describe Pluto::Operation::VerticalBlur do
  describe "#vertical_blur" do
    it "works with ImageGA" do
      image = ga_sample
      blurred_image = image.vertical_blur(10)

      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest blurred_image, "38d71a5c13f46afdca6b13ecbdeb97327cd46dd7"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      blurred_image = image.vertical_blur(10)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest blurred_image, "d7116d6cea0a14e23cc3a23dbc86ad8bf1fecf2f"
    end

    it "doesn't cause arithmetic overload" do
      with_sample("problem_images/28_arithmetic_overflow_in_blur.jpeg") do |io|
        image = Pluto::ImageRGBA.from_jpeg(io)
        expect_digest image.vertical_blur(10), "fd483aa927fb2ca8fdeb714e82dbbd3bf173daba"
      end
    end
  end

  describe "#vertical_blur!" do
    it "works with ImageGA" do
      image = ga_sample
      image.vertical_blur!(10)

      expect_digest image, "38d71a5c13f46afdca6b13ecbdeb97327cd46dd7"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.vertical_blur!(10)

      expect_digest image, "d7116d6cea0a14e23cc3a23dbc86ad8bf1fecf2f"
    end
  end
end
