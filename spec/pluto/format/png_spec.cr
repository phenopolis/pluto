require "../../spec_helper"

describe Pluto::Format::PNG do
  describe ".from_png and #to_png" do
    it "works with ImageGA" do
      with_sample("desert.png") do |io|
        image = Pluto::ImageGA.from_png(io)
        io = IO::Memory.new
        image.to_png(io)

        digest(io.to_s).should eq "6fbf353f3f427b07d8dd83359e9dd7ba6e683037"
      end
    end

    it "works with ImageRGBA" do
      with_sample("desert.png") do |io|
        image = Pluto::ImageRGBA.from_png(io)
        io = IO::Memory.new
        image.to_png(io)

        digest(io.to_s).should eq "8d1f3ae9f83ef9442b84f4bb0b2d30df06598c7e"
      end
    end
  end
end
