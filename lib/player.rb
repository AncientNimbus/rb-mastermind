# frozen_string_literal: true

require_relative 'logic'
# Player class for Mastermind
#
# @abstract
# @author Ancient Nimbus
# @since 0.1.0
class Player
  include Logic

  attr_accessor :name, :role, :game_save

  def initialize(name)
    @name = name
    @game_save = {}
  end

  # Save actions performed by the player
  def save_turn(key, *value)
    game_save[key] = value
  end

  # Clear player save data
  def clear_save
    game_save.clear
  end
end

# Computer is a subclass of the Player class
#
# @author Ancient Nimbus
class Computer < Player
  def initialize(name = 'Computer')
    super(name)
  end

  # Generate a 4 digit code
  def code_gen(options_arr)
    random_picker(options_arr)
  end
end
