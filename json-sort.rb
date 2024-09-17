require 'json'

def sort(json)
  # TODO: replace switch case by array of functions

  if (json.nil?)
    return json
  end

  if (json == '')
    return json
  end

  object = JSON.parse json

  case object
  when Array
    if object.empty?
      return object.to_json
    end
    object.sort_by! do |e|
      e.is_a?(String) ? e : e.keys.map { |key| e[key].to_s.strip.downcase }
                             .join('')
    end
  when Hash
    if (object.empty?)
      return object.to_json
    end
    if (object[object.keys.first].is_a?(String))
      object = Hash[object.sort_by { |key, value| key }]
    end
    if (!object[object.keys.first].is_a?(Array))
      return object.to_json
    end
    object[object.keys.first].sort!
  end

  object.to_json
end
