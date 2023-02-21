require "../../spec_helper"

Spectator.describe Pluto::Operation::VerticalBlur do
  include SpecHelper

  let(image) { new_rgba_pluto }
  let(gray_image) { new_gray_pluto }

  describe "#vertical_blur" do
    it "works with RGBAImage" do
      digest(image.vertical_blur(10)).should eq "d7116d6cea0a14e23cc3a23dbc86ad8bf1fecf2f"
    end

    it "works with GrayscaleImage" do
      digest(gray_image.vertical_blur(10)).should eq "38d71a5c13f46afdca6b13ecbdeb97327cd46dd7"
    end
  end

  describe "#vertical_blur!" do
    it "works with RGBAImage" do
      digest(image.vertical_blur!(10)).should eq "d7116d6cea0a14e23cc3a23dbc86ad8bf1fecf2f"
    end

    it "works with GrayscaleImage" do
      digest(gray_image.vertical_blur!(10)).should eq "38d71a5c13f46afdca6b13ecbdeb97327cd46dd7"
    end
  end
end
