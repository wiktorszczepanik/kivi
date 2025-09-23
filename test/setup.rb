require 'test/unit'
require 'pathname'

require_relative '../lib/kivi'

module KVTEST

  class Setup < Test::Unit::TestCase

    CUSTOM_ACTIONS_W = 'www'.freeze
    CUSTOM_ACTIONS_R = 'rrr'.freeze
    CUSTOM_ACTIONS_RW = 'rwrwrw'.freeze
    CUSTOM_EMPTY_ACTIONS = ''.freeze

    @is_old_kivi_file_created = false

    def setup
      timestamp = Time.now.strftime('%Y%m%d%H%M%S')

      # New curosor setup
      @new_kivi_file = "file/new_correct_access_testing_kivi_db_#{timestamp}.kv"
      File.delete(@new_kivi_file) if File.exist?(@new_kivi_file)

      # Old curosor setup
      unless @is_old_kivi_file_created
        @old_kivi_file = "file/old_correct_access_testing_kivi_db_#{timestamp}.kv"
        File.open(@old_kivi_file, 'wb') do |output|
          gz = Zlib::GzipWriter.new(output)
          gz.write('')
          gz.close
        end
        @is_old_kivi_file_created = true
      end
    end

    def teardown
      File.delete(@new_kivi_file) if File.exist?(@new_kivi_file)
    end

    # Empty
    def test_init_empty_kivi
      @empty_cursor = KIVI::Cursor.new
      assert_equal nil, @empty_cursor.file_path
      @empty_cursor.close
    end

    # With Path
    def test_init_with_new_correct_file
      @cursor_with_new_correct_file = KIVI::Cursor.new(@new_kivi_file)
      assert_equal Pathname.new(@new_kivi_file), @cursor_with_new_correct_file.file_path
      assert_equal true, @cursor_with_new_correct_file.is_newly_created
      assert_equal({ read: true, write: false }, @cursor_with_new_correct_file.actions)
      @cursor_with_new_correct_file.close
    end

    # With Path
    def test_init_with_old_correct_file
      @cursor_with_old_correct_file = KIVI::Cursor.new(@old_kivi_file)
      assert_equal Pathname.new(@old_kivi_file), @cursor_with_old_correct_file.file_path
      assert_equal false, @cursor_with_old_correct_file.is_newly_created
      assert_equal({ read: true, write: false }, @cursor_with_old_correct_file.actions)
    end

    # With Path and Actions
    def test_init_with_new_correct_file_and_actions_rw
      @cursor_with_new_correct_file_and_rw_actions = KIVI::Cursor.new(@new_kivi_file, CUSTOM_ACTIONS_RW)
      assert_equal({ read: true, write: true }, @cursor_with_new_correct_file_and_rw_actions.actions)
      @cursor_with_new_correct_file_and_rw_actions.close
    end

    def test_init_with_new_correct_file_and_actions_r
      @cursor_with_new_correct_file_and_r_actions = KIVI::Cursor.new(@new_kivi_file, CUSTOM_ACTIONS_R)
      assert_equal({ read: true, write: false }, @cursor_with_new_correct_file_and_r_actions.actions)
      @cursor_with_new_correct_file_and_r_actions.close
    end

    def test_init_with_new_correct_file_and_actions_w
      @cursor_with_new_correct_file_and_w_actions = KIVI::Cursor.new(@new_kivi_file, CUSTOM_ACTIONS_W)
      assert_equal({ read: false, write: true }, @cursor_with_new_correct_file_and_w_actions.actions)
      @cursor_with_new_correct_file_and_w_actions.close
    end

    def test_init_with_new_correct_file_and_actions_empty
      @cursor_with_new_correct_file_and_empty_actions = KIVI::Cursor.new(@new_kivi_file, CUSTOM_EMPTY_ACTIONS)
      assert_equal({ read: false, write: false }, @cursor_with_new_correct_file_and_empty_actions.actions)
      @cursor_with_new_correct_file_and_empty_actions.close
    end

    # With Path and Actions
    def test_init_with_old_correct_file_and_actions_rw
      @cursor_with_old_correct_file_and_rw_actions = KIVI::Cursor.new(@old_kivi_file, CUSTOM_ACTIONS_RW)
      assert_equal({ read: true, write: true }, @cursor_with_old_correct_file_and_rw_actions.actions)
      @cursor_with_old_correct_file_and_rw_actions.close
    end

    def test_init_with_old_correct_file_and_actions_r
      @cursor_with_old_correct_file_and_r_actions = KIVI::Cursor.new(@old_kivi_file, CUSTOM_ACTIONS_R)
      assert_equal({ read: true, write: false }, @cursor_with_old_correct_file_and_r_actions.actions)
      @cursor_with_old_correct_file_and_r_actions.close
    end

    def test_init_with_old_correct_file_and_actions_w
      @cursor_with_old_correct_file_and_w_actions = KIVI::Cursor.new(@old_kivi_file, CUSTOM_ACTIONS_W)
      assert_equal({ read: false, write: true }, @cursor_with_old_correct_file_and_w_actions.actions)
      @cursor_with_old_correct_file_and_w_actions.close
    end

    def test_init_with_old_correct_file_and_actions_empty
      @cursor_with_old_correct_file_and_empty_actions = KIVI::Cursor.new(@old_kivi_file, CUSTOM_EMPTY_ACTIONS)
      assert_equal({ read: false, write: false }, @cursor_with_old_correct_file_and_empty_actions.actions)
      @cursor_with_old_correct_file_and_empty_actions.close
    end

    # Test method .create
    def test_create_new_file_on_empty_cursor
      @cursor_create = KIVI::Cursor.new
      @cursor_create.create(@new_kivi_file)
      assert_equal Pathname.new(@new_kivi_file), @cursor_create.file_path
      assert_equal({ read: true, write: false }, @cursor_create.actions)
      @cursor_create.close
    end

    # Test method .load
    def test_load_new_file_on_empty_cursor
      @cursor_load = KIVI::Cursor.new
      @cursor_load.load(@old_kivi_file)
      assert_equal Pathname.new(@old_kivi_file), @cursor_load.file_path
      assert_equal({ read: true, write: false }, @cursor_load.actions)
      @cursor_load.close
    end

  end

end
