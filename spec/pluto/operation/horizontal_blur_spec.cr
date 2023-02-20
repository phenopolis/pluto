require "../../spec_helper"

describe Pluto::Operation::HorizontalBlur do
  describe "#horizontal_blur" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::RGBAImage.from_ppm(data)
      blurred_image = original_image.horizontal_blur(10)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      Digest::SHA1.hexdigest(blurred_image.to_ppm).should eq "625be82cf07186fde56a81059c8149bc192bb1c9"
    end

    it "works with GreyscaleImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::GreyscaleImage.from_ppm(data)
      blurred_image = original_image.horizontal_blur(10)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "1a4d4e43e17f3245cefe5dd2c002fb85de079ae8"
      Digest::SHA1.hexdigest(blurred_image.to_ppm).should eq "b04348fe463d35197cc57b0114596d9b78a20f55"
    end
  end

  describe "#horizontal_blur!" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::RGBAImage.from_ppm(data)
      image.horizontal_blur!(10)

      Digest::SHA1.hexdigest(image.to_ppm).should eq "625be82cf07186fde56a81059c8149bc192bb1c9"
    end

    it "works with GreyscaleImage" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::GreyscaleImage.from_ppm(data)
      image.horizontal_blur!(10)

      Digest::SHA1.hexdigest(image.to_ppm).should eq "b04348fe463d35197cc57b0114596d9b78a20f55"
    end
  end
end
