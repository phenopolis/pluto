require "./pluto"
require "./lib-formats/jpeg"

{% for sub in Pluto::Image.subclasses %}
class {{sub}}
  include Pluto::Format::JPEG
end
{% end %}
