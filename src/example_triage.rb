#!/usr/bin/env ruby

require_relative 'class/list'
require_relative 'class/state'
require 'psych'
##https://regexr.com/

$state = State.load_state

puts State.highlight("This is a test file")

ARGV = ["-e","yaml"]

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
      # puts "ARGV: #{ARGV}"         
      # puts                         
      # State.titles.each{ |t|       
      # print "#{t}, "              
      # }                           
      # puts
      # puts "linemode: #{$state.linemode}"
      # puts
    #################################    

  begin
    if $state.linemode
      list_title = ARGV[1]
      list_item  = ARGV[2]

        ### TEST ####################################
          # puts "state: #{$state}"
          # puts "list_title = #{list_title}"
          # puts "list_item  = #{list_item}"
          # puts
        ##############################################
      if State.titles.include?(list_title)

        ### TEST ##################################
          # if State.titles.include?(list_title)
          #   puts "YES!"
          # else
          #   puts "nope"
          # end
          # p State.titles
        ###########################################

        list = $state.load_list(list_title)
          ### TEST  ###########################################
            # puts "list has been loaded into triage"
            # gets
          ######################################################

        begin
          case flag
          when :a
            ### TEST ###########################
              # passing #{list_item} to add method
            ##################################
            list = list.add_item(list_item)
            ### TEST ##############################
              # puts "\nBack in Triage"
              # puts "\nlist title:"
              # puts list.list_title
              # puts "\nWih index:"
              # p list.list_items_with_index
              # puts "\n No index:"
              # p list.list_items_no_index
              # puts "\n Removed Items:" 
              # p list.removed_items
              # puts "\n Added Items:"
              # p list.added_items
              # puts "\n list hash:"
              # p list.list_hash
              # puts "\n######################################################################\n"
              # puts list
              # exit
            #######################################
          when :r
            ### TEST ###########################
              puts "The item will be removed"
            ###################################
            # list.remove_item(list_item)
            # puts "#{list_item} added to #{list_title}"
          end
        rescue
          puts "#{ARGV[1]} Doesn't Exist"
          raise #ArgumentsError, "Invalid number of arguments for #{ARGV[0]}"
        ensure
          puts State.save_list(list.list_title, list.list_yaml)
          exit
        end
      elsif !State.titles.include?(list_title) && flag == :a
        begin
            puts "\nPassing #{State.highlight(list_title)} to State class\n\r" ; gets

          puts list = $state.create_list(list_title) ;gets

            puts "List created: #{puts list}\n"

          list.add_item(list_item)
          puts list.list_hash

          puts State.save_list(list.list_title,list.list_yaml)
        rescue
          puts "Invalid number of arguments for #{ARGV[0]}"
          raise
        ensure
          exit
        end
      end
    end
  rescue
    puts "Invalid number of arguments for #{ARGV[0]}"
    raise standardError
  ensure
    exit
  end
when 2
  if $state.linemode
    list_title =ARGV[1]  
  
    case flag
    when :e
      if State.titles.include?(list_title)
        list = $state.load_list(list_title)
        list.view_list
      else
        puts "List can't be found. Did you spell it right?"
        exit
      end

    else
      puts "Invalid Flag"
    end
  
  else
    p list_title = ARGV[0]
    p list_item = ARGV[1]
  end

end
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
