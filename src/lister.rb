require_relative './class/list'
require_relative './class/state'
# require 'tty-prompt'
require 'pastel'
require 'tty-prompt'

$state = State.load_state
system "clear"
# $menu = TTY::Prompt.new(symbols: {marker: "●"})

# def select_main
#   return $menu.select("What would you like to do?",
#     State.main_options, cycle: true)
# end

## puts State.main_options
## Main Menu

def edit_list(list)
  choices = State.edit_options

  opt = ""
  
  while opt != choices[-1]
          
    system "clear"
    
    puts "EDIT LIST"
    opt = State.select_items(choices)
    
    system "clear"
    
    case opt
      
    when choices[0]
      item_to_add = State.ask "What item would you like to add?"

      puts list.add_item(item_to_add)
    when choices[1]
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
      puts "Current Title:\n\"#{list.list_title}\""
      new_title = State.ask "What would you like to change the title to?"

      puts list.change_title(new_title)
    when choices[3]
      list.view_list
      puts
    when choices[4]
      list.update_yaml
      puts list.list_items
      puts
      puts list.list_yaml
      gets
      State.save_list(list.list_title,list.list_yaml)


    when choices[5]
      puts opt
    else choices[6]
     return "Returning to main menu"
    end
    State.press_any_key
    system "clear"
  
  end
end



opt = ""

while opt != "Exit"
  opt = State.select_items(State.main_options)
  
  system = "clear"
  case opt
  when "New List"
    list_title = State.ask "What is the title of your list?"
    
    until list_title != nil
      puts "Every good list deserves a title :)\n\r"
      list_title = State.ask("What is the title of your list?")
    end
    
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
end