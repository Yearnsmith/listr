require 'psych'
require 'tty-prompt'

require_relative 'list.rb'

# Errors:
class StateErr < StandardError
end


# State:
# [!] Stores metadata about app
# [ ] Contains an array of files in list dir
# [ ] Saves List files to disc
# [ ] Loads List files from disc
# [ ] Stores recent actions
# [ ] Enables Undo actions
# [ ] Enables Redo actions
# [ ] Stores metadata in a hash & YAML format
# [ ] Metadata is saved to disc in YAML format

class State

  attr_reader :state_dir, :state_name, :state_file, :state_hash, :state_yaml
  attr_accessor :files, :linemode

  
  #Where these files are stored
  @@main_options = ["New List", "Load List", "Exit"]
  @@edit_options = [ "Add Item", "Remove Item", "Change Title", "View List", "Save List", "Return To Main Menu" ]
  @@state_dir = "./states/"
  @@list_dir = "./lists/"
  @@state_files = Dir.children("states")

  @@menu = TTY::Prompt.new(symbols: {marker: "●"})
  
  def initialize(name="default")

    @state_name = name
    @state_file = "#{@state_name}.lstr"

    # @files = (Dir.children("lists")).select do |file|
    #             file.end_with? "yml"
    #           end
    @files = ['My List']
    @linemode = false

    @state_hash = {@state_name.to_sym => {linemode: @linemode, files: @files } }
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

  def self.main_options
    @@main_options
  end

  def self.edit_options
    @@edit_options
  end

  #####  Load State  ######

  def self.load_state

    case @@state_files.length == 1
    
    when true
      file = Psych.load_file "states/#{@@state_files[0]}"
    
      state = State.new file.to_a[0][0].to_s

      return state
    
    when false
      if @@state_files.length == 0
        state = State.new()
    
        IO.write("#{@@state_dir}#{state.state_file}", state.state_yaml)
    
        @@state_files = Dir.children("states")

        return state
      else
        raise StateErr, "More than one profile detected"
      end

    end

  end

  #####  Select Items #####
  def self.select_items(options)
    return @@menu.select("What would you like to do?",
    options, cycle: true)
  end

  def self.ask(question)
    return @@menu.ask(question)
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

    title = list_title

    until !@files.include?(title)
      print "A list with this title already exists.\nplease choose a new title… "
      title = gets.chomp
      # create_list(title)
    end
      list = List.new(title)

      puts "\"#{title}\" has been created!"

      return list
  end

end