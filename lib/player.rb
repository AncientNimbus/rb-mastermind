# frozen_string_literal: true

# Player class for Mastermind
#
# @abstract
# @author Ancient Nimbus
# @since 0.1.0
class Player
  attr_accessor :name, :role, :game_save

  def initialize(name, role)
    @name = name
    @role = role
    @game_save = {}
  end

  def save_turn(key, *value)
    game_save[key] = value
  end

  def clear_save
    game_save.clear
  end
end

# Computer is a subclass of the Player class
#
# @author Ancient Nimbus
class Computer < Player
  def code_gen
    # Generate a 4 digit code
  end
end
