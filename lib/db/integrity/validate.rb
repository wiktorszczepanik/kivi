module KVDB::HASH
  # for 64 bits
  FNF_PRIME = 0x00000100000001b3
  FNF_OFFSET = 0xcbf29ce484222325

  # Fowler–Noll–Vo hash function
  def fnf1a(text)
    hash = FNF_OFFSET
    text.each_byte do |byte|
      hash ^= byte
      hash *= FNF_PRIME
    end

    hash
    end
  end
end
