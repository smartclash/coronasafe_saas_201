require 'aes'

source_file = ARGV[0]
password = ARGV[1]
target_file = "#{source_file}.enc"

encrypted = AES.encrypt(File.read(source_file), password)
File.open(target_file, 'wb') {|f| f.write(encrypted)}
