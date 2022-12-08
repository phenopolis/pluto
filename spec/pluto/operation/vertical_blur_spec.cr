require "../../spec_helper"

describe Pluto::Operation::VerticalBlur do
  describe "#vertical_blur" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")

      original_image = Pluto::Image.from_ppm(data)
      blurred_image = original_image.vertical_blur(10)

      Digest::SHA1.hexdigest(original_image.to_ppm).should eq "d7fa6faf6eec5350f8de8b41f478bf7e8d217fa9"
      Digest::SHA1.hexdigest(blurred_image.to_ppm).should eq "d7116d6cea0a14e23cc3a23dbc86ad8bf1fecf2f"
    end
  end

  describe "#vertical_blur!" do
    it "works" do
      data = SpecHelper.read_sample("pluto.ppm")

      image = Pluto::Image.from_ppm(data)
      image.vertical_blur!(10)

      Digest::SHA1.hexdigest(image.to_ppm).should eq "d7116d6cea0a14e23cc3a23dbc86ad8bf1fecf2f"
    end
  end
end
