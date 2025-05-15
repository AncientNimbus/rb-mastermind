# frozen_string_literal: true

# Game logic helper module
#
# @author Ancient Nimbus
# @since 0.1.0
module Logic
  # Generates all possible combinations of n elements from the given array.
  # Each combination is a Cartesian product of the array with itself n times.
  #
  # @param num_arr [Array<Integer>] the array of numbers to generate combinations from such as [*1..4]
  # @param combo_length [Integer] the length of each combination
  # @return [Array<Array<Integer>>] an array of all possible combinations
  # @version 1.0.0
  def combinations(num_arr, combo_length)
    b_arr = combo_length > 1 ? Array.new(combo_length - 1, num_arr) : []
    num_arr.product(*b_arr)
  end

  # Select and return element(s) randomly from an array object.
  #
  # @param arr [Array<Object>] array of objects
  # @param output_elem [Integer] number of random elements to return
  # @return [Array<Object>] an array of random element(s)
  # @version 1.0.0
  def random_picker(arr, output_elem = 1)
    arr.sample(output_elem)
  end

  # Compares a guess against the secret code and returns
  #  the count of exact matches (red) and value matches (white) as a hash.
  # @param guess [Array<Integer>] the guessed code
  # @param secret [Array<Integer>] the secret code to compare against
  # @return [Hash] A hash with keys :red and :white indicating the match counts
  # @version 1.0.0
  def compare_value(guess, secret)
    reds = count_exact_matches(guess, secret)
    whites = count_value_matches(guess, secret)

    { red: reds, white: whites }
  end

  # Counts the number of exact matches (same value at the same index)
  #  Modifies the guess and secret arrays by setting matched elements to nil.
  # @param guess [Array<Integer>] the guessed code
  # @param secret [Array<Integer>] the secret code to compare against
  # @return [Integer] The count of exact matching values
  # @version 1.0.0
  def count_exact_matches(guess, secret)
    guess.each_with_index.count do |val, idx|
      if val == secret[idx]
        guess[idx] = secret[idx] = nil
        true
      else
        false
      end
    end
  end

  # Counts the number of matching values.
  # Removing matched values from the secret to avoid duplicate matches.
  # @param guess [Array<Integer>] the guessed code
  # @param secret [Array<Integer>] the secret code to compare against
  # @return [Integer] The count of matching values
  # @version 1.0.0
  def count_value_matches(guess, secret)
    count = 0
    guess.compact.each do |val|
      if secret.include?(val)
        secret[secret.index(val)] = nil
        count += 1
      end
    end
    count
  end
end
