#!/usr/bin/env -S crystal run --no-debug --release

require "../src/pluto"

record Result, name : String, time : Int64, memory : Int64

def benchmark_memory
  bytes_before_measure = GC.stats.total_bytes
  yield
  (GC.stats.total_bytes - bytes_before_measure).to_i64
end

def benchmark_time
  time = Time.monotonic
  yield
  Time.monotonic - time
end

def print_result_table(results : Array(Result))
  name_rjust = results.map(&.name.size).max
  time_ljust = results.map(&.time.to_s.size.+(2)).max
  memo_ljust = results.map(&.memory.humanize_bytes.size).max

  # Headers
  table = [
    [" " * name_rjust, "Time".ljust(time_ljust), "Memory".ljust(memo_ljust)],
    ["-" * name_rjust, "-" * time_ljust, "-" * memo_ljust],
  ]

  # Rows
  results.each do |result|
    table << [
      result.name.rjust(name_rjust),
      "#{result.time}ms".ljust(time_ljust),
      result.memory.humanize_bytes.ljust(memo_ljust),
    ]
  end

  output = String.build do |string|
    table.each do |row|
      string << "| " << row.join(" | ") << " |\n"
    end
    string << "\nTotal Time: " << results.sum(&.time) << "ms\n"
    string << "Total Memory: " << results.sum(&.memory).humanize_bytes
  end

  puts output
end

macro benchmark(&)
  image = Pluto::RGBAImage.from_ppm(File.read("lib/pluto_samples/pluto.ppm"))
  memory = 0i64
  time = benchmark_time do
    memory = benchmark_memory do
      {{yield}}
    end
  end
  Result.new(name: "{{yield.id}}".gsub("image.", ""), memory: memory, time: time.total_milliseconds.to_i64)
end

results = [] of Result

results << benchmark { image.bilinear_resize!(640, 480) }
results << benchmark { image.brightness!(1.4) }
results << benchmark { image.box_blur!(10) }
results << benchmark { image.channel_swap!(:red, :blue) }
results << benchmark { image.contrast!(128) }
results << benchmark { image.gaussian_blur!(10) }
results << benchmark { image.horizontal_blur!(10) }
results << benchmark { image.vertical_blur!(10) }

print_result_table(results)
