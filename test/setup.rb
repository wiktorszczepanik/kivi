require 'test/unit'
require 'pathname'

require_relative '../lib/kvdb'

module KVTEST

  class Setup < Test::Unit::TestCase

    NEW_CORRECT_KVDB = 'file/new_correct_db.kv'.freeze
    OLD_CORRECT_KVDB = 'file/old_correct_db.kv'.freeze

    CUSTOM_ACTIONS_W = 'www'.freeze
    CUSTOM_ACTIONS_R = 'rrr'.freeze
    CUSTOM_ACTIONS_RW = 'rwrwrw'.freeze
    CUSTOM_EMPTY_ACTIONS = ''.freeze

    def setup
      File.new(OLD_CORRECT_KVDB, 'w').close
    end

    # Empty
    def test_init_empty_kvdb
      begin
        @empty_cursor = KVDB::Cursor.new
        assert_equal nil, @empty_cursor.file_path
      ensure
        @empty_cursor = nil
      end
    end

    # With Path
    def test_init_with_new_correct_file
      begin
        @cursor_with_new_correct_file = KVDB::Cursor.new(NEW_CORRECT_KVDB)
        assert_equal Pathname.new(NEW_CORRECT_KVDB), @cursor_with_new_correct_file.file_path
        assert_equal true, @cursor_with_new_correct_file.is_newly_created
        assert_equal({ read: true, write: false }, @cursor_with_new_correct_file.actions)
      ensure
        File.delete(NEW_CORRECT_KVDB)
      end
    end

    # With Path
    def test_init_with_old_correct_file
      @cursor_with_old_correct_file = KVDB::Cursor.new(OLD_CORRECT_KVDB)
      assert_equal Pathname.new(OLD_CORRECT_KVDB), @cursor_with_old_correct_file.file_path
      assert_equal false, @cursor_with_old_correct_file.is_newly_created
      assert_equal({ read: true, write: false }, @cursor_with_old_correct_file.actions)
    end

    # With Path and Actions
    def test_init_with_new_correct_file_and_actions
      begin
        @cursor_with_new_correct_file_and_rw_actions = KVDB::Cursor.new(NEW_CORRECT_KVDB, CUSTOM_ACTIONS_RW)
        assert_equal({ read: true, write: true }, @cursor_with_new_correct_file_and_rw_actions.actions)

        @cursor_with_new_correct_file_and_r_actions = KVDB::Cursor.new(NEW_CORRECT_KVDB, CUSTOM_ACTIONS_R)
        assert_equal({ read: true, write: false }, @cursor_with_new_correct_file_and_r_actions.actions)

        @cursor_with_new_correct_file_and_w_actions = KVDB::Cursor.new(NEW_CORRECT_KVDB, CUSTOM_ACTIONS_W)
        assert_equal({ read: false, write: true }, @cursor_with_new_correct_file_and_w_actions.actions)

        @cursor_with_new_correct_file_and_empty_actions = KVDB::Cursor.new(NEW_CORRECT_KVDB, CUSTOM_EMPTY_ACTIONS)
        assert_equal({ read: false, write: false }, @cursor_with_new_correct_file_and_empty_actions.actions)
      ensure
        File.delete(NEW_CORRECT_KVDB)
      end
    end

    # With Path and Actions
    def test_init_with_old_correct_file_and_actions
      @cursor_with_old_correct_file_and_rw_actions = KVDB::Cursor.new(OLD_CORRECT_KVDB, CUSTOM_ACTIONS_RW)
      assert_equal({ read: true, write: true }, @cursor_with_old_correct_file_and_rw_actions.actions)

      @cursor_with_old_correct_file_and_r_actions = KVDB::Cursor.new(OLD_CORRECT_KVDB, CUSTOM_ACTIONS_R)
      assert_equal({ read: true, write: false }, @cursor_with_old_correct_file_and_r_actions.actions)

      @cursor_with_old_correct_file_and_w_actions = KVDB::Cursor.new(OLD_CORRECT_KVDB, CUSTOM_ACTIONS_W)
      assert_equal({ read: false, write: true }, @cursor_with_old_correct_file_and_w_actions.actions)

      @cursor_with_old_correct_file_and_empty_actions = KVDB::Cursor.new(OLD_CORRECT_KVDB, CUSTOM_EMPTY_ACTIONS)
      assert_equal({ read: false, write: false }, @cursor_with_old_correct_file_and_empty_actions.actions)
    end

    # Test method .create
    def test_create_new_file_on_empty_cursor
      begin
        @empty_cursor = KVDB::Cursor.new
        @empty_cursor.create(NEW_CORRECT_KVDB)
        assert_equal Pathname.new(NEW_CORRECT_KVDB), @empty_cursor.file_path
      ensure
        File.delete(NEW_CORRECT_KVDB)
        @empty_cursor = nil
      end
    end

    # Test method .load
    def test_load_new_file_on_empty_cursor
      begin
        @empty_cursor = KVDB::Cursor.new
        @empty_cursor.load(OLD_CORRECT_KVDB)
        assert_equal Pathname.new(OLD_CORRECT_KVDB), @empty_cursor.file_path
      ensure
        @empty_cursor = nil
      end
    end

  end

end
