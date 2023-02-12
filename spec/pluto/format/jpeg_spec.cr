require "../../spec_helper"

describe Pluto::Format::JPEG do
  describe ".from_jpeg" do
    it "works" do
      data = SpecHelper.read_sample("pluto.jpg")
      image = Pluto::RGBImage.from_jpeg(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "60b7ab88c98807171df33b9242043d1e082b9e1a"
    end
  end

  describe "#to_jpeg" do
    it "works" do
      data = SpecHelper.read_sample("pluto.jpg")
      image = Pluto::RGBImage.from_jpeg(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "60b7ab88c98807171df33b9242043d1e082b9e1a"
    end
  end
end
