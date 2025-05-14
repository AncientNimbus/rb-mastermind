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

  attr_accessor :all_codes
  attr_reader :turns, :digits_arr, :slots, :mode, :secret_code

  PEGS = { 1 => :green, 2 => :yellow, 3 => :blue, 4 => :magenta, 5 => :cyan, 6 => :red }.freeze
  STATES = { good: :red, off: :white, wrong: :grey }.freeze

  def initialize(turns = 12, digits: 6, slots: 4)
    # pre-game
    @mode = get_input(MSGS.dig(:mode, :re), MSGS.dig(:mode, :msg), MSGS.dig(:mode, :err_msg), type_mode: true)
    # @mode = input_v2(MSGS.dig(:mode, :re), MSGS.dig(:mode, :msg), MSGS.dig(:mode, :err_msg))
    # Game board configuration
    init_game(turns, digits, slots)

    debug

    # test = Computer.new('Computer', 'CodeMaker')
    # test.save_turn(1, [1, 2, 3, 4], [1, 2]) # possible save format
  end

  def all_combinations
    combinations(digits_arr, slots)
  end

  def mode_selection
    # puts mode == 1 ? FLOW.dig(:mode, :pvp) : FLOW.dig(:mode, :pve)
    # @p1 = create_player
    # self.p2 = if mode == 1
    #             create_player
    #           else
    #             Computer.new
    #           end
    # new_game
  end

  def init_game(turns, digits, slots)
    @turns = turns
    @digits_arr = (1..digits).to_a
    @slots = slots

    @all_codes = all_combinations
    @secret_code = code_picker
  end

  private

  # pick one code randomly
  def code_picker
    random_picker(all_codes)
  end

  def debug
    p digits_arr
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
# 3. Method that will accept a 4 numbered sequence and save it as secret
# 4. Display a row that will show user / computer’s guess (4 main slots)
# 5. Display hints (4 mini slots next to the main slots)
# 6. Let user to be code maker
# 7. Let computer to be code maker (Default behaviour)
# 8. Let user to be code breaker (Default behaviour)
# 9. Let computer to be code breaker
# 11. Get computer random input
# 12. Get input from algorithmic solver (hardest part of the project!)
# 13. Game last for 12 turns
# 14. Offer to restart
# 15. Offer to exit
# 18. ASCII Banner (Extra: Finesse)
