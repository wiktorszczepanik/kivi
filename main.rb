require_relative 'lib/kvdb'

cursor = KVDB::Cursor.new('test/file/dbi.kv')

puts cursor.actions
