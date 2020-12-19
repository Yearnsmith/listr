triage = ARGV.length

If ARGV.include?(state.flags)
  linemode = true
end

Case triage

When 4

raise ArgumentsError, “Invalid number of arguments”

When 3

if linemode
  flag =ARGV[0]
  list_title = ARGV[1]
  list_item = ARGV[2]

  if State.titles.files.include?(list_title)
    list = state.load_list(list_title)
    case flag
    when -a
      List.add_item(list_item)
     
    when -r
      List.remove_item(list_item)
    else
      raise ArgumentsError, "Invalid number of arguments"
    end
  elseif flag == "-a"
    state.create_list
  else
    raise error ArgumentError, ""Invalid number of arguments"
  
else
  raise ArgumentsError, "Invalid number of arguments"
end


When 2
  if linemode
    flag = ARGV[0]
    list_title =ARGV[1]  
  else
    list_title = ARGV[0]
    list_item = ARGV[1]
When 1
  if linemode
    raise ArgumentsError, "Invalid number of arguments"
  else
    list_title = ARG[0]
  end
    
exit
end
