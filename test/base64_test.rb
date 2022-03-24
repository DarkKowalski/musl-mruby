# frozen_string_literal: true

require_relative 'test_helper'

class MuslMRubyBase64Test < Minitest::Test
  def test_basic_base64
    result = musl_mruby_run('base64.rb')

    assert_equal(0, result[:exit])
  end
end
