# frozen_string_literal: true

# CLI Operations helper module
#
# @author Ancient Nimbus
module CliHelper
  # A method that collects user input, and only returns the value
  # when it is validated against the provided Regex pattern.
  # @param reg [Regexp] a Regex pattern to check against user inputs
  # @param msg [String] prompt to print to the user
  # @param err_msg [String] display warning message when on invalid inputs
  # @return [String] user input
  def self.get_input(reg, msg, err_msg = nil)
    input_value = ''
    first_entry = true

    until input_value.match?(reg) && !input_value.empty?
      message = first_entry ? msg : err_msg
      puts "\n* #{message}"
      first_entry = false

      input_value = gets.chomp
      exit if input_value == FLOW.dig(:keys, :exit)
    end
    input_value
  end

  # TODO: Typing effect method
  # TODO: Text delay method
end
