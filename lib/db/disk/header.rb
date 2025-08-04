module KVDB::ROW
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
  end
end
