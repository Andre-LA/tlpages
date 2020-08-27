-- Tag and Element modules
--
-- about elements: https://developer.mozilla.org/en-US/docs/Glossary/element
-- about attributes: https://developer.mozilla.org/en-US/docs/Glossary/attribute
--
-- element table shape:
-- {
--   tag = tag, -- check ltag.lua
--   attributes = attributes,
--   content = 'enclosed content' -- child elements go here to as a array table
-- }
local ltag = require 'lpages.tag'
local errmsgs = require 'errmsgs'

local function element_to_string(element, level)
  local tag = element.tag
  level = level or 0
  local indentation = string.rep('  ', level)
  local next_indentation = string.rep('  ', level+1)

  local element_len = #element
  local is_string_content = element_len > 0 and type(element[1]) == 'string'
  local element_content = {}

  if is_string_content then
    element_content[1] = element[1]
  else
    for i = 1, element_len do
      table.insert(element_content, '\n' .. next_indentation .. element[i]:tostring(level + 1))
    end
  end

  local tag_str = tag:tostring(false, element.attributes)
  local content_str = table.concat(element_content)
  local closing_tag = #element > 0 and tag:tostring(true) or ''

  if not is_string_content and #closing_tag > 0 then
    closing_tag = '\n' .. indentation .. closing_tag
  end

  return string.format('%s%s%s', tag_str, content_str, closing_tag)
end

local Element = {}
local Element_mt = { __index = Element, __tostring = element_to_string }

Element.tostring = element_to_string

--- returns if it contains any content
function Element:contains_content()
  return #self > 0
end

function Element.is_element(element)
  local errors = {}

  if type(element) ~= 'table' then
    return false, 'is not a table'
  end

  if not element.tag then
    return false, "doesn't contains the 'tag' field"
  end

  -- check tag
  local is_tag, tag_err = ltag.is_tag(element.tag)
  if not is_tag then
    table.insert(errors, tag_err)
  end

  -- check attributes
  local t_attributes = type(element.attributes)
  if t_attributes ~= 'table' and t_attributes ~= 'nil' then
    table.insert(errors, errmsgs.simple_wrongtypes('attributes', {'table', 'nil'}, t_attributes))
  end

  -- check content
  for i = 1, #element do
    local i_type = type(element[i])

    if i == 1 then
      if i_type ~= 'string' and i_type ~= 'table' then
        table.insert(errors, errmsgs.simple_wrongtypes("elements[1]", {'string', 'table'}, i_type))
      end
    else
      if i_type ~= 'table' then
        table.insert(errors, errmsgs.simple_wrongtypes("elements[" .. i .. "]", {'table'}, i_type))
      end
    end
  end

  if #errors == 0 then
    return element
  else
    return false, errmsgs.multiple_msgs(errors)
  end
end

function Element.new(tag, attributes_or_content, ...)
  local using_attributes = (
    attributes_or_content and -- is not nil
    type(attributes_or_content) == 'table' and  -- is not a (string) content
    #attributes_or_content == 0 and -- doens't contains array elements
    Element.is_element(attributes_or_content) == false -- is not nested elements
  )

  local element_table = {
    tag = tag,
    attributes = using_attributes and attributes_or_content or nil,
  }

  local content = {...}
  if not using_attributes then
    table.insert(content, 1, attributes_or_content)
  end
  table.move(content, 1, #content, 1, element_table)

  local ok_element, err = Element.is_element(element_table)
  assert(ok_element, err)

  return setmetatable(ok_element, Element_mt)
end

return Element
