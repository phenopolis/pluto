require "../../spec_helper"

describe Pluto::Format::WebP do
  describe ".from_webp and #to_webp" do
    it "works with ImageGA" do
      with_sample("desert.webp") do |io|
        image = Pluto::ImageGA.from_webp(io)
        lossless_io = IO::Memory.new
        lossy_io = IO::Memory.new
        image.to_lossless_webp(lossless_io)
        image.to_lossy_webp(lossy_io)

        digest(lossless_io.to_s).should eq "018030901b3e8863ca981ec1bc590a1bbdb100d5"
        digest(lossy_io.to_s).should eq "60e700116a58001376df705a3b2f3cda7b7ed366"
      end
    end

    it "works with ImageRGBA" do
      with_sample("desert.webp") do |io|
        image = Pluto::ImageRGBA.from_webp(io)
        lossless_io = IO::Memory.new
        lossy_io = IO::Memory.new
        image.to_lossless_webp(lossless_io)
        image.to_lossy_webp(lossy_io)

        digest(lossless_io.to_s).should eq "e30cdbc531e2161506488e5a2251d73ea2b2f764"
        digest(lossy_io.to_s).should eq "86e8bb2400ae93950c45650e0d2f8635f1ce93be"
      end
    end
  end
end
