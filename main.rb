require_relative 'lib/kvdb'

# cursor = KVDB::Cursor.new('test/file/db.kv', 'rw')
cursor = KVDB::Cursor.new('test/file/db.kv', 'rw')
# cursor.put(1, 4)
puts cursor.test
# puts cursor.test
