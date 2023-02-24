require "digest"
require "spec"

require "../src/pluto"

module SpecHelper
  def self.pluto_ppm : Bytes
    @@pluto_ppm_bytes ||= File.open("lib/pluto_samples/pluto.ppm").getb_to_end
  end

  def self.pluto_jpg : Bytes
    @@pluto_jpg_bytes ||= File.open("lib/pluto_samples/pluto.jpg").getb_to_end
  end
end
