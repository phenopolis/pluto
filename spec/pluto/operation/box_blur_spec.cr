require "../../spec_helper"

describe Pluto::Operation::BoxBlur do
  describe "#box_blur" do
    it "works with ImageGA" do
      image = grayscale_sample
      blurred_image = image.box_blur(10)

      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest blurred_image, "2a14473b3004d51de5c63397a4e4089bc2a3bf67"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      blurred_image = image.box_blur(10)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest blurred_image, "69360969157745b7fb63cf07ccbef3dd91e25f62"
    end
  end

  describe "#box_blur!" do
    it "works with ImageGA" do
      image = grayscale_sample
      image.box_blur!(10)

      expect_digest image, "2a14473b3004d51de5c63397a4e4089bc2a3bf67"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.box_blur!(10)

      expect_digest image, "69360969157745b7fb63cf07ccbef3dd91e25f62"
    end
  end
end
