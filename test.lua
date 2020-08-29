local lpages = require 'lpages'
local elements = lpages.elements

local page = elements.html{
  elements.head{
    elements.meta{charset = 'utf-8'},
    elements.title'My test page'
  },
  elements.body{
    elements.img{src = '', alt = 'My test image'}
  },
}

io.open('test.html', 'w')
  :write('<!DOCTYPE html>\n' .. tostring(page))
  :close()
