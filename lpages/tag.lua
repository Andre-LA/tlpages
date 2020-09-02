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
    return tag.closeable and string.format('</%s>', tag.name) or ''
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
    return false, 'tag parameter is not a table'
  end

  if not tag.name then
    return false, "the tag parameter doesn't contains the 'name' field"
  end

  local errors = {}

  local t_name = type(tag.name)
  local name_is_correct = t_name == 'string'

  local t_closeable = type(tag.closeable)
  local closeable_is_correct = t_closeable == 'boolean'

  if name_is_correct and closeable_is_correct then
    return tag
  else
    if not name_is_correct then
      table.insert(errors, errmsgs.simple_wrongtypes('tag.name', {'string'}, t_name))
    end

    if not closeable_is_correct then
      table.insert(errors, errmsgs.simple_wrongtypes('tag.closeable', {'boolean'}, t_name))
    end

    return false, errmsgs.multiple_msgs(errors)
  end
end

function Tag.new(name, closeable)
  local tag_table = {
    name = name,
    closeable = closeable or false,
  }

  local ok_tag, err = Tag.is_tag(tag_table)
  assert(ok_tag, err)

  return setmetatable(ok_tag, Tag_mt)
end

return Tag
