require "../../spec_helper"

describe Pluto::Operation::Brightness do
  describe "#brightness" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::RGBImage.from_ppm(data)
      brightened_image = original_image.brightness(1.4)
      darkened_image = original_image.brightness(0.6)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      Digest::SHA1.hexdigest(brightened_image.to_ppm).should eq "e276fd23c577bf986b0e75c3f8e43cc936307450"
      Digest::SHA1.hexdigest(darkened_image.to_ppm).should eq "f84f1a69db111484616cb1b9bd58e92a608c50e7"
    end
  end

  describe "#brightness!" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::RGBImage.from_ppm(data)
      image.brightness!(1.4)
      Digest::SHA1.hexdigest(image.to_ppm).should eq "e276fd23c577bf986b0e75c3f8e43cc936307450"

      image = Pluto::RGBImage.from_ppm(data)
      image.brightness!(0.6)
      Digest::SHA1.hexdigest(image.to_ppm).should eq "f84f1a69db111484616cb1b9bd58e92a608c50e7"
    end
  end
end
