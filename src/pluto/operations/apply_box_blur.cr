module Pluto::Operations::ApplyBoxBlur
  def apply_box_blur(value : Int32) : Image
    clone.apply_box_blur!(value)
  end

  def apply_box_blur!(value : Int32) : Image
    apply_horizontal_blur!(value)
    apply_vertical_blur!(value)
  end
end
