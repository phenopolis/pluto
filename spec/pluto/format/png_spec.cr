require "../../spec_helper"

describe Pluto::Format::PNG do
  describe ".from_png and #to_png" do
    it "works with GrayscaleImage" do
      with_sample("pluto.png") do |io|
        image = Pluto::GrayscaleImage.from_png(io)
        io = IO::Memory.new
        image.to_png(io)

        digest(io.to_s).should eq "5fc8ce7e9d94d4b3ceb5d2216cf66e90e03c66e0"
      end
    end

    it "works with RGBAImage" do
      with_sample("pluto.png") do |io|
        image = Pluto::RGBAImage.from_png(io)
        io = IO::Memory.new
        image.to_png(io)

        digest(io.to_s).should eq "ac52c1565aac9a06d9bcf9553891b2251a55f0b1"
      end
    end
  end
end
