require "../../spec_helper"

describe Pluto::Format::JPEG do
  describe ".from_jpeg and #to_jpeg" do
    it "works with ImageGA" do
      with_sample("desert.jpeg") do |io|
        image = Pluto::ImageGA.from_jpeg(io)
        io = IO::Memory.new
        image.to_jpeg(io)

        digest(io.to_s).should eq "ec8d5a06d5c5ec3fdb6a25665aa7b33ac9757a87"
      end
    end

    it "works with ImageRGBA" do
      with_sample("desert.jpeg") do |io|
        image = Pluto::ImageRGBA.from_jpeg(io)
        io = IO::Memory.new
        image.to_jpeg(io)

        digest(io.to_s).should eq "f76d0f00ba95da1cec8adcd17cf2990d95be3aeb"
      end
    end
  end
end
