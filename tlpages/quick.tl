local Element = require 'tlpages.element'

local type Attritutes = {string:string}

local type QuickBuilder = function(elements: string | {Element}, attributes: Attritutes): Element

return function (element_name: string): QuickBuilder
  local fn = function(content: string | {Element}, attributes: Attritutes): Element
    local element: Element = {
      is_void = content == nil,
      name = element_name,
      attributes = attributes,
      content = content
    }
    return element
  end

  return fn
end
