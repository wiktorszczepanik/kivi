require_relative 'lib/kvdb'

# cursor = KVDB::Cursor.new('test/file/db.kv', 'rw')
cursor = KVDB::Cursor.new('test/file/test.kv', 'rw')
# cursor.put(1, 11)
# cursor.put(2, 22)
# cursor.put(3, 33)
# cursor.put(4, "Testowa wiadomosc.")
# cursor.put(5, "Testowa wiadomosc.")
# puts cursor.get(4)
puts cursor.test
