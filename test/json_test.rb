# frozen_string_literal: true

require_relative 'test_helper'

class MuslMRubyJSONTest < Minitest::Test
  def test_basic_json
    result = musl_mruby_run('json.rb')

    assert_equal(0, result[:exit])
  end
end
