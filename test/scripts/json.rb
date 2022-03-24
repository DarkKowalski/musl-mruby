# frozen_string_literal: true

from = {
  name: 'John',
  age: 30,
  addresses: %w[
    a b
  ]
}

to = JSON.generate(from)
to2 = from.to_json

puts to, to2
