#!/usr/bin/env ruby

require_relative 'class/list'
require_relative 'class/state'
require 'psych'
##https://regexr.com/

$state = State.load_state

puts State.highlight("This is a test file")

# ARGV = ["-a"]

triage = ARGV.length

flags = [:a,:add,:r,:remove,:e,:echo]

# if !ARGV.empty?
  !ARGV.empty? ? (flag = ARGV[0].gsub(/\-/,"").to_sym) : flag = nil
# end
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
when 0
  puts "Go to main menu"
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
    # If the list exists
  else # If linemode is off
    list_title = ARGV[0]
    list_item = ARGV[1]
  end

  if State.titles.include?(list_title)
     # load the list
    list = $state.load_list(list_title)
      # if linemode is on
    if flag != nil
      case flag
      when :e
        list.view_list
      else
        puts "Invalid Flag"
      end
    else
      #go to edit list
      puts "go to edit_list(list)"
    end
  else
    puts "Title not found, or some other error"
  end

when 1
  begin
    if $state.linemode
      # Giving a traceback, because they are accessing this through command line.
      # Prefer to give the user an error without a traceback
      puts State.pastel.red.bold("Error: Invalid number of arguments for -#{flag}. Expecting a title, with optional item")
      exit
      # raise StandardError, "Invalid number of arguments for -#{flag}. Expecting a title, with optional item"
    else
      list_title = ARGV[0]
      if State.titles.include?(list_title)
        # load the list
        list = $state.load_list(list_title)
        puts "go to edit_list(list_title)"
      else
        State.create_list(list_title)
      end
    end
  # ensure
  #   exit
  end
else
  puts "An Error has occured"
end
# end
