require_relative 'lib/db/Cursor'

cursor = KVDB::Cursor.new('tests/db.kv', 'rw')

puts cursor.file_path
puts cursor.actions
