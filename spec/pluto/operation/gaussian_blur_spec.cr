require "../../spec_helper"

describe Pluto::Operation::GaussianBlur do
  describe "#gaussian_blur" do
    it "works with ImageGA" do
      image = ga_sample
      blurred_image = image.gaussian_blur(10)

      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"
      expect_digest blurred_image, "b85901335f1c1c78303678b6b8a0bd4b2fe0ece0"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      blurred_image = image.gaussian_blur(10)

      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      expect_digest blurred_image, "fede3d7d1c5aec5a27c904c60fe39772acbc0459"
    end
  end

  describe "#gaussian_blur!" do
    it "works with ImageGA" do
      image = ga_sample
      image.gaussian_blur!(10)

      expect_digest image, "b85901335f1c1c78303678b6b8a0bd4b2fe0ece0"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.gaussian_blur!(10)

      expect_digest image, "fede3d7d1c5aec5a27c904c60fe39772acbc0459"
    end
  end
end
