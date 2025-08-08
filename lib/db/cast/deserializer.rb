module KVDB::CAST

  # Casts data from binary format to Ruby types
  class Deserializer

    def initialize
      @standard = KVDB::STAND::Header.new
    end

    def header(bytes)
      header = bytes.unpack(@standard::FORMAT)
      return [header[0], header[1], header[2], header[3],
        @standard::TYPE[header[4]],
        @standard::TYPE[header[5]]]
    end

    def unpack(bytes, type)
      case type
      when :Integer, :Float
        bytes.unpack1
      when :String
        bytes
      else
        raise KVDB::Err::TypesError, 'Invalid datatype while unpacking.'
      end
    end

  end
end
