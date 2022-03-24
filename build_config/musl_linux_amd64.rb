# frozen_string_literal: true

MRuby::Build.new do |conf|
  conf.toolchain :gcc
  conf.gem 'mrbgems/mruby-compiler' # For cross-compilation
  conf.gembox 'default'

  # All mgems: https://github.com/mruby/mgem-list

  conf.gem mgem: 'mruby-open3'
  # conf.gem mgem: 'mruby-ssh'
  conf.gem mgem: 'mruby-base64'
  conf.gem mgem: 'mruby-iijson'
  conf.gem mgem: 'mruby-logger'
  conf.gem mgem: 'mruby-digest'
  conf.gem mgem: 'mruby-require'

  conf.cc do |cc|
    cc.command = 'musl-gcc'
    cc.flags << '-I../libressl/build/install/usr/local/include'
  end

  conf.linker do |linker|
    linker.command = 'musl-gcc'
    linker.flags << '-L../libressl/build/install/usr/local/lib -static'
  end

  conf.enable_bintest
  conf.enable_test
end
