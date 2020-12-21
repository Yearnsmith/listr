#!/usr/bin/env ruby

require_relative './class/list'
require_relative './class/state'
require 'psych'
require 'pastel'
require 'tty-prompt'
require 'tty-font'


# class NoSuchItem < StandardError
#   def initialize(message)
#     puts State.pastel.red("Error: #{message}")
#     @message = message
#   end
#   def to_s
#     return @message
#   end
# end

# class EmptyList < StandardError
#   def initialize(message)
#     puts State.pastel.red(message)
#   end
# end

$state = State.load_state

$font_standard = TTY::Font.new(:standard)
$font_straight = TTY::Font.new(:straight)

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

  
  #####################################################
def editing_titles(words)
  puts State.pastel.cyan($font_straight.write(words.upcase))
end

# Editing Menu

def edit_list(list)
  choices = State.edit_options

  opt = ""
   
  while opt != choices[-1]
          
    system "clear"
    editing_titles("edit")
    puts "Editing: #{State.highlight(list.list_title,"cyan")}"
    opt = State.select_items(choices)
    
    system "clear"
    
    case opt
      
    # Add item
    when choices[0]
      editing_titles(opt)
      item_to_add = State.ask "What item would you like to add?"

      puts list.add_item(item_to_add)

    # Remove item
    when choices[1]
      editing_titles(opt)
      if list.list_items.length == 0
        puts State.pastel.red.bold "There are no items in this list..."
      else

        item_to_remove = State.select_items("What item would you like to remove?",list.list_items_no_index)
        # puts item_to_remove.index()
        puts list.remove_item(item_to_remove)
      end

    # Change title
    when choices[2]
      editing_titles(opt)
      puts "Current Title:\n\"#{list.list_title}\""
      new_title = State.ask "What would you like to change the title to?"
      
      new_title = State.check_if_nil(new_title)

      puts list.change_title(new_title)

    # View List
    when choices[3]
      editing_titles(opt)
      list.view_list
      puts

    # save list
    when choices[4] 
      editing_titles(opt)
      list.update_yaml
      puts list.list_items_no_index
      State.save_list(list.list_title,list.list_yaml)


    when choices[5]
      editing_titles(opt)
      puts opt
    else choices[6]
      editing_titles("Returning...")
      print"Returning to main menu"
      sleep(1)
      main_menu
    end
    State.press_any_key
    system "clear"
  
  end
end

def print_title
  puts State.pastel.cyan($font_standard.write("Lister"))
end

def main_menu
  welcome_text = %(
    A terminal app for making lists.
    To get started, select "New List", and follow the prompts.
    
    )
  system "clear"
  opt = ""
  
  while opt != "Exit"
    print_title
    puts welcome_text
  
  opt = State.select_items(State.main_options)
  
  system = "clear"
  case opt
  when "New List"
    list_title = State.ask "What is the title of your list?"
    
    list_title = State.check_if_nil(list_title)
    

    list = $state.create_list(list_title)

    puts edit_list(list)

  when "Load List"
    system "clear"
    print_title
    puts State.highlight("Load List","cyan")
    #update list files and titles
    State.update_list_titles
    #display lists to edit and return a value
    file_to_load = State.select_items("Which list would you like to edit?", State.titles)
    
    list = $state.load_list(file_to_load)

    puts edit_list(list)
  when "Help"
    puts
    puts "Help goes here"
    gets

  else "Exit"
    puts "Exit".upcase
    puts
    puts "Good Bye :)"
    exit
  end
  # $menu.keypress("Press any key")
  # State.press_any_key
  system "clear"
  #print_title
  end
end

if (triage >= 4)

  puts "Error: Too many arguments"
  exit
end

case triage
when 0
  main_menu
when 3

  begin
    if $state.linemode
      list_title = ARGV[1]
      list_item  = ARGV[2]
      if State.titles.include?(list_title)
        list = $state.load_list(list_title)
        begin
          case # flag
          when flag == :a || flag == :add
            list = list.add_item(list_item)
          when flag == :r || flag == :remove
            puts "The item will be removed"
          end
        rescue
          puts "#{ARGV[1]} Doesn't Exist"
          # raise #ArgumentsError, "Invalid number of arguments for #{ARGV[0]}"
        ensure
          puts State.save_list(list.list_title, list.list_yaml)
          exit
        end
      elsif !State.titles.include?(list_title) && flag == :a
        begin

          list = $state.create_list(list_title)

          list.add_item(list_item)

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
    raise StandardError
  ensure
    exit
  end
when 2
  if $state.linemode
    list_title =ARGV[1]  
    # If the list exists
  else
    # If linemode is off
    list_title = ARGV[0]
    list_item = ARGV[1]
  end
  if State.titles.include?(list_title)
    # load the list
    list = $state.load_list(list_title)
    # if linemode is on
    if flag != nil
      case
      when flag == :e || flag == :echo
        list.view_list
      else
        puts "Invalid Flag"
      end
    else
      list = $state.load_list(list_title)
      list.add_item(list_item)
      edit_list(list)
    end
  elsif !State.titles.include?(list_title) && (flag == :a ||flag == :add)
    if flag != nil
      list = $state.create_list(list_title)
      puts State.save_list(list.list_title,list.list_yaml)
    end
  else
    puts "Title not found, or some other error"
  end
when 1
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
      edit_list(list_title)
    else
      State.create_list(list_title)
    end
  end
else
  puts "An Error has occured"
end