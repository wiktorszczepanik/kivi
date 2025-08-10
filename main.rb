require_relative 'lib/kvdb'

cursor = KVDB::Cursor.new('test/file/db.kv', 'rw')
puts cursor.test
# cursor.put(1, 4)
# puts cursor.test
