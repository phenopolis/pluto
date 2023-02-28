require "digest"
require "spec"

require "../src/pluto"

module SpecHelper
  def self.with_sample(name : String)
    File.open("lib/pluto_samples/#{name}") do |file|
      yield file
    end
  end

  @@pluto_ppm_bytes : Bytes?

  def self.pluto_ppm : Bytes
    @@pluto_ppm_bytes ||= with_sample("pluto.ppm", &.getb_to_end)
  end

  @@pluto_jpg_bytes : Bytes?

  def self.pluto_jpg : Bytes
    @@pluto_jpg_bytes ||= with_sample("pluto.jpg", &.getb_to_end)
  end
end
