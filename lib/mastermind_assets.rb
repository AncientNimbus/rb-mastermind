# frozen_string_literal: true

# Mastermind CLI Assets Module
#
# @author Ancient Nimbus
module MastermindAssets
  # Text strings for the game
  MSGS = {
    keys: { exit: 'exit', yes: 'yes' },

    mode: { re: /\A[1-2]\z/, msg: 'Select a mode (1 or 2) to continue...',
            err_msg: 'Please enter a valid mode!', evp: "\n* Code Maker mode selected",
            pve: "\n* Code Breaker mode selected" },

    shape: { x: 'X', o: 'O' },

    rst: { re: /\byes\b/, msg: "\n* Restart? (Type: yes)",
           err_msg: 'Please enter a valid input!' },

    player: { re: /.*/, msg: ->(num) { "Please name Player #{num}" }, err_msg: 'Name cannot be empty!' },

    ai: { name: 'Computer', feedback_msg1: ->(name) { "\n* #{name} is thinking..." },
          feedback_msg2: ->(name, num) { "* #{name} has chose grid #{num}!" } },

    play: { re: /\A[1-9]\z/, msg: lambda { |name|
      "It is #{name}'s turn, choose from grid number 1 to 9"
    }, err_msg: 'Invalid input, choose again!' },

    first_turn: { msg: lambda { |name|
      "\n* Randomly picking who is starting first... \n* #{name} will make the first turn"
    } },

    tie: { msg: "\n* It is a Tie!" },

    win: { msg: ->(name) { "\n* #{name} has won this round!" } }
  }.freeze
  # @todo: ASCII Banner
  # @todo: Program info
  # @todo: Game introduction
  # @todo: Game board design
  # @todo: Game flow design
  # @todo: User messages
  # @todo: Input warnings
end
