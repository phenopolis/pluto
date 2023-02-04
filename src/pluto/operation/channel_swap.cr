module Pluto::Operation::ChannelSwap
  def channel_swap(a : Channel, b : Channel) : Image
    clone.channel_swap!(a, b)
  end

  def channel_swap!(a : Channel, b : Channel) : Image
    ch_a, ch_b = self[a], self[b]
    self[a] = ch_b
    self[b] = ch_a
    self
  end
end
