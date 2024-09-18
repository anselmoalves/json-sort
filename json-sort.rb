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
  when String
    return object
  when Array
    if object.empty?
      return object
    end

    object.sort_by do |e|
      case e
      when String
        sort_object e
      when Array
        sort_object e
      when Hash
        e.keys.map { |key| e[key].to_s.strip.downcase }
         .join('')
      end
    end
  when Hash
    if object.empty?
      return object
    end

    Hash[object.map do |key, value|
      [key, sort_object(value)]
    end.to_h.sort_by { |key, value| key }]
  end
end
