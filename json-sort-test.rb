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

    result = sort object

    assert_equal object, result
  end

  def test_when_the_json_is_an_empty_string__do_nothing
    object = ''

    result = sort object

    assert_equal object, result
  end

  def test_when_the_json_is_an_empty_array__do_nothing
    object = [].to_json

    result = sort object

    assert_equal object, result
  end

  def test_when_the_json_is_an_array_of_strings_with_a_single_entry__do_nothing
    object = ['a'].to_json

    result = sort object

    assert_equal object, result
  end

  def test_when_the_json_is_a_nested_array_of_strings_with_a_single_entry__do_nothing
    object = [['a']].to_json

    result = sort object

    assert_equal object, result
  end

  def test_when_the_json_is_an_array_of_a_hashes_of_strings_with_a_single_entry__do_nothing
    object = [{ 'k': 'a' }].to_json

    result = sort object

    assert_equal object, result
  end

  def test_when_the_json_is_an_array_of_two_hashes_of_string_values_with_a_single_key__sort_the_array
    object = [{ 'k': 'b' }, { 'k': 'a' }].to_json

    result = sort object

    assert_equal [{ 'k': 'a' }, { 'k': 'b' }].to_json, result
  end

  def test_when_the_json_is_an_array_of_two_hashes_of_string_values_with_multiple_keys__sort_the_array
    object = [{ 'k1': 'a', 'k2': 'c' }, { 'k1': 'a', 'k2': 'b' }].to_json

    result = sort object

    assert_equal [{ 'k1': 'a', 'k2': 'b' }, { 'k1': 'a', 'k2': 'c' }].to_json, result
  end

  def test_when_the_json_is_an_empty_hash__do_nothing
    object = {}.to_json

    result = sort object

    assert_equal object, result
  end

  def test_when_the_json_is_a_hash_of_strings_with_a_single_entry__do_nothing
    object = { 'k': 'a' }.to_json

    result = sort object

    assert_equal object, result
  end

  def test_when_the_json_is_a_hash_of_strings__sort_the_hash_by_keys
    object = '{ "k": "a", "j": "b" }'

    result = sort object

    assert_equal '{"j":"b","k":"a"}', result
  end

  def test_when_the_json_is_a_hash_of_array_values__sort_the_array
    object = '{ "k": ["b", "a"] }'

    result = sort object

    assert_equal '{"k":["a","b"]}', result
  end
end

class Suite < TestDecorator

  def setup_suite
    puts 'setup_suite'
  end

  def tear_down_suite
    puts
    puts 'tear_down_suite'
  end
end

Test::Unit::UI::Console::TestRunner.run Suite.new(JsonSortTest)
Test::Unit::TestSuite.new 'Json sort tests'
