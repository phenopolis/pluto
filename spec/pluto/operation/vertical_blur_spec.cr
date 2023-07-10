require "../../spec_helper"

describe Pluto::Operation::VerticalBlur do
  describe "#vertical_blur" do
    it "works with ImageGA" do
      image = ga_sample
      blurred_image = image.vertical_blur(10)

      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"
      expect_digest blurred_image, "d03c020dd139648563ac726ad62f4773b007e250"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      blurred_image = image.vertical_blur(10)

      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      expect_digest blurred_image, "5021f57e61fc64143d3c4dcb6ddeb67cd3304b8f"
    end

    it "doesn't cause arithmetic overload" do
      with_sample("problem_images/28_arithmetic_overflow_in_blur.jpeg") do |io|
        image = Pluto::ImageRGBA.from_jpeg(io)
        expect_digest image.vertical_blur(10), "00e2c8a20e4554242bca3e0acf841028a2922fe6"
      end
    end
  end

  describe "#vertical_blur!" do
    it "works with ImageGA" do
      image = ga_sample
      image.vertical_blur!(10)

      expect_digest image, "d03c020dd139648563ac726ad62f4773b007e250"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.vertical_blur!(10)

      expect_digest image, "5021f57e61fc64143d3c4dcb6ddeb67cd3304b8f"
    end
  end
end
