require "./pluto"
require "./lib-formats/png"

{% for subclass in Pluto::Image.subclasses %}
class {{subclass}}
  include Pluto::Format::PNG
end
{% end %}
