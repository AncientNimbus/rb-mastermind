# frozen_string_literal: true

# Mastermind CLI Assets Module
#
# @author Ancient Nimbus
module MastermindAssets
  # Pre-launch info
  START = <<~'PRE'
    |<<=============|Reference this line to adjust your console window width for the best experience|=============>>|

    * When you are ready, press 'enter' to start...
  PRE
  # Banner for the program
  LOGO = <<~'LOGO'
    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
    |  ___      ___      __       ________ ___________ _______  _______  ___      ___  __   _____  ___  ________    |
    + |"  \    /"  |    /""\     /"       ("     _   "/"     "|/"      \|"  \    /"  ||" \ (\"   \|"  \|"      "\   +
    |  \   \  //   |   /    \   (:   \___/ )__/  \\__(: ______|:        |\   \  //   |||  ||.\\   \    (.  ___  :)  |
    |  /\\  \/.    |  /' /\  \   \___  \      \\_ /   \/    | |_____/   )/\\  \/.    ||:  ||: \.   \\  |: \   ) ||  |
    + |: \.        | //  __'  \   __/  \\     |.  |   // ___)_ //      /|: \.        ||.  ||.  \    \. (| (___\ ||  +
    | |.  \    /:  |/   /  \\  \ /" \   :)    \:  |  (:      "|:  __   \|.  \    /:  |/\  ||    \    \ |:       :)  |
    | |___|\__/|___(___/    \___(_______/      \__|   \_______|__|  \___|___|\__/|___(__\_|_\___|\____\(________/   |
    +                                                                                                               +
    |                              A Command Line Game by: Ancient Nimbus | Ver: 0.7.1                              |
    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
  LOGO
  # Text strings for the game
  MSGS = {
    keys: { exit: 'exit', yes: 'yes' },

    mode: { re: /\A[1-2]\z/, msg: 'Select a mode (1 or 2) to continue...',
            err_msg: 'Please enter a valid mode!', evp: "\n* Code Maker mode selected",
            pve: "\n* Code Breaker mode selected" },

    shape: { x: 'X', o: 'O' },

    rst: { re: /\byes|y\b/, msg: "Restart? Type: 'y'/'yes' or 'exit' to quit",
           err_msg: 'Please enter a valid input!' },

    player: { re: /.*/, msg: ->(num) { "Please name Player #{num}" }, err_msg: 'Name cannot be empty!' },

    ai: { name: 'Computer', feedback_msg1: ->(name) { "\n* #{name} is thinking..." },
          feedback_msg2: ->(name, num) { "* #{name} has chose grid #{num}!" } },

    play: { re: /\A[1-6]{4}\z/, msg: 'Make a guess...',
            err_msg: 'Invalid input! Enter a 4-digit number between 1-6 (e.g., 4216)' },

    first_turn: { msg: lambda { |name|
      "\n* Randomly picking who is starting first... \n* #{name} will make the first turn"
    } },

    tie: { msg: "\n* It is a Tie!" },

    win: { msg: ->(name) { "\n* #{name} has won this round!" } }
  }.freeze

  # @todo: Game introduction
  # @todo: Game board design
  # @todo: Game flow design
  # @todo: User messages
  # @todo: Input warnings
end
