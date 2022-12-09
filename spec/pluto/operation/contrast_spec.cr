require "../../spec_helper"

describe Pluto::Operation::Contrast do
  describe "#contrast" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::Image.from_ppm(data)
      positive_image = original_image.contrast(128)
      negative_image = original_image.contrast(-128)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      Digest::SHA1.hexdigest(positive_image.to_ppm).should eq "d773339697e9c3ed2ea188ecc1adbbe73dbc1ba5"
      Digest::SHA1.hexdigest(negative_image.to_ppm).should eq "c2269bee571172cf97377547e5e9de9b91e552c5"
    end
  end

  describe "#contrast!" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::Image.from_ppm(data)
      image.contrast!(128)
      Digest::SHA1.hexdigest(image.to_ppm).should eq "d773339697e9c3ed2ea188ecc1adbbe73dbc1ba5"

      image = Pluto::Image.from_ppm(data)
      image.contrast!(-128)
      Digest::SHA1.hexdigest(image.to_ppm).should eq "c2269bee571172cf97377547e5e9de9b91e552c5"
    end
  end
end
