require "../spec_helper"

describe Pluto::Image do
  it "initializes" do
    Pluto::Image.new([[1u32, 2u32], [3u32, 4u32]], 2, 2).should be_truthy
  end
end
