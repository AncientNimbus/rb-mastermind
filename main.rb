# frozen_string_literal: true

require_relative 'lib/mastermind'
require_relative 'lib/cli_helper'

# Project Mastermind
def main
  # CliHelper.do_at_exit('* Thank you for playing LLAP 🖖')
  Mastermind.new
end

main
