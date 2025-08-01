require_relative 'lib/kvdb'

cursor = KVDB::Cursor.new('test/file/dba.kv')

puts cursor.is_newly_created
