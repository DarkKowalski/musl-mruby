# frozen_string_literal: true

class MuslMRubyBuildConfig
  attr_reader :cc, :build_dir, :make_args, :executable,
              :http_proxy, :mruby_source, :mruby_git_branch, :mruby_git_source,
              :libssl_a, :libtls_a, :libcrypto_a, :libressl_include_dir

  def initialize(cc: 'musl-gcc',
                 build_dir: 'build',
                 executable: 'musl-mruby',
                 http_proxy: nil,
                 mruby_git_source: 'https://github.com/mruby/mruby',
                 mruby_git_branch: 'stable',
                 libssl_a: nil,
                 libtls_a: nil,
                 libcrypto_a: nil,
                 libressl_include_dir: nil)
    @cc = cc
    @build_dir = File.absolute_path(File.join('.', build_dir))
    @executable = File.absolute_path(File.join(@build_dir, executable))
    @http_proxy = http_proxy
    @mruby_git_source = mruby_git_source
    @mruby_git_branch = mruby_git_branch
    @libssl_a = libssl_a
    @libtls_a = libtls_a
    @libcrypto_a = libcrypto_a
    @libressl_include_dir = libressl_include_dir
  end

  def show
    config = {
      cc: @cc,
      http_proxy: @http_proxy,
      mruby_git_source: @mruby_git_source,
      mruby_git_branch: @mruby_git_branch,
      build_dir: @build_dir,
      mruby_source_dir: mruby_source_dir,
      mruby_include_dir: mruby_include_dir,
      libmruby_a: libmruby_a,
      libssl_a: @libssl_a,
      libtls_a: @libtls_a,
      libcrypto_a: @libcrypto_a,
      libressl_include_dir: @libressl_include_dir,
      executable: @executable
    }

    pp config

    config
  end

  def c_entry
    File.absolute_path(File.join('src', 'main.c'))
  end

  def mruby_source_dir
    File.absolute_path(File.join(@build_dir, 'mruby'))
  end

  def mruby_include_dir
    File.absolute_path(File.join(mruby_source_dir, 'include'))
  end

  def mruby_build_dir
    File.absolute_path(File.join(mruby_source_dir, 'build'))
  end

  def libmruby_a
    File.absolute_path(File.join(mruby_build_dir, 'host', 'lib', 'libmruby.a'))
  end

  def install_config(config: 'musl_linux_amd64.rb')
    from = File.absolute_path(File.join('build_config', config))
    to = File.absolute_path(File.join(mruby_source_dir, 'build_config', 'default.rb'))
    default = File.absolute_path(File.join(mruby_source_dir, 'build_config'))

    FileUtils.rm_rf(default)
    FileUtils.mkdir_p(default)
    FileUtils.cp(from, to)
  end

  def compile_libmruby_cmd
    "cd #{mruby_source_dir} && https_proxy=#{@http_proxy} rake all -j"
  end

  def compile_musl_mruby_cmd
    "#{@cc} -std=c99 -Wl,-Bstatic -I#{mruby_include_dir} -I#{@libressl_include_dir} #{c_entry} #{libmruby_a} #{@libssl_a} #{@libtls_a} #{@libcrypto_a} -lm -static -o #{@executable}"
  end

  def fetch_mruby_git_source_cmd
    "https_proxy=#{@http_proxy} git clone #{@mruby_git_source} #{mruby_source_dir} -b #{@mruby_git_branch}"
  end
end
