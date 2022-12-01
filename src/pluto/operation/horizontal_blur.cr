module Pluto::Operation::HorizontalBlur
  def horizontal_blur(value : Int32) : Image
    clone.horizontal_blur!(value)
  end

  def horizontal_blur!(value : Int32) : Image
    blur(
      value,
      step: 1,
      stride: @width,
      row_len: @width,
      row_count: @height,
    )
    self
  end
end
