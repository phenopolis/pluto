require "./pluto"
require "./lib-formats/webp"

{% for subclass in Pluto::Image.subclasses %}
class {{subclass}}
  include Pluto::Format::WebP
end
{% end %}
