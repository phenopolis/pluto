require "../../spec_helper"

describe Pluto::Operation::MaskApply do
  describe "#apply" do
    it "works with GrayscaleImage" do
      image = Pluto::GrayscaleImage.from_ppm(SpecHelper.read_sample("pluto.ppm"))
      mask = Pluto::Mask.new(image.width, image.height)
      Digest::SHA1.hexdigest(image.apply(mask).to_ppm).should eq "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
    end

    it "blacks out half the image" do
      image = Pluto::GrayscaleImage.from_ppm(SpecHelper.read_sample("pluto.ppm"))
      mask = Pluto::Mask.new(image.width, image.height)
      mask[0..(image.width//2), 0..] = false
      Digest::SHA1.hexdigest(image.apply(mask).to_ppm).should eq "4013960c0180c5d7a1741c13456055853bf54416"
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
