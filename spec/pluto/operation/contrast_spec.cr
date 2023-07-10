require "../../spec_helper"

describe Pluto::Operation::Contrast do
  describe "#contrast" do
    it "works with ImageGA" do
      image = ga_sample
      positive_image = image.contrast(128)
      negative_image = image.contrast(-128)

      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"
      expect_digest positive_image, "cb808af0f18177345e8315118e28ebc4a45f3dc9"
      expect_digest negative_image, "d9dc489f940cd57ad2dc5f44667af8504cb7e000"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      positive_image = image.contrast(128)
      negative_image = image.contrast(-128)

      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      expect_digest positive_image, "98d23f0e0f02cafed7f79e66b49ea2e62517c3f5"
      expect_digest negative_image, "93fbd42c7a37627e9a3e1914d3ad8dab8e8dd7d0"
    end
  end

  describe "#contrast!" do
    it "works with ImageGA" do
      image = ga_sample
      image.contrast!(128)
      expect_digest image, "cb808af0f18177345e8315118e28ebc4a45f3dc9"

      image = ga_sample
      image.contrast!(-128)
      expect_digest image, "d9dc489f940cd57ad2dc5f44667af8504cb7e000"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.contrast!(128)
      expect_digest image, "98d23f0e0f02cafed7f79e66b49ea2e62517c3f5"

      image = rgba_sample
      image.contrast!(-128)
      expect_digest image, "93fbd42c7a37627e9a3e1914d3ad8dab8e8dd7d0"
    end
  end
end
