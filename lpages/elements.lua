local errmsgs = require 'errmsgs'
local element, tag = require 'lpages.element', require 'lpages.tag'

local tags = {
  html = tag.new'html',

  head = tag.new'head',
  meta = tag.new'meta',
  title = tag.new'title',

  body = tag.new'body',
  img = tag.new'img',
}

local elements = {}

function elements.html(html_elements)
  local errors = {}

  local t_html_elements = type(html_elements)
  local html_elements_is_table, err_html_elements_is_table = t_html_elements == 'table', errmsgs.simple_wrongtypes('html_elements', {'table'}, t_html_elements)

  if not html_elements_is_table then
    table.insert(errors, err_html_elements_is_table)
    error(errmsgs.multiple_msgs(errors))
  end

  local html_contains_2_elements, err_html_contains_2_elements = #html_elements == 2, ('html_elements must contains 2 elements, got ' .. #html_elements)

  if not html_contains_2_elements then
    table.insert(errors, err_html_contains_2_elements)
  end

  local html_1st_is_element, err_html_1st_is_element = element.is_element(html_elements[1])

  if html_1st_is_element then
    local html_1st_is_head, err_html_1st_is_head = html_elements[1].tag.name == 'head', 'html_elements[1].tag is not an <head> tag'
    if not html_1st_is_head then
      table.insert(errors, err_html_1st_is_head)
    end
  else
    table.insert(errors, err_html_1st_is_element)
  end

  local html_2nd_is_element, err_html_2nd_is_element = element.is_element(html_elements[1])

  if html_2nd_is_element then
    local html_2nd_is_body, err_html_2nd_is_body = html_elements[2].tag.name == 'body', 'html_elements[2].tag is not an <body> tag'
    if not html_2nd_is_body then
      table.insert(errors, err_html_2nd_is_body)
    end
  else
    table.insert(errors, err_html_2nd_is_element)
  end

  if #errors > 0 then
    error(errmsgs.multiple_msgs(errors))
  end

  return element.new(tags.html, html_elements[1], html_elements[2])
end

function elements.head(head_elements)
  local t_head_elements = type(head_elements)
  assert(t_head_elements == 'table', errmsgs.simple_wrongtypes('head_elements', {'table'}, t_head_elements))

  for i = 1, #head_elements do
    assert(element.is_element(head_elements[i]), errmsgs.simple_wrongtypes('head_elements['..i..']', {'Element'}, type(head_elements[i])))
  end

  return element.new(tags.head, table.unpack(head_elements))
end

function elements.title(title)
  local t_title = type(title)
  assert(t_title == 'string', errmsgs.simple_wrongtypes('title', {'string'}, t_title))

  return element.new(tags.title, title)
end

function elements.meta(meta_attributes)
  local t_meta_attributes = type(meta_attributes)
  assert(t_meta_attributes == 'table', errmsgs.simple_wrongtypes('meta_attributes', {'table'}, t_meta_attributes))

  return element.new(tags.meta, meta_attributes)
end

function elements.body(body_elements)
  local t_body_elements = type(body_elements)
  assert(t_body_elements == 'table', errmsgs.simple_wrongtypes('body_elements', {'table'}, t_body_elements))

  for i = 1, #body_elements do
    assert(element.is_element(body_elements[i]), errmsgs.simple_wrongtypes('body_elements['..i..']', {'Element'}, type(body_elements[i])))
  end

  return element.new(tags.body, table.unpack(body_elements))
end

function elements.img(img_attributes)
  local t_img_attributes = type(img_attributes)
  assert(t_img_attributes == 'table', errmsgs.simple_wrongtypes('img_attributes', {'table'}, t_img_attributes))

  if img_attributes.alt then
    local t_alt = type(img_attributes.alt)
    assert(t_alt == 'string', errmsgs.simple_wrongtypes('img_attributes.alt', {'string'}, t_alt))
  end

  return element.new(tags.img, img_attributes)
end

return elements
