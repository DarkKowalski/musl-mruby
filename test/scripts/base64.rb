# frozen_string_literal: true

text = 'Hello World'
enc = Base64.encode(text)
dec = Base64.decode(enc)

puts enc
puts dec
