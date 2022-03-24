# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
require 'open3'

Minitest::Reporters.use! [Minitest::Reporters::SpecReporter.new]

# A simple wrapper for musl_mruby CLI
def musl_mruby_run(script = nil, options: nil)
  executable = File.absolute_path(File.join(File.dirname(__FILE__), '..', 'build', 'musl-mruby'))
  scripts = File.absolute_path(File.join(File.dirname(__FILE__), 'scripts'))
  script =  File.absolute_path(File.join(scripts, script))

  return unless File.exist?(executable) && File.exist?(script)

  result = {}
  cmd = [executable, options, script].compact.join(' ')
  result[:cmd] = cmd

  Open3.popen3(cmd) do |_stdin, stdout, stderr, thread|
    result[:stdout] = stdout.read
    result[:stderr] = stderr.read

    result[:pid] = thread[:pid].to_i
    result[:exit] = thread.value.to_i
  end

  result
end
