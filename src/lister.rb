require_relative './class/list'
require_relative './class/state'
require 'psych'
require 'pastel'
require 'tty-prompt'
require 'tty-font'

$state = State.load_state
$font_standard = TTY::Font.new(:standard)
$font_straight = TTY::Font.new(:straight)

def editing_titles(words)
  puts State.pastel.cyan($font_straight.write(words.upcase))
end
system "clear"

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
      
    when choices[0]
      editing_titles(opt)
      item_to_add = State.ask "What item would you like to add?"

      puts list.add_item(item_to_add)
    when choices[1]
      editing_titles(opt)
      if list.list_items.length == 0
        puts "There are no items in this list."
      else
        
        puts list.list_title
        puts "="*list.list_title.length
        puts list.list_items
        
        
        item_to_remove = State.ask "What item would you like to remove?"
        
        puts list.remove_item(item_to_remove)
      end
    when choices[2]
      editing_titles(opt)
      puts "Current Title:\n\"#{list.list_title}\""
      new_title = State.ask "What would you like to change the title to?"
      
      new_title = State.check_if_nil(new_title)

      puts list.change_title(new_title)
    when choices[3]
      editing_titles(opt)
      list.view_list
      puts
    when choices[4]
      editing_titles(opt)
      list.update_yaml
      puts list.list_items
      puts
      puts list.list_yaml
      gets
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
    
    list = $state.load_list

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
