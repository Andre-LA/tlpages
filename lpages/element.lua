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

  local elements_count = 0
  local element_content = {}

  for i = 1, #element do
    local content_i_str;

    if type(element[i]) == 'string' then
      content_i_str = element[i]
    else
      elements_count = elements_count + 1
      content_i_str = element[i]:tostring(level + 1)
    end

    table.insert(element_content, '\n' .. next_indentation .. content_i_str)
  end

  local opening_tag = tag:tostring(false, element.attributes)
  local content = table.concat(element_content)
  local closing_tag = tag:tostring(true)
  if tag.closeable then
    closing_tag ='\n' .. indentation .. closing_tag
  end

  return string.format('%s%s%s', opening_tag, content, closing_tag)
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
  assert(is_tag, tag_err)

  -- check attributes
  local t_attributes = type(element.attributes)
  if t_attributes ~= 'table' and t_attributes ~= 'nil' then
    table.insert(errors, errmsgs.simple_wrongtypes('attributes', {'table', 'nil'}, t_attributes))
  end

  -- check content
  for i = 1, #element do
    local i_type = type(element[i])

    if i_type ~= 'string' and i_type ~= 'table' then
      table.insert(errors, errmsgs.simple_wrongtypes("elements[1]", {'string', 'table'}, i_type))
    end
  end

  if #errors == 0 then
    return element
  else
    return false, errmsgs.multiple_msgs(errors)
  end
end

function Element.new(tag, attributes, ...)
  local element_table = {
    tag = tag,
    attributes = attributes,
  }

  local content = {...}
  table.move(content, 1, #content, 1, element_table)

  local ok_element, err = Element.is_element(element_table)
  assert(ok_element, err)

  return setmetatable(ok_element, Element_mt)
end

return Element
