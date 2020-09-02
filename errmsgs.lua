local errmsgs = {}

function errmsgs.simple_wrongtypes(varname, types_expected, type_got)
  local t_expected_msg = table.concat(types_expected, "' or '")
  return string.format(
    "incorrect type on '%s' parameter, '%s' expected, got '%s'",
    varname, t_expected_msg, type_got
  )
end

function errmsgs.multiple_msgs(errmsgs)
  if #errmsgs == 1 then
    return errmsgs[1]
  else
    return string.format('got %d errors:\n  - %s', #errmsgs, table.concat(errmsgs, '\n  - '))
  end
end

return errmsgs
