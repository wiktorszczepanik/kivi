require_relative 'lib/kivi'
require 'zlib'

# KIVI::Cursor.open('test/file/db1.kv', 'rw') do |cursor|
  # cursor.put(1, '11')
  # cursor[2] = '22'
  # cursor[3] = '33'
  # cursor.put(4, '44')
# end

old_timestamp = Time.now.strftime('%Y%m%d%H%M%S')
old_kivi_file = "test/file/old_correct_access_testing_kivi_db_#{old_timestamp}.kv"
File.open(old_kivi_file, 'wb') do |output|
  gz = Zlib::GzipWriter.new(output)
  gz.write('')
  gz.close
end
