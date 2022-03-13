-- Copyright (c) 2020-2022 André Luiz Alvares
-- tlpages is licensed under the MPL 2.0 license.
-- Please refer to the LICENSE file for details
-- SPDX-License-Identifier: MPL-2.0

local tag = {}

local type Attritutes = {string:string}

function tag.render_attributes(attributes: Attritutes): string
  if not attributes then
    return ''
  end

  local result: {string} = {}

  for k, v in pairs(attributes) do
    table.insert(result, k .. '="' .. v .. '"') -- key="value"
  end

  if #result > 0 then
    table.insert(result, 1, '')
  end

  return table.concat(result, ' ')
end

function tag.render_opening_tag(name: string, attributes: Attritutes): string
  return '<' .. name .. tag.render_attributes(attributes) .. '>' -- <foo bar="baz">
end

function tag.render_closing_tag(name: string): string
  return '</' .. name .. '>' -- </foo>
end

return tag
