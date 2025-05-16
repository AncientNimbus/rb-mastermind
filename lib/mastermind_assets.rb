# frozen_string_literal: true

require 'colorize'
# Mastermind CLI Assets Module
#
# @author Ancient Nimbus
# @version 0.9.2
module MastermindAssets
  # Text Formatting helper
  TFH = {
    digits: '4'.colorize(:yellow),
    min_d: '1'.colorize(:yellow),
    max_d: '6'.colorize(:yellow),
    turns: '12'.colorize(:yellow),
    mode1: '1'.colorize(:yellow),
    mode2: '2'.colorize(:yellow),
    enter_cmd: 'enter'.colorize(:green),
    exit_cmd: 'exit'.colorize(:yellow)
  }.freeze

  # Display Formatter
  DF = {
    d0: '◌'.colorize(:light_grey),
    d1: '❶'.colorize(:green),
    d2: '❷'.colorize(:yellow),
    d3: '❸'.colorize(:blue),
    d4: '❹'.colorize(:magenta),
    d5: '❺'.colorize(:cyan),
    d6: '❻'.colorize(:red),
    h0: '◌'.colorize(:light_grey),
    h1: '●'.colorize(:white),
    h2: '●'.colorize(:red)
  }.freeze

  # Game row preview
  ROW = <<~ROW.freeze
    *-----+-----+-----+-----*---+---*
    |     |     |     |     | #{DF[:h0]} | #{DF[:h1]} |
    |  #{DF[:d1]}  |  #{DF[:d3]}  |  #{DF[:d4]}  |  #{DF[:d2]}  |---+---|
    |     |     |     |     | #{DF[:h2]} | #{DF[:h0]} |
    *-----+-----+-----+-----*---+---*
  ROW

  # Helper method to build help string
  def self.build_help(range = [*1..6])
    range.map { |num| "#{num} ➜ #{DF[:"d#{num}"]} " }.join(' ')
  end
  # Input Helper
  HELP = MastermindAssets.build_help

  # Pre-launch info
  START = <<~PRE.freeze
    |<<=============|Reference this line to adjust your console window width for the best experience|=============>>|

    |<<=========================|Avoid typing when text is printing (A fix is coming...)|=========================>>|

    * Hi there!
    * When you are ready, press #{TFH[:enter_cmd]} to start...
  PRE

  # Banner for the program
  LOGO = <<~'LOGO'.colorize(:green)
    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
    |  ___      ___      __       ________ ___________ _______  _______  ___      ___  __   _____  ___  ________    |
    + |"  \    /"  |    /""\     /"       ("     _   "/"     "|/"      \|"  \    /"  ||" \ (\"   \|"  \|"      "\   +
    |  \   \  //   |   /    \   (:   \___/ )__/  \\__(: ______|:        |\   \  //   |||  ||.\\   \    (.  ___  :)  |
    |  /\\  \/.    |  /' /\  \   \___  \      \\_ /   \/    | |_____/   )/\\  \/.    ||:  ||: \.   \\  |: \   ) ||  |
    + |: \.        | //  __'  \   __/  \\     |.  |   // ___)_ //      /|: \.        ||.  ||.  \    \. (| (___\ ||  +
    | |.  \    /:  |/   /  \\  \ /" \   :)    \:  |  (:      "|:  __   \|.  \    /:  |/\  ||    \    \ |:       :)  |
    | |___|\__/|___(___/    \___(_______/      \__|   \_______|__|  \___|___|\__/|___(__\_|_\___|\____\(________/   |
    +                                                                                                               +
    |                              A Command Line Game by: Ancient Nimbus | Ver: 0.9.2                              |
    +---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+---+
  LOGO

  # How to play
  HOW = <<~HOW.freeze
    How-to-play:
     * The Code Maker will create a #{TFH[:digits]} digits sequence secret code.
     * Each digit is set between #{TFH[:min_d]} to #{TFH[:max_d]}, and it can repeat. For example: 1216, 6542, 1166...
     * The Code Breaker's goal is to try guess the secret code.
     * After each guess, Code Breaker will receive a feedback represented by red and/or white dots.
     * Red dot indicates the digit value is in the code, and at the right slot.
     * White dot indicates the digit value is in the code, but at the wrong slot.
     * The hints are not in order.
     * Win the game by making the right guess within #{TFH[:turns]} turns.

    Mode selection:
     * [#{TFH[:mode1]}] Become the Code Breaker - Try to guess the code!
     * [#{TFH[:mode2]}] Become the Code Maker   - Put your computer to the test! (Coming Soon!)

    Game layout:
    #{ROW}
    Help: #{HELP}

    You can type #{TFH[:exit_cmd]} to leave the game at any point.
  HOW

  # Text strings for the game
  MSGS = {
    keys: { exit: 'exit', yes: 'yes' },

    exit: { msg: '* Thank you for playing LLAP 🖖' },

    mode: { re: /\A[1-2]\z/, msg: "Select a mode to continue... (Type: #{TFH[:mode1]} or #{TFH[:mode2]})",
            err_msg: 'Please enter a valid mode number!',
            evp: '* Code Maker mode selected', pve: '* Code Breaker mode selected' },

    rst: { re: /\byes|y\b/, msg: "Restart? Type: 'y'/'yes' or 'exit' to quit",
           err_msg: 'Please enter a valid input!' },

    player: { re: /.*/, msg: ->(num) { "Please name Player #{num}" },
              err_msg: 'Name cannot be empty!' },

    play: { re: /\A[1-6]{4}\z/, msg: 'Make a guess...',
            err_msg: 'Invalid input! Enter a 4-digit number between 1-6 (e.g., 4216)' },

    pick_code: { re: /\A[1-6]{4}\z/, msg: 'Create a secret code...',
                 err_msg: 'Invalid input! Enter a 4-digit number between 1-6 (e.g., 4216)' },

    ai: { name: 'Computer',
          fb_msg1: ->(name) { "* #{name} is thinking..." },
          fb_msg2: ->(name, code) { "* #{name} has entered #{code}!" } },

    row_title1: { msg: ->(_code) { 'Computer has chosen **** as secret code, and you have 12 attempts to crack it.' } },

    row_title2: { msg: ->(code) { "Your code: #{code} is stored, and computer has 12 attempts to crack it." } },

    welcome: { msg: ->(name) { "* Welcome to Mastermind, #{name.colorize(:yellow)} ;)" } },

    win: { msg: lambda { |name, turn|
      "* Mastermind #{name}! You cracked the code in #{turn} turn#{'s' if turn > 1}! Well done!"
    } },

    win_ai: { msg: ->(_name, turn) { "* Mighty Computer has cracked your code in #{turn} turn#{'s' if turn > 1}!" } },

    lose: { msg: ->(name, code) { "* This is a tough one #{name}, the secret code is #{code}." } },

    lose_ai: { msg: ->(name, _code) { "* #{name}, you have outsmarted your mighty computer, well done!" } }
  }.freeze
end
