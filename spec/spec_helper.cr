require "digest"
require "spec"

require "../src/pluto"

PLUTO_JPEG_BYTES = with_sample("pluto.jpg", &.getb_to_end)
PLUTO_PPM_BYTES  = with_sample("pluto.ppm", &.getb_to_end)

def expect_digest(image : Pluto::Image, digest : String) : Nil
  io = IO::Memory.new
  image.to_ppm(io)
  digest(io.to_s).should eq digest
end

def digest(data : String) : String
  Digest::SHA1.hexdigest(data)
end

def grayscale_sample : Pluto::GrayscaleImage
  Pluto::GrayscaleImage.from_ppm(PLUTO_PPM_BYTES)
end

def rgba_sample : Pluto::RGBAImage
  Pluto::RGBAImage.from_ppm(PLUTO_PPM_BYTES)
end

def with_sample(name : String, &)
  File.open("lib/pluto_samples/#{name}") do |file|
    yield file
  end
end
