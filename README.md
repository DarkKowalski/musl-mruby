# Musl MRuby Script Engine

[![CI Tests](https://github.com/DarkKowalski/musl-mruby/actions/workflows/test.yml/badge.svg)](https://github.com/DarkKowalski/musl-mruby/actions/workflows/test.yml)

**[mruby](https://github.com/mruby/mruby) + [musl](https://musl.cc/) + [libressl](https://www.libressl.org/) = a self contained minimalistic Ruby CLI**

## Build

Debian 10/Ubuntu 20.04 AMD64

```
apt install build-essential musl-dev musl-tools ruby
gem install bundler
bundle install --jobs 4 --retry 3
bundle exec rake
```

You will get `musl-mruby` and `cert.pem` in `build` directory.

## Hello world

```bash
cat << EOF > hello_world.rb
# hello_world.rb
text = 'Hello World!'
base64 = Base64.encode(text)
sha256 = Digest::SHA256.hexdigest(text)
puts "text: #{text}"
puts "base64: #{base64}"
puts "sha256: #{sha256}"
EOF

ldd build/musl-mruby
# => not a dynamic executable

./build/musl-mruby hello_world.rb
# =>
# text: Hello World!
# base64: SGVsbG8gV29ybGQh
# sha256: 7f83b1657ff1fc53b92dc18148a1d65dfc2d4b1fa3d677284addd200126d9069
```
