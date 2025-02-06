# json-sort.rb

def sort(object)
  return object if object.nil? || object == ''

  # Parse the JSON string into a Ruby object if it's a string
  parsed_object = object.is_a?(String) ? JSON.parse(object) : object

  # Recursively sort the object
  sorted_object = recursive_sort(parsed_object)

  # Convert back to JSON if the input was a JSON string
  object.is_a?(String) ? JSON.generate(sorted_object) : sorted_object
end

def recursive_sort(obj)
  case obj
  when Array
    # Sort arrays, recursively sorting their elements
    obj.map { |item| recursive_sort(item) }.sort_by { |item| item.to_s }
  when Hash
    # Sort hashes by keys, recursively sorting their values
    sorted_hash = {}
    obj.keys.sort.each do |key|
      sorted_hash[key] = recursive_sort(obj[key])
    end
    sorted_hash
  else
    # Return non-array, non-hash objects as-is
    obj
  end
end
