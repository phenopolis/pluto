require "../../spec_helper"

describe Pluto::Format::JPEG do
  describe ".from_jpeg" do
    it "works with IO" do
      SpecHelper.with_sample("pluto.jpg") do |io|
        image = Pluto::RGBAImage.from_jpeg(io)
        Digest::SHA1.hexdigest(image.to_jpeg).should eq "60b7ab88c98807171df33b9242043d1e082b9e1a"
      end
    end

    it "works with String" do
      SpecHelper.with_sample("pluto.jpg") do |io|
        image = Pluto::RGBAImage.from_jpeg(io.gets_to_end)
        Digest::SHA1.hexdigest(image.to_jpeg).should eq "60b7ab88c98807171df33b9242043d1e082b9e1a"
      end
    end

    it "works with RGBAImage" do
      data = SpecHelper.pluto_jpg
      image = Pluto::RGBAImage.from_jpeg(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "60b7ab88c98807171df33b9242043d1e082b9e1a"
    end

    it "works with GrayscaleImage" do
      data = SpecHelper.pluto_jpg
      image = Pluto::GrayscaleImage.from_jpeg(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "dc96176fe2d46790ac4f3f8efcaef666db06c4f3"
    end
  end

  describe "#to_jpeg" do
    it "works with RGBAImage" do
      data = SpecHelper.pluto_jpg
      image = Pluto::RGBAImage.from_jpeg(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "60b7ab88c98807171df33b9242043d1e082b9e1a"
    end

    it "works with GrayscaleImage" do
      data = SpecHelper.pluto_jpg
      image = Pluto::GrayscaleImage.from_jpeg(data)

      Digest::SHA1.hexdigest(image.to_jpeg).should eq "dc96176fe2d46790ac4f3f8efcaef666db06c4f3"
    end
  end
end
