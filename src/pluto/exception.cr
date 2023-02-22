class Pluto::Exception < ::Exception
  getter error_code : LibJPEGTurbo::ErrorCode

  def initialize(handle : LibJPEGTurbo::Handle)
    super(String.new(LibJPEGTurbo.get_error_str(handle)))
    @error_code = LibJPEGTurbo.get_error_code(handle)
  end
end
