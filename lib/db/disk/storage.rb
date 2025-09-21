require_relative '../../kivi'

module KIVI::DISK
  # Used only in cursor
  # Get indexs from key value database file
  class Storage

    attr_accessor :positions_map

    def initialize(file_path, actions)
      if actions[:read] || actions[:write]
        @file = File.open(file_path, 'r+b') # orginal = 'a+b'
        @serialize = KIVI::CAST::Serializer.new
      else
        raise Err::FlagsError, 'Minimum read flag is required, to put or get data.'
      end
      @deserialize = KIVI::CAST::Deserializer.new
      @position_in_file = 0
      @positions_map = {}
      init_positions
    end

    def get_row_from_kivi(key)
      header = @positions_map[key]
      return '' if header.nil?

      @file.seek(header.start_position + header.value_position)
      value_bytes = @file.read(header.value_size)
      @deserialize.unpack(value_bytes, header.value_type)
    end

    def put_row_into_kivi(key, value)
      del_row_from_kivi(key)
      hash, timestamp, key_size, value_size, key_type, vlaue_type = values_for_header(key, value)
      header = KIVI::DB::Header.new(hash, timestamp, key_size, value_size, key_type, vlaue_type)
      full_header = increment_header(key, header)
      row = @serialize.row(full_header, value)
      @file.write(row)
      @file.flush
    end

    def del_row_from_kivi(key)
      header = @positions_map[key]
      return '' if header.nil?

      remaining_start = header.start_position +
        header.value_position + header.value_size

      @file.seek(remaining_start)
      remaining_data = @file.read
      @file.seek(header.start_position)
      @file.write(remaining_data)
      @file.truncate(@file.pos)

      @positions_map.clear
      @position_in_file = 0
      @file.rewind
      init_positions
    end

    def init_positions
      while (row = @file.read(KIVI::STAND::Header::SIZE))
        header = KIVI::DB::Header.new(*@deserialize.header(row))
        key_bytes = @file.read(header.key_size)
        value_bytes = @file.read(header.value_size)
        key = @deserialize.unpack(key_bytes, header.key_type)
        value = @deserialize.unpack(value_bytes, header.value_type)

        unless KIVI::HASH.fnf1a(value) == header.hash
          raise KIVI::Err::CorruptionError, 'Invalid value.'
        end

        header = increment_header(key, header)
      end
    end

    def close
      @file.flush
      @file.close
      @positions_map.clear
      @position_in_file = 0
    end


    private

    def values_for_header(key, value)
      hash = KIVI::HASH.fnf1a(String(value))
      timestamp = Time.now.to_i
      key_type = key.class.to_s.to_sym
      value_type = value.class.to_s.to_sym
      key_size = @serialize.pack(key, key_type).length
      value_size = @serialize.pack(value, value_type).length
      [hash, timestamp, key_size, value_size, key_type, value_type]
    end

    def increment_header(key, header)
      header.add_key(key)
      header.add_start_position(@position_in_file)
      header.add_value_position(KIVI::STAND::Header::SIZE + header.key_size)
      @positions_map[key] = header
      row_size = header.value_position + header.value_size
      @position_in_file += row_size
      header
    end

  end
end
