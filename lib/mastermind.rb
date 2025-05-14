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
  def initialize
    p 'Mastermind'
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
# 10. Get user input
# 11. Get computer random input
# 12. Get input from algorithmic solver (hardest part of the project!)
# 13. Game last for 12 turns
# 14. Offer to restart
# 15. Offer to exit
# 16. Text delay (Extra: Simulated thinking, Finesse)
# 17. Text typing effect (Extra: Finesse)
# 18. ASCII Banner (Extra: Finesse)
