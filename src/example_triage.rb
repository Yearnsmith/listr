require_relative 'class/list'
require_relative 'class/state'
require 'psych'
##https://regexr.com/

$state = State.load_state

ARGV = ["-a","aa","World"]

triage = ARGV.length

flags = [:a,:add,:r,:remove,:e,:echo]

flag = ARGV[0].gsub(/\-/,"").to_sym

if flags.include?(flag)
  $state.linemode = true
else
  $state.linemode = false
  flag = nil
end

if (triage >= 4)

  puts "Error: Too many arguments"
  exit
end

case triage

when 3
  ####  Test  #####################
    puts "ARGV: #{ARGV}"         ##
    puts                         ##
    State.titles.each{ |t|       ##
     print "#{t}, "              ##
    }                            ## 
    puts                         ##
    puts "linemode: #{$state.linemode}" ##
    puts                         ##
  #################################    

  begin
    if $state.linemode
      list_title = ARGV[1]
      list_item  = ARGV[2]

          ### TEST ####################################
            puts "state: #{$state}"
            puts "list_title = #{list_title}"
            puts "list_item  = #{list_item}"
            puts
          ##############################################
      if State.titles.include?(list_title)
        puts "YES!"
      else
        puts "nope"
      end
     list = $state.load_list(list_title)
        ### TEST  ###########################################
        puts "list has been loaded into triage"
        gets
        ######################################################
      begin
        case flag
        when :a

          puts "passing #{list_item} to add method" ; gets
          
          list = list.add_item(list_item)

          puts "\nBack in Triage"

          puts "\nlist title:"
          puts list.list_title

          puts "\nWih index:"
          p list.list_items_with_index
          
          puts "\n No index:"
          p list.list_items_no_index

          puts "\n Removed Items:" 
          p list.removed_items

          puts "\n Added Items:"
          p list.added_items

          puts "\n list hash:"
          p list.list_hash
          puts "\n######################################################################\n"
          puts list
          exit
        when :r
          list.remove_item(list_item)
          puts "#{list_item} added to #{list_title}"
        end
      # rescue
        # puts "#{ARGV[1]} Doesn't Exist"
        raise #ArgumentsError, "Invalid number of arguments for #{ARGV[0]}"
      ensure
        # exit
      end
    elsif flag == :a
      begin
        State.create_list(list_title)
        State.add_item(list_item)
        puts list.list_hash
      # rescue
        # puts "Invalid number of arguments for #{ARGV[0]}"
        # raise error ArgumentsError, "Invalid number of arguments for #{ARGV[0]}"
      ensure
        # exit
      end
    end
  # rescue
    # puts "Invalid number of arguments for #{ARGV[0]}"
    # raise standardError
  ensure
    # exit
  end
end
# when 2
#   if linemode
#     flag = ARGV[0]
#     list_title =ARGV[1]  
#   else
#     list_title = ARGV[0]
#     list_item = ARGV[1]
#   end
# when 1
#   begin
#     if linemode
#       raise ArgumentsError, "Invalid number of arguments"
#     else
#       list_title = ARG[0]
#     end
#   end
# exit
# end
