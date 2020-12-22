#!/usr/bin/env ruby

require_relative './class/list'
require_relative './class/state'
require 'psych'
require 'pastel'
require 'tty-prompt'
require 'tty-font'
require 'tty-pager'

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

$help_text = <<-HELP

Thank you for using Lister. Lister makes it easy to manage lists via
a command-line interface.

#{State.highlight("Getting Started")}

    #{State.highlight("Installing Lister")}

    Installing Lister is as simple as running the install script.
    
    Lister requires the following dependencies:
      - A Terminal (Bash, GNOME Terminal, WSL, etc.)
      - Ruby
      - Ruby Gems
        
    Lister will install the following dependencies:
      - Psych
      - tty-prompt
      - pastel
      - Bundler
      - Rspec
  
      
    #{State.highlight("Create Your First List")}
    
    Simply Type: #{State.highlight("lister \"Your Title\" \"Your First Item\"","code")}

    or #{State.highlight("lister -a \"Your Title\" \"Your First Item\"","code")}
    if you wish to stay in the command prompt.


#{State.highlight("Using Lister")}

There are two ways to use Lister: Interactve mode and Linemode. Lister
automatically detects which mode is being used.


    #{State.highlight("Interactive Mode")}

    Interactive mode is the default way to use Lister. It allows you
    to edit a list by following prompts.
      
    When Interactive Mode loads, the Main Menu will appear. Press the
    up and down keys on your keyboard to move between options. Press
    select to select it.

    This same functionality is present throughout most of Lister's
    menus.

    
        #{State.highlight("Creating A New List")}

        Beginning a new list in Interacive Mode is as simple as
        selecting \"New List\" from the Main Menu, and enterig a title
        when prompted.

        #{State.pastel.bold("Important: Each note must have a unique title, and titles are\n        case-sensitive.")}


        #{State.highlight("Edit An Existing List")}

        To edit an existing list, select \"Edit List\" from the Main
        Menu. Lister will show a new menu containing all of your
        lists. Select from these as you have other menus.
    

            #{State.highlight("Add an Item")}
        
            To add an item, select Add Item from the menu, and type
            the item when the prompt appears. The item will be
            appended, or, added to the end of the list.


            #{State.highlight("Remove an Item")}
        
            To remove an item, select \"Remove Item\" from the menu,
            and select the item from the interactive list. If the item
            is not on the screen, continue scrolling down, or use the
            ← & → keys to 'page' through. The once you have found the
            item, press enter while it i highlighted, and it will be
            removed.
            

            #{State.highlight("Change List Title")}

            To change the title of a list, select \"Change title\".
            Lister will prompt you for a new title.


            #{State.highlight("View Your List")}

            To view the list select \"View List\". The current list
            will be printed to the screen.


            #{State.highlight("Save Your List")}

            To save a list select \"Save List\". Lister will
            automatically name the save-file with the name of your
            list.


            #{State.highlight("Get Help")}
                
            Selecting \"Help\" on either the Main or Edit menus
            displays this help text.
            

            #{State.highlight("Return To Main Menu")}
            
            To return to the main menu, select \"Return To Main Menu\".

            #{State.pastel.bold("Important: Lister does not auto-save. Any unsaved changes\n            will be lost!")}


        #{State.highlight("Exit Lister")}

        When you are finished editing your list select \"Exit\" from
        the Main Menu.
        

    #{State.highlight("Linemode")}

    Using Lister direcly from the command-line is as simple as typing:

    #{State.highlight("lister [option] [list-title] [list-item]", "code")}


    [list-title] may be entered with or without surrounding quotes.
    i.e. #{State.highlight("title","code")} or #{State.highlight("\"title\"","code")}

    List titles that contain spaces (i.e. are more than one word) must
    be surrounded by quotes.
    
        #{State.highlight("Options")}

        #{State.highlight("-a")} or #{State.highlight("--add")}
        
        Add [list-item] to the end of [list-title].
        
        If [list-title] doesn't exist, Lister will create a new list
        named [list-title] that title, and append [list-item] to the
        list.


        #{State.highlight("-r")} or #{State.highlight("--remove")}
        
        Removes the last occurance of [list-item] from [list-title]
    

    #{State.pastel.bold("Some linemode options only take 1 argument:")}

        #{State.highlight("lister [option] [list-title]", "code")}
    

        #{State.highlight("-e")} or #{State.highlight("-echo")}

        Prints your list to the screen. It is possible to combine this
        with your pager (i.e. less):

        #{State.highlight("lister -e [list-title] | less", "code")}

        Or pass it to a new file:

        #{State.highlight("lister --echo [list-title] >> [filename]", "code")}


        #{State.highlight("-a")} or #{State.highlight("--add")}
        
        #{State.highlight("lister -a [list-title]", "code")}

        Will create a new list named [list-title] if [list-title]
        doesn't exist.

#{State.highlight("Jumping into Interactive Mode:")}

It's possible to jump straight to a function in Interactive Mode from
the command line:

    #{State.highlight("lister [list-title]","code")}

    Will load lister in Interactive mode, along with a file with the
    name [list-title], and display the Edit Menu.

    If [list-title] doesn't exist a matching file name doesn't exist,
    Lister will create a new list.

    #{State.highlight("lister [list-title] [list-item]","code")}

    Will behave the same as above, and also append [list-item] to the
    list before opening Edit menu.

HELP

def pager(text)
  TTY::Pager.page(text, command: "less -R", width: 75)
end

triage = ARGV.length

flags = [:a,:add,:r,:remove,:e,:echo]

