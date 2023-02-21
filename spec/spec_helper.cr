require "digest"
require "spectator"
require "spectator/should"

require "../src/pluto"

module SpecHelper
  def self.read_sample(name : String) : String
    File.read("lib/pluto_samples/#{name}")
  end

  def new_rgba_pluto : Pluto::RGBAImage
    Pluto::RGBAImage.from_ppm(File.read("lib/pluto_samples/pluto.ppm"))
  end

  def new_gray_pluto : Pluto::GrayscaleImage
    Pluto::GrayscaleImage.from_ppm(File.read("lib/pluto_samples/pluto.ppm"))
  end

  macro with_images
    let(image) { new_rgba_pluto }
    let(gray_image) { new_gray_pluto }
  end

  def digest(image : Pluto::Image) : String
    Digest::SHA1.hexdigest(image.to_ppm)
  end
end
