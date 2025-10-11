require_relative 'lib/kivi'


KIVI::Cursor.open('test/file/db1.kv', 'rw') do |cursor|

  # Put key and value

  cursor.put(1, '11')
  cursor.put(2, '22')
  cursor[3] = '33'
  cursor[4] = '44'

  # Get value by key
  puts cursor.get(1)
  puts cursor.get(2)
  puts cursor[2]
  puts cursor[2]

  # Delete record by key
  cursor.del(1)
  cursor.del(3)

  # Keys - all keys for selected .kv
  cursor.keys

  # Size - number of bytes
  cursor.size

end
