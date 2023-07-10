<p align="center">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://raw.githubusercontent.com/phenopolis/pluto-logo/main/logo-white.png"
    />
    <img
      alt="logo"
      src="https://raw.githubusercontent.com/phenopolis/pluto-logo/main/logo-black.png"
      width="720px"
    />
  </picture>
</p>

<p align="center">A fast and convenient image processing library</p>

## Currently supported

- Image formats
  - JPEG (through [libjpeg-turbo](https://github.com/libjpeg-turbo/libjpeg-turbo))
  - PNG (through [libspng](https://libspng.org/))
  - PPM
  - [StumpyCore](https://github.com/stumpycr/stumpy_core)
  - WebP (through [libwebp](https://developers.google.com/speed/webp))
    - Webp 1.3 is supported, and requires `libsharpyuv` to be available. If WebP 1.3 isn't needed, the flag `-Dlegacy_webp` can be used to skip that requirement.
- Image operations
  - Bilinear resize
  - Box blur
  - Brightness
  - Channel swap
  - Contrast
  - Crop
  - Gaussian blur
  - Horizontal blur
  - Padding
  - Vertical blur

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     pluto:
       github: phenopolis/pluto
   ```

2. Run `shards install`.

## Usage

### Basic

```crystal
require "pluto"

# Formats requiring linkinkg a C library must be explicitly `require`d
require "pluto/format/jpeg"
require "pluto/format/png"
require "pluto/format/webp"

image = File.open("lib/pluto_samples/desert.png") do |file|
  Pluto::ImageRGBA.from_png(file)
end

image.contrast(-100)  # Creates a new object
image.contrast!(-100) # Modifies the existing object

io = IO::Memory.new
image.to_jpeg(io)
io.rewind
File.write("output.jpeg", io)
```

### StumpyCore

Pluto can convert to and from [StumpyCore](https://github.com/stumpycr/stumpy_core) `Canvas` objects, so any format that Stumpy supports can be usable with Pluto as well.

```crystal
require "pluto"
require "stumpy_png"

canvas = StumpyPNG.read("lib/pluto_samples/desert.png") # => StumpyCore::Canvas
image = Pluto::ImageRGBA.from_stumpy(canvas)            # => Pluto::ImageRGBA
image.to_stumpy                                         # => StumpyCore::Canvas
```

> **Note**
>
> Converting from a `StumpyCore::Canvas` created from a 16-bit image will result in a loss of information, since Pluto currently only supports 8 bit.

### More

See the API or the [`spec/`](https://github.com/phenopolis/pluto/tree/main/spec) folder for more examples.

## Benchmarks

See [`BENCHMARKS.md`](https://github.com/phenopolis/pluto/blob/main/BENCHMARKS.md).

## Contributing

1. Fork it (<https://github.com/phenopolis/pluto/fork>).
2. Create your feature branch (`git checkout -b my-new-feature`).
3. Commit your changes (`git commit -am 'Add some feature'`).
4. Push to the branch (`git push origin my-new-feature`).
5. Create a new Pull Request.
