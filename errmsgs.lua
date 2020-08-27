local errmsgs = {}

function errmsgs.simple_wrongtypes(varname, types_expected, type_got)
  local t_expected_msg = table.concat(types_expected, "' or '")
  return string.format(
    "incorrect type on '%s' parameter, '%s' expected, got '%s'",
    varname, t_expected_msg, type_got
  )
end

function errmsgs.multiple_msgs(errmsgs)
  return string.format(
    'got %d error%s:\n  - %s',
    #errmsgs,
    #errmsgs > 1 and 's' or '',
    table.concat(errmsgs, '\n  - ')
  )

end

return errmsgs
