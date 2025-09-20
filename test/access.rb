require 'test/unit'
require 'pathname'
require_relative '../lib/kvdb'

module KVTEST

  class Access < Test::Unit::TestCase

    CORRECT_KVDB = 'file/correct_db.kv'.freeze
    TEST_VALUE_INT = 3
    TEST_VALUE_FLOAT = 3.14
    TEST_VALUE_STRING = 'PI'.freeze

    def setup
      @cursor = KVDB::Cursor.new(CORRECT_KVDB, 'rw')
    end

    # Test key as int type
    # key = int, vlaue = ...

    def test_key_int_and_value_int
      @cursor.put(1, TEST_VALUE_INT)
      assert_equal TEST_VALUE_INT, @cursor.get(1)
    end

    def test_key_int_and_value_float
      @cursor.put(2, TEST_VALUE_FLOAT)
      assert_equal TEST_VALUE_FLOAT, @cursor.get(2)
    end

    def test_key_int_and_value_string_
      @cursor.put(3, TEST_VALUE_STRING)
      assert_equal TEST_VALUE_STRING, @cursor.get(3)
    end

    # Test key as float type
    # key = float, vlaue = ...

    def test_key_float_and_value_int
      @cursor.put(1.1, TEST_VALUE_INT)
      assert_equal TEST_VALUE_INT, @cursor.get(1.1)
    end

    def test_key_float_and_value_float
      @cursor.put(2.2, TEST_VALUE_FLOAT)
      assert_equal TEST_VALUE_FLOAT, @cursor.get(2.2)
    end

    def test_key_float_and_value_string_
      @cursor.put(3.3, TEST_VALUE_STRING)
      assert_equal TEST_VALUE_STRING, @cursor.get(3.3)
    end

    # Test key as string type
    # key = string, vlaue = ...

    def test_key_string_and_value_int
      @cursor.put('one', TEST_VALUE_INT)
      assert_equal TEST_VALUE_INT, @cursor.get('one')
    end

    def test_key_string_and_value_float
      @cursor.put('two', TEST_VALUE_FLOAT)
      assert_equal TEST_VALUE_FLOAT, @cursor.get('two')
    end

    def test_key_string_and_value_string_
      @cursor.put('three', TEST_VALUE_STRING)
      assert_equal TEST_VALUE_STRING, @cursor.get('three')
    end
  end

end
