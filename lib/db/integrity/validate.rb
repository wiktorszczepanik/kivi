module KIVI::HASH
  # for 64 bits
  FNF_PRIME = 0x00000100000001b3
  FNF_OFFSET = 0xcbf29ce484222325

  # for 32 bits
  # FNF_PRIME = 0x01000193
  # FNF_OFFSET = 0x811c9dc5

  # Fowler–Noll–Vo hash function
  def self.fnf1a(value)
    text = value.to_s
    hash = FNF_OFFSET
    text.each_byte do |byte|
      hash ^= byte
      hash *= FNF_PRIME
      hash &= 0xFFFFFFFFFFFFFFFF # mask for 64 bits
      # hash &= 0xFFFFFFFF # mask for 64 bits
    end
    hash
  end

end
