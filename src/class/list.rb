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

  attr_reader :list_hash, :list_yaml #, :removed_items
  attr_accessor :list_title, :list_items, :removed_items

  def initialize(title)
    #Neccessary for displaying, storing, and accessing list data
    @list_title = title
    @list_items = []
    @list_hash = { @list_title => {items: @list_items, last_five_removed: @removed_items, last_five_added: @added_items} }
    @list_yaml = Psych.dump @list_hash
    
    #Features for future
    #store last 3 removed items for this list
    @removed_items = []
    @added_items = []
  end

  # def editing_menu(items)
  #   $editing = TTY::Prompt.new
    
  #   return $editing.select("What would you like to do?", items, cycle: true)
  # end


  # ensure an arry never exceeds n items.
  def limit_items(array, n_items)
    if array.length >= n_items
        array.shift( (array.length + 1) - n_items )
    end
  end


  def edit_list
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

        puts add_item(item_to_add)
      when choices[1]
        if @list_items.length == 0
          puts "There are no items in this list."
        else
          
          puts @list_title
          puts "="*@list_title.length
          puts @list_items
          
          
          item_to_remove = State.ask "What item would you like to remove?"
          
          puts remove_item(item_to_remove)
        end
      when choices[2]
        puts "Current Title:\n\"#{@list_title}\""
        new_title = State.ask "What would you like to change the title to?"

        puts change_title(new_title)
      when choices[3]
        view_list
        puts
      when choices[4]
        puts opt
      when choices[5]
        puts opt
      else choices[6]
       return "Returning to main menu"
      end
      State.press_any_key
      system "clear"
    
    end
  end

  def add_item(item_to_add)

      @list_items << item_to_add
    return "\"#{item_to_add}\" has been added to \"#{@list_title}\""
  end

  def remove_item(item_to_remove)
    # Ensure there are items to remove
    if @list_items.length == 0
      puts "There are no items in this list."
      return
    end
    # Ensure sure item is in list
    until @list_items.include?(item_to_remove)
      puts "\"#{item_to_remove}\" is not in the list.\n"
      item_to_remove = State.ask "What item would you like to remove?"
    end
    # Confirm Deletion
    puts "This will delete the last occurance of \"#{item_to_remove}\".\nIt will be gone forever..."
    confirm = State.menu.select("Are you sure you want to delete?",%w(Yes No))

    #remove item and add it to an array of removed items, along with it's index in the list.
    #This will be handy for any debugging, log files, and a future "undo" action.
    if confirm == "Yes"
      # ensure @removed_items never exceeds 5 items.
      limit_items(@removed_items, 5)
      #push the removed item and it's index to @removed_items
      # 1. access @list_items, get the index of the last instance item_to_remove.
      # 2. access @list_items, get the index of the last instance of item_to_remove. Then delete the item at that index.
      # 3. Push the deleted item's index and the deleted item to @removed_items array for later use.
      @removed_items << [@list_items.rindex(item_to_remove), @list_items.delete_at( @list_items.rindex(item_to_remove) )]
            
      return "\n\"#{item_to_remove}\" has been removed from \"#{@list_title}\""
    else
      return "\n\"#{item_to_remove}\" is safe for now. :)"
    end
    

  end


  def change_title(new_title)

    good_title = State.check_for_duplicate(new_title, "list", "title")
    gooder_title = State.check_invalid_title_chars(good_title)

    @list_title = gooder_title
  end

  def view_list
    puts @list_title
    puts "="*@list_title.length
    list_items.each{ |i| puts i}
  end

end
