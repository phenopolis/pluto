module Pluto::Format::Save
  # Perform a best guess file save based on the extension in the provided filename
  def save(filename : String) : Nil
    case filename
    when .ends_with?(".ppm")                       then to_ppm(filename)
    when .ends_with?(".jpeg"), .ends_with?(".jpg") then to_jpeg(filename)
    else                                                raise "Unable to identify image type from file extension of #{filename}"
    end
  end
end