# if !ARGV.empty?
!ARGV.empty? ? (flag = ARGV[0].gsub(/\-/,"").to_sym) : flag = nil
# end
if flags.include?(flag)
  $state.linemode = true
else
  $state.linemode = false
  flag = nil
end

  
  #####################################################
def editing_titles(words)
  puts State.pastel.cyan($font_straight.write(words.upcase))
end

# Editing Menu

def edit_list(list)

  puts list

  choices = State.edit_options

  opt = ""

  while opt != choices[-1]
          
    system "clear"
    editing_titles("edit")
    puts "Editing: #{State.highlight(list.list_title,"cyan")}"
    opt = State.select_items(choices)
    
    system "clear"
    
    case opt
      
    # Add item
    when choices[0]
      editing_titles(opt)
      item_to_add = State.ask "What item would you like to add?"

      list.add_item(item_to_add)

    # Remove item
    when choices[1]
      editing_titles(opt)
      if list.list_items.length == 0
        puts State.pastel.red.bold "There are no items in this list..."
      else
        # item_to_remove = State.select_items("Which item would you like to remove?", list.list_items_with_index.to_h)
        index_to_remove = State.menu.select("Which item would you like to remove?") do |menu|
          menu.enum "."
          count = 0
          list.list_items.each{|i|
            menu.choice i, count
            count +=1 
          }
        end
        # item_to_remove = State.select_items("What item would you like to remove?",list.list_items_no_index)
        # puts item_to_remove.index()
        puts list.remove_item(index_to_remove)
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
      pager(list.view_list)
      State.press_any_key

    # save list
    when choices[4] 
      editing_titles(opt)
      list.update_yaml
      puts State.save_list(list.list_title,list.list_yaml)

    # view Help
    when choices[5]
      editing_titles(opt)
      pager($help_text)

    else choices[6]
      editing_titles("Returning...")
      print"Returning to main menu"
      sleep(1)
      main_menu
    end
    sleep(0.75)
    system "clear"
  
  end
end

def print_title
  puts State.pastel.cyan($font_standard.write("Lister"))
end

def main_menu
  welcome_text = %(
    A terminal app for making lists.
    To get started, select "New List", and follow the prompts.
    
    )
  system "clear"
  opt = ""
  
  while opt != "Exit"
    print_title
    puts welcome_text
  
  opt = State.select_items(State.main_options)
  
  system = "clear"
  case opt
  when "New List"
    list_title = State.ask "What is the title of your list?"

    list = $state.create_list(list_title)
  
    puts edit_list(list)

  when "Load List"
    system "clear"
    print_title
    puts State.highlight("Load List","cyan")
    #update list files and titles
    State.update_list_titles
    #display lists to edit and return a value
    file_to_load = State.select_items("Which list would you like to edit?", State.titles)
    
    list = $state.load_list(file_to_load)

    puts edit_list(list)
    
  when "Help"
    puts
    pager($help_text)

  else "Exit"
    puts "Exit".upcase
    puts
    puts "Good Bye :)"
    exit
  end
  system "clear"
  end
end

if (triage >= 4)

  puts "Error: Too many arguments"
  exit
end

case triage
when 0
  main_menu
when 3

  begin
    if $state.linemode
      list_title = ARGV[1]
      list_item  = ARGV[2]
      if State.titles.include?(list_title)
        list = $state.load_list(list_title)
        begin
          case # flag
          when flag == :a || flag == :add
            list = list.add_item(list_item)
          when flag == :r || flag == :remove
            puts "The item will be removed"
          end
        rescue
          puts "#{ARGV[1]} Doesn't Exist"
          # raise #ArgumentsError, "Invalid number of arguments for #{ARGV[0]}"
        ensure
          puts State.save_list(list.list_title, list.list_yaml)
          exit
        end
      elsif !State.titles.include?(list_title) && flag == :a
        begin

          list = $state.create_list(list_title)

          list.add_item(list_item)

          puts State.save_list(list.list_title,list.list_yaml)
        rescue
          puts "Invalid number of arguments for #{ARGV[0]}"
          raise
        ensure
          exit
        end
      end
    end
  rescue
    puts "Invalid number of arguments for #{ARGV[0]}"
    raise StandardError
  ensure
    exit
  end
when 2
  if $state.linemode
    list_title =ARGV[1]  
    # If the list exists
  else
    # If linemode is off
    list_title = ARGV[0]
    list_item = ARGV[1]
  end
  if State.titles.include?(list_title)
    # load the list
    list = $state.load_list(list_title)
    # if linemode is on
    if flag != nil
      case
      when flag == :e || flag == :echo
        list.view_list
      else
        puts "Invalid Flag"
      end
    else
      list = $state.load_list(list_title)
      list.add_item(list_item)
      edit_list(list)
    end
  elsif !State.titles.include?(list_title) && (flag == :a ||flag == :add)
    if flag != nil
      list = $state.create_list(list_title)
      puts State.save_list(list.list_title,list.list_yaml)
    end
  else
    puts "Title not found, or some other error"
  end
when 1
  if $state.linemode
    # Giving a traceback, because they are accessing this through command line.
    # Prefer to give the user an error without a traceback
    puts State.pastel.red.bold("Error: Invalid number of arguments for -#{flag}. Expecting a title, with optional item")
    exit
    # raise StandardError, "Invalid number of arguments for -#{flag}. Expecting a title, with optional item"
  else
    list_title = ARGV[0]
    if State.titles.include?(list_title)
      # load the list
      list = $state.load_list(list_title)
      edit_list(list)
    else
      State.create_list(list_title)
    end
  end
else
  puts "An Error has occured"
end