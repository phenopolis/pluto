require "../spec_helper"

describe Pluto::Mask do
  it "initializes with width and height" do
    mask = Pluto::Mask.new(3, 3)
    mask.bits.should eq BitArray.new(9, true)
    mask.size.should eq 9
  end

  it "initializes with bit array and width" do
    bits = BitArray.new(9, false)
    mask = Pluto::Mask.new(3, bits)
    mask.bits.should eq bits
    mask.width.should eq 3
    mask.height.should eq 3
    mask.size.should eq 9
  end

  it "initializes with block" do
    mask = Pluto::Mask.new(4, 4) { |x, y| (1..2).includes?(x) && (1..2).includes?(y) }
    mask.size.should eq 16
    mask.width.should eq 4
    mask.height.should eq 4
    mask[0.., 0..].should eq [
      SpecHelper.bit_arr(4, 0b0000),
      SpecHelper.bit_arr(4, 0b0110),
      SpecHelper.bit_arr(4, 0b0110),
      SpecHelper.bit_arr(4, 0b0000),
    ]
  end

  it "initializes from integer" do
    mask = Pluto::Mask.new(4, 4, 0b1010010110100101)
    mask.size.should eq 16
    mask.width.should eq 4
    mask.height.should eq 4
    mask[0.., 0..].should eq [
      SpecHelper.bit_arr(4, 0b1010),
      SpecHelper.bit_arr(4, 0b0101),
      SpecHelper.bit_arr(4, 0b1010),
      SpecHelper.bit_arr(4, 0b0101),
    ]
  end

  it "raises if bit array size isn't evenly divisible by width" do
    expect_raises(Exception, /BitArray size 3 must be an even number of 2/) do
      Pluto::Mask.new(2, BitArray.new(3))
    end
  end

  it "#[]" do
    bits = BitArray.new(4, false)
    bits[1] = true
    bits[3] = true

    # Mask looks like:
    # 0 1
    # 0 1

    mask = Pluto::Mask.new(2, bits)
    mask[0, 0].should be_false
    mask[1, 0].should be_true
    mask[0, 1].should be_false
    mask[1, 1].should be_true
  end

  context "raises index error when" do
    mask = Pluto::Mask.new(2, BitArray.new(4))
    it "coordinate is outside of height" do
      expect_raises(IndexError, "Out of bounds: this mask is 2x2, and (0,2) is outside of that") do
        mask[0, 2]
      end
    end

    it "coordinate is outside of width" do
      expect_raises(IndexError, "Out of bounds: this mask is 2x2, and (2,0) is outside of that") do
        mask[2, 0]
      end
    end

    it "x range is outside of width" do
      expect_raises(IndexError, "Range 1..3 exceeds bounds of 2") do
        mask[1..3, 0]
      end
    end

    it "y range is outside of height" do
      expect_raises(IndexError, "Range 1..3 exceeds bounds of 2") do
        mask[1..3, 0]
      end
    end
  end

  context "using #[] with checkerboard pattern" do
    mask = Pluto::Mask.new(4, 4, 0b1010010110100101)

    it "supports single point" do
      mask[0, 0].should be_true
      mask[0, 1].should be_false
      mask[1, 0].should be_false
      mask[1, 1].should be_true
      mask[3, 3].should be_true
    end

    it "supports range for x" do
      mask[0..3, 0].should eq SpecHelper.bit_arr(4, 0b1010)
      mask[0..3, 1].should eq SpecHelper.bit_arr(4, 0b0101)
      mask[0..3, 2].should eq SpecHelper.bit_arr(4, 0b1010)
      mask[0..3, 3].should eq SpecHelper.bit_arr(4, 0b0101)
    end

    it "supports range for y" do
      mask[0, 0..3].should eq SpecHelper.bit_arr(4, 0b1010)
      mask[1, 0..3].should eq SpecHelper.bit_arr(4, 0b0101)
      mask[2, 0..3].should eq SpecHelper.bit_arr(4, 0b1010)
      mask[3, 0..3].should eq SpecHelper.bit_arr(4, 0b0101)
    end

    it "supports finite range for both x and y" do
      mask[0..3, 0..3].should eq [
        SpecHelper.bit_arr(4, 0b1010),
        SpecHelper.bit_arr(4, 0b0101),
        SpecHelper.bit_arr(4, 0b1010),
        SpecHelper.bit_arr(4, 0b0101),
      ]
    end

    it "supports infinite range for both x and y" do
      mask[0.., 0..].should eq [
        SpecHelper.bit_arr(4, 0b1010),
        SpecHelper.bit_arr(4, 0b0101),
        SpecHelper.bit_arr(4, 0b1010),
        SpecHelper.bit_arr(4, 0b0101),
      ]
    end

    it "initializes from a larger mask" do
      other_mask = Pluto::Mask.new(mask[1..2, 1..2])
      other_mask[0..-1, 0..-1].should eq [
        SpecHelper.bit_arr(2, 0b10),
        SpecHelper.bit_arr(2, 0b01),
      ]
    end
  end

  context "using #[] with unique pattern" do
    mask = Pluto::Mask.new(4, 4, 0b0000111001101001)

    it "supports single point" do
      mask[0, 0].should be_false
      mask[0, 1].should be_true
      mask[1, 0].should be_false
      mask[1, 1].should be_true
      mask[3, 3].should be_true
    end

    it "supports range for x" do
      mask[0..3, 0].should eq SpecHelper.bit_arr(4, 0b0000)
      mask[0..3, 1].should eq SpecHelper.bit_arr(4, 0b1110)
      mask[0..3, 2].should eq SpecHelper.bit_arr(4, 0b0110)
      mask[0..3, 3].should eq SpecHelper.bit_arr(4, 0b1001)
    end

    it "supports range for y" do
      mask[0, 0..3].should eq SpecHelper.bit_arr(4, 0b0101)
      mask[1, 0..3].should eq SpecHelper.bit_arr(4, 0b0110)
      mask[2, 0..3].should eq SpecHelper.bit_arr(4, 0b0110)
      mask[3, 0..3].should eq SpecHelper.bit_arr(4, 0b0001)
    end

    it "supports finite range for both x and y" do
      mask[0..3, 0..3].should eq [
        SpecHelper.bit_arr(4, 0b0000),
        SpecHelper.bit_arr(4, 0b1110),
        SpecHelper.bit_arr(4, 0b0110),
        SpecHelper.bit_arr(4, 0b1001),
      ]
    end

    it "supports infinite range for both x and y" do
      mask[0.., 0..].should eq [
        SpecHelper.bit_arr(4, 0b0000),
        SpecHelper.bit_arr(4, 0b1110),
        SpecHelper.bit_arr(4, 0b0110),
        SpecHelper.bit_arr(4, 0b1001),
      ]
    end

    it "initializes from a larger mask" do
      other_mask = Pluto::Mask.new(mask[0..2, 1..2])
      other_mask[0..-1, 0..-1].should eq [
        SpecHelper.bit_arr(3, 0b111),
        SpecHelper.bit_arr(3, 0b011),
      ]
    end
  end

  it "#inverts" do
    mask = Pluto::Mask.new(4, 4, 0b1010010110100101)
    mask.invert.should eq Pluto::Mask.new(4, 4, 0b0101101001011010)
    mask.should eq Pluto::Mask.new(4, 4, 0b1010010110100101)
  end

  it "#inverts!" do
    mask = Pluto::Mask.new(4, 4, 0b1010010110100101)
    mask.invert!
    mask.should eq Pluto::Mask.new(4, 4, 0b0101101001011010)
  end

  context "using #[]= using checkerboard pattern" do
    it "sets a single point" do
      mask = Pluto::Mask.new(4, 4, 0b1010010110100101)
      mask[1, 0] = true
      mask[0.., 0..].should eq [
        SpecHelper.bit_arr(4, 0b1110),
        SpecHelper.bit_arr(4, 0b0101),
        SpecHelper.bit_arr(4, 0b1010),
        SpecHelper.bit_arr(4, 0b0101),
      ]

      mask[3, 2] = true
      mask[0.., 0..].should eq [
        SpecHelper.bit_arr(4, 0b1110),
        SpecHelper.bit_arr(4, 0b0101),
        SpecHelper.bit_arr(4, 0b1011),
        SpecHelper.bit_arr(4, 0b0101),
      ]

      mask[1, 1] = false
      mask[0.., 0..].should eq [
        SpecHelper.bit_arr(4, 0b1110),
        SpecHelper.bit_arr(4, 0b0001),
        SpecHelper.bit_arr(4, 0b1011),
        SpecHelper.bit_arr(4, 0b0101),
      ]
    end

    it "sets range for x and single point for y" do
      mask = Pluto::Mask.new(4, 4, 0b1010010110100101)
      mask[0..3, 0] = true
      mask[0.., 0..].should eq [
        SpecHelper.bit_arr(4, 0b1111),
        SpecHelper.bit_arr(4, 0b0101),
        SpecHelper.bit_arr(4, 0b1010),
        SpecHelper.bit_arr(4, 0b0101),
      ]

      mask[1..2, 2] = true
      mask[0.., 0..].should eq [
        SpecHelper.bit_arr(4, 0b1111),
        SpecHelper.bit_arr(4, 0b0101),
        SpecHelper.bit_arr(4, 0b1110),
        SpecHelper.bit_arr(4, 0b0101),
      ]

      mask[1..2, 2] = false
      mask[0.., 0..].should eq [
        SpecHelper.bit_arr(4, 0b1111),
        SpecHelper.bit_arr(4, 0b0101),
        SpecHelper.bit_arr(4, 0b1000),
        SpecHelper.bit_arr(4, 0b0101),
      ]
    end

    it "sets range for y and single point for x" do
      mask = Pluto::Mask.new(4, 4, 0b1010010110100101)
      mask[0, 0..3] = true
      mask[0.., 0..].should eq [
        SpecHelper.bit_arr(4, 0b1010),
        SpecHelper.bit_arr(4, 0b1101),
        SpecHelper.bit_arr(4, 0b1010),
        SpecHelper.bit_arr(4, 0b1101),
      ]

      mask[2, 1..2] = true
      mask[0.., 0..].should eq [
        SpecHelper.bit_arr(4, 0b1010),
        SpecHelper.bit_arr(4, 0b1111),
        SpecHelper.bit_arr(4, 0b1010),
        SpecHelper.bit_arr(4, 0b1101),
      ]

      mask[2, 1..2] = false
      mask[0.., 0..].should eq [
        SpecHelper.bit_arr(4, 0b1010),
        SpecHelper.bit_arr(4, 0b1101),
        SpecHelper.bit_arr(4, 0b1000),
        SpecHelper.bit_arr(4, 0b1101),
      ]
    end

    it "sets range for both x and y" do
      mask = Pluto::Mask.new(4, 4, 0b1010010110100101)
      mask[1..2, 1..2] = true
      mask[0.., 0..].should eq [
        SpecHelper.bit_arr(4, 0b1010),
        SpecHelper.bit_arr(4, 0b0111),
        SpecHelper.bit_arr(4, 0b1110),
        SpecHelper.bit_arr(4, 0b0101),
      ]

      mask[0.., 0..] = true
      mask[0.., 0..].should eq [
        SpecHelper.bit_arr(4, 0b1111),
        SpecHelper.bit_arr(4, 0b1111),
        SpecHelper.bit_arr(4, 0b1111),
        SpecHelper.bit_arr(4, 0b1111),
      ]

      mask[1..2, 1..2] = false
      mask[0.., 0..].should eq [
        SpecHelper.bit_arr(4, 0b1111),
        SpecHelper.bit_arr(4, 0b1001),
        SpecHelper.bit_arr(4, 0b1001),
        SpecHelper.bit_arr(4, 0b1111),
      ]
    end
  end

  it "converts to grayscale" do
    mask = Pluto::Mask.new(4, 4, 0b1010010110100101)
    Digest::SHA1.hexdigest(mask.to_gray.to_ppm).should eq "3f5741961d8c2290ca93988c23c7f13bc97c66aa"
  end
end
