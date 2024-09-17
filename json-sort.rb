require 'json'

def sort(json)
  # TODO: replace switch case by array of functions

  if json.nil?
    return json
  end

  if json == ''
    return json
  end

  object = JSON.parse json
  sorted_object = sort_object object
  sorted_object.to_json
end

def sort_object(object)
  case object
  when Array
    if object.empty?
      return object
    end
    if object.first.is_a? Array
      return object.map { |e| sort_object(e) }
    end
    return object.sort_by do |e|
      e.is_a?(String) ? e : e.keys.map { |key| e[key].to_s.strip.downcase }
                             .join('')
    end
  when Hash
    if object.empty?
      return object
    end
    if object[object.keys.first].is_a? String
      return Hash[object.sort_by { |key, value| key }]
    end
    if !object[object.keys.first].is_a? Array
      return object
    end
    object[object.keys.first].sort!
    return object
  end
end
