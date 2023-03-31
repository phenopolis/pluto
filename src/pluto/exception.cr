class Pluto::Exception < ::Exception
  getter error_code : Int32?

  def initialize(message : String)
    super(message, nil)
  end

  def initialize(message : String, @error_code : Int32)
    super(message, nil)
  end

  def initialize(@error_code : Int32)
    super("Received `#{@error_code}` as the error code")
  end
end
