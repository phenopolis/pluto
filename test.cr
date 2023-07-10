require "./src/pluto"

# Formats requiring linkinkg a C library must be explicitly `require`d
require "./src/pluto/format/jpeg"
require "./src/pluto/format/png"
require "./src/pluto/format/webp"

image = File.open("lib/pluto_samples/desert.png") do |file|
  Pluto::ImageRGBA.from_png(file)
end

io = IO::Memory.new
image.to_lossless_webp(io)
io.rewind
File.write("desert.webp", io)
