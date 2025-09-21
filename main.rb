require_relative 'lib/kivi'
require 'pp'

# KIVI::Cursor.open('test/file/db1.kv', 'rw') do |cursor|
#   cursor.put(1, '11')
#   cursor[2] = '22'
#   cursor[3] = '33'
#   cursor.put(4, '44')
#   puts cursor[1]
# end

cursor = KIVI::Cursor.new('test/file/new_correct_db.kv', 'rw')
cursor.put(1, 11)
cursor.put(1.1, 11.1)
puts cursor.get(1.1)
cursor.close
