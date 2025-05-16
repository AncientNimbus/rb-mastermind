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

  # Select and return an element randomly from an array object.
  #
  # @param arr [Array<Object>] array of objects
  # @return the random element
  # @version 1.1.0
  def random_picker(arr)
    arr.sample
  end

  # Compares a guess against the secret code and returns the count of exact matches (red) and
  # value matches (white) as a hash and boolean flag if there is a full match.
  # @param guess [Array<Integer>] the guessed code
  # @param secret [Array<Integer>] the secret code to compare against
  # @return [Array<Hash, Boolean>] A hash with keys :red and :white indicating the match counts,
  #  a bool that flags true when there is a full match.
  # @version 2.0.0
  def compare_value(guess, secret)
    guess_dup = guess.dup
    secret_dup = secret.dup
    reds = count_exact_matches(guess_dup, secret_dup)
    whites = count_value_matches(guess_dup, secret_dup)

    [{ red: reds, white: whites }, reds == 4]
  end

  # Counts the number of exact matches (same value at the same index)
  # Modifies the guess and secret arrays by setting matched elements to nil.
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

  # Convert hints hash to array
  #
  # @since 0.8.0
  # @version 2.0.0
  def hints_to_arr(hints, shuffle: true)
    arr = []
    hints.each_pair do |key, value|
      value.times do
        arr.push(key == :red ? 2 : 1)
      end
    end
    shuffle ? arr.shuffle : arr
  end

  # Convert user input and return a valid code as Array
  # @param input_code [String] user input
  # @since 0.9.0
  def input_to_code(input_code)
    input_code.split('').map(&:to_i)
  end

  # The minimax solver method
  # @param options_arr [Array] nested array containing valid codes [[1, 2, 3, 4]]
  # @param all_options_arr [Array] nested array containing all valid codes [[1, 1, 1, 1]...[6, 6, 6, 6]]
  # @return [Array<Integer>] best guess
  # @ since 0.9.4
  # @ version 1.1.0
  def best_guess(options_arr, all_opts_arr)
    remaining_length = options_arr.length
    # first move
    return [1, 1, 2, 2] if remaining_length == all_opts_arr.length

    # last two moves
    options_arr.sample if remaining_length <= 2

    # Rejection only kicks in if the array length is less than 8
    guesses = remaining_length < 8 ? options_arr : all_opts_arr

    minimax_solver(guesses, options_arr)
    # p "printing best guess: #{best_guess}"
  end

  # The minimax solver method
  # @ since 0.9.5
  # @ version 1.0.0
  def minimax_solver(guesses, options_arr) # rubocop:disable Metrics/MethodLength
    min_max_remaining = Float::INFINITY
    best_guess = nil
    guesses.each do |guess|
      feedback_counts = Hash.new(0)

      options_arr.each do |code|
        feedback = compare_value(guess, code)[0]
        key = [feedback[:red], feedback[:white]]
        feedback_counts[key] += 1
      end
      # worst case
      max_remaining = feedback_counts.values.max

      if max_remaining < min_max_remaining
        min_max_remaining = max_remaining
        best_guess = guess
      end
    end
    best_guess
  end

  # Remove elements from the remaining options array that has the same feedback as the current guess
  # Technically, the computer ended up playing more than 12 turns! Not fair lol...
  # @return [Array] remaining options after reductions
  # @since 0.9.4
  # @version 1.0.0
  def remove_opts(guess, hints, options_arr)
    options_arr.select! do |code|
      compare_value(guess, code)[0] == hints
    end
    # p "from remove opt: #{options_arr.length} possibilities remaining"
    options_arr
  end
end
