require 'psych'
require 'tty-prompt'
require 'tty-font'
require 'pastel'
require_relative 'list.rb'

# Errors:
# For things going wrong with states
class StateErr < StandardError
end
# For things going wrong when setting list titles
class InvalidTitle < StandardError
end
# When there is a duplicate list... or there tries to be
class DuplicateList < InvalidTitle
end

class TitleIsNil <  InvalidTitle
end

# State:
# [!] Stores metadata about app
# [x] Contains an array of files in list dir
# [x] Saves List files to disc
# [x] Loads List files from disc
# [ ] Stores recent actions
# [ ] Enables Undo actions
# [ ] Enables Redo actions
# [x] Stores metadata in a hash & YAML format
# [x] Metadata is saved to disc in YAML format

class State

  attr_reader :state_dir, :state_name, :state_file, :state_hash, :state_yaml,:titles
  attr_accessor :files, :linemode,:pastel

  
  #Where these files are stored
  @@main_options = [ "New List", "Load List", "Help", "Exit" ]
  @@edit_options = [ "Add Item", "Remove Item", "Change Title", "View List", "Save List", "Help", "Return To Main Menu" ]
  # Naming
  @@invalid_title_chars = "\"\'\\\/\:\:\*\<\>\|\&"
  @@state_dir = "./states/"
  @@list_dir = "./lists/"

  #State File:
  @@state_files = Dir.children(@@state_dir)
  
  # Use this for all prompts
  @@menu = TTY::Prompt.new(symbols: {marker: "●"}, help_color: :cyan, active_color: :cyan)
  # use this for all coloured text
  @@pastel = Pastel.new

  def self.highlight(text, colour = "white")
    case colour
    when "cyan"
      @@pastel.black.on_cyan.bold(" #{text} ")
    when "green"
      @@pastel.black.on_green.bold(" #{text} ")
    when "red"
      @@pastel.black.on_red.bold(" #{text} ")
    when "magenta"
      @@pastel.black.on_magenta.bold(" #{text} ")
    when "yellow"
      @@pastel.black.on_yellow.bold(" #{text} ")
    when "white"
      @@pastel.inverse(" #{text} ")

    end
  end
  
  def initialize(name="default")
    
    @state_name = name
    @state_file = "#{@state_name}.lstr"
    
    @files = Dir.children( @@list_dir ).select { |child| child.end_with? "yml"}
    @@titles = @files.map(&:clone).each do |file|
                  file.delete_suffix!(".yml")
                end
    @linemode = false
    
    @state_hash = { @state_name.to_sym => { linemode: @linemode, files: @files } }
    @state_yaml = Psych.dump(@state_hash)
  end

  
  #### Getters ####

  def self.dir
    @@state_dir
  end

  def self.list_dir
    @@list_dir
  end

  def self.state_files
    @@state_files
  end

  def self.titles
    @@titles
  end

  def self.menu
    @@menu
  end

  def self.pastel
    @@pastel
  end

  def self.main_options
    @@main_options
  end

  def self.edit_options
    @@edit_options
  end

  def self.invalid_title_chars
    @@invalid_title_chars
  end

  #####  Load State  ######

  def self.load_state

    case @@state_files.length == 1
    
    when true
      file = Psych.load_file "#{@@state_dir}#{@@state_files[0]}"
    
      state = State.new file.to_a[0][0].to_s

      return state
    
    when false
      if @@state_files.length == 0
        state = State.new()
    
        IO.write("#{@@state_dir}#{state.state_file}", state.state_yaml)
    
        @@state_files = Dir.children(@@state_dir)

        return state
      else
        raise StateErr, "More than one profile detected"
      end

    end

  end
  #####  Get State  ####
  # def self.get_state(state_obj)
  #   return state_obj
  # end

  #####  Select Items #####
  def self.select_items(message = "What would you like to do?", items)
    return @@menu.select(message,
    items, show_help: :always, cycle: true, filter: true, per_page: 10)
  end

  def self.ask(question, check = nil)
    return @@menu.ask(question, required: true) do |q|
      q.modify :trim
      if check != nil
        q.validate(check)
      end
    end
  end

  #####  Press Any Key #####
  def self.press_any_key(time = nil)
    message = "Press any key to continue"
    if time != nil
      @@menu.keypress(message,timeout: time)
    else
      @@menu.keypress(message)
    end

  end
 
  # When there is invalid input I could use this while
  # raising an error... for now it's used in until blocks...
  # ...if linemode is on...
  def self.if_linemode(message, prompt = nil)
    # put a message
    puts "\n#{message}"
    if @linemode == true
      # exit the program
      exit
    elsif prompt != nil
      # Otherwise ask for a new item :)
      item = @@menu.ask(prompt)
    end
    return item
  end

  def self.check_if_nil(title)
    until title != nil
       title = State.if_linemode("Every good list deserves a title :)",
          "What is the title of your list?")
    end
    return title
  end

  def self.dup_title(l_title)
    p foo = List.new(l_title) ; gets
      
    p  foo.title?(l_title) ;gets
      # puts true
  end

  #Check to see if one thing is the same as another thing within a given category.
  def self.check_for_duplicate(item, cat, thing)
    item = State.check_if_nil(item)
    # Until they don't equal each other, case insensitive...
    until !(@@titles.map{|i| i.downcase}).include?(item)
      # If operating in linemode, exit straight away, otherwise choose a new thing
      item = State.if_linemode( "A #{cat} with this #{thing} already exists.",
      "Please choose a new #{thing}...")
    end
    return item
  end

    # check if title has valid characters
    def self.check_invalid_title_chars(title)
      # use Regexp instance to look for invalid characters
      # https://www.rubyguides.com/2015/06/ruby-regex/
      # https://ruby-doc.org/core-2.7.2/Regexp.html#method-i-match-3F
      # https://regexr.com/
      match = Regexp.new("[#{@@invalid_title_chars}]")
      #continue the following until a proper title has been supplied
      until !(match =~ title)# == nil
        title = State.check_if_nil(title)
        title =  self.if_linemode( "\nTitle cannot contain #{@@invalid_title_chars}",
         "Please choose a new title:")
        end
      # end
      return title
    end

  #####  Create List  #####

  def create_list(list_title)
      # "Checking #{list_title}:"
      # "Check if it's an empty field:"
    list_title = State.check_if_nil(list_title)

      # "Check if it contains bad characters:"
    # list_title = State.check_for_duplicate(list_title, "list", "title")
    list_title = State.check_invalid_title_chars(list_title) ; gets

    @@titles
    puts
    
      # "Check if title exists:"
    if State.dup_title(list_title)
      
      list = List.new(list_title)

      puts "\"#{list.list_title}\" has been created!"
      State.press_any_key
      return list
    else
      puts "Title already Exists"
    end
      
  end
  ##############
  # load lists #
  ##############
  def load_list(file_to_load)
        #instantiate blank list with file name
    list = List.new(file_to_load)
      
      #####  TEST ###########################################
        # puts file_to_load
        # puts "This is my blank hash: #{list.list_hash}"
        # puts "File Instantiated";gets
        # puts
      #####################################################

      # open file with IO class -- this automatically closes the file for me. :)
      # Use Psych to convert yaml file into a hash. Using safe_load to de-serialize for safety.
      # https://ruby-doc.org/core-2.7.2/IO.html#method-c-read
      # https://ruby-doc.org/stdlib-2.7.2/libdoc/psych/rdoc/Psych.html#method-c-safe_load
    begin
      file_to_load = Psych.safe_load( IO.read( "#{@@list_dir}#{file_to_load}.yml" ),permitted_classes:[Symbol] )
    rescue => e
      puts "Error loading file. Please make sure it exists."
      if @linemode != true
        State.press_any_key
        #return user to the main screen, so they can load another list.
        return main_menu
      else
        raise
      end
    end

      ###  TEST  #########################
        # puts "File Loaded IN" ;gets
        # puts
        # puts file_to_load ;gets 
      ###################################

      # Map hash to instance variables 
        # Map hash to instance variables 
      # Map hash to instance variables 
    a = file_to_load.to_a[0][0]

      ###  TEST ####################
        # puts "a: #{a}"
        # puts list
        # puts list.list_hash[b] = file_to_load[a].each_value{|v| v.nil? == true ? v = [] : v = v } ; gets ; puts

        # p file_to_load[a][:items_no_index]
        # p list.list_items_with_index = file_to_load[a][:items_with_index]
        # p list.list_items_no_index = file_to_load[a][:items_no_index]
        # p list.removed_items = file_to_load[a][:last_five_removed]
        # p list.added_items = file_to_load[a][:last_five_added]
        # # Update the hash and yaml for the List instance (These aren't publically writable)
        # p list.yaml_hash
      #############################
    file_to_load[a][:items_no_index]
    list.list_items_with_index = file_to_load[a][:items_with_index]
    list.list_items_no_index = file_to_load[a][:items_no_index]
    list.removed_items = file_to_load[a][:last_five_removed]
    list.added_items = file_to_load[a][:last_five_added]
      # Update the hash and yaml for the List instance (These aren't publically writable)
    list.update_yaml

    if @linemode != true
        # Put confirmation
      puts "Editing #{list.list_title}..."
      State.press_any_key
    end
      # return list object to lister
    return list

  end
    ##############
    # Save Lists #
    ##############
  def self.save_list(title,yaml)
    
    puts "Saving to disc..."
    IO.write("#{@@list_dir}#{title}.yml",yaml)

    if !@@titles.include?(title)
      @@titles << title
      State.update_list_titles
    end

    return @@pastel.green("#{self.highlight(title,"green")} has been saved. :)")
  end

    # I don't understand why save_list can't see this mehod when "self." is removed.
    # It should be seen within the class... but it's not.
    # Is this because save_list is being called from an external flow,
    # and calling update_list_titles from there?
    # If so, then shouldn't all methods defined in a class need .self?!
  def self.update_list_titles
    @files = Dir.children( @@list_dir ).select { |f| f.end_with? "yml"}
    
    @@titles = @files.map(&:clone).each do |i|
                 i.delete_suffix!(".yml")
               end
  end

end# Class
