-- Copyright (c) 2020-2022 André Luiz Alvares
-- tlpages is licensed under the MPL 2.0 license.
-- Please refer to the LICENSE file for details
-- SPDX-License-Identifier: MPL-2.0

local Quick = require 'tlpages.quick'

local DOCTYPE = Quick '!DOCTYPE html' (nil)

local page = (
  Quick 'html' {
    Quick 'head' {
      Quick 'meta' (nil, {charset = 'utf-8'}),
      Quick 'title' 'My Page',
    },

    Quick 'body' {
      Quick 'p' ('blablabla'),
      Quick 'p' ('blablabla2\n'),
      Quick 'p' ('bla bla \n bla blabla3'),
      Quick 'p' ('bla bla \n bla blabla4\n'),
      Quick 'img' (nil, {alt = "Without image yet"})
    }
  }
)

local file <close> = assert(io.open('test.html', 'w'), "file 'test.html' not found")
file:write(table.concat({ DOCTYPE:render(), page:render() }, '\n'))


