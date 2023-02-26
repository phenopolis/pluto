require "../../spec_helper"

describe Pluto::Operation::MaskApply do
  describe "#apply" do
    describe "with Grayscale" do
      it "changes nothing when initialized as all true" do
        image = Pluto::GrayscaleImage.from_ppm(SpecHelper.read_sample("pluto.ppm"))
        mask = Pluto::Mask.new(image)
        Digest::SHA1.hexdigest(image.apply(mask).to_ppm).should eq "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      end

      it "blacks out half the image" do
        image = Pluto::GrayscaleImage.from_ppm(SpecHelper.read_sample("pluto.ppm"))
        mask = Pluto::Mask.new(image)
        mask[0..(image.width//2), 0..] = false
        Digest::SHA1.hexdigest(image.apply(mask).to_ppm).should eq "4013960c0180c5d7a1741c13456055853bf54416"
      end

      it "applies threshold" do
        image = Pluto::GrayscaleImage.from_ppm(SpecHelper.read_sample("pluto.ppm"))
        Digest::SHA1.hexdigest(image.apply(image.threshold(16)).to_ppm).should eq "2e0b4f156fa6978b7c7bf024068a58cb8d13d82b"
      end

      it "applies threshold through mask" do
        image = Pluto::GrayscaleImage.from_ppm(SpecHelper.read_sample("pluto.ppm"))
        Digest::SHA1.hexdigest(image.threshold(16).apply(image).to_ppm).should eq "2e0b4f156fa6978b7c7bf024068a58cb8d13d82b"
      end
    end

    describe "with RGBAImage" do
      it "changes nothing when initialized as all true" do
        image = Pluto::RGBAImage.from_ppm(SpecHelper.read_sample("pluto.ppm"))
        mask = Pluto::Mask.new(image)
        Digest::SHA1.hexdigest(image.apply(mask).to_ppm).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      end

      it "blacks out half the image" do
        image = Pluto::RGBAImage.from_ppm(SpecHelper.read_sample("pluto.ppm"))
        mask = Pluto::Mask.new(image)
        mask[0..(image.width//2), 0..] = false
        Digest::SHA1.hexdigest(image.apply(mask).to_ppm).should eq "d60dbccb569875392fa91054463e4de30e661e7b"
      end

      it "applies threshold" do
        image = Pluto::RGBAImage.from_ppm(SpecHelper.read_sample("pluto.ppm"))
        Digest::SHA1.hexdigest(image.apply(image.to_gray.threshold(16)).to_ppm).should eq "62409fe550b1d7d87757fbf7c9612514cae72acd"
      end

      it "applies threshold through mask" do
        image = Pluto::RGBAImage.from_ppm(SpecHelper.read_sample("pluto.ppm"))
        Digest::SHA1.hexdigest(image.to_gray.threshold(16).apply(image).to_ppm).should eq "62409fe550b1d7d87757fbf7c9612514cae72acd"
      end
    end
  end

  it "draws a blue pluto" do
    image = Pluto::RGBAImage.from_ppm(SpecHelper.read_sample("pluto.ppm"))
    Digest::SHA1.hexdigest(
      image
        .to_gray
        .threshold(16)
        .apply(image) do |_, _, _, channel_type|
          channel_type == Pluto::ChannelType::Blue ? 255u8 : 0u8
        end
        .to_ppm
    ).should eq "a72ff68332ecffec70d1766114ed5202e944488f"
  end
end
