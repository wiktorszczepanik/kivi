module KVDB::DB
  # Header attributes for database row
  class Header

    attr_accessor :hash, :timestamp, :key_size, :value_size, :key_type, :vlaue_type

    def initialize(hash, timestamp, key_size, value_size, key_type, vlaue_type)
      @hash = hash
      @timestamp = timestamp
      @key_size = key_size
      @vlaue_size = value_size
      @key_type = key_type
      @value_type = vlaue_type
    end

    def add_key(key)
      @key = key
    end

    def add_start_position(position)
      @start_position = position
    end

    def add_value_position(position)
      @value_position = position
    end

    def get_key()
      return @key
    end

    def get_start_position()
      return @start_position
    end

    def get_value_position()
      return @value_position
    end

  end
end
