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
end
