require "../../spec_helper"

describe Pluto::Operation::BoxBlur do
  describe "#box_blur" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::Image.from_ppm(data)
      blurred_image = original_image.box_blur(10)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      Digest::SHA1.hexdigest(blurred_image.to_ppm).should eq "df1710255ae9dbd5a86832546cfb6a23b558c9bb"
    end
  end

  describe "#box_blur!" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::Image.from_ppm(data)
      image.box_blur!(10)

      Digest::SHA1.hexdigest(image.to_ppm).should eq "df1710255ae9dbd5a86832546cfb6a23b558c9bb"
    end
  end
end
