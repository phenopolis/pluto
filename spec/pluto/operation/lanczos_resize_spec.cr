require "../../spec_helper"

describe Pluto::Operation::LanczosResize do
  describe "#lanczos_resize" do
    it "works with ImageGA" do
      image = ga_sample
      downsized_image = image.lanczos_resize(480, 360)
      upsized_image = image.lanczos_resize(800, 600)

      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"
      expect_digest downsized_image, "632fa536d3e67c7246fdc01464ad2885cb75db02"
      expect_digest upsized_image, "050cbc8311c2bd5fc743eddf9c8e853dc4da48d5"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      downsized_image = image.lanczos_resize(480, 360)
      upsized_image = image.lanczos_resize(800, 600)

      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      expect_digest downsized_image, "d74d1ca3e015022523b668b6a43861b17f074cdb"
      expect_digest upsized_image, "e3142be22f65829647fe85f1cf699d4bf0675310"
    end
  end

  describe "#lanczos_resize!" do
    it "works with ImageGA" do
      image = ga_sample
      image.lanczos_resize!(480, 360)
      expect_digest image, "632fa536d3e67c7246fdc01464ad2885cb75db02"

      image = ga_sample
      image.lanczos_resize!(800, 600)
      expect_digest image, "050cbc8311c2bd5fc743eddf9c8e853dc4da48d5"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.lanczos_resize!(480, 360)
      expect_digest image, "d74d1ca3e015022523b668b6a43861b17f074cdb"

      image = rgba_sample
      image.lanczos_resize!(800, 600)
      expect_digest image, "e3142be22f65829647fe85f1cf699d4bf0675310"
    end
  end
end
