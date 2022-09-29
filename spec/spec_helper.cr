require "spec"
require "../src/pluto"

module SpecHelper
  def self.read_sample(name : String) : String
    File.read("lib/pluto_samples/#{name}")
  end
end
