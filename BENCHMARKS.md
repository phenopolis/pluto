# Benchmarks

## 1.0.0

### Intel Core i7-6700K

- Architecture: x86_64
- Cores/Threads: 4/8
- Frequency: 4.2 GHz
- Operating System: Arch Linux

|                                  | Time     | Memory  |
| -------------------------------- | -------- | ------- |
| from_jpeg(jpeg_bytes)            | 2.3ms    | 2.05MiB |
| from_jpeg(jpeg_io)               | 2.05ms   | 2.08MiB |
| from_png(png_bytes)              | 3.89ms   | 2.35MiB |
| from_png(png_io)                 | 3.44ms   | 2.57MiB |
| from_ppm(ppm_bytes)              | 714.55µs | 1.17MiB |
| from_ppm(ppm_io)                 | 2.4ms    | 1.2MiB  |
| from_webp(webp_bytes)            | 3.05ms   | 1.17MiB |
| from_webp(webp_io)               | 2.75ms   | 1.27MiB |
| to_jpeg(IO::Memory.new)          | 3.43ms   | 964kiB  |
| to_lossless_webp(IO::Memory.new) | 105.22ms | 1.23MiB |
| to_lossy_webp(IO::Memory.new)    | 21.13ms  | 1.2MiB  |
| to_png(IO::Memory.new)           | 37.01ms  | 1.3MiB  |
| to_ppm(IO::Memory.new)           | 2.34ms   | 2.0MiB  |
| bilinear_resize!(640, 480)       | 6.41ms   | 1.17MiB |
| box_blur!(10)                    | 5.6ms    | 600kiB  |
| brightness!(1.4)                 | 1.87ms   | 0B      |
| channel_swap!(:red, :blue)       | 70.0ns   | 0B      |
| contrast!(128)                   | 2.05ms   | 0B      |
| crop!(200, 200, 100, 100)        | 27.13µs  | 100kiB  |
| gaussian_blur!(10)               | 17.03ms  | 1.75MiB |
| horizontal_blur!(10)             | 2.31ms   | 300kiB  |
| vertical_blur!(10)               | 3.41ms   | 300kiB  |

Total Time: 228.41ms
Total Memory: 24.7MiB

## v0.3.1

### Apple M2 Pro

- Architecture: arm64
- Cores/Threads: 12/12
- Frequency: 3.7 GHz
- Operating System: macOS 13.3.1

|                                  | Time     | Memory  |
| -------------------------------- | -------- | ------- |
| from_jpeg(jpeg_bytes)            | 1.48ms   | 2.05MiB |
| from_jpeg(jpeg_io)               | 1.2ms    | 2.08MiB |
| from_png(png_bytes)              | 3.33ms   | 2.35MiB |
| from_png(png_io)                 | 3.19ms   | 2.57MiB |
| from_ppm(ppm_bytes)              | 510.71µs | 1.17MiB |
| from_ppm(ppm_io)                 | 1.88ms   | 1.2MiB  |
| from_webp(webp_bytes)            | 2.59ms   | 1.17MiB |
| from_webp(webp_io)               | 2.13ms   | 1.27MiB |
| to_jpeg(IO::Memory.new)          | 3.43ms   | 964kiB  |
| to_lossless_webp(IO::Memory.new) | 120.76ms | 1.23MiB |
| to_lossy_webp(IO::Memory.new)    | 16.92ms  | 1.2MiB  |
| to_png(IO::Memory.new)           | 29.6ms   | 1.3MiB  |
| to_ppm(IO::Memory.new)           | 1.96ms   | 2.0MiB  |
| bilinear_resize!(640, 480)       | 2.63ms   | 1.17MiB |
| box_blur!(10)                    | 2.43ms   | 600kiB  |
| brightness!(1.4)                 | 1.18ms   | 0B      |
| channel_swap!(:red, :blue)       | 42.0ns   | 0B      |
| contrast!(128)                   | 1.37ms   | 0B      |
| crop!(200, 200, 100, 100)        | 11.88µs  | 100kiB  |
| gaussian_blur!(10)               | 7.37ms   | 1.75MiB |
| horizontal_blur!(10)             | 1.23ms   | 300kiB  |
| vertical_blur!(10)               | 1.2ms    | 300kiB  |

- Total Time: 206.41ms
- Total Memory: 24.7MiB

### Intel Core i7-6700K

- Architecture: x86_64
- Cores/Threads: 4/8
- Frequency: 4.2 GHz
- Operating System: Arch Linux

|                                  | Time     | Memory  |
| -------------------------------- | -------- | ------- |
| from_jpeg(jpeg_bytes)            | 2.05ms   | 2.05MiB |
| from_jpeg(jpeg_io)               | 1.97ms   | 2.08MiB |
| from_png(png_bytes)              | 3.47ms   | 2.35MiB |
| from_png(png_io)                 | 3.62ms   | 2.57MiB |
| from_ppm(ppm_bytes)              | 724.27µs | 1.17MiB |
| from_ppm(ppm_io)                 | 2.43ms   | 1.2MiB  |
| from_webp(webp_bytes)            | 3.06ms   | 1.17MiB |
| from_webp(webp_io)               | 3.06ms   | 1.27MiB |
| to_jpeg(IO::Memory.new)          | 3.36ms   | 964kiB  |
| to_lossless_webp(IO::Memory.new) | 105.43ms | 1.23MiB |
| to_lossy_webp(IO::Memory.new)    | 21.1ms   | 1.2MiB  |
| to_png(IO::Memory.new)           | 36.37ms  | 1.3MiB  |
| to_ppm(IO::Memory.new)           | 2.3ms    | 2.0MiB  |
| bilinear_resize!(640, 480)       | 6.19ms   | 1.17MiB |
| box_blur!(10)                    | 5.62ms   | 600kiB  |
| brightness!(1.4)                 | 1.85ms   | 0B      |
| channel_swap!(:red, :blue)       | 74.0ns   | 0B      |
| contrast!(128)                   | 2.03ms   | 0B      |
| crop!(200, 200, 100, 100)        | 29.6µs   | 100kiB  |
| gaussian_blur!(10)               | 16.95ms  | 1.75MiB |
| horizontal_blur!(10)             | 2.26ms   | 300kiB  |
| vertical_blur!(10)               | 3.32ms   | 300kiB  |

- Total Time: 227.19ms
- Total Memory: 24.7MiB
