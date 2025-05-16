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
# @version 1.0.0
class Mastermind
  include CliHelper
  include Logic
  include MastermindAssets

  MODE2_KEYS = { pve: :evp, row_title1: :row_title2, win: :win_ai, lose: :lose_ai }.freeze

  attr_accessor :all_codes, :turns, :digits_arr, :slots, :mode, :secret_code, :turn, :win, :p1, :ai
  attr_reader :game_config

  def initialize(turns = 12, digits: 6, slots: 4)
    welcome
    # Game board configuration
    @game_config = { turns: turns, digits: (1..digits).to_a, slots: slots }
    @all_codes = all_combinations
    # Enter game session
    mode_selection
  end

  # Greeting sequence when player launch the program for the first time.
  def welcome
    slowed_reply(START, tw_delay: 0.025)
    gets
    slowed_reply([LOGO, HOW], tw_delay: 0.0025)
  end

  # Prompt user to select a mode and start the game mode accordingly
  # - mode 1: User as the code breaker
  # - mode 2: Computer as the code breaker
  def mode_selection
    @mode = prompt_handler(:mode).to_i
    typewriter(MSGS.dig(:mode, prompt_picker(:pve)))
    @p1 = create_player
    @ai = Computer.new(all_codes)

    slowed_reply(MSGS.dig(:welcome, :msg).call(p1.name))
    new_game
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

  # print current turn to console
  # @since 0.9.3
  def print_turn(guess, hints)
    display = [row_builder(guess, hints_to_arr(hints))]
    display.insert(0, MSGS.dig(:ai, :fb_msg).call(MSGS.dig(:ai, :name), guess.join(''))) if mode == 2
    slowed_reply(display, tw_delay: 0.01)
  end

  # Pre-game setup, configuring the environment and setup instance variables.
  def init_game
    @turns = game_config[:turns]
    @digits_arr = game_config[:digits]
    @slots = game_config[:slots]
    @secret_code = code_picker
    # p "Cheat: Secret is #{secret_code}"

    @turn = 1
    @win = false

    p1.clear_save
    ai.clear_save
  end

  # Core game loop
  # @version 2.0.0
  def game_loop(player)
    until win || turn > turns
      guess = play_turn
      hints, self.win = compare_value(guess, secret_code)
      # Save turn to current player's save data
      player.save_turn(turn, { guess: guess, hints: hints })
      # print turn to board display
      print_turn(guess, hints)

      self.turn += 1 unless win
    end
    announce_result
  end

  # Start a new game based on the selected mode
  # @version 2.0.0
  def new_game
    init_game
    # Setting the row title depending on the chosen mode
    title = MSGS.dig(prompt_picker(:row_title1), :msg).call(print_code(secret_code))
    # display a blank board
    slowed_reply(row_builder(title: title), tw_delay: 0.01)
    # Enter game loop
    game_loop(mode == 1 ? p1 : ai)
  end

  # Prompt user to get the 4 digit guess
  # @version 2.0.0
  def play_turn
    mode == 1 ? input_to_code(prompt_handler(:play)) : ai.code_solver
  end

  # Display session result
  def announce_result
    p1_name = p1.name
    response = win ? [:win, p1_name, turn] : [:lose, p1_name, print_code(secret_code)]

    slowed_reply(MSGS.dig(prompt_picker(response[0]), :msg).call(response[1], response[2]))

    restart
  end

  # Prompt user to restart the game
  def restart
    prompt_handler(:rst) ? new_game : exit
  end

  private

  # Pick which strings to call depending on mode
  # @param symbol [Symbol] expects mode 1 key name
  # @return [Symbol] if mode 1 is selected return the same key name otherwise returns mode 2 key name
  # @since 0.9.2
  # @version 1.1.0
  def prompt_picker(symbol)
    return symbol if mode == 1

    MODE2_KEYS[symbol]
  end

  # Print secret code with colored icons
  # @version 2.0.0
  def print_code(range = [*1..4])
    range.map { |num| "#{DF[:"d#{num}"]} " }.join(' ')
  end

  # Calculate and return every valid combinations of the game.
  def all_combinations
    combinations(game_config[:digits], game_config[:slots])
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
