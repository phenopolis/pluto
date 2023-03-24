@[Link(ldflags: "-lwebp")]
lib LibWebP
  fun decode_rgba = WebPDecodeRGBA(data : UInt8*, data_size : LibC::SizeT, width : LibC::Int*, height : LibC::Int*) : UInt8*
  fun encode_lossless_rgba = WebPEncodeLosslessRGBA(rgba : UInt8*, width : LibC::Int, height : LibC::Int, stride : LibC::Int, output : UInt8**) : LibC::SizeT
  fun free = WebPFree(ptr : Void*)
  fun get_info = WebPGetInfo(data : UInt8*, data_size : LibC::SizeT, width : LibC::Int*, height : LibC::Int*) : LibC::Int
end
