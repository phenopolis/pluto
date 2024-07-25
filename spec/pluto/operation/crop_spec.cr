require "../../spec_helper"

describe Pluto::Operation::Crop do
  describe "#crop" do
    it "checks image width boundaries" do
      image = ga_sample

      expect_raises(Pluto::Exception, "Crop dimensions extend 1 pixels beyond width of the image (640)") do
        image.crop(0, 0, image.width + 1, image.height)
      end
    end

    it "checks image height boundaries" do
      image = ga_sample

      expect_raises(Pluto::Exception, "Crop dimensions extend 1 pixels beyond height of the image (480)") do
        image.crop(0, 0, image.width, image.height + 1)
      end
    end

    it "works with ImageGA" do
      image = ga_sample
      whole_image = image.crop(0, 0, image.width, image.height)
      cropped_image = image.crop(200, 200, 100, 100)

      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"
      expect_digest whole_image, "91fd39e895dac79f13501d32efbb6301c3558462"
      expect_digest cropped_image, "3d4506051ef8676ec269e2f4567e00c521a531f9"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      whole_image = image.crop(0, 0, image.width, image.height)
      cropped_image = image.crop(200, 200, 100, 100)

      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      expect_digest whole_image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      expect_digest cropped_image, "d460916b5b023a2a7f4957f3dbf08d32f4ada941"
    end
  end

  describe "#crop!" do
    it "works with ImageGA" do
      image = ga_sample
      image.crop!(0, 0, image.width, image.height)
      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"

      image = ga_sample
      image.crop!(200, 200, 100, 100)
      expect_digest image, "3d4506051ef8676ec269e2f4567e00c521a531f9"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.crop!(0, 0, image.width, image.height)
      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"

      image = rgba_sample
      image.crop!(200, 200, 100, 100)
      expect_digest image, "d460916b5b023a2a7f4957f3dbf08d32f4ada941"
    end
  end
end
