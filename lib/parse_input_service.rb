# frozen_string_literal: true

require 'bigdecimal'

class ParseInputService
  INPUT_REGEXP = '(\d) (imported )*(.+) at (\d+.\d{2})'

  attr_reader :lines

  # `lines` is expected to be an array of strings
  def initialize(lines)
    @lines = lines
  end

  # Returns an array of objects containing the parsed data.
  # Each object has the following keys:
  #   - `quantity`: an integer number
  #   - `imported` a boolean
  #   - `description`: a string
  #   - `price`: a decimal number
  def call
    lines.map { parse_line(_1) }.compact
  end

  private

  def parse_line(line)
    return if (line.nil? || line.empty?)

    m = line.match(INPUT_REGEXP)
    return if m.nil?

    quantity, imported, description, price = m.captures

    {
      quantity:    quantity.to_i,
      imported:    !imported.nil?,
      description: description,
      price:       BigDecimal(price),
    }
  end

end
