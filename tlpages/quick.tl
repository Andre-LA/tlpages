local Element = require 'tlpages.element'

local type Attritutes = {string:string}

local type QuickBuilder = function(elements: string | { string | Element }, attributes: Attritutes): Element

local Quick = function (element_name: string): QuickBuilder
  assert(element_name, "Quick: `element_name` must be given!")

  return function(content: string | { string | Element }, attributes: Attritutes): Element
    return Element.new {
      name = element_name,
      attributes = attributes,
      content = content
    }
  end
end

return Quick
