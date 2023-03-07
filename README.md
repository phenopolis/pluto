<p align="center">
  <img
    alt="logo"
    src="https://raw.githubusercontent.com/phenopolis/pluto-logo/main/logo-white.png"
    width="720px"
  />
</p>

<p align="center">A fast and convenient image processing library</p>

## Currently supported

- Image formats
  - JPEG (through [libjpeg-turbo](https://github.com/libjpeg-turbo/libjpeg-turbo))
  - PNG (through [libspng](https://libspng.org/))
  - PPM
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

1. Require the library

   ```crystal
   require "pluto"
   ```

2. See the `spec` folder for examples

## Contributing

1. Fork it (<https://github.com/phenopolis/pluto/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
