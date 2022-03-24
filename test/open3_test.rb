# frozen_string_literal: true

require_relative 'test_helper'

class MuslMRubyOpen3Test < Minitest::Test
  def test_basic_open3
    result = musl_mruby_run('open3.rb')

    assert_equal(0, result[:exit])
  end
end
