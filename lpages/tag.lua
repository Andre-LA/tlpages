-- Tag module
-- about tags: https://developer.mozilla.org/en-US/docs/Glossary/tag
--
-- tag table shape:
-- {
--   name = 'tag name',
-- }
local errmsgs = require 'errmsgs'

local function tag_to_string(tag, is_closing_tag, attributes)
  if is_closing_tag then
    return string.format('</%s>', tag.name)
  else
    -- attributes to string
    if attributes then
      local attributes_str = {}
      local n = 0

      for attr_name, attr_vl in pairs(attributes) do
        n = n + 1
        if attr_vl ~= true then
          attributes_str[n] = string.format('%s="%s"', attr_name, attr_vl)
        else -- empty attribute, same as '%s=""'
          attributes_str[n] = string.format('%s', attr_name)
        end
      end

      return string.format('<%s %s>', tag.name, table.concat(attributes_str, ' '))
    else
      return string.format('<%s>', tag.name)
    end
  end
end

local Tag = {}
local Tag_mt = {__index = Tag, __tostring = tag_to_string }

Tag.tostring = tag_to_string

function Tag.is_tag(tag)
  if type(tag) ~= 'table' then
    return false, 'is not a table'
  end

  if not tag.name then
    return false, "doesn't contains the 'name' field"
  end

  local t_name = type(tag.name)
  local name_is_correct = t_name == 'string'

  if name_is_correct then
    return tag
  else
    return false, errmsgs.simple_wrongtypes('name', {'string'}, t_name)
  end
end

function Tag.new(name)
  local tag_table = {
    name = name
  }

  local ok_tag, err = Tag.is_tag(tag_table)
  assert(ok_tag, err)

  return setmetatable(ok_tag, Tag_mt)
end

return Tag
