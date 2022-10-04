module Pluto::Operation::BoxBlur
  def box_blur(value : Int32) : Image
    clone.box_blur!(value)
  end

  def box_blur!(value : Int32) : Image
    horizontal_blur!(value)
    vertical_blur!(value)
  end
end
