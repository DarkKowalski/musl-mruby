# frozen_string_literal: true

require_relative 'build_config/helper/build_config'
require_relative 'build_config/helper/libressl'
require 'fileutils'

proxy = ENV['http_proxy'] || ENV['HTTP_PROXY'] || ENV['https_proxy'] || ENV['HTTPS_PROXY']
libressl_config = LibreSSLBuildConfig.new(http_proxy: proxy)
musl_mruby_config = MuslMRubyBuildConfig.new(http_proxy: proxy,
                                             mruby_git_source: 'https://github.com/mruby/mruby',
                                             mruby_git_branch: 'stable',
                                             libssl_a: libressl_config.libressl_a[:libssl_a],
                                             libtls_a: libressl_config.libressl_a[:libtls_a],
                                             libressl_include_dir: libressl_config.libressl_include_dir)

namespace :musl_mruby do
  desc 'Build the final executable which is statically linked against musl'
  task compile: %i[libressl:libressl_a mruby:libmruby] do
    sh musl_mruby_config.compile_musl_mruby_cmd
    sh "strip #{musl_mruby_config.executable}"
    sh "file #{musl_mruby_config.executable}"
  end

  desc 'Remove the final executable'
  task :clean do
    FileUtils.rm_rf(musl_mruby_config.executable)
  end
end

namespace :mruby do
  desc 'Build libmruby.a'
  task libmruby: :config do
    sh musl_mruby_config.compile_libmruby_cmd unless File.exist?(musl_mruby_config.libmruby_a)
  end

  desc 'Configure MRuby'
  task config: :source do
    musl_mruby_config.install_config
  end

  desc 'Fetch MRuby git source'
  task :source do
    sh musl_mruby_config.fetch_mruby_git_source_cmd unless File.exist?(musl_mruby_config.mruby_source_dir)
  end

  desc 'Remove MRuby build directory'
  task :clean do
    FileUtils.rm_rf(musl_mruby_config.mruby_build_dir)
  end

  desc 'Remove MRuby build and source directory'
  task :clobber do
    FileUtils.rm_rf(musl_mruby_config.mruby_source_dir)
    FileUtils.rm_rf(musl_mruby_config.mruby_build_dir)
  end
end

namespace :libressl do
  desc 'Install LibreSSL'
  task libressl_a: :config do
    FileUtils.mkdir_p libressl_config.libressl_install_dir

    unless File.exist?(libressl_config.libressl_cert) &&
           File.exist?(libressl_config.libressl_a[:libtls_a]) &&
           File.exist?(libressl_config.libressl_a[:libssl_a]) &&
           File.exist?(libressl_config.libressl_a[:libcrypto_a])
      sh libressl_config.install_libressl_cmd
      FileUtils.cp libressl_config.libressl_cert, libressl_config.build_dir
    end
  end

  desc 'Build LibreSSL'
  task build: :config do
    sh libressl_config.build_libressl_cmd
  end

  desc 'Configure LibreSSL'
  task config: :source do
    FileUtils.mkdir_p libressl_config.libressl_build_dir

    sh libressl_config.autogen_cmd
    sh libressl_config.configure_cmd
  end

  desc 'Fetch LibreSSL git source'
  task :source do
    sh libressl_config.fetch_libressl_git_source_cmd unless File.exist?(libressl_config.libressl_source_dir)
  end

  desc 'Remove LibreSSL artifacts'
  task :clean do
    FileUtils.rm_rf(libressl_config.libressl_build_dir)
    FileUtils.rm_rf(libressl_config.libressl_install_dir)
  end

  desc 'Remove LibreSSL source and artifacts'
  task :clobber do
    FileUtils.rm_rf(libressl_config.libressl_source_dir)
    FileUtils.rm_rf(libressl_config.libressl_build_dir)
    FileUtils.rm_rf(libressl_config.libressl_install_dir)
  end
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/*_test.rb'].exclude('test/scripts')
  t.verbose = true
end

# Global commands

desc 'Show build configuration'
task :show do
  libressl_config.show
  musl_mruby_config.show
end

task build: 'musl_mruby:compile'

task clean: %i[mruby:clean musl_mruby:clean libressl:clean]

task clobber: %i[mruby:clobber musl_mruby:clean libressl:clobber] do
  FileUtils.rm_rf(musl_mruby_config.build_dir)
end

task lint: 'rubocop:auto_correct'

task default: %i[lint build test]
