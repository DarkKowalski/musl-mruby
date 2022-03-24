# frozen_string_literal: true

class LibreSSLBuildConfig
  attr_reader :cc, :http_proxy, :libressl_git_source, :libressl_git_branch, :build_dir

  def initialize(cc: 'musl-gcc',
                 build_dir: 'build',
                 http_proxy: nil,
                 libressl_git_source: 'https://github.com/libressl-portable/portable',
                 libressl_git_branch: 'OPENBSD_6_8')

    @cc = cc
    @http_proxy = http_proxy
    @libressl_git_source = libressl_git_source
    @libressl_git_branch = libressl_git_branch
    @build_dir = build_dir
  end

  def show
    config = {
      cc: cc,
      http_proxy: http_proxy,
      libressl_git_source: libressl_git_source,
      libressl_git_branch: libressl_git_branch,
      build_dir: build_dir,
      libressl_a: libressl_a,
      libressl_cert: libressl_cert,
      libressl_include_dir: libressl_include_dir,
      libressl_source_dir: libressl_source_dir
    }

    pp config

    config
  end

  def libressl_source_dir
    File.absolute_path(File.join(build_dir, 'libressl'))
  end

  def libressl_build_dir
    File.absolute_path(File.join(libressl_source_dir, 'build'))
  end

  def libressl_install_dir
    File.absolute_path(File.join(libressl_build_dir, 'install'))
  end

  def libressl_include_dir
    File.absolute_path(File.join(libressl_install_dir, 'usr', 'local', 'include'))
  end

  def libressl_a
    {
      libtls_a: File.absolute_path(File.join(libressl_install_dir, 'usr', 'local', 'lib', 'libtls.a')),
      libssl_a: File.absolute_path(File.join(libressl_install_dir, 'usr', 'local', 'lib', 'libssl.a')),
      libcrypto_a: File.absolute_path(File.join(libressl_install_dir, 'usr', 'local', 'lib', 'libcrypto.a'))
    }
  end

  def libressl_cert
    File.absolute_path(File.join(libressl_build_dir, 'install.', 'cert.pem'))
  end

  def fetch_libressl_git_source_cmd
    "https_proxy=#{@http_proxy} git clone #{@libressl_git_source} #{libressl_source_dir} -b #{@libressl_git_branch}"
  end

  def autogen_cmd
    "cd #{libressl_source_dir} && https_proxy=#{@http_proxy} ./autogen.sh"
  end

  def configure_cmd
    "cd #{libressl_build_dir} && CC=#{@cc} ../configure --disable-shared --with-openssldir=. "
  end

  def build_libressl_cmd
    "cd #{libressl_build_dir} && make -j"
  end

  def install_libressl_cmd
    "cd #{libressl_build_dir} && DESTDIR=#{libressl_install_dir} make install -j -o install-exec-hook"
  end
end
