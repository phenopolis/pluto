module Pluto::Operation::BoxBlur
  def box_blur(value : Int32) : self
    clone.box_blur!(value)
  end

  def box_blur!(value : Int32) : self
    horizontal_blur!(value)
    vertical_blur!(value)
  end
end
