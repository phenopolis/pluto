require "../../spec_helper"

describe Pluto::Operation::ChannelSwap do
  describe "#channel_swap" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::RGBAImage.from_ppm(data)
      bgr_image = original_image.channel_swap(:red, :blue)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      Digest::SHA1.hexdigest(bgr_image.to_ppm).should eq "1ae680c7e12077eb596ab12ec4328e3e78afb054"
    end

    it "works with GrayscaleImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::GrayscaleImage.from_ppm(data)
      expect_raises(Exception, /Unknown channel type Red for GrayscaleImage/) do
        original_image.channel_swap(:red, :blue)
      end
    end
  end

  describe "#channel_swap!" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::RGBAImage.from_ppm(data)
      image.channel_swap!(:red, :blue)

      Digest::SHA1.hexdigest(image.to_ppm).should eq "1ae680c7e12077eb596ab12ec4328e3e78afb054"
    end
  end
end
