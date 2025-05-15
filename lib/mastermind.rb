# frozen_string_literal: true

require 'colorize'
require_relative 'mastermind_assets'
require_relative 'player'
require_relative 'logic'
require_relative 'cli_helper'

# Base class for the game Mastermind.
#
# @author Ancient Nimbus
class Mastermind
  include CliHelper
  include Logic
  include MastermindAssets

  attr_accessor :all_codes, :turns, :digits_arr, :slots, :mode, :secret_code, :turn, :win, :p1, :ai
  attr_reader :game_config

  # Coloring options for main slots
  PEGS = { 1 => :green, 2 => :yellow, 3 => :blue, 4 => :magenta, 5 => :cyan, 6 => :red }.freeze
  # Coloring options for hint slots
  STATES = { red: :red, white: :white, default: :grey }.freeze

  def initialize(turns = 12, digits: 6, slots: 4)
    # Welcome
    slowed_reply([START.colorize(:yellow)])
    gets
    slowed_reply([LOGO.colorize(:green)], tw_delay: 0.0025)

    # Game board configuration
    @game_config = { turns: turns, digits: (1..digits).to_a, slots: slots }
    # Enter game session
    mode_selection
  end

  # Prompt user to select a mode and start the game mode accordingly
  # - mode 1: User as the code breaker
  # - mode 2: Computer as the code breaker
  def mode_selection
    @mode = prompt_handler(:mode).to_i
    mode == 1 ? typewriter(MSGS.dig(:mode, :pve)) : typewriter(MSGS.dig(:mode, :evp))
    @p1 = create_player
    @ai = Computer.new

    new_game(mode)
  end

  # Access the Player class to create a human player
  def create_player
    Player.new(get_input(MSGS.dig(:player, :re), MSGS.dig(:player, :msg).call('P1'), MSGS.dig(:player, :err_msg)))
  end

  # Pre-game setup, configuring the environment and setup instance variables.
  def init_game
    @turns = game_config[:turns]
    @digits_arr = game_config[:digits]
    @slots = game_config[:slots]

    @all_codes = all_combinations
    @secret_code = code_picker

    @turn = 1
    @win = false

    p1.clear_save
    ai.clear_save
  end

  # Core game loop
  def game_loop
    until win || turn > turns
      p "Cheat: Secret is #{secret_code}"
      guess = prompt_handler(:play).split('').map(&:to_i)
      p1.save_turn(turn, { guess: guess, hints: compare_value(guess, secret_code) })

      p p1.view_turn(turn)
      p p1.game_save

      self.turn += 1
    end
    announce_winner
  end

  # Start a new game based on the selected mode
  def new_game(mode = 1)
    puts "Starting mode: #{mode}"
    init_game
    game_loop
  end

  # Display winner's messages
  def announce_winner
    puts 'Somebody win'
    restart
  end

  # Prompt user to restart the game
  def restart
    prompt_handler(:rst) ? new_game(mode) : exit
  end

  private

  # Calculate and return every valid combinations of the game.
  def all_combinations
    combinations(digits_arr, slots)
  end

  # Helper to trim down repeated typing when accessing eternal textfile.
  # @param msg_key [:Symbol] expects message key value, reference MastermindAssets for more info.
  def prompt_handler(msg_key, type_mode: true)
    get_input(MSGS.dig(msg_key, :re), MSGS.dig(msg_key, :msg), MSGS.dig(msg_key, :err_msg), type_mode: type_mode)
  end

  # Determine how the code is created based on game mode.
  def code_picker
    mode == 1 ? ai.code_gen(all_codes) : [1, 2, 3, 4]
  end
end

# ### Game variations
# Mastermind original: 6 colours and 4 holes
# ### Requirements
# 1. A set of codes from 1 - 6 represented by 6 different colours
# 2. 3 states per row positions: Red, White, and Empty
#    1. Empty: Wrong guess
#    2. White: In the code, but not in the right position
#    3. Red: In the code, and in the right place
# 4. Display a row that will show user / computer’s guess (4 main slots)
# 5. Display hints (4 mini slots next to the main slots)
# 6. Let user to be code maker
# 7. Let computer to be code maker (Default behaviour)
# 8. Let user to be code breaker (Default behaviour)
# 9. Let computer to be code breaker
# 11. Get computer random input
# 12. Get input from algorithmic solver (hardest part of the project!)
# 18. ASCII Banner (Extra: Finesse)
