module Pluto::Format::Open
  def open(filename : String) : self
    case filename
    when .ends_with?(".ppm")                       then open_ppm(filename)
    when .ends_with?(".jpeg"), .ends_with?(".jpg") then open_jpeg(filename)
    else                                                raise "Unable to identify image type from file extension of #{filename}"
    end
  end
end
