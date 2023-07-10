require "digest"
require "spec"
require "stumpy_core"
require "stumpy_png"

require "../src/pluto"
require "../src/pluto/format/jpeg"
require "../src/pluto/format/png"
require "../src/pluto/format/webp"

PLUTO_JPEG_BYTES = with_sample("desert.jpeg", &.getb_to_end)
PLUTO_PPM_BYTES  = with_sample("desert.ppm", &.getb_to_end)

def expect_digest(image : Pluto::Image, digest : String) : Nil
  io = IO::Memory.new
  image.to_ppm(io)
  digest(io.to_s).should eq digest
end

def digest(data : String) : String
  Digest::SHA1.hexdigest(data)
end

def ga_sample : Pluto::ImageGA
  Pluto::ImageGA.from_ppm(PLUTO_PPM_BYTES)
end

def rgba_sample : Pluto::ImageRGBA
  Pluto::ImageRGBA.from_ppm(PLUTO_PPM_BYTES)
end

def with_sample(name : String, &)
  File.open("lib/pluto_samples/#{name}") do |file|
    yield file
  end
end
