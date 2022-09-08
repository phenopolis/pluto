require "../../spec_helper"

describe Pluto::Operations::ChangeContrast do
  describe "#change_contrast" do
    it "works" do
      data = File.read("samples/pluto.ppm")
      image = Pluto::Image.from_ppm(data)
      positive_image = image.change_contrast(128)
      negative_image = image.change_contrast(-128)

      image.pixels[240][320].should eq 4005796096
      positive_image.pixels[240][320].should eq 4294953472
      negative_image.pixels[240][320].should eq 2761328640
    end
  end

  describe "#change_contrast!" do
    it "works" do
      data = File.read("samples/pluto.ppm")
      image = Pluto::Image.from_ppm(data)

      image.pixels[240][320].should eq 4005796096
      image.change_contrast!(128).pixels[240][320].should eq 4294953472
      image.change_contrast!(-128).pixels[240][320].should eq 2863306752
    end
  end
end
