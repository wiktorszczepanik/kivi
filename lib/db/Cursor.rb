require 'pathname'

module KVDB

  # Represents a cursor for retrieval and manipulation key-value pairs in a Database.
  # Example usage:
  # kv_db = KVDB::Cursor.new('path/to/file.kv', 'rw')
  class Cursor

    ALLOWED_ACTIONS = %w[r w].freeze

    attr_accessor :file_path, :actions

    def initialize(*args)
      put_defaults
      case args.length
      when 0 # Left defaults
      when 1
        put_file_path(args[0])
      when 2
        put_file_path(args[0])
        put_allowed_actions(args[1])
      else
        raise 'Incorrect number of flags.'
      end
    end

    private

    def put_defaults
      @file_path = nil
      @actions = { read: true, write: true }
    end

    # Check if file paht exists
    def put_file_path(path)
      temp_path = Pathname.new(path)
      if temp_path.exist?
        @file_path = temp_path
      else
        File.new(temp_path, 'w').close
        @file_path = temp_path
      end
    end

    # Allowed actions are read & write
    def put_allowed_actions(action)
      action.chars.uniq.each do |char|
        case char
        when 'r'
          @actions[:read] = true
        when 'w'
          @actions[:write] = true
        else
          raise "\'#{char}\' is incorrect action type. Available are #{ALLOWED_ACTIONS}"
        end
      end
    end

  end

end
