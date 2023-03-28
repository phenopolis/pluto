@[Link(ldflags: "-lturbojpeg")]
lib LibJPEGTurbo
  alias Handle = Void*

  fun compress2 = tjCompress2(handle : Handle, src_buf : UInt8*, width : LibC::Int, pitch : LibC::Int, height : LibC::Int, pixel_format : PixelFormat, jpeg_buf : UInt8**, jpeg_size : LibC::ULong*, jpeg_subsamp : Subsampling, jpeg_qual : LibC::Int, flags : LibC::Int) : LibC::Int
  fun decompress_header3 = tjDecompressHeader3(handle : Handle, jpeg_buf : UInt8*, jpeg_size : LibC::ULong, width : LibC::Int*, height : LibC::Int*, jpeg_subsamp : Subsampling*, jpeg_colorspace : Colorspace*) : LibC::Int
  fun decompress2 = tjDecompress2(handle : Handle, jpeg_buf : UInt8*, jpeg_size : LibC::ULong, dst_buf : UInt8*, width : LibC::Int, pitch : LibC::Int, height : LibC::Int, pixel_format : PixelFormat, flags : LibC::Int) : LibC::Int
  fun destroy = tjDestroy(handle : Handle) : LibC::Int
  fun free = tjFree(buffer : UInt8*) : Void
  fun get_error_code = tjGetErrorCode(handle : Handle) : ErrorCode
  fun get_error_str = tjGetErrorStr2(handle : Handle) : UInt8*
  fun init_compress = tjInitCompress : Handle
  fun init_decompress = tjInitDecompress : Handle

  enum Colorspace
    RGB   = 0
    YCbCr = 1
    Gray  = 2
    CMYK  = 3
    YCCK  = 4
  end

  enum PixelFormat
    RGB     =  0
    BGR     =  1
    RGBX    =  2
    BGRX    =  3
    XBGR    =  4
    XRGB    =  5
    GRAY    =  6
    RGBA    =  7
    BGRA    =  8
    ABGR    =  9
    ARGB    = 10
    CMYK    = 11
    Unknown = -1
  end

  enum Subsampling
    S444 = 0
    S422 = 1
    S420 = 2
    Gray = 3
    S440 = 4
    S411 = 5
  end

  enum ErrorCode
    Warning = 1
    Fatal   = 2
  end
end
