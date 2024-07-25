require "../../spec_helper"

describe Pluto::Operation::Rotation do
  describe "#rotation" do
    it "checks padding and radius" do
      image = ga_sample

      expect_raises(Pluto::Exception, "Can't pad image and limit rotation by radius") do
        image.rotation(0, padding: true, radius: 1)
      end
    end

    it "works with ImageGA" do
      image = ga_sample
      rotated = image.rotation(45)
      rotated_pad = image.rotation(45, padding: true)
      rotated_pad_repeat = image.rotation(45, padding: true, padding_type: Pluto::PaddingType::Repeat)
      rotated_off_center = image.rotation(45, center_x: 100, center_y: 100)

      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"
      expect_digest rotated, "6b78ea150f64b2daa041ca3d1b5b15e452a1256e"
      expect_digest rotated_pad, "38599000bcaae5157bdce099a4271cfc0c281d2a"
      expect_digest rotated_pad_repeat, "685a9680a331cd47392b7b770ce31b63a654b3f9"
      expect_digest rotated_off_center, "92539f71b01a3f68544539be7ec99b913f8c1010"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      rotated = image.rotation(45)
      rotated_pad = image.rotation(45, padding: true)
      rotated_pad_repeat = image.rotation(45, padding: true, padding_type: Pluto::PaddingType::Repeat)
      rotated_off_center = image.rotation(45, center_x: 100, center_y: 100)

      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      expect_digest rotated, "061a9d70f2f5e3a2f431d68800c5f1f3f21ee2c1"
      expect_digest rotated_pad, "1d88df93b97f893ddc540506ab56f0ef7cb0723b"
      expect_digest rotated_pad_repeat, "8047ab1372b2657e36f225d37978eff2cfea2aa9"
      expect_digest rotated_off_center, "274b32e69584337dfc47c375678af7bb5c649ce1"
    end
  end

  describe "#rotation!" do
    it "works with ImageGA" do
      image = ga_sample
      image.rotation!(45)
      expect_digest image, "6b78ea150f64b2daa041ca3d1b5b15e452a1256e"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.rotation!(45)
      expect_digest image, "061a9d70f2f5e3a2f431d68800c5f1f3f21ee2c1"
    end
  end
end
