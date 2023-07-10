require "../../spec_helper"

describe Pluto::Operation::Padding do
  describe "#padding" do
    it "works with ImageGA" do
      image = ga_sample
      black_padding_image = image.padding(100, left: 100, top: 200, right: 300, bottom: 400, padding_type: :black)
      repeat_padding_image = image.padding(100, left: 100, top: 200, right: 300, bottom: 400, padding_type: :repeat)

      expect_digest image, "91fd39e895dac79f13501d32efbb6301c3558462"
      expect_digest black_padding_image, "026bfc487c33a3e08faa03ea15028383d6fbcabb"
      expect_digest repeat_padding_image, "57d142c46c3d226d3baa8bacd8e942b53f85ad02"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      black_padding_image = image.padding(100, left: 100, top: 200, right: 300, bottom: 400, padding_type: :black)
      repeat_padding_image = image.padding(100, left: 100, top: 200, right: 300, bottom: 400, padding_type: :repeat)

      expect_digest image, "13dc397f7b6098b66b9c523f8cf0f715ac5a8e4a"
      expect_digest black_padding_image, "02e0ce76b0c1f7d53abb6debfe0bb59248de35c9"
      expect_digest repeat_padding_image, "72a80c554b643a38e325590c8a270ec55b9a2666"
    end
  end

  describe "#padding!" do
    it "works with ImageGA" do
      image = ga_sample
      image.padding!(100, left: 100, top: 200, right: 300, bottom: 400, padding_type: :black)
      expect_digest image, "026bfc487c33a3e08faa03ea15028383d6fbcabb"

      image = ga_sample
      image.padding!(100, left: 100, top: 200, right: 300, bottom: 400, padding_type: :repeat)
      expect_digest image, "57d142c46c3d226d3baa8bacd8e942b53f85ad02"
    end

    it "works with ImageRGBA" do
      image = rgba_sample
      image.padding!(100, left: 100, top: 200, right: 300, bottom: 400, padding_type: :black)
      expect_digest image, "02e0ce76b0c1f7d53abb6debfe0bb59248de35c9"

      image = rgba_sample
      image.padding!(100, left: 100, top: 200, right: 300, bottom: 400, padding_type: :repeat)
      expect_digest image, "72a80c554b643a38e325590c8a270ec55b9a2666"
    end
  end
end
