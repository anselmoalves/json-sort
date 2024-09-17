require 'json'
require './json-sort'
require 'test/unit'
require 'test/unit/ui/console/testrunner'

class TestDecorator < Test::Unit::TestSuite

  def initialize(test_case_class)
    super
    self << test_case_class.suite
  end

  def run(result, &progress_block)
    setup_suite
    begin
      super(result, &progress_block)
    ensure
      tear_down_suite
    end
  end
end

class JsonSortTest < Test::Unit::TestCase

  def test_when_the_json_is_nil__do_nothing
    object = nil

    sort! object

    assert_equal nil, object
  end

  def test_when_the_json_is_an_empty_array__do_nothing
    object = []

    sort! object

    assert_equal [], object
  end

  def test_when_the_json_is_an_array_of_two_hashes_of_string_values_with_a_single_key__sort_the_array
    object = [{ 'k': 'b' }, { 'k': 'a' }]

    sort! object

    assert_equal [{ 'k': 'a' }, { 'k': 'b' }], object
  end

  def test_when_the_json_is_an_array_of_two_hashes_of_string_values_with_multiple_keys__sort_the_array
    object = [{ 'k1': 'a', 'k2': 'c' }, { 'k1': 'a', 'k2': 'b' }]

    sort! object

    assert_equal [{ 'k1': 'a', 'k2': 'b' }, { 'k1': 'a', 'k2': 'c' }], object
  end

  def test_when_the_json_is_a_hash_of_strings__sort_the_hash_by_keys
    object = { 'k': 'a' }

    sort! object

    assert_equal ({ 'k': 'a' }), object
  end

  def test_when_the_json_is_a_hash_of_array_values__sort_the_array
    object = { 'k': ['b' , 'a'] }

    sort! object

    assert_equal ({ 'k': ['a' , 'b'] }), object
  end
end

class Suite < TestDecorator

  def setup_suite
    puts 'setup_suite'
  end

  def tear_down_suite
    puts 'tear_down_suite'
  end
end

Test::Unit::UI::Console::TestRunner.run Suite.new(JsonSortTest)
Test::Unit::TestSuite.new 'Json sort tests'
