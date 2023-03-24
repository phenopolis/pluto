require "./pluto"
require "./lib-formats/webp"

{% for sub in Pluto::Image.subclasses %}
class {{sub}}
  include Pluto::Format::WebP
end
{% end %}
