require 'pathname'
require_relative '../kvdb'

module KVDB
  # Represents a cursor for retrieval and manipulation key-value pairs in a Database.
  # Example usage:
  # kv_db = KVDB::Cursor.new('path/to/file.kv', 'rw')
  class Cursor
    ALLOWED_ACTIONS = %w[r w].freeze
    ALLOWED_EXT = %w[.kv .kvdb].freeze

    attr_accessor :file_path, :actions, :is_newly_created

    def initialize(*args)
      put_defaults
      case args.length
      when 0 # Left defaults
      when 1
        put_file_path(args[0])
        instance_of_storage if @actions[:read] == true
      when 2
        put_file_path(args[0])
        put_allowed_actions(args[1])
        instance_of_storage if @actions[:read] == true
      else
        raise Err::FlagsError, 'Incorrect number of flags.'
      end
    end

    def to_s
      <<~HEREDOC
        KVDB Info:
        Path:    #{@file_path || '(empty)'}
        State:   #{@is_newly_created ? 'Created new' : 'Loaded exitsing'}
        Actions: #{@actions}
      HEREDOC
    end

    def put(key, value)
      @storage.put_row_into_kivi(key, value)
    end

    def get(key)
      @storage.get_row_from_kivi(key)
    end

    def test
      @storage.positions_map
    end

    def create(*args)
      raise Err::FlagsError, 'Incorrect number of flags.' unless [1, 2].include?(args.length)

      _, _, full = base_file_path_validation(args[0])
      raise Err::PathError, 'File already exists.' if full.exist?

      put_file_path(args[0])
      put_allowed_actions(args[1]) if args.length == 2
      @is_newly_created = true
    end

    def load(*args)
      raise Err::FlagsError, 'Incorrect number of flags.' unless [1, 2].include?(args.length)

      _, _, full = base_file_path_validation(args[0])
      raise Err::PathError, 'File already exists.' unless full.exist?

      put_file_path(args[0])
      put_allowed_actions(args[1]) if args.length == 2
      @is_newly_created = false
    end

    def put_actions(actions)
      put_allowed_actions(actions)
    end

    private

    def put_defaults
      @file_path = nil
      @actions = { read: true, write: false }
    end

    # Check if file paht exists
    def put_file_path(path)
      _, _, full = base_file_path_validation(path)
      if full.exist?
        @file_path = full
        @is_newly_created = false
      else
        File.new(full, 'w').close
        @file_path = full
        @is_newly_created = true
      end
    end

    def base_file_path_validation(path)
      full = Pathname.new(path)
      dir, base = full.split
      raise Err::PathError, 'Directories in path does not exists.' unless dir.exist?
      raise Err::PathError, 'Invalid extension.' unless ALLOWED_EXT.include?(base.extname)

      [dir, base, full]
    end

    # Allowed actions are read & write
    def put_allowed_actions(action)
      @actions = { read: false, write: false }
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
      instance_of_storage if @actions[:read] == true
    end

    def instance_of_storage
      @storage = KVDB::DISK::Storage.new(@file_path, @actions) if @actions[:read] == true
    end
  end
end
