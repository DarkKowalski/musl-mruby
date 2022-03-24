# frozen_string_literal: true

SSH.start('example.com', 'root', password: 'no_password') do |ssh|
  puts ssh.fingerprint
end
