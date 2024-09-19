require 'json'

def sort(json)
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
    object.sort_by! do |e|
      case e
      when Array
        sort_object e
      when Hash
        sort_object e
        e.keys.map { |key| "#{key.to_s}#{e[key.to_s].to_s}" }.join
      else
        sort_object(e).to_s
      end
    end
  when Hash
    Hash[object.map do |key, value|
      [key, sort_object(value)]
    end.to_h.sort_by { |key, value| key }].map do |key, value|
      object.delete key
      object[key] = value
    end
  end
  object
end

ARGV.each do |filename|
  json = File.read filename
  sorted_json = sort json
  File.open(filename, 'w') { |file| file.write JSON.pretty_generate JSON.parse sorted_json }
end
