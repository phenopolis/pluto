require "../../spec_helper"

describe Pluto::Operation::Pad do
  describe "#pad" do
    it "works with ImageGA" do
      image = ga_sample
      image.crop!(0, 0, image.width // 2, image.height)
      black_pad = image.pad(40)
      repeat_pad = image.pad(40, pad_type: Pluto::PadType::Repeat)

      expect_digest image, "c699cce8b977af923eed0203127fbe2e14b41ae4"
      expect_digest black_pad, "eafc48c6cbd575f63473edfc0e1b86ed05659a3c"
      expect_digest repeat_pad, "73dd639141c31f964dfd854bb405f43b762897ad"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.crop!(0, 0, image.width // 2, image.height)
      black_pad = image.pad(40)
      repeat_pad = image.pad(40, pad_type: Pluto::PadType::Repeat)

      expect_digest image, "38d1076ce0918f55880fa6dd4082fd944c78bbe3"
      expect_digest black_pad, "893bd2357a99f33cb68f5ab0423fabfbd2d30b69"
      expect_digest repeat_pad, "c7edc92797d4cc743d997fae5c064a97e36ce044"
    end
  end

  describe "#pad!" do
    it "works with ImageGA" do
      image = ga_sample
      image.crop!(0, 0, image.width // 2, image.height)
      image.pad!(40)
      expect_digest image, "eafc48c6cbd575f63473edfc0e1b86ed05659a3c"

      image = ga_sample
      image.crop!(0, 0, image.width // 2, image.height)
      image.pad!(40, pad_type: Pluto::PadType::Repeat)
      expect_digest image, "73dd639141c31f964dfd854bb405f43b762897ad"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.crop!(0, 0, image.width // 2, image.height)
      image.pad!(40)
      expect_digest image, "893bd2357a99f33cb68f5ab0423fabfbd2d30b69"

      image = rgba_sample
      image.crop!(0, 0, image.width // 2, image.height)
      image.pad!(40, pad_type: Pluto::PadType::Repeat)
      expect_digest image, "c7edc92797d4cc743d997fae5c064a97e36ce044"
    end
  end
end
