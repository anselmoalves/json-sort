# json-sort.rb
require 'json'

def sort_value(value)
  if value.is_a?(Array)
    if value.empty?
      value
    else
      value.map { |v| sort_value(v) }.sort_by { |x|
        case x
        when Numeric
          0
        when String
          1
        when TrueClass, FalseClass
          2
        when Hash
          3
        when Array
          4
        else
          5
        end
      }
    end
  elsif value.is_a?(Hash)
    sorted_hash = {}
    value.keys.sort.each { |k| sorted_hash[k] = sort_value(value[k]) }
    sorted_hash
  else
    value
  end
end

def sort(json_string)
  return json_string if json_string.nil? || json_string.empty?
  begin
    object = JSON.parse(json_string)
  rescue JSON::ParserError
    return json_string
  end

  sorted_object = sort_value(object)
  sorted_json = JSON.generate(sorted_object)

  # For cases where input and output are the same, return input string to
  # match "do nothing" expectation where possible.
  if JSON.parse(sorted_json) == object
    return json_string
  else
    return sorted_json
  end
rescue JSON::ParserError
  return json_string
end
