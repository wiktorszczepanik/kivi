require_relative 'lib/kivi'

KIVI::Cursor.open('test/file/db1.kv', 'rw') do |cursor|

  # Put key and value
  cursor.put(1, '11')
  curosr.put(2, '22')
  cursor[3] = '33'
  cursor[4] = '44'

  # Get value by key
  cursor.get(1)
  cursor.get(2)
  cursor[2]
  cursor[2]

  # Delete record by key
  cursor.del(1)
  cursor.del(3)

  # Keys - all keys for selected .kv
  cursor.keys

  # Size - number of bytes
  cursor.size

  # Close cursor
  cursor.close

  # Reopen already closed cursor
  cursor.reopen

  # Create new .kv
  cursor.create('test/file/db2.kv', 'rw')

  # Load existing .kv
  cursor.load('test/file/db1.kv', 'rw')

  # New permissions
  cursor.put_actions('r') # Read only

end
