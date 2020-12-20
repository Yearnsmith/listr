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
    puts "Editing: #{State.pastel.black.on_cyan.bold(list.list_title)}"
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
     return "Returning to main menu"
    end
    State.press_any_key
    system "clear"
  
  end
end

def print_title
  puts State.pastel.cyan($font_standard.write("Lister"))
end

def main_menu
system "clear"
opt = ""

while opt != "Exit"
  print_title
 welcome_text = %(
A terminal app for making lists.
To get started, select "New List", and follow the prompts.

)
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
    puts "Load List".upcase
    #update list files and titles
    $state.update_list_titles
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

main_menu