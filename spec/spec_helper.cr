require "digest"
require "spec"

require "../src/pluto"

module SpecHelper
  def self.pluto_ppm : IO
    IO::Memory.new(@@pluto_ppm_bytes ||= begin
      File.open("lib/pluto_samples/pluto.ppm").getb_to_end
    end)
  end

  def self.pluto_jpg : IO
    IO::Memory.new(@@pluto_jpg_bytes ||= begin
      File.open("lib/pluto_samples/pluto.jpg").getb_to_end
    end)
  end
end
