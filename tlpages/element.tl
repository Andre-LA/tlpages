-- Copyright (c) 2020-2022 André Luiz Alvares
-- tlpages is licensed under the MPL 2.0 license.
-- Please refer to the LICENSE file for details
-- SPDX-License-Identifier: MPL-2.0

local tag = require 'tlpages.tag'

local type Attritutes = {string:string}

local function render_level(level: integer): string
  return string.rep('  ', level)
end

local record Element
  name: string
  attributes: Attritutes
  content: string | {Element}
end

local Element_mt: metatable<Element> = {
  __index = Element
}

function Element.new(init: Element): Element
  assert(init, "Element.new: value `init` must be given!")
  assert(init.name, "Element.new: value `init.name` must be given!")

  return setmetatable(init, Element_mt)
end

function Element:render(level: integer): string
  if not level then
    level = 0
  end

  local opening_tag = tag.render_opening_tag(self.name, self.attributes)
  local is_void = self.content == nil

  if is_void then
    return opening_tag
  else
    local function render_content(content: string | {Element}, lvl: integer): string
      if not content then
        return ''
      end

      if content is string then
        local ends_with_nl = string.sub(content, -1) == '\n'
        if ends_with_nl then
          -- remove the new line ending character
          content = string.sub(content, 1, -2)
        end

        local contains_nl = string.find(content as string, '\n') ~= nil
        if contains_nl then
          -- add indentation to these new lines
          content = '\n' .. render_level(lvl) .. string.gsub(content as string, ' ?\n ?', '\n' .. render_level(lvl)) .. '\n' .. render_level(lvl-1)
        end

        return content as string
      else
        local result: {string} = {}

        for _, v in ipairs(content) do
          table.insert(result, Element.render(v, lvl))
        end

        if #result > 0 then
          table.insert(result, 1, '')
        end

        return table.concat(result, '\n' .. render_level(lvl)) .. '\n' .. render_level(lvl-1)
      end
    end

    local closing_tag = tag.render_closing_tag(self.name)
    local content = render_content(self.content, level + 1)
    return (
      opening_tag .. content .. closing_tag
    )
  end
end

return Element
