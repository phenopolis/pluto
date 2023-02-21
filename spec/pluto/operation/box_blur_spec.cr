require "../../spec_helper"

Spectator.describe Pluto::Operation::BoxBlur do
  describe "#box_blur" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::RGBAImage.from_ppm(data)
      blurred_image = original_image.box_blur(10)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      Digest::SHA1.hexdigest(blurred_image.to_ppm).should eq "df1710255ae9dbd5a86832546cfb6a23b558c9bb"
    end

    it "works with GrayscaleImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::GrayscaleImage.from_ppm(data)
      blurred_image = original_image.box_blur(10)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      Digest::SHA1.hexdigest(blurred_image.to_ppm).should eq "dc18cddfd3486fa33dae3af028a9da3274facc3e"
    end
  end

  describe "#box_blur!" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::RGBAImage.from_ppm(data)
      image.box_blur!(10)

      Digest::SHA1.hexdigest(image.to_ppm).should eq "df1710255ae9dbd5a86832546cfb6a23b558c9bb"
    end

    it "works with GrayscaleImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::GrayscaleImage.from_ppm(data)
      image.box_blur!(10)

      Digest::SHA1.hexdigest(image.to_ppm).should eq "dc18cddfd3486fa33dae3af028a9da3274facc3e"
    end
  end
end
