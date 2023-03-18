require "../../spec_helper"

describe Pluto::Operation::BoxBlur do
  describe "#box_blur" do
    it "works with ImageGA" do
      image = grayscale_sample
      blurred_image = image.box_blur(10)

      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest blurred_image, "dc18cddfd3486fa33dae3af028a9da3274facc3e"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      blurred_image = image.box_blur(10)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest blurred_image, "df1710255ae9dbd5a86832546cfb6a23b558c9bb"
    end
  end

  describe "#box_blur!" do
    it "works with ImageGA" do
      image = grayscale_sample
      image.box_blur!(10)

      expect_digest image, "dc18cddfd3486fa33dae3af028a9da3274facc3e"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.box_blur!(10)

      expect_digest image, "df1710255ae9dbd5a86832546cfb6a23b558c9bb"
    end
  end
end
