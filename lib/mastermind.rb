# frozen_string_literal: true

require 'colorize'
require_relative 'mastermind_assets'
require_relative 'player'
require_relative 'logic'
require_relative 'cli_helper'

# Base class for the game Mastermind.
#
# @author Ancient Nimbus
# @since 0.1.0
# @version 0.9.1
class Mastermind
  include CliHelper
  include Logic
  include MastermindAssets

  attr_accessor :all_codes, :turns, :digits_arr, :slots, :mode, :secret_code, :turn, :win, :p1, :ai
  attr_reader :game_config

  def initialize(turns = 12, digits: 6, slots: 4)
    # welcome
    # Game board configuration
    @game_config = { turns: turns, digits: (1..digits).to_a, slots: slots }
    # Enter game session
    mode_selection
  end

  # Greeting sequence when player launch the program for the first time.
  def welcome
    slowed_reply(START, tw_delay: 0.025)
    gets
    slowed_reply(LOGO, tw_delay: 0.0025)
    slowed_reply(HOW, tw_delay: 0.025)
  end

  # Prompt user to select a mode and start the game mode accordingly
  # - mode 1: User as the code breaker
  # - mode 2: Computer as the code breaker
  def mode_selection
    @mode = prompt_handler(:mode).to_i
    mode == 1 ? typewriter(MSGS.dig(:mode, :pve)) : typewriter(MSGS.dig(:mode, :evp))
    @p1 = create_player
    @ai = Computer.new

    slowed_reply(MSGS.dig(:welcome, :msg).call(p1.name))
    new_game(mode)
  end

  # Access the Player class to create a human player
  def create_player
    Player.new(get_input(MSGS.dig(:player, :re), MSGS.dig(:player, :msg).call(Player.total_player + 1),
                         MSGS.dig(:player, :err_msg)))
  end

  # Build the game display
  def row_builder(guess = [0, 0, 0, 0], hints = [0, 0, 0, 0], title: "Turn: #{turn}")
    <<~ROW
      #{title}
      *-----+-----+-----+-----*---+---*
      |     |     |     |     | #{DF[:"h#{hints.fetch(0, 0)}"]} | #{DF[:"h#{hints.fetch(1, 0)}"]} |
      |  #{DF[:"d#{guess.fetch(0, 0)}"]}  |  #{DF[:"d#{guess.fetch(1, 0)}"]}  |  #{DF[:"d#{guess.fetch(2, 0)}"]}  |  #{DF[:"d#{guess.fetch(3, 0)}"]}  |---+---|
      |     |     |     |     | #{DF[:"h#{hints.fetch(2, 0)}"]} | #{DF[:"h#{hints.fetch(3, 0)}"]} |
      *-----+-----+-----+-----*---+---*
      Help: #{HELP}
    ROW
  end

  # Pre-game setup, configuring the environment and setup instance variables.
  def init_game
    @turns = game_config[:turns]
    @digits_arr = game_config[:digits]
    @slots = game_config[:slots]

    @all_codes = all_combinations
    @secret_code = code_picker
    p "Cheat: Secret is #{secret_code}"

    @turn = 1
    @win = false

    p1.clear_save
    ai.clear_save
  end

  # Core game loop
  def game_loop
    until win || turn > turns
      guess = play_turn
      hints, self.win = compare_value(guess, secret_code)
      # Save turn to player's save data
      p1.save_turn(turn, { guess: guess, hints: hints })
      # print turn to board display
      slowed_reply(row_builder(guess, hints_to_arr(hints)), tw_delay: 0.01)

      self.turn += 1 unless win
    end
    announce_winner
  end

  # Prompt user to get the 4 digit guess
  # @version 2.0.0
  def play_turn
    mode == 1 ? input_to_code(prompt_handler(:play)) : random_picker(all_codes)
  end

  # Start a new game based on the selected mode
  # @version 2.0.0
  def new_game(mode = 1)
    init_game
    # Setting the row title depending on the chosen mode
    title = mode == 1 ? MSGS.dig(:row_title1, :msg) : MSGS.dig(:row_title2, :msg).call(print_code(secret_code))
    # display a blank board
    slowed_reply(row_builder(title: title), tw_delay: 0.01)
    # Enter game loop
    game_loop
  end

  # Display winner's messages
  def announce_winner
    if win
      slowed_reply(MSGS.dig(:win, :msg).call(p1.name, turn))
    else
      slowed_reply(MSGS.dig(:lose, :msg).call(p1.name, print_code(secret_code)))
    end
    restart
  end

  # Prompt user to restart the game
  def restart
    prompt_handler(:rst) ? new_game(mode) : exit
  end

  # Print secret code with colored icons
  def print_code(range = [*1..4])
    arr = []
    range.each do |num|
      arr.push("#{DF[:"d#{num}"]} ")
    end
    arr.join(' ')
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
    mode == 1 ? ai.code_gen(all_codes) : input_to_code(prompt_handler(:pick_code))
  end

  CliHelper.do_at_exit(MSGS.dig(:exit, :msg))
end

# ### TODO Requirements
# 12. Get input from algorithmic solver (hardest part of the project!) (hard mode)
# Global typewriter switch
