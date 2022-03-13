-- Copyright (c) 2020-2022 André Luiz Alvares
-- tlpages is licensed under the MPL 2.0 license.
-- Please refer to the LICENSE file for details
-- SPDX-License-Identifier: MPL-2.0

local tag = require 'tlpages.tag'

local type Attritutes = {string:string}

local record Element
  is_void: boolean
  name: string
  attributes: Attritutes
  content: string | {Element}
end

local function render_level(level: integer): string
  return string.rep('  ', level)
end

function Element:render(level: integer): string
  local opening_tag = tag.render_opening_tag(self.name, self.attributes)

  if self.is_void then
    return opening_tag
  else
    local function render_content(content: string | {Element}, lvl: integer): string
      if not content then
        return ''
      end

      if content is string then
        return content
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
