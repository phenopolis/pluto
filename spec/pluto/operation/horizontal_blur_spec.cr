require "../../spec_helper"

describe Pluto::Operation::HorizontalBlur do
  describe "#horizontal_blur" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::Image.from_ppm(data)
      blurred_image = original_image.horizontal_blur(10)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      Digest::SHA1.hexdigest(blurred_image.to_ppm).should eq "625be82cf07186fde56a81059c8149bc192bb1c9"
    end
  end

  describe "#horizontal_blur!" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::Image.from_ppm(data)
      image.horizontal_blur!(10)

      Digest::SHA1.hexdigest(image.to_ppm).should eq "625be82cf07186fde56a81059c8149bc192bb1c9"
    end
  end
end
