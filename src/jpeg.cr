require "./pluto"
require "./lib-formats/jpeg"

{% for subclass in Pluto::Image.subclasses %}
class {{subclass}}
  include Pluto::Format::JPEG
end
{% end %}
