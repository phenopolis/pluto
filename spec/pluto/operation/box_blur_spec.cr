require "../../spec_helper"

describe Pluto::Operation::BoxBlur do
  describe "#box_blur" do
    it "works with ImageGA" do
      image = ga_sample
      blurred_image = image.box_blur(10)

      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"
      expect_digest blurred_image, "0a24ab38c29ea444e78154d4bd483efde67c69ff"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      blurred_image = image.box_blur(10)

      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      expect_digest blurred_image, "9cd95160cd69ada96ddb0f37fd08cbbf02a968a0"
    end
  end

  describe "#box_blur!" do
    it "works with ImageGA" do
      image = ga_sample
      image.box_blur!(10)

      expect_digest image, "0a24ab38c29ea444e78154d4bd483efde67c69ff"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.box_blur!(10)

      expect_digest image, "9cd95160cd69ada96ddb0f37fd08cbbf02a968a0"
    end
  end
end
