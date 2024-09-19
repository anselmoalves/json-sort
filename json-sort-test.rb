require 'coverage.so'
Coverage.start
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

  def test_when_the_json_is_an_array_of_strings__sort_the_array
    object = ['b', 'a'].to_json

    result = sort object

    assert_equal ['a', 'b'].to_json, result
  end

  def test_when_the_json_is_an_array_of_numbers__sort_the_array
    object = [2, 1].to_json

    result = sort object

    assert_equal [1, 2].to_json, result
  end

  def test_when_the_json_is_an_array_of_booleans__sort_the_array
    object = [true, false].to_json

    result = sort object

    assert_equal [false, true].to_json, result
  end

  def test_when_the_json_is_an_array_of_numbers_and_string__sort_the_array
    object = ['a', 1].to_json

    result = sort object

    assert_equal [1, 'a'].to_json, result
  end

  def test_when_the_json_is_an_array_of_booleans_and_numbers__sort_the_array
    object = [false, 1].to_json

    result = sort object

    assert_equal [1, false].to_json, result
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

  def test_when_the_json_is_a_nested_array_of_strings__sort_the_inner_array
    object = [['b', 'a']].to_json

    result = sort object

    assert_equal [['a', 'b']].to_json, result
  end

  def test_when_the_json_is_a_three_level_nested_array_of_strings__sort_the_innermost_array
    object = [[['b', 'a']]].to_json

    result = sort object

    assert_equal [[['a', 'b']]].to_json, result
  end

  def test_when_the_json_is_an_array_of_a_hash_of_strings_with_a_single_entry__do_nothing
    object = [{ 'k': 'a' }].to_json

    result = sort object

    assert_equal object, result
  end

  def test_when_the_json_is_an_array_of_a_hash_of_array_of_strings__sort_the_array
    object = [{ 'k': { 'a': ['c', 'b'] } }].to_json

    result = sort object

    assert_equal [{ 'k': { 'a': ['b', 'c'] } }].to_json, result
  end

  def test_when_the_json_is_an_array_of_two_hashes_of_string_values_with_a_single_key__sort_the_array
    object = [{ 'k': 'b' }, { 'k': 'a' }].to_json

    result = sort object

    assert_equal [{ 'k': 'a' }, { 'k': 'b' }].to_json, result
  end

  def test_when_the_json_is_an_array_of_two_hashes_of_strings__sort_the_array
    object = [{ 'j': 'a', 'k': 'c' }, { 'j': 'a', 'k': 'b' }].to_json

    result = sort object

    assert_equal [{ 'j': 'a', 'k': 'b' }, { 'j': 'a', 'k': 'c' }].to_json, result
  end

  def test_when_the_json_is_an_array_of_hashes_of_hashes_of_strings__sort_the_hashes_by_keys
    object = '[{ "j": { "l": "a", "k": "b" } }]'

    result = sort object

    assert_equal '[{"j":{"k":"b","l":"a"}}]', result
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

  def test_when_the_json_is_a_hash_of_array_of_strings__sort_the_array
    object = '{ "k": ["b", "a"] }'

    result = sort object

    assert_equal '{"k":["a","b"]}', result
  end

  def test_when_the_json_is_a_hash_of_array_of_hash__sort_the_array
    object = '{ "k": [{ "l": "a", "j": "b" }] }'

    result = sort object

    assert_equal '{"k":[{"j":"b","l":"a"}]}', result
  end

  def test_when_the_json_is_a_nested_hash_of_strings_with_a_single_entry__do_nothing
    object = '{ "k": { "a": "b" } }'

    result = sort object

    assert_equal '{"k":{"a":"b"}}', result
  end

  def test_when_the_json_is_a_nested_hash_of_an_array_of_strings__sort_the_array
    object = '{ "k": { "a": ["c", "b"] } }'

    result = sort object

    assert_equal '{"k":{"a":["b","c"]}}', result
  end

  def test_when_the_json_is_a_nested_hash_of_an_array_of_hashes_of_string__sort_the_array
    object = '{ "k": { "a": [{ "j": "a", "k": "c" }, { "j": "a", "k": "b" }] } }'

    result = sort object

    assert_equal '{"k":{"a":[{"j":"a","k":"b"},{"j":"a","k":"c"}]}}', result
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

p Coverage.result
