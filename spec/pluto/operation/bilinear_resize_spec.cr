require "../../spec_helper"

describe Pluto::Operation::BilinearResize do
  describe "#bilinear_resize" do
    it "works with ImageGA" do
      image = ga_sample
      downsized_image = image.bilinear_resize(480, 360)
      upsized_image = image.bilinear_resize(800, 600)

      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"
      expect_digest downsized_image, "c9170d334fceaabb2872d77f8ad17a060fe6b8bb"
      expect_digest upsized_image, "e805444081aca847564403289d958f5c934d72a2"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      downsized_image = image.bilinear_resize(480, 360)
      upsized_image = image.bilinear_resize(800, 600)

      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      expect_digest downsized_image, "cbd396e1eb36f130c704e08ba241c7d306e52d68"
      expect_digest upsized_image, "feb78bd9f4ac63e53012acd351facd2882e1bf91"
    end
  end

  describe "#bilinear_resize!" do
    it "works with ImageGA" do
      image = ga_sample
      image.bilinear_resize!(480, 360)
      expect_digest image, "c9170d334fceaabb2872d77f8ad17a060fe6b8bb"

      image = ga_sample
      image.bilinear_resize!(800, 600)
      expect_digest image, "e805444081aca847564403289d958f5c934d72a2"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.bilinear_resize!(480, 360)
      expect_digest image, "cbd396e1eb36f130c704e08ba241c7d306e52d68"

      image = rgba_sample
      image.bilinear_resize!(800, 600)
      expect_digest image, "feb78bd9f4ac63e53012acd351facd2882e1bf91"
    end
  end
end
