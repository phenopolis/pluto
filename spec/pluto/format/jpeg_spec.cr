require "../../spec_helper"

describe Pluto::Format::JPEG do
  describe ".from_jpeg" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("pluto.jpg")
      image = Pluto::RGBAImage.from_jpeg(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "60b7ab88c98807171df33b9242043d1e082b9e1a"
    end

    it "works with GreyscaleImage" do
      data = SpecHelper.read_sample("pluto.jpg")
      image = Pluto::GreyscaleImage.from_jpeg(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "dc96176fe2d46790ac4f3f8efcaef666db06c4f3"
    end
  end

  describe "#to_jpeg" do
    it "works with RGBAImage" do
      data = SpecHelper.read_sample("pluto.jpg")
      image = Pluto::RGBAImage.from_jpeg(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "60b7ab88c98807171df33b9242043d1e082b9e1a"
    end

    it "works with GreyscaleImage" do
      data = SpecHelper.read_sample("pluto.jpg")
      image = Pluto::GreyscaleImage.from_jpeg(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "dc96176fe2d46790ac4f3f8efcaef666db06c4f3"
    end
  end
end
