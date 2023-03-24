require "./pluto"
require "./lib-formats/png"

{% for sub in Pluto::Image.subclasses %}
class {{sub}}
  include Pluto::Format::PNG
end
{% end %}
