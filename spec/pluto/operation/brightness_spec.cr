require "../../spec_helper"

describe Pluto::Operation::Brightness do
  describe "#brightness" do
    it "works with ImageGA" do
      image = ga_sample
      brightened_image = image.brightness(1.4)
      darkened_image = image.brightness(0.6)

      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest brightened_image, "16e5ec301a72d75ea53c62c8f7b66b0b583455e4"
      expect_digest darkened_image, "c3d8d9c5c221ae0672f92def1ccdc8d0aea13d5d"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      brightened_image = image.brightness(1.4)
      darkened_image = image.brightness(0.6)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest brightened_image, "e276fd23c577bf986b0e75c3f8e43cc936307450"
      expect_digest darkened_image, "f84f1a69db111484616cb1b9bd58e92a608c50e7"
    end
  end

  describe "#brightness!" do
    it "works with ImageGA" do
      image = ga_sample
      image.brightness!(1.4)
      expect_digest image, "16e5ec301a72d75ea53c62c8f7b66b0b583455e4"

      image = ga_sample
      image.brightness!(0.6)
      expect_digest image, "c3d8d9c5c221ae0672f92def1ccdc8d0aea13d5d"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.brightness!(1.4)
      expect_digest image, "e276fd23c577bf986b0e75c3f8e43cc936307450"

      image = rgba_sample
      image.brightness!(0.6)
      expect_digest image, "f84f1a69db111484616cb1b9bd58e92a608c50e7"
    end
  end
end
