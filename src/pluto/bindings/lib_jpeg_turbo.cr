@[Link(ldflags: "-lturbojpeg")]
lib LibJPEGTurbo
  alias Handle = Void*

  fun compress2 = tjCompress2(handle : Handle, src_buf : UInt8*, width : LibC::Int, pitch : LibC::Int, height : LibC::Int, pixel_format : PixelFormat, jpeg_buf : UInt8**, jpeg_size : LibC::ULong*, jpeg_subsamp : Subsampling, jpeg_qual : LibC::Int, flags : LibC::Int) : LibC::Int
  fun decompress_header3 = tjDecompressHeader3(handle : Handle, jpeg_buf : UInt8*, jpeg_size : LibC::ULong, width : LibC::Int*, height : LibC::Int*, jpeg_subsamp : Subsampling*, jpeg_colorspace : Colorspace*) : LibC::Int
  fun decompress2 = tjDecompress2(handle : Handle, jpeg_buf : UInt8*, jpeg_size : LibC::ULong, dst_buf : UInt8*, width : LibC::Int, pitch : LibC::Int, height : LibC::Int, pixel_format : PixelFormat, flags : LibC::Int) : LibC::Int
  fun destroy = tjDestroy(handle : Handle) : LibC::Int
  fun init_compress = tjInitCompress : Handle
  fun init_decompress = tjInitDecompress : Handle
  fun get_error_code = tjGetErrorCode(handle : Handle) : ErrorCode
  fun get_error_str = tjGetErrorStr2(handle : Handle) : UInt8*

  enum Colorspace
    RGB
    YCbCr
    Gray
    CMYK
    YCCK
  end

  enum PixelFormat
    RGB
    BGR
    RGBX
    BGRX
    XBGR
    XRGB
    GRAY
    RGBA
    BGRA
    ABGR
    ARGB
    CMYK
    Unknown = -1
  end

  enum Subsampling
    S444
    S422
    S420
    Gray
    S440
    S411
  end

  enum ErrorCode
    WARNING
    FATAL
  end
end
