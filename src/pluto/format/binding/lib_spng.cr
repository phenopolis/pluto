@[Link(ldflags: "-lspng")]
lib LibSPNG
  fun ctx_free = spng_ctx_free(ctx : Void*)
  fun ctx_new = spng_ctx_new(flags : CtxFlags) : Void*
  fun decode_image = spng_decode_image(ctx : Void*, out : Void*, len : LibC::SizeT, fmt : Format, flags : DecodeFlags) : LibC::Int
  fun decoded_image_size = spng_decoded_image_size(ctx : Void*, fmt : Format, len : LibC::SizeT*) : LibC::Int
  fun encode_chunks = spng_encode_chunks(ctx : Void*) : LibC::Int
  fun encode_image = spng_encode_image(ctx : Void*, img : Void*, len : LibC::SizeT, fmt : Format, flags : EncodeFlags) : LibC::Int
  fun get_ihdr = spng_get_ihdr(ctx : Void*, ihdr : IHDR*) : LibC::Int
  fun get_png_buffer = spng_get_png_buffer(ctx : Void*, len : LibC::SizeT*, error : LibC::Int*) : UInt8*
  fun set_ihdr = spng_set_ihdr(ctx : Void*, ihdr : IHDR*) : LibC::Int
  fun set_option = spng_set_option(ctx : Void*, option : Option, value : LibC::Int) : LibC::Int
  fun set_png_buffer = spng_set_png_buffer(ctx : Void*, buf : Void*, size : LibC::SizeT) : LibC::Int

  enum ColorType : UInt8
    Grayscale      = 0
    TrueColor      = 2
    Indexed        = 3
    GrayscaleAlpha = 4
    TrueColorAlpha = 6
  end

  enum CtxFlags
    None          = 0
    IgnoreAdler32 = 1
    Encoder       = 2
  end

  enum DecodeFlags
    None        =   0
    TRNS        =   1
    Gamma       =   2
    Progressive = 256
  end

  enum EncodeFlags
    Progressive = 1
    Finalize    = 2
  end

  enum Format
    RGBA8  =   1
    RGBA16 =   2
    RGB8   =   4
    GA8    =  16
    GA16   =  32
    G8     =  64
    PNG    = 256
    Raw    = 512
  end

  enum Option
    KeepUnknownChunks       =  1
    ImgCompressionLevel     =  2
    ImgWindowBits           =  3
    ImgMemLevel             =  4
    ImgCompressionStrategy  =  5
    TextCompressionLevel    =  6
    TextWindowBits          =  7
    TextMemLevel            =  8
    TextCompressionStrategy =  9
    FilterChoice            = 10
    ChunkCountLimit         = 11
    EncodeToBuffer          = 12
  end

  struct IHDR
    width : UInt32
    height : UInt32
    bit_depth : UInt8
    color_type : ColorType
    compression_method : UInt8
    filter_method : UInt8
    interlace_method : UInt8
  end
end
