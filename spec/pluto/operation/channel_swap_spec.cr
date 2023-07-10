require "../../spec_helper"

describe Pluto::Operation::ChannelSwap do
  describe "#channel_swap" do
    it "works with ImageGA" do
      image = ga_sample
      ag_image = image.channel_swap(:gray, :alpha)

      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"
      expect_digest ag_image, "660145a96da80f41330c161df87de83945230a35"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      bgra_image = image.channel_swap(:red, :blue)

      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      expect_digest bgra_image, "4a5f44a8474e5d0996ac3260287f7b96d702e358"
    end
  end

  describe "#channel_swap!" do
    it "works with ImageGA" do
      image = ga_sample
      image.channel_swap!(:gray, :alpha)

      expect_digest image, "660145a96da80f41330c161df87de83945230a35"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.channel_swap!(:red, :blue)

      expect_digest image, "4a5f44a8474e5d0996ac3260287f7b96d702e358"
    end
  end
end
