module KVDB::DB
  # Header attributes for database row
  class Header

    attr_accessor :hash, :timestamp, :key_size, :value_size, :key_type, :value_type, :key, :start_position, :value_position

    def initialize(hash, timestamp, key_size, value_size, key_type, value_type)
      @hash = hash
      @timestamp = timestamp
      @key_size = key_size
      @value_size = value_size
      @key_type = key_type
      @value_type = value_type

      @key = -1
      @start_position = -1
      @value_position = -1
    end

    def to_s
      <<~HEREDOC
        Header Structure Info:
        Hash:           #{@hash}
        Timestamp:      #{@timestamp}
        Key size:       #{@key_size}
        Value size:     #{@value_size}
        Key type:       #{@key_type}
        Value type:     #{@value_type}
        Key:            #{@key}
        Start position: #{@start_position}
        Value position: #{@value_position}
      HEREDOC
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

  end
end
