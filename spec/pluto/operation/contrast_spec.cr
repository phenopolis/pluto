require "../../spec_helper"

describe Pluto::Operation::Contrast do
  describe "#contrast" do
    it "works with ImageGA" do
      image = grayscale_sample
      positive_image = image.contrast(128)
      negative_image = image.contrast(-128)

      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest positive_image, "5aa2004129f7267c851b8055cdd93da205ab7483"
      expect_digest negative_image, "9f6321f4b1387dd03b47a266a32905615e652e26"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      positive_image = image.contrast(128)
      negative_image = image.contrast(-128)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest positive_image, "d773339697e9c3ed2ea188ecc1adbbe73dbc1ba5"
      expect_digest negative_image, "c2269bee571172cf97377547e5e9de9b91e552c5"
    end
  end

  describe "#contrast!" do
    it "works with ImageGA" do
      image = grayscale_sample
      image.contrast!(128)
      expect_digest image, "5aa2004129f7267c851b8055cdd93da205ab7483"

      image = grayscale_sample
      image.contrast!(-128)
      expect_digest image, "9f6321f4b1387dd03b47a266a32905615e652e26"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.contrast!(128)
      expect_digest image, "d773339697e9c3ed2ea188ecc1adbbe73dbc1ba5"

      image = rgba_sample
      image.contrast!(-128)
      expect_digest image, "c2269bee571172cf97377547e5e9de9b91e552c5"
    end
  end
end
