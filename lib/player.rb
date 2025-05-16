# frozen_string_literal: true

require_relative 'logic'
# Player class for Mastermind
#
# @abstract
# @author Ancient Nimbus
# @since 0.1.0
class Player
  include Logic

  @number_of_player = 0
  attr_accessor :name, :role, :game_save

  def initialize(name)
    @name = name
    @game_save = {}
    Player.count_player
  end

  # Save actions performed by the player
  def save_turn(key, value)
    game_save[key] = value
  end

  # Clear player save data
  def clear_save
    game_save.clear
  end

  # Return save data of a single turn
  def view_turn(turn)
    game_save[turn]
  end

  def self.count_player
    @number_of_player += 1
  end

  def self.total_player
    @number_of_player
  end
end

# Computer is a subclass of the Player class
#
# @author Ancient Nimbus
# @since 0.1.0
class Computer < Player
  attr_accessor :options_arr
  attr_reader :all_options_arr

  def initialize(all_options_arr, name = 'Computer')
    super(name)
    @options_arr = all_options_arr.dup
    @all_options_arr = all_options_arr
  end

  # Save actions performed by the computer and remove bad options
  # @since 0.9.4
  # @version 1.0.0
  def save_turn(key, value)
    super
    remove_opts(value[:guess], value[:hints], options_arr)
  end

  # Add all valid codes back to computer player
  # @since 0.9.4
  # @version 1.0.0
  def clear_save
    super
    self.options_arr = all_options_arr.dup
  end

  # Generate a 4 digit code
  # @return [Array<Integer>]
  def code_gen(options_arr)
    random_picker(options_arr)
  end

  # Solve player 1's code
  # @return [Array<Integer>]
  # @since 0.9.4
  # @version 1.0.0
  def code_solver
    minimax_solver(options_arr, all_options_arr)
  end
end
