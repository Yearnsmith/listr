# List Class

# Lists:
# [!] .create_list(State method) != .init_list(State method) != initializing/instantiating new List object
# [X] Are objects of List class.
# [X] Have a title
# [X] Contain items
# [X] Store items in an array
# [ ] It's items may be added
# [ ] It's items may be removed
# [ ] It's title may be changed
# [X] Store title and items together in a hash & YAML format
# [ ] Are saved to disc in YAML format

require 'psych'
require 'tty-prompt'
require_relative 'state'

class List

  attr_reader :list_hash, :list_yaml
  attr_accessor :list_title, :list_items

  def initialize(title)
    @list_title = title
    @list_items = []
    @list_hash = { @list_title => @list_items }
    @list_yaml = Psych.dump @list_hash
  end

  # def editing_menu(items)
  #   $editing = TTY::Prompt.new
    
  #   return $editing.select("What would you like to do?", items, cycle: true)
  # end

  def edit_list
    choices = State.edit_options
    

      opt = ""
    
    while opt != choices[5]
      
      
      system "clear"
      
      puts "EDIT LIST"
      opt = State.select_items(choices)
      
      system "clear"
      
      case opt
        
      when choices[0]
        puts "Hello World!"
      when choices[1]
        puts opt
      when choices[2]
        puts opt
      when choices[3]
        puts opt
      when choices[4]
        puts opt
      else choices[5]
       return "Returning to main menu"
      end
      State.press_any_key
      system "clear"
    
    end
  end

  def add_item(item_to_add)
    # puts "Add Item"
    return "Add Item"
  end

  def remove_item(item_to_remove)
  end

  def change_title(new_name)
  end

end
