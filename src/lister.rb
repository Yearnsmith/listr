require_relative './class/list'
require_relative './class/state'
# require 'tty-prompt'
require 'pastel'
require 'tty-prompt'

$state = State.load_state

# $menu = TTY::Prompt.new(symbols: {marker: "●"})

# def select_main
#   return $menu.select("What would you like to do?",
#     State.main_options, cycle: true)
# end

## puts State.main_options
## Main Menu

opt = ""

while opt != "Exit"
  
  puts "(Use ↑/↓ arrow keys, press Enter to select)" 
  opt = State.select_items(State.main_options)
  
  system = "clear"
  case opt
  when "New List"
    list_title = State.ask "What is the title of your list?"
    
    until list_title != nil
      puts "Every good list deserves a title :)\n\r"
      list_title = State.ask "What is the title of your list?"
    end
    
    list = $state.create_list(list_title)

    puts list.edit_list

  when "Load List"
    puts "Load List".upcase
    puts
    puts "code goes here"

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