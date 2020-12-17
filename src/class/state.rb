require 'psych'
require 'tty-prompt'

require_relative 'list.rb'

# Errors:
class StateErr < StandardError
end


# State:
# [!] Stores metadata about app
# [x] Contains an array of files in list dir
# [ ] Saves List files to disc
# [ ] Loads List files from disc
# [ ] Stores recent actions
# [ ] Enables Undo actions
# [ ] Enables Redo actions
# [x] Stores metadata in a hash & YAML format
# [ ] Metadata is saved to disc in YAML format

class State

  attr_reader :state_dir, :state_name, :state_file, :state_hash, :state_yaml,:titles
  attr_accessor :files, :linemode

  
  #Where these files are stored
  @@main_options = ["New List", "Load List", "Help", "Exit"]
  @@edit_options = [ "Add Item", "Remove Item", "Change Title", "View List", "Save List", "Help", "Return To Main Menu" ]
  @@invalid_title_chars = "\"\'\\\/\:\:\*\<\>\|\&"
  @@state_dir = "./states/"
  @@list_dir = "./lists/"

  #State File:
  # @@state_files = Dir.children("states")
  @@state_files = Dir.children(@@state_dir)
  
  # Use this for all prompts
  @@menu = TTY::Prompt.new(symbols: {marker: "●"}, help_color: :green)
  
  def initialize(name="default")

    @state_name = name
    @state_file = "#{@state_name}.lstr"

    @files = Dir.children( @@list_dir ).select { |f| f.end_with? "yml"}
    @@titles = @files.map(&:clone).each do |i|
      i.delete_suffix!(".yml")
      i.gsub!("-"," ")
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

  def self.menu
    @@menu
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

  #####  Select Items #####
  def self.select_items(message = "What would you like to do?", options)
    return @@menu.select(message,
    options, cycle: true, per_page: 10)
  end

  def self.ask(question)
    return @@menu.ask(question){ |q| q.modify :strip}
  end

  #####  Press Any Key #####
  def self.press_any_key(time = nil)

    if time != nil
      @@menu.keypress("Press any key",timeout: time)
    else
      @@menu.keypress("Press any key")
    end

  end

  #####  Create List  #####

  def create_list(list_title)
    p @@titles
    gets
    good_title = State.check_for_duplicate(list_title, "list", "title")
    
    gooder_title = State.check_invalid_title_chars(good_title)

      list = List.new(gooder_title)

      puts "\"#{list.list_title}\" has been created!"
      puts list.list_hash
      State.press_any_key
      return list
  end

  def self.check_for_duplicate(item, cat, thing)
    p @@titles
    until !(@@titles.map{|i| i.downcase}).include?(item.downcase)
      puts "A #{cat} with this #{thing} already exists."
      if @linemode == true
        exit
      else
        print "please choose a new #{thing}… "
      end#if linemode
        item = gets.chomp
    end#until
    return item
  end#def

    def self.check_invalid_title_chars(title)
      match = Regexp.new("[#{@@invalid_title_chars}]")
      until (match =~ title) == nil
        puts "\nTitle cannot contain #{@@invalid_title_chars}"
        title = @@menu.ask("Please choose a new title:")
        
      end
      return title
    end

    #load lists
    def load_list

      #update list files and titles
      update_list_titles
      #display lists to edit and return a value
      file_to_load = State.select_items("Which list would you like to edit?", @@titles)
      #instantiate blank list with file name
      list = List.new(file_to_load)
      
      #print hash
        # open file with IO class -- this automatically closes the file for me. :)
        # Use Psych to convert yaml file into a hash. Using safe_load to de-serialize for safety.
        # https://ruby-doc.org/core-2.7.2/IO.html#method-c-read
        # https://ruby-doc.org/stdlib-2.7.2/libdoc/psych/rdoc/Psych.html#method-c-safe_load
        file_to_load = Psych.safe_load( IO.read( "#{@@list_dir}#{file_to_load}.yml" ),permitted_classes:[Symbol] )
        # Map hash to instance variables 
        list.list_title = a = file_to_load.to_a[0][0]
        list.list_items = file_to_load[a][:items]
        list.removed_items = file_to_load[a][:last_five_removed]
        list.added_items = file_to_load[a][:last_five_added]
        # Update the hash and yaml for the List instance (These aren't publically writable)
        list.update_yaml
        # Put confirmation
        puts "Editing #{list.list_title}..."
        State.press_any_key
        # return list object to lister
        return list
      
      #return list to caller

    end

    def self.save_list(title,yaml)
      puts "Saving to disc..."
      IO.write("#{@@list_dir}#{title}.yml",yaml)

      if !@@titles.include?(title)
        @@titles << title
      end

      return "\"#{title}\" has been saved. :)"
    end

    def update_list_titles
      @files = Dir.children( @@list_dir ).select { |f| f.end_with? "yml"}
      
      @@titles = @files.map(&:clone).each do |i|
        i.delete_suffix!(".yml")
        i.gsub!("-"," ")
      end
    end

end# Class