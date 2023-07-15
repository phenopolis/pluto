#!/usr/bin/env -S crystal run --no-debug --release

require "../src/pluto"
require "../src/pluto/format/jpeg"
require "../src/pluto/format/png"
require "../src/pluto/format/webp"

record Result, name : String, time : Float64, memory : Int64

def benchmark_memory(&)
  bytes_before_measure = GC.stats.total_bytes
  yield
  (GC.stats.total_bytes - bytes_before_measure).to_i64
end

def benchmark_time(&)
  time = Time.monotonic
  yield
  Time.monotonic - time
end

private def elapsed_text(millis)
  return "#{millis.round(2)}ms" if millis >= 1
  return "#{(millis * 1000).round(2)}µs" if millis >= 0.001

  "#{(millis * 1_000_000).round(2)}ns"
end

def print_result_table(results : Array(Result))
  name_ljust = results.map(&.name.size).max
  time_ljust = results.map { |res| elapsed_text(res.time).size }.max
  memo_ljust = results.map(&.memory.humanize_bytes.size).max

  # Headers
  table = [
    [" " * name_ljust, "Time".ljust(time_ljust), "Memory".ljust(memo_ljust)],
    ["-" * name_ljust, "-" * time_ljust, "-" * memo_ljust],
  ]

  # Rows
  results.each do |result|
    table << [
      result.name.ljust(name_ljust),
      elapsed_text(result.time).ljust(time_ljust),
      result.memory.humanize_bytes.ljust(memo_ljust),
    ]
  end

  output = String.build do |string|
    table.each do |row|
      string << "| " << row.join(" | ") << " |\n"
    end
    string << "\n- Total Time: " << elapsed_text(results.sum(&.time))
    string << "\n- Total Memory: " << results.sum(&.memory).humanize_bytes
  end

  puts output
end

macro benchmark(&)
  {% for format_name in {"jpeg", "png", "ppm", "webp"} %}
    {{ format_name.id }}_io = File.open("lib/pluto_samples/desert.{{ format_name.id }}")
    {{ format_name.id }}_bytes = {{ format_name.id }}_io.getb_to_end
    {{ format_name.id }}_io.rewind
  {% end %}
  image_rgba = File.open("lib/pluto_samples/desert.ppm") { |file| Pluto::ImageRGBA.from_ppm(file) }

  memory = 0i64
  time = benchmark_time do
    memory = benchmark_memory do
      {{yield}}
    end
  end

  Result.new(
    name: "{{yield.id}}".gsub("Pluto::ImageRGBA.", "").gsub("image_rgba.", ""),
    memory: memory,
    time: time.total_milliseconds
  )
end

results = [] of Result

results << benchmark { Pluto::ImageRGBA.from_jpeg(jpeg_bytes) }
results << benchmark { Pluto::ImageRGBA.from_jpeg(jpeg_io) }
results << benchmark { Pluto::ImageRGBA.from_png(png_bytes) }
results << benchmark { Pluto::ImageRGBA.from_png(png_io) }
results << benchmark { Pluto::ImageRGBA.from_ppm(ppm_bytes) }
results << benchmark { Pluto::ImageRGBA.from_ppm(ppm_io) }
results << benchmark { Pluto::ImageRGBA.from_webp(webp_bytes) }
results << benchmark { Pluto::ImageRGBA.from_webp(webp_io) }

results << benchmark { image_rgba.to_jpeg(IO::Memory.new) }
results << benchmark { image_rgba.to_lossless_webp(IO::Memory.new) }
results << benchmark { image_rgba.to_lossy_webp(IO::Memory.new) }
results << benchmark { image_rgba.to_png(IO::Memory.new) }
results << benchmark { image_rgba.to_ppm(IO::Memory.new) }

results << benchmark { image_rgba.bilinear_resize!(640, 480) }
results << benchmark { image_rgba.box_blur!(10) }
results << benchmark { image_rgba.brightness!(1.4) }
results << benchmark { image_rgba.channel_swap!(:red, :blue) }
results << benchmark { image_rgba.contrast!(128) }
results << benchmark { image_rgba.crop!(200, 200, 100, 100) }
results << benchmark { image_rgba.gaussian_blur!(10) }
results << benchmark { image_rgba.horizontal_blur!(10) }
results << benchmark { image_rgba.padding!(100) }
results << benchmark { image_rgba.rotate!(45) }
results << benchmark { image_rgba.vertical_blur!(10) }

print_result_table(results)
