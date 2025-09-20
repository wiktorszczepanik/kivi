require_relative 'lib/kivi'
require 'pp'

KVDB::Cursor.open('test/file/db1.kv', 'rw') do |cursor|
  cursor.put(1, '11')
  cursor[2] = '22'
  cursor[3] = '33'
  cursor.put(4, '44')
  puts cursor[1]
end
