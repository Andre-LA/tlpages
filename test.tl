-- Copyright (c) 2020-2022 André Luiz Alvares
-- tlpages is licensed under the MPL 2.0 license.
-- Please refer to the LICENSE file for details
-- SPDX-License-Identifier: MPL-2.0

local Element = require 'tlpages.element'

print(
  Element.render(
    { name = 'html', content = {
        { name = 'head', content = {
            { name = 'meta', attributes = {charset='utf-8'}, is_void = true, content = '' },
            { name = 'title', content = 'MyPage' }
          }
        },
        { name = 'body', content = {
            {name = 'img', attributes = {alt = "My image doesn't exists yet :)"}, is_void = true}
          }
        }
      }
    },

    0
  )
)
