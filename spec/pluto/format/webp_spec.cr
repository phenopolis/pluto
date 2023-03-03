require "../../spec_helper"

describe Pluto::Format::WebP do
  describe ".from_webp and #to_webp" do
    it "works with GrayscaleImage" do
      with_sample("pluto.webp") do |io|
        image = Pluto::GrayscaleImage.from_webp(io)
        io = IO::Memory.new
        image.to_webp(io)

        digest(io.to_s).should eq "92678d201760ee50929ea344a81c76d5f61e70e6"
      end
    end

    it "works with RGBAImage" do
      with_sample("pluto.webp") do |io|
        image = Pluto::RGBAImage.from_webp(io)
        io = IO::Memory.new
        image.to_webp(io)

        digest(io.to_s).should eq "84238a32866606bfb7ebedc6d77fe3af11f03cab"
      end
    end
  end
end
