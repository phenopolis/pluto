class Pluto::Exception < ::Exception
  getter error_code : Int32

  def initialize(@error_code : Int32)
  end

  def initialize(handle : LibJPEGTurbo::Handle)
    super(String.new(LibJPEGTurbo.get_error_str(handle)))
    @error_code = LibJPEGTurbo.get_error_code(handle).to_i
  end
end
