module KIVI::CAST

  # Casts data from binary format to Ruby types
  class Deserializer

    def initialize
      # @standard = KVDB::STAND::Header.new
    end

    def header(data)
      # header = data.unpack(@standard::FORMAT)
      header = data.unpack(KIVI::STAND::Header::FORMAT)
      # puts header[0]
      return [header[0], header[1], header[2], header[3],
        KIVI::STAND::Header::TYPE_LOOKUP[header[4]],
        KIVI::STAND::Header::TYPE_LOOKUP[header[5]]]
    end

    def unpack(bytes, type)
      # directive = KVDB::STAND::Header::DIRECTIVE[type]
      case type
      when :Integer
        bytes.unpack1('Q')
      when :Float
        bytes.unpack1('E')
      when :String
        bytes.unpack1('A*')
      else
        raise KIVI::Err::TypesError, 'Invalid datatype while packing.'
      end
    end

  end
end
