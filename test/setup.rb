require 'test/unit'
require 'pathname'

require_relative '../lib/kivi'

module KVTEST

  class Setup < Test::Unit::TestCase

    NEW_CORRECT_KIVI = 'file/new_correct_db.kv'.freeze
    OLD_CORRECT_KIVI = 'file/old_correct_db.kv'.freeze

    CUSTOM_ACTIONS_W = 'www'.freeze
    CUSTOM_ACTIONS_R = 'rrr'.freeze
    CUSTOM_ACTIONS_RW = 'rwrwrw'.freeze
    CUSTOM_EMPTY_ACTIONS = ''.freeze

    def setup
      File.new(OLD_CORRECT_KIVI, 'w').close
      File.open(OLD_CORRECT_KIVI, 'wb') do |output|
        gz = Zlib::GzipWriter.new(output)
        gz.write('')
        gz.close
      end
    end

    # Empty
    def test_init_empty_kivi
      begin
        @empty_cursor = KIVI::Cursor.new
        assert_equal nil, @empty_cursor.file_path
      ensure
        @empty_cursor = nil
      end
    end

    # With Path
    def test_init_with_new_correct_file
      begin
        @cursor_with_new_correct_file = KIVI::Cursor.new(NEW_CORRECT_KIVI)
        assert_equal Pathname.new(NEW_CORRECT_KIVI), @cursor_with_new_correct_file.file_path
        assert_equal true, @cursor_with_new_correct_file.is_newly_created
        assert_equal({ read: true, write: false }, @cursor_with_new_correct_file.actions)
        @cursor_with_new_correct_file.close
      ensure
        File.delete(NEW_CORRECT_KIVI)
      end
    end

    # With Path
    def test_init_with_old_correct_file
      @cursor_with_old_correct_file = KIVI::Cursor.new(OLD_CORRECT_KIVI)
      assert_equal Pathname.new(OLD_CORRECT_KIVI), @cursor_with_old_correct_file.file_path
      assert_equal false, @cursor_with_old_correct_file.is_newly_created
      assert_equal({ read: true, write: false }, @cursor_with_old_correct_file.actions)
    end

    # With Path and Actions
    def test_init_with_new_correct_file_and_actions
      begin
        @cursor_with_new_correct_file_and_rw_actions = KIVI::Cursor.new(NEW_CORRECT_KIVI, CUSTOM_ACTIONS_RW)
        assert_equal({ read: true, write: true }, @cursor_with_new_correct_file_and_rw_actions.actions)
        @cursor_with_new_correct_file_and_rw_actions.close

        @cursor_with_new_correct_file_and_r_actions = KIVI::Cursor.new(NEW_CORRECT_KIVI, CUSTOM_ACTIONS_R)
        assert_equal({ read: true, write: false }, @cursor_with_new_correct_file_and_r_actions.actions)
        @cursor_with_new_correct_file_and_r_actions.close

        @cursor_with_new_correct_file_and_w_actions = KIVI::Cursor.new(NEW_CORRECT_KIVI, CUSTOM_ACTIONS_W)
        assert_equal({ read: false, write: true }, @cursor_with_new_correct_file_and_w_actions.actions)
        @cursor_with_new_correct_file_and_w_actions.close

        @cursor_with_new_correct_file_and_empty_actions = KIVI::Cursor.new(NEW_CORRECT_KIVI, CUSTOM_EMPTY_ACTIONS)
        assert_equal({ read: false, write: false }, @cursor_with_new_correct_file_and_empty_actions.actions)
        @cursor_with_new_correct_file_and_empty_actions.close
      ensure
        File.delete(NEW_CORRECT_KIVI)
      end
    end

    # With Path and Actions
    def test_init_with_old_correct_file_and_actions
      @cursor_with_old_correct_file_and_rw_actions = KIVI::Cursor.new(OLD_CORRECT_KIVI, CUSTOM_ACTIONS_RW)
      assert_equal({ read: true, write: true }, @cursor_with_old_correct_file_and_rw_actions.actions)
      @cursor_with_old_correct_file_and_rw_actions.close

      @cursor_with_old_correct_file_and_r_actions = KIVI::Cursor.new(OLD_CORRECT_KIVI, CUSTOM_ACTIONS_R)
      assert_equal({ read: true, write: false }, @cursor_with_old_correct_file_and_r_actions.actions)
      @cursor_with_old_correct_file_and_r_actions.close

      @cursor_with_old_correct_file_and_w_actions = KIVI::Cursor.new(OLD_CORRECT_KIVI, CUSTOM_ACTIONS_W)
      assert_equal({ read: false, write: true }, @cursor_with_old_correct_file_and_w_actions.actions)
      @cursor_with_old_correct_file_and_w_actions.close

      @cursor_with_old_correct_file_and_empty_actions = KIVI::Cursor.new(OLD_CORRECT_KIVI, CUSTOM_EMPTY_ACTIONS)
      assert_equal({ read: false, write: false }, @cursor_with_old_correct_file_and_empty_actions.actions)
      @cursor_with_old_correct_file_and_empty_actions.close
    end

    # Test method .create
    def test_create_new_file_on_empty_cursor
      begin
        @empty_cursor = KIVI::Cursor.new
        @empty_cursor.create(NEW_CORRECT_KIVI)
        assert_equal Pathname.new(NEW_CORRECT_KIVI), @empty_cursor.file_path
      ensure
        File.delete(NEW_CORRECT_KIVI)
        @empty_cursor = nil
      end
    end

    # Test method .load
    def test_load_new_file_on_empty_cursor
      begin
        @empty_cursor = KIVI::Cursor.new
        @empty_cursor.load(OLD_CORRECT_KIVI)
        assert_equal Pathname.new(OLD_CORRECT_KIVI), @empty_cursor.file_path
      ensure
        @empty_cursor = nil
        # File.delete(OLD_CORRECT_KIVI)
      end
    end

  end

end
