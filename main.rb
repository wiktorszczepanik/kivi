require_relative 'lib/kvdb'
require 'pp'

cursor = KVDB::Cursor.new
# cursor = KVDB::Cursor.new('test/file/d2.kv', 'rw')
# cursor.put(1, '11')
# cursor.put(2, '22')
# cursor.put(3, '33')
# cursor.put(4, '44')
# # cursor.del(1)
# cursor.load('test/file/d2.kv', 'rw')
# cursor.close
puts cursor.get(3)
