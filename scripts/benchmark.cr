#!/usr/bin/env -S crystal run --no-debug --release
require "../src/pluto"

record BenchmarkResult, time : Int64, memory : Int64

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

def print_result_table(total : Hash(String, BenchmarkResult))
  name_rjust = total.keys.map(&.size).max
  time_ljust = total.values.map { |t| t.time.to_s.size + 2 }.max
  memo_ljust = total.values.map(&.memory.humanize_bytes.size).max

  # Headers
  table = [
    [" " * name_rjust, "Time".ljust(time_ljust), "Memory".ljust(memo_ljust)],
    ["-" * name_rjust, "-" * time_ljust, "-" * memo_ljust],
  ]

  # Rows
  total.each do |name, t|
    table << [
      name.rjust(name_rjust),
      "#{t.time}ms".ljust(time_ljust),
      t.memory.humanize_bytes.ljust(memo_ljust),
    ]
  end

  # Output table itself
  puts table.map { |r| "| #{r.join(" | ")} |" }.join("\n")

  # Total Results
  puts "\nTotal Time  : #{total.sum { |_, v| v.time }}ms"
  puts "Total Memory: #{total.sum { |_, v| v.memory }.humanize_bytes}"
end

macro benchmark(&)
  image = Pluto::Image.from_ppm(File.read("lib/pluto_samples/pluto.ppm"))
  memory = 0i64
  time = benchmark_time do
    memory = benchmark_memory do
      {{yield}}
    end
  end
  total["{{yield.id}}".gsub("image.", "")] = BenchmarkResult.new(memory: memory, time: time.total_milliseconds.to_i64)
end

# ======== RECORD BENCHMARKS HERE ========
total = {} of String => BenchmarkResult

benchmark { image.bilinear_resize!(640, 480) }
benchmark { image.brightness!(1.4) }
benchmark { image.box_blur!(10) }
benchmark { image.channel_swap!(:red, :blue) }
benchmark { image.contrast!(128) }
benchmark { image.gaussian_blur!(10) }
benchmark { image.horizontal_blur!(10) }
benchmark { image.vertical_blur!(10) }

print_result_table(total)
