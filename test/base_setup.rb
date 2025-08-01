require 'test/unit'
require 'pathname'
require_relative '../lib/kvdb'

module KVTEST

  class BaseSetup < Test::Unit::TestCase

    NEW_CORRECT_KVDB = 'file/new_correct_db.kv'
    OLD_CORRECT_KVDB = 'file/old_correct_db.kv'

    def setup
      File.new(OLD_CORRECT_KVDB, 'w').close

      # Empty
      @empty_cursor = KVDB::Cursor.new

      # Only with path
      @cursor_with_new_correct_file = KVDB::Cursor.new(NEW_CORRECT_KVDB)
      @cursor_with_old_correct_file = KVDB::Cursor.new(OLD_CORRECT_KVDB)
    end

    # Empty
    def test_init_empty_kvdb
      assert_equal nil, @empty_cursor.file_path
    end

    # With Path ---- TODO: incorrect 2nd output
    def test_init_with_new_correct_file
      begin
        assert_equal Pathname.new(NEW_CORRECT_KVDB), @cursor_with_new_correct_file.file_path
        assert_equal true, @cursor_with_new_correct_file.is_newly_created
        assert_equal({ read: true, write: false }, @cursor_with_new_correct_file.actions)
      ensure
        File.delete(NEW_CORRECT_KVDB)
      end
    end

    # def init_full
    # end

    # def test_create
    # end

    # def test_load
    # end

  end

end
