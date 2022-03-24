# frozen_string_literal: true

require_relative 'test_helper'

class MuslMRubySSHTest < Minitest::Test
  def test_basic_ssh
    #result = musl_mruby_run('ssh.rb')

    #assert_equal(0, result[:exit])

    warn '- mruby-ssh is disabled -'
    skip
  end
end
