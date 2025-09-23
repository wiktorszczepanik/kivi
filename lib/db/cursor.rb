require 'pathname' # could not be resolved
require 'fileutils'
require 'zlib'
require 'stringio'

require_relative '../kivi'

module KIVI
  # Represents a cursor for retrieval and manipulation key-value pairs in a Database.
  # Recommended usage:
  # KVDB::Cursor.open('test/file/db1.kv', 'rw') do |cursor|
  #   cursor.put(1, '11')
  #   puts cursor.get(1)
  # end
  class Cursor

    ALLOWED_ACTIONS = %w[r w].freeze
    ALLOWED_EXT = %w[.kv .kvdb].freeze

    attr_accessor :file_path, :actions, :is_newly_created

    def initialize(*args)
      @status_closed = false
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

    # Context manager section
    def self.open(*args)
      cursor = new(*args)
      yield(cursor)
    ensure
      cursor.close
    end

    def to_s
      <<~HEREDOC
        KVDB Info:
        Path:    #{@file_path || '(empty)'}
        State:   #{@is_newly_created ? 'Created new' : 'Loaded exitsing'}
        Actions: #{@actions}
        Size:    #{size}
      HEREDOC
    end

    # Puts key and value to database
    def put(key, value)
      raise KIVI::Err::StatusError, 'Cursor already closed.' if @status_closed == true
      raise KIVI::Err::FlagsError, 'Write action is missing. PUT action is not allowed.' unless @actions[:write]

      @storage.put_row_into_kivi(key, value)
    end

    def []=(key, value)
      put(key, value)
    end

    # Get value
    def get(key)
      raise KIVI::Err::StatusError, 'Cursor already closed.' if @status_closed == true
      raise KIVI::Err::FlagsError, 'Read action is missing. GET action is not allowed.' unless @actions[:read]

      @storage.get_row_from_kivi(key)
    end

    def [](key)
      get(key)
    end

    # Delete row in database per key
    def del(key)
      raise KIVI::Err::StatusError, 'Cursor already closed.' if @status_closed == true
      raise KIVI::Err::FlagsError, 'Write action is missing. DEL action is not allowed.' unless @actions[:write]

      @storage.del_row_from_kivi(key)
    end

    def keys
      raise KIVI::Err::StatusError, 'Cursor already closed.' if @status_closed == true
      raise KIVI::Err::FlagsError, 'Read action is missing. KEYS action is not allowed.' unless @actions[:read]

      @storage.positions_map.keys

    end

    # Getting size of the kivi file
    def size
      raise KIVI::Err::StatusError, 'Cursor already closed.' if @status_closed == true
      raise KIVI::Err::FlagsError, 'Read action is missing. SIZE action is not allowed.' unless @actions[:read]

      File.size(file_path)
    end

    # Close the cursor
    # Close method is NOT required if cursor is implemented with context manager
    def close
      raise KIVI::Err::StatusError, 'Cursor already closed.' if @status_closed == true

      @status_closed = true
      begin
        @storage.close
      rescue
      ensure
        compress
        @file_path = nil
        @actions = { read: false, write: false }
      end
    end

    # Required only if cursor is closed
    def reopen(*args)
      raise KIVI::Err::StatusError, 'Cursor is already open.' if @status_closed == false

      initialize(*args)
    end

    # Create new kivi database file
    def create(*args)
      raise KIVI::Err::StatusError, 'Cursor already closed.' if @status_closed == true
      raise Err::FlagsError, 'Incorrect number of flags.' unless [1, 2].include?(args.length)

      _, _, full = base_file_path_validation(args[0])
      raise Err::PathError, 'File already exists.' if full.exist?

      put_file_path(args[0])
      put_allowed_actions(args[1]) if args.length == 2
      @is_newly_created = true
    end

    # Load existing kivi database file
    def load(*args)
      raise KIVI::Err::StatusError, 'Cursor already closed.' if @status_closed == true
      raise Err::FlagsError, 'Incorrect number of flags.' unless [1, 2].include?(args.length)

      _, _, full = base_file_path_validation(args[0])
      raise Err::PathError, 'The file does not exist.' unless full.exist?

      put_file_path(args[0])
      put_allowed_actions(args[1]) if args.length == 2
      @is_newly_created = false
    end

    # Set allowed actions per cursor / db
    def put_actions(actions)
      raise KIVI::Err::StatusError, 'Cursor already closed.' if @status_closed == true

      put_allowed_actions(actions)
    end

    private

    def compress(file_path = nil)
      file_path ||= @file_path
      original_data = File.binread(file_path)

      buffer = StringIO.new
      gz = Zlib::GzipWriter.new(buffer)
      gz.write(original_data)
      gz.close

      File.binwrite(file_path, buffer.string)
    end

    def decompress(file_path = nil)
      file_path ||= @file_path
      compressed_data = File.binread(file_path)

      buffer = StringIO.new(compressed_data)
      gz = Zlib::GzipReader.new(buffer)
      original_data = gz.read
      gz.close

      File.binwrite(file_path, original_data)
    end

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
        decompress
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
      # raise Err::PathError, 'Invalid extension.' unless ALLOWED_EXT.include?(base.extname)

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
      @storage = KIVI::DISK::Storage.new(@file_path, @actions) if @actions[:read] == true
    end
  end
end
