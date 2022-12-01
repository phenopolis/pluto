module Pluto::Operation::VerticalBlur
  def vertical_blur(value : Int32) : Image
    clone.vertical_blur!(value)
  end

  def vertical_blur!(value : Int32) : Image
    blur(
      value,
      step: @width,
      stride: 1,
      row_len: @height,
      row_count: @width,
    )
    self
  end
end
