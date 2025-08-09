require_relative '../../kvdb'

module KVDB::DISK
  # Used only in cursor
  # Get indexs from key value database file
  class Storage
    attr_accessor :positions_map

    def initialize(file_path, actions)
      if actions[:read] && actions[:write]
        @file = File.open(file_path, 'a+b')
        @serialize = KVDB::CAST::Serializer.new
      elsif actions[:read]
        @file = File.open(file_path, 'rb')
      else
        raise Err::FlagsError, 'Minimum read flag is required, to put or get data.'
      end
      @deserialize = KVDB::CAST::Deserializer.new
      @position_in_file = 0
      @positions_map = {}
      init_positions
    end

    def get_row_from_kivi(key)
      header = @positions_map[key]
      return '' if header.nil?

      @file.seek(header.get_value_position)
      value_bytes = @file.read(header.value_size)
      @deserialize.unpack(value_bytes)
    end

    def put_row_into_kivi(key, value)
      header = KVDB::DB::Header.new(values_for_header(key, value))
      header = increment_header(key, header)
      row = @serialize.row(header, value)
      @file.write(row)
      @file.flush
    end

    def init_positions
      while (row = @file.read(KVDB::STAND::Header::SIZE))
        header = KVDB::DB::Header.new(@deserialize.header(row))

        key_bytes = @file.read(header.key_size)
        value_bytes = @file.read(header.value_size)
        key = @deserialize.unpack(key_bytes)
        value = @deserialize.unpack(value_bytes)

        raise KVDB::Err::CorruptionError, 'Invalid value.' unless KVDB::HASH.fnf1a(value) == header.hash

        header = increment_header(key, header)
      end
    end

    private

    def increment_header(key, header)
      header.add_key(key)
      header.add_start_position(@position_in_file)
      header.add_value_position(KVDB::STAND::Header::SIZE + header.key_size)
      @positions_map[key] = header
      row_size = header.get_value_position + header.value_size
      @position_in_file += row_size
      header
    end

    # TODO:
    def values_for_header(key, value)
      hash = KVDB::HASH.fnf1a(String(value))
      timestamp = Time.now.to_i
      key_type = key.class.to_s.to_sym
      value_type = value.class.to_s.to_sym
      key_size = @serialize.pack(key, key_type)
      value_size = @serialize.pack(value, value_type)
      [hash, timestamp, key_size, value_size, key_type, value_type]
    end
  end
end
