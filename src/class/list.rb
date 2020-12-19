# List Class

# Lists:
# [!] .create_list(State method) != .init_list(State method) != initializing/instantiating new List object
# [X] Are objects of List class.
# [X] Have a title
# [X] Contain items
# [X] Store items in an array
# [X] It's items may be added
# [X] It's items may be removed
# [X] It's title may be changed
# [X] Store title and items together in a hash & YAML format
# [X] Are saved to disc in YAML format

require 'psych'
require 'tty-prompt'
require 'tty-font'
require 'pastel'
# require_relative 'state'

class NoSuchItem < TypeError
  def initialize(message)
    puts State.pastel.red("Error: #{message}")
    @message = message
  end
  def to_s
    return @message
  end
end

class EmptyList < StandardError
  def initialize(message)
    puts State.pastel.red(message)
  end
end



class List
  
  attr_reader :list_hash, :list_yaml #, :removed_items
  attr_accessor :list_title, :list_items, :removed_items, :added_items

  def initialize(title)
    #Neccessary for displaying, storing, and accessing list data
    @list_title = title
    @list_items = []
    # @list_items_no_index = @list_items.each{|i| list_items_no_index << i.shift}
    @list_items_no_index = []
    @list_hash = { @list_title => {items_with_index: @list_items, items_with_no_index: @list_items_no_index, last_five_removed: @removed_items, last_five_added: @added_items} }
    @list_yaml = Psych.dump @list_hash
    
    #Features for future
    #store last 3 removed items for this list
    @removed_items = []
    @added_items = []
  end

  ### Utility Methods ###

  # Highlight items
  def highlight(item)
    State.pastel.black.on_cyan.bold(item)
  end

  # ensure an arry never exceeds n items.
  def limit_items(array, n_items)
    if array.length >= n_items
        array.shift( (array.length + 1) - n_items )
    end
  end

#### Item Methods ####
  def add_item(item_to_add)

      # @list_items << item_to_add
      @list_items_no_index << item_to_add
      @list_items << added_item = [item_to_add, list_items.length]
      @list_items_no_index = @list_items.map(&:clone).each{|i| i.pop}
      puts @list_items_no_index[-1]

    return "#{highlight(item_to_add)} has been added to #{highlight(@list_title) }"
  end

  def remove_item(item_to_remove)
          ## Testing ###################
          # $state.linemode = true     #
          # item_to_remove = "Bannana" #
          # @list_items = []           #
          ##############################
    
    if $state.linemode == false
      
      # Confirm Deletion
      puts "\nThis will delete the last occurance of #{highlight(item_to_remove)}.\r\n\
      It will be gone forever..."
      
      # Give hard options
      confirm = State.select_items("\nAre you sure you want to delete?",%w(Yes No))
      
      #remove item and add it to an array of removed items, along with it's index in the list.
      #This will be handy for any debugging, log files, and a future "undo" feature.
    else
      ### LINEMODE ###
  
      # Error handling: `puts` message and `exit` if in linemode.
      # For UX purposes I don't want to display a full error message to user.

      # Ensure there are items to remove.
      if @list_items.length == 0
        State.pastel.red.bold("#{highlight(@list_title)} has no items.\n")
        exit

      # Ensure sure item is in list
      elsif !@list_items.include?(item_to_remove)
        State.pastel.red.bold "#{ State.pastel.black.on_red.bold( item_to_remove ) } is not in the list.\n"
        exit
        
      end
      confirm = "Yes"
    end
    # puts $state.linemode
    
    if confirm == "Yes"
          ## TEST ###############################
          # @list_items.delete(item_to_remove)  #
          #######################################
          retry_count = 0                     #
      begin
      # ensure @removed_items never exceeds 5 items.
      limit_items(@removed_items, 5)

      #push the removed item and it's index to @removed_items
      # 1. access @list_items, get the index of the last instance item_to_remove.
      # 2. access @list_items, get the index of the last instance of item_to_remove. Then delete the item at that index.
      # 3. Push the deleted item's index and the deleted item to @removed_items array for later use.
        
          ## TEST##############################
          # @list_items.delete(item_to_remove)  #
          #####################################

        @removed_items << [@list_items.rindex(item_to_remove), @list_items.delete_at( @list_items.rindex(item_to_remove) )]

        # item = 

        rescue TypeError
          puts "#{highlight(item_to_remove)} doesn't seem to exist...\n"
          sleep(0.5)
          puts "Updating list items..."
          sleep(0.5)
          list = List.new(@list_title)
          
          file_to_load = @list_title
          begin
            file_to_load = Psych.safe_load( IO.read( "#{State.list_dir}#{file_to_load}.yml" ),permitted_classes:[Symbol] )
          rescue => e
            puts "I tried reloading your file but it doesn't exist. Perhaps it hadn't saved, or it's been deleted while you were editing it."
            State.press_any_key
            return main_menu
          end
          @list_title = a = file_to_load.to_a[0][0]
          @list_items = file_to_load[a][:items]
          @removed_items = file_to_load[a][:last_five_removed]
          @added_items = file_to_load[a][:last_five_added]

          update_yaml
          retry_count += 1
          retry if retry_count < 2
          #If reloading the file doesn't work... there is an issue with the execution of the code.
          #Exit program and give a reason.
          system "clear"
          print "Error: Something has gone wrong while editing your file";sleep(0.75);".";print".";sleep(0.75);puts"."
          sleep(1)
          print "\nClosing application";sleep(0.75);print".";sleep(0.75);print".";sleep(0.75);puts"."
          sleep(1)
          exit

          # I would use the following if I could supress the traceback.
          # raise NoSuchItem.new("#{item_to_remove} doesn't exist")
      else
        return "#{ highlight(item_to_remove) } has been removed from \"#{highlight @list_title}"
      end
    else
      return "\n\"#{item_to_remove}\" is safe for now. :)"
    end
  end


  def change_title(new_title)

    new_title = State.check_if_nil(new_title)

    new_title = State.check_for_duplicate(new_title, "list", "title")
    new_title = State.check_invalid_title_chars(new_title)

    @list_title = new_title
  end

  def view_list
    puts @list_title
    puts "="*@list_title.length
    # @list_items.each_entry{ |i| puts i[0]}
    # puts @list_items_no_index
    puts @list_hash
  end

  def update_hash
    @list_hash = { @list_title => {items: @list_items, last_five_removed: @removed_items, last_five_added: @added_items} }
  end
  def update_yaml
    update_hash
    @list_yaml = Psych.dump @list_hash    
  end

end
