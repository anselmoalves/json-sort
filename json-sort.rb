require 'json'

def sort!(json)
  # TODO: replace switch case by array of functions
  case json
  when Array
    if json.empty?
      return
    else
      json.sort_by! do |e|
        e.keys.map { |key| e[key].to_s.strip.downcase }
         .join('')
      end
      return
    end
  when Hash
    json[json.keys.first].sort!
  end
end
