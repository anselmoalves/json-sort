require 'json'

def sort(object)
  # Return the object as is for nil, empty string, or empty array
  return object if object.nil? || object == '' || object == [].to_json

  parsed_object = JSON.parse(object)

  # Check if the object is an array
  if parsed_object.is_a?(Array)
    # If array, recursively sort each item if necessary
    parsed_object = parsed_object.map { |item| item.is_a?(String) || item.is_a?(Numeric) || item.is_a?(TrueClass) || item.is_a?(FalseClass) ? item : sort(item.to_json) }
    # Sort the array itself
    parsed_object.sort!
    return parsed_object.to_json
  end

  # Check if the object is a hash
  if parsed_object.is_a?(Hash)
    # Recursively sort keys and values of the hash
    sorted_hash = parsed_object.sort.to_h
    sorted_hash.each do |key, value|
      sorted_hash[key] = value.is_a?(String) || value.is_a?(Numeric) || value.is_a?(TrueClass) || value.is_a?(FalseClass) ? value : sort(value.to_json)
    end
    return sorted_hash.to_json
  end

  # Return the object as is if it's neither an array nor a hash
  object
end
