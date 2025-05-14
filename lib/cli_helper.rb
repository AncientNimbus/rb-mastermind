# frozen_string_literal: true

# CLI Operations helper module
#
# @author Ancient Nimbus
# @since 0.1.0
module CliHelper
  # A method that collects user input, and only returns the value
  # when it is validated against the provided Regex pattern.
  # @param reg [Regexp] a Regex pattern to check against user inputs
  # @param msg [String] prompt to print to the user
  # @param err_msg [String] display warning message when on invalid inputs
  # @return [String] user input
  def get_input(reg = /.*/, msg = 'Enter your input...', err_msg = nil, exit_str: 'exit')
    input_value = ''
    first_entry = true

    until input_value.match?(reg) && !input_value.empty?
      message = first_entry ? msg : err_msg
      puts "\n* #{message}"
      first_entry = false

      input_value = gets.chomp
      exit if input_value == exit_str
    end
    input_value
  end

  # A method that prints text to the console one character at a time.
  # @param str [String] text to print
  # @param delay [Float] character output rate in second
  # @return an empty line
  def typewriter(str, delay: 0.1)
    str.each_char do |char|
      print char
      sleep(delay)
    end
    puts
  end

  # A method that prints text to the console at a delayed rate.
  # The idea here is to simulate a chatbot-like behavior.
  # @param str_arr [Array<String>] an array of strings, the method will print one element at a time
  # @param delay [Float] line output rate in second
  # @param type_mode [Boolean] toggle true to enable typewriter style output
  # @param tw_delay [Float] character output rate in second
  def slowed_reply(str_arr, delay: 0.5, type_mode: true, tw_delay: 0.1)
    str_arr.each do |str|
      if type_mode
        print typewriter(str, delay: tw_delay)
      else
        puts str
      end
      sleep(delay)
    end
  end
end
