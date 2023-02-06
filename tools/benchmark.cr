require "../src/pluto"

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

def output_results(total : Hash(String, NamedTuple(memory: Int64, time: Int64)))
  name_rjust = total.keys.map(&.size).max
  time_ljust = total.values.map { |t| t[:time].to_s.size + 2 }.max
  mem_rjust = total.values.map(&.[:memory].humanize_bytes.size).max
  puts "| #{"".ljust(name_rjust)} | #{"Time".ljust(time_ljust)} | #{"Memory".ljust(mem_rjust)} |"
  puts "| #{"-" * name_rjust} | #{"-" * time_ljust} | #{"-" * mem_rjust} |"
  total.each do |name, t|
    print "| "
    print name.rjust(name_rjust)
    print " | "
    print "#{t[:time]}ms".ljust(time_ljust)
    print " | "
    print t[:memory].humanize_bytes.ljust(mem_rjust)
    puts " |"
  end
  puts "\nTotal Time  : #{total.sum { |_, v| v[:time] }}ms"
  puts "Total Memory: #{total.sum { |_, v| v[:memory] }.humanize_bytes}"
end

macro benchmark(&)
  image = Pluto::Image.from_ppm(File.read("lib/pluto_samples/pluto.ppm"))
  memory = 0i64
  time = benchmark_time do
    memory = benchmark_memory do
      {{yield}}
    end
  end
  total["{{yield.id}}".gsub(/^image\./, "")] = {memory: memory, time: time.total_milliseconds.to_i64}
end

# ======== RECORD BENCHMARKS HERE ========
total = {} of String => NamedTuple(memory: Int64, time: Int64)

benchmark { image.bilinear_resize!(640, 480) }
benchmark { image.brightness!(1.4) }
benchmark { image.box_blur!(10) }
benchmark { image.channel_swap!(:red, :blue) }
benchmark { image.contrast!(128) }
benchmark { image.gaussian_blur!(10) }
benchmark { image.horizontal_blur!(10) }
benchmark { image.vertical_blur!(10) }

output_results(total)
