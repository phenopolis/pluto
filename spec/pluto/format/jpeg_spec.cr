require "../../spec_helper"

describe Pluto::Format::JPEG do
  describe ".from_jpeg and #to_jpeg" do
    it "works with ImageGA" do
      with_sample("pluto.jpeg") do |io|
        image = Pluto::ImageGA.from_jpeg(io)
        io = IO::Memory.new
        image.to_jpeg(io)

        digest(io.to_s).should eq "dc96176fe2d46790ac4f3f8efcaef666db06c4f3"
      end
    end

    it "works with ImageRGBA" do
      with_sample("pluto.jpeg") do |io|
        image = Pluto::ImageRGBA.from_jpeg(io)
        io = IO::Memory.new
        image.to_jpeg(io)

        digest(io.to_s).should eq "60b7ab88c98807171df33b9242043d1e082b9e1a"
      end
    end
  end
end
