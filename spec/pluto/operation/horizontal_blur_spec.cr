require "../../spec_helper"

describe Pluto::Operation::HorizontalBlur do
  describe "#horizontal_blur" do
    it "works with ImageGA" do
      image = ga_sample
      blurred_image = image.horizontal_blur(10)

      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"
      expect_digest blurred_image, "494db94155c1beabd28fb936079452be7bd70200"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      blurred_image = image.horizontal_blur(10)

      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      expect_digest blurred_image, "e79d6940c0de729acf40647629fb1e22cda78a3d"
    end

    it "doesn't cause arithmetic overload" do
      with_sample("problematic_images/28_arithmetic_overflow_in_blur.jpeg") do |io|
        image = Pluto::ImageRGBA.from_jpeg(io)
        expect_digest image.horizontal_blur(10), "d1e2b9363a2e7a36e738599cda8dab844a828b15"
      end
    end

    it "doesn't cause arithmetic overload again" do
      with_sample("problematic_images/46_arithmetic_overflow_in_blur_again.jpeg") do |io|
        image = Pluto::ImageRGBA.from_jpeg(io)
        expect_digest image.horizontal_blur(5), "a6ce6aeb78bc3cc6cff8e39f932b3e778b127950"
      end
    end
  end

  describe "#horizontal_blur!" do
    it "works with ImageGA" do
      image = ga_sample
      image.horizontal_blur!(10)

      expect_digest image, "494db94155c1beabd28fb936079452be7bd70200"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.horizontal_blur!(10)

      expect_digest image, "e79d6940c0de729acf40647629fb1e22cda78a3d"
    end
  end
end
