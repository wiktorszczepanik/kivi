module KVDB::CAST
  # Casts data from Ruby types to binary format
  class Serializer
    def initialize
      @standard = KVDB::STAND::Header.new
    end

    def row(header, value)
      [header.hash, header.timestamp, header.key_size, header.value_size, header.key_type, header.value_type,
       header.key, value].pack(KVDB::STAND::Header::SIZE + key_size + value_size)
    end

    def pack(bytes, type)
      case type
      when :Integer
        bytes.pack('q<')
      when :Float
        bytes.pack('E')
      when :String
        bytes.encode('utf-8')
      else
        raise KVDB::Err::TypesError, 'Invalid datatype while packing.'
      end
    end
  end
end
