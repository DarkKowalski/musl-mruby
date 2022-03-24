# frozen_string_literal: true

text = 'Hello World'

puts Digest::MD5.digest(text)
puts Digest::MD5.hexdigest(text)

puts Digest::SHA1.digest(text)
puts Digest::SHA1.hexdigest(text)

puts Digest::SHA256.digest(text)
puts Digest::SHA256.hexdigest(text)

puts Digest::RMD160.digest(text)
puts Digest::RMD160.hexdigest(text)

puts Digest::SHA384.digest(text)
puts Digest::SHA384.hexdigest(text)

puts Digest::SHA512.digest(text)
puts Digest::SHA512.hexdigest(text)
