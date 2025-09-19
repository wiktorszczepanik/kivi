require_relative 'lib/kvdb'
require 'pp'

# cursor = KVDB::Cursor.new('test/file/db.kv', 'rw')
cursor = KVDB::Cursor.new('test/file/test1.kv', 'rw')
# cursor.put(1, 11)
# cursor.put(2, 22)
# cursor.put(3, 33)
# cursor.put(4, "Testowa wiadomosc.")
# cursor.put(5, "Testowa wiadomosc.")
# cursor.put(1.11111, "value")
# puts cursor.get(1.1111)
# pp cursor.test
