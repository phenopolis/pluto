require "../../spec_helper"

describe Pluto::Operation::ChannelSwap do
  describe "#channel_swap" do
    it "works with GrayscaleImage" do
      image = grayscale_sample

      expect_raises(Exception, /Unknown channel type Red for GrayscaleImage/) do
        image.channel_swap(:red, :blue)
      end
    end

    it "works with RGBAImage" do
      image = rgba_sample
      bgra_image = image.channel_swap(:red, :blue)

      expect_digest image, "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      expect_digest bgra_image, "1ae680c7e12077eb596ab12ec4328e3e78afb054"
    end
  end

  describe "#channel_swap!" do
    it "works with GrayscaleImage" do
      image = grayscale_sample

      expect_raises(Exception, /Unknown channel type Red for GrayscaleImage/) do
        image.channel_swap!(:red, :blue)
      end
    end

    it "works with RGBAImage" do
      image = rgba_sample
      image.channel_swap!(:red, :blue)

      expect_digest image, "1ae680c7e12077eb596ab12ec4328e3e78afb054"
    end
  end
end
