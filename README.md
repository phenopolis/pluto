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
- Image operations
  - Bilinear resize
  - Box blur
  - Brightness
  - Channel swap
  - Contrast
  - Crop
  - Gaussian blur
  - Horizontal blur
  - Vertical blur

## Installation

1. Add the dependency to your `shard.yml`

   ```yaml
   dependencies:
     pluto:
       github: phenopolis/pluto
   ```

2. Run `shards install`

## Usage

### Basic

```crystal
require "pluto"

# Formats requiring linkinkg a C library must be explicitly `require`d
require "pluto/format/jpeg"
require "pluto/format/png"
require "pluto/format/webp"

image = File.open("lib/pluto_samples/pluto.png") do |file|
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

canvas = StumpyPNG.read("lib/pluto_samples/pluto.png") # => StumpyCore::Canvas
image = Pluto::ImageRGBA.new(canvas)                   # => Pluto::ImageRGBA
image.to_stumpy                                        # => StumpyCore::Canvas
```

> **Note**
>
> Converting from a `StumpyCore::Canvas` created from a 16-bit image will result in a loss of information, since Pluto currently only supports 8 bit.

### More

See the API or the `spec/` folder for more examples

## Benchmarks

- Hardware: Intel Core i7-6700K (4 cores/8 threads, 4.2 GHz).
- Software: Arch Linux x86_64.

|                                  | Time     | Memory  |
| -------------------------------- | -------- | ------- |
| from_jpeg(jpeg_bytes)            | 2.09ms   | 2.05MiB |
| from_jpeg(jpeg_io)               | 1.99ms   | 2.08MiB |
| from_png(png_bytes)              | 3.45ms   | 2.35MiB |
| from_png(png_io)                 | 3.61ms   | 2.57MiB |
| from_ppm(ppm_bytes)              | 799.44µs | 1.17MiB |
| from_ppm(ppm_io)                 | 2.45ms   | 1.2MiB  |
| from_webp(webp_bytes)            | 3.02ms   | 1.17MiB |
| from_webp(webp_io)               | 2.88ms   | 1.27MiB |
| to_jpeg(IO::Memory.new)          | 3.35ms   | 964kiB  |
| to_lossless_webp(IO::Memory.new) | 105.68ms | 1.23MiB |
| to_lossy_webp(IO::Memory.new)    | 21.21ms  | 1.2MiB  |
| to_png(IO::Memory.new)           | 36.46ms  | 1.3MiB  |
| to_ppm(IO::Memory.new)           | 2.34ms   | 2.0MiB  |
| bilinear_resize!(640, 480)       | 6.21ms   | 1.17MiB |
| box_blur!(10)                    | 7.74ms   | 600kiB  |
| brightness!(1.4)                 | 1.84ms   | 0B      |
| channel_swap!(:red, :blue)       | 63.0ns   | 0B      |
| contrast!(128)                   | 2.03ms   | 0B      |
| crop!(200, 200, 100, 100)        | 29.62µs  | 100kiB  |
| gaussian_blur!(10)               | 23.01ms  | 1.75MiB |
| horizontal_blur!(10)             | 3.17ms   | 300kiB  |
| vertical_blur!(10)               | 4.51ms   | 300kiB  |

> **Note**
>
> Tested with the latest release.

## Contributing

1. Fork it (<https://github.com/phenopolis/pluto/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
