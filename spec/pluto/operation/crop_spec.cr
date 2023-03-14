require "../../spec_helper"

describe Pluto::Operation::Crop do
  describe "#crop" do
    it "checks image width boundaries" do
      image = grayscale_sample

      expect_raises(Exception, "Crop dimensions extend 1 pixels beyond width of the image (640)") do
        image.crop(0, 0, image.width + 1, image.height)
      end
    end

    it "checks image height boundaries" do
      image = grayscale_sample

      expect_raises(Exception, "Crop dimensions extend 1 pixels beyond height of the image (480)") do
        image.crop(0, 0, image.width, image.height + 1)
      end
    end

    it "works with ImageGA" do
      image = grayscale_sample
      whole_image = image.crop(0, 0, image.width, image.height)
      cropped_image = image.crop(200, 200, 100, 100)

      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest whole_image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest cropped_image, "42c223c282a5ca6419683e98216908520838b717"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      whole_image = image.crop(0, 0, image.width, image.height)
      cropped_image = image.crop(200, 200, 100, 100)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest whole_image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest cropped_image, "d02012cf3aae614ef06f1dbbf4aa8952905b259b"
    end
  end

  describe "#crop!" do
    it "works with ImageGA" do
      image = grayscale_sample
      image.crop!(0, 0, image.width, image.height)
      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"

      image = grayscale_sample
      image.crop!(200, 200, 100, 100)
      expect_digest image, "42c223c282a5ca6419683e98216908520838b717"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.crop!(0, 0, image.width, image.height)
      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"

      image = rgba_sample
      image.crop!(200, 200, 100, 100)
      expect_digest image, "d02012cf3aae614ef06f1dbbf4aa8952905b259b"
    end
  end
end
