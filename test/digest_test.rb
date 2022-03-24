# frozen_string_literal: true

require_relative 'test_helper'

class MuslMRubyDigestTest < Minitest::Test
  def test_basic_digest
    result = musl_mruby_run('digest.rb')

    assert_equal(0, result[:exit])
  end
end
