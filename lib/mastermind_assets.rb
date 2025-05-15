# frozen_string_literal: true

require 'colorize'
# Mastermind CLI Assets Module
#
# @author Ancient Nimbus
# @version 0.7.2
module MastermindAssets
  # Pre-launch info
  START = <<~'PRE'
    |<<=============|Reference this line to adjust your console window width for the best experience|=============>>|

    * Hi there!
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
    |                              A Command Line Game by: Ancient Nimbus | Ver: 0.7.2                              |
    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
  LOGO
  # How to play
  HELP = <<~HELP.freeze
    How-to-play:
     * The Code Maker will create a #{'4'.colorize(:yellow)} digits sequence secret code.
     * Each digit is set between 1 to 6, and it can repeat. For example: 1216, 6542, 1166...
     * The Code Breaker's goal is to try guess the secret code.
     * After each guess, Code Breaker will receive a feedback represented by red and/or white dots.
     * Red dot indicates the digit value is in the code, and at the right slot.
     * White dot indicates the digit value is in the code, but at the wrong slot.
     * Win the game by making the right guess within #{'12 turns'.colorize(:yellow)}.

    Mode selection:
     * #{'[1]'.colorize(:yellow)} Become the Code Breaker - Try to guess code!
     * #{'[2]'.colorize(:yellow)} Become the Code Maker   - Put your computer to the test!

    You can type #{'exit'.colorize(:yellow)} to leave the game at any point.
  HELP
  # Text strings for the game
  MSGS = {
    keys: { exit: 'exit', yes: 'yes' },

    mode: { re: /\A[1-2]\z/,
            msg: 'Select a mode to continue... (Type: 1 or 2)',
            err_msg: 'Please enter a valid mode number!',
            evp: '* Code Maker mode selected',
            pve: '* Code Breaker mode selected' },

    rst: { re: /\byes|y\b/,
           msg: "Restart? Type: 'y'/'yes' or 'exit' to quit",
           err_msg: 'Please enter a valid input!' },

    player: { re: /.*/,
              msg: ->(num) { "Please name Player #{num}" },
              err_msg: 'Name cannot be empty!' },

    play: { re: /\A[1-6]{4}\z/,
            msg: 'Make a guess...',
            err_msg: 'Invalid input! Enter a 4-digit number between 1-6 (e.g., 4216)' },

    ai: { name: 'Computer',
          fb_msg1: ->(name) { "* #{name} is thinking..." },
          fb_msg2: ->(name, code) { "* #{name} has entered #{code}!" } },

    win: { msg: ->(name) { "* #{name}, you have cracked the code! You are the Mastermind!" } },

    lose: { msg: ->(name, code) { "* This is a tough one #{name}, the secret code is #{code}." } }
  }.freeze

  # @todo: Game introduction
  # @todo: Game board design
  # @todo: Game flow design
end
