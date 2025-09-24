## Kivi

Kivi is a single-file database written in Ruby that utilizes a hash table (key-value) structure. Data is stored on disk in binary format and compressed using gzip (*zlib*). Kivi offers a simple yet functional interaction with data, making it a great solution for small projects. Currently, Kivi supports the following types for keys and values: **Integer**, **Float**, and **String**.

### Usage

```ruby
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
```
> ⚠️ **Warning:** Please note that the structure of the above code (context manager) is the recommended form. You can connect to the database file without using a context manager; however, resources must be manually closed using the **.close** method. Failing to close the connection will result in a lack of compression, leading to issues when attempting to reconnect.

### Installation

Currently, Kivi is not distributed as a gem. To use Kivi, clone the repository and load the `kivi.rb` file in your project. To verify that everything is working correctly, you can run the unit tests located in the `test/` directory.
