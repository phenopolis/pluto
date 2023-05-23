require "../../spec_helper"

describe Pluto::Format::WebP do
  describe ".from_webp and #to_webp" do
    it "works with ImageGA" do
      with_sample("pluto.webp") do |io|
        image = Pluto::ImageGA.from_webp(io)
        lossless_io = IO::Memory.new
        lossy_io = IO::Memory.new
        image.to_lossless_webp(lossless_io)
        image.to_lossy_webp(lossy_io)

        digest(lossless_io.to_s).should eq "4a23dfdec161349c163c0a17a6af4cf94e1807d7"
        digest(lossy_io.to_s).should eq "4bc3001918416800036ab01c59239c984177626c"
      end
    end

    it "works with ImageRGBA" do
      with_sample("pluto.webp") do |io|
        image = Pluto::ImageRGBA.from_webp(io)
        lossless_io = IO::Memory.new
        lossy_io = IO::Memory.new
        image.to_lossless_webp(lossless_io)
        image.to_lossy_webp(lossy_io)

        # FIXME: It currently returns a different hash on Ubuntu 22.04, which our CI uses.
        # Uncomment after updating to a newer version of Ubuntu or switching distributions.
        # digest(lossless_io.to_s).should eq "84238a32866606bfb7ebedc6d77fe3af11f03cab"
        digest(lossy_io.to_s).should eq "d0a47a094bc2fa9e850b534236ca89a035af65d1"
      end
    end
  end
end
