require "../../spec_helper"

describe Pluto::Operations::ChangeContrast do
  describe "#change_contrast" do
    it "works" do
      data = File.read("samples/pluto.ppm")
      image = Pluto::Image.from_ppm(data)
      positive_image = image.change_contrast(128)
      negative_image = image.change_contrast(-128)

      image.red[240][320].should eq 238
      image.green[240][320].should eq 195
      image.blue[240][320].should eq 153

      positive_image.red[240][320].should eq 255
      positive_image.green[240][320].should eq 255
      positive_image.blue[240][320].should eq 202

      negative_image.red[240][320].should eq 164
      negative_image.green[240][320].should eq 150
      negative_image.blue[240][320].should eq 136
    end
  end

  describe "#change_contrast!" do
    it "works" do
      data = File.read("samples/pluto.ppm")
      image = Pluto::Image.from_ppm(data)

      image.red[240][320].should eq 238
      image.green[240][320].should eq 195
      image.blue[240][320].should eq 153

      image.change_contrast!(128)
      image.red[240][320].should eq 255
      image.green[240][320].should eq 255
      image.blue[240][320].should eq 202

      image.change_contrast!(-128)
      image.red[240][320].should eq 170
      image.green[240][320].should eq 170
      image.blue[240][320].should eq 152
    end
  end
end
