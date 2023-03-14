require "../../spec_helper"

describe Pluto::Format::WebP do
  describe ".from_webp and #to_webp" do
    it "works with ImageGA" do
      with_sample("pluto.webp") do |io|
        image = Pluto::ImageGA.from_webp(io)
        io = IO::Memory.new
        image.to_webp(io)

        digest(io.to_s).should eq "4a23dfdec161349c163c0a17a6af4cf94e1807d7"
      end
    end

    it "works with ImageRGBA" do
      with_sample("pluto.webp") do |io|
        image = Pluto::ImageRGBA.from_webp(io)
        io = IO::Memory.new
        image.to_webp(io)

        digest(io.to_s).should eq "84238a32866606bfb7ebedc6d77fe3af11f03cab"
      end
    end
  end
end
