require "digest"
require "spec"

require "../src/pluto"

module SpecHelper
  def self.read_sample(name : String) : String
    File.read("lib/pluto_samples/#{name}")
  end

  def self.pluto_ppm : IO
    IO::Memory.new(@@pluto_ppm_bytes ||= begin
      File.open("lib/pluto_samples/pluto.ppm").getb_to_end
    end)
  end
end
