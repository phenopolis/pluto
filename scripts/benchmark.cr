#!/usr/bin/env -S crystal run --no-debug --release

require "../src/pluto"

record BenchmarkResult, name : String, time : Int64, memory : Int64

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

def print_result_table(benchmarks : Array(BenchmarkResult))
  name_rjust = benchmarks.map(&.name.size).max
  time_ljust = benchmarks.map { |result| result.time.to_s.size + 2 }.max
  memo_ljust = benchmarks.map(&.memory.humanize_bytes.size).max

  # Headers
  table = [
    [" " * name_rjust, "Time".ljust(time_ljust), "Memory".ljust(memo_ljust)],
    ["-" * name_rjust, "-" * time_ljust, "-" * memo_ljust],
  ]

  # Rows
  benchmarks.each do |result|
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
    string << "\nTotal Time: " << benchmarks.sum(&.time) << "ms\n"
    string << "Total Memory: " << benchmarks.sum(&.memory).humanize_bytes
  end

  puts output
end

macro benchmark(&)
  image = Pluto::Image.from_ppm(File.read("lib/pluto_samples/pluto.ppm"))
  memory = 0i64
  time = benchmark_time do
    memory = benchmark_memory do
      {{yield}}
    end
  end
  BenchmarkResult.new(name: "{{yield.id}}".gsub("image.", ""), memory: memory, time: time.total_milliseconds.to_i64)
end

benchmarks = [] of BenchmarkResult

benchmarks << benchmark { image.bilinear_resize!(640, 480) }
benchmarks << benchmark { image.brightness!(1.4) }
benchmarks << benchmark { image.box_blur!(10) }
benchmarks << benchmark { image.channel_swap!(:red, :blue) }
benchmarks << benchmark { image.contrast!(128) }
benchmarks << benchmark { image.gaussian_blur!(10) }
benchmarks << benchmark { image.horizontal_blur!(10) }
benchmarks << benchmark { image.vertical_blur!(10) }

print_result_table(benchmarks)
