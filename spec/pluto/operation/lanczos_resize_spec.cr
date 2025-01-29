require "../../spec_helper"

describe Pluto::Operation::LanczosResize do
  describe "#lanczos_resize" do
    it "works with ImageGA" do
      image = ga_sample
      downsized_image = image.lanczos_resize(480, 360)
      upsized_image = image.lanczos_resize(800, 600)

      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"
      expect_digest downsized_image, "4bf6ffe9b120933b7286e3a0531fc13a0ff60d6c"
      expect_digest upsized_image, "fb736760e9948a69bc732ad16de62552ad5ff1d3"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      downsized_image = image.lanczos_resize(480, 360)
      upsized_image = image.lanczos_resize(800, 600)

      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      expect_digest downsized_image, "37ba532cf7741899a3557b5cc259d1956a960694"
      expect_digest upsized_image, "e80e6fdc2f1b9b096cf62bc74e7d75feacac4823"
    end
  end

  describe "#lanczos_resize!" do
    it "works with ImageGA" do
      image = ga_sample
      image.lanczos_resize!(480, 360)
      expect_digest image, "4bf6ffe9b120933b7286e3a0531fc13a0ff60d6c"

      image = ga_sample
      image.lanczos_resize!(800, 600)
      expect_digest image, "fb736760e9948a69bc732ad16de62552ad5ff1d3"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.lanczos_resize!(480, 360)
      expect_digest image, "37ba532cf7741899a3557b5cc259d1956a960694"

      image = rgba_sample
      image.lanczos_resize!(800, 600)
      expect_digest image, "e80e6fdc2f1b9b096cf62bc74e7d75feacac4823"
    end
  end
end
