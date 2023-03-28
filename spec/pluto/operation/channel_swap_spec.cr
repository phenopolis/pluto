require "../../spec_helper"

describe Pluto::Operation::ChannelSwap do
  describe "#channel_swap" do
    it "works with ImageGA" do
      image = ga_sample
      ag_image = image.channel_swap(:gray, :alpha)

      expect_digest image, "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      expect_digest ag_image, "660145a96da80f41330c161df87de83945230a35"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      bgra_image = image.channel_swap(:red, :blue)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest bgra_image, "1ae680c7e12077eb596ab12ec4328e3e78afb054"
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

      expect_digest image, "1ae680c7e12077eb596ab12ec4328e3e78afb054"
    end
  end
end
