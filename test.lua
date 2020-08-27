local lpages = require 'lpages'
local elements = lpages.elements

local tags = {
  html = lpages.tag.new'html',
  body = lpages.tag.new'body',
  img = lpages.tag.new'img',
}

local page = elements.html{
  elements.head{
    elements.meta{charset = 'utf-8'},
    elements.title'Minha página de teste'
  },
  elements.body{
    elements.img{src = '', alt = 'Minha imagem de teste'}
  },
}

local html_str = '<!DOCTYPE html>\n' .. tostring(page)
io.open('test.html', 'w'):write(html_str):close()
