require "../../spec_helper"

describe Pluto::Operation::Brightness do
  describe "#brightness" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::RGBAImage.from_ppm(data)
      brightened_image = original_image.brightness(1.4)
      darkened_image = original_image.brightness(0.6)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      Digest::SHA1.hexdigest(brightened_image.to_ppm).should eq "e276fd23c577bf986b0e75c3f8e43cc936307450"
      Digest::SHA1.hexdigest(darkened_image.to_ppm).should eq "f84f1a69db111484616cb1b9bd58e92a608c50e7"
    end

    it "works with GreyscaleImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::GreyscaleImage.from_ppm(data)
      brightened_image = original_image.brightness(1.4)
      darkened_image = original_image.brightness(0.6)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      Digest::SHA1.hexdigest(brightened_image.to_ppm).should eq "16e5ec301a72d75ea53c62c8f7b66b0b583455e4"
      Digest::SHA1.hexdigest(darkened_image.to_ppm).should eq "c3d8d9c5c221ae0672f92def1ccdc8d0aea13d5d"
    end
  end

  describe "#brightness!" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::RGBAImage.from_ppm(data)
      image.brightness!(1.4)
      Digest::SHA1.hexdigest(image.to_ppm).should eq "e276fd23c577bf986b0e75c3f8e43cc936307450"

      image = Pluto::RGBAImage.from_ppm(data)
      image.brightness!(0.6)
      Digest::SHA1.hexdigest(image.to_ppm).should eq "f84f1a69db111484616cb1b9bd58e92a608c50e7"
    end

    it "works with GreyscaleImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::GreyscaleImage.from_ppm(data)
      image.brightness!(1.4)
      Digest::SHA1.hexdigest(image.to_ppm).should eq "16e5ec301a72d75ea53c62c8f7b66b0b583455e4"

      image = Pluto::GreyscaleImage.from_ppm(data)
      image.brightness!(0.6)
      Digest::SHA1.hexdigest(image.to_ppm).should eq "c3d8d9c5c221ae0672f92def1ccdc8d0aea13d5d"
    end
  end
end
