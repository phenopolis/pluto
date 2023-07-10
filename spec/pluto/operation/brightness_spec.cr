require "../../spec_helper"

describe Pluto::Operation::Brightness do
  describe "#brightness" do
    it "works with ImageGA" do
      image = ga_sample
      brightened_image = image.brightness(1.4)
      darkened_image = image.brightness(0.6)

      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"
      expect_digest brightened_image, "4dbf387343f62918983b6b254eba086066320eb4"
      expect_digest darkened_image, "60791a4949583fa56304175e0d2bf0d643d11e8f"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      brightened_image = image.brightness(1.4)
      darkened_image = image.brightness(0.6)

      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      expect_digest brightened_image, "27c0f8ddf392e55691dba9e74bdd174e9a84373a"
      expect_digest darkened_image, "0f84f1c0b8ca27642f244ca1c9ea316737216d61"
    end
  end

  describe "#brightness!" do
    it "works with ImageGA" do
      image = ga_sample
      image.brightness!(1.4)
      expect_digest image, "4dbf387343f62918983b6b254eba086066320eb4"

      image = ga_sample
      image.brightness!(0.6)
      expect_digest image, "60791a4949583fa56304175e0d2bf0d643d11e8f"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.brightness!(1.4)
      expect_digest image, "27c0f8ddf392e55691dba9e74bdd174e9a84373a"

      image = rgba_sample
      image.brightness!(0.6)
      expect_digest image, "0f84f1c0b8ca27642f244ca1c9ea316737216d61"
    end
  end
end
