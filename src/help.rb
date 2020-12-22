#!/usr/bin/env Ruby

require 'pastel'


<<-HELP

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