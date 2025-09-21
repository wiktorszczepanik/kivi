module KIVI::CAST

  # Casts data from Ruby types to binary format
  class Serializer

    def initialize
      @standard = KIVI::STAND::Header.new
    end

    def row(header, value)
      key_type_value = KIVI::STAND::Header::TYPE[header.key_type]
      value_type_value = KIVI::STAND::Header::TYPE[header.value_type]
      packed_kv = pack(header.key, header.key_type) + pack(value, header.value_type)
      [header.hash, header.timestamp,
       header.key_size, header.value_size,
       key_type_value, value_type_value
      ].pack(KIVI::STAND::Header::FORMAT) + packed_kv
    end

    def pack(data, type)
      case type
      when :Integer
        [data].pack('Q')
      when :Float
        [data].pack('E')
      when :String
        [data].pack('A*')
        # data.encode('utf-8')
      else
        raise KIVI::Err::TypesError, 'Invalid datatype while packing.'
      end
    end

  end

end
