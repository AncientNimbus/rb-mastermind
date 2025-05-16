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
  def initialize(name = 'Computer')
    super(name)
  end

  # Generate a 4 digit code
  def code_gen(options_arr)
    random_picker(options_arr)
  end
end
