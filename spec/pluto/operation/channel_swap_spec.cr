require "../../spec_helper"

describe Pluto::Operation::ChannelSwap do
  describe "#channel_swap" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("california.ppm")

      original_image = Pluto::RGBAImage.from_ppm(data)
      bgr_image = original_image.channel_swap(:red, :blue)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "af8e3295128d5d056330b50c45f1ca63f71a4f4a"
      Digest::SHA1.hexdigest(bgr_image.to_ppm).should eq "9d857319f960a9b4798d3d62d270baae61278f70"
    end

    it "works with GreyscaleImage" do
      data = SpecHelper.read_sample("california.ppm")

      original_image = Pluto::GreyscaleImage.from_ppm(data)
      expect_raises(Exception, /Unknown channel type Red for GreyscaleImage/) do
        original_image.channel_swap(:red, :blue)
      end
    end
  end

  describe "#channel_swap!" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("california.ppm")

      image = Pluto::RGBAImage.from_ppm(data)
      image.channel_swap!(:red, :blue)

      Digest::SHA1.hexdigest(image.to_ppm).should eq "9d857319f960a9b4798d3d62d270baae61278f70"
    end
  end
end
