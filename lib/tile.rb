require "colorize"
require 'set'
require 'byebug'

class Tile
  attr_reader :value, :possible_values

  def initialize(value)
    # byebug if value == 0
    @value = value
    @given = value == 0 ? false : true
    @possible_values = @given ? nil : Set.new((1..9).to_a) 

  end

  def restrict_possible(num)
    @possible_values.delete(num)
    @possible_values
  end

  def color
    given? ? :blue : :red
  end

  def given?
    @given
  end

  def to_s
    value == 0 ? " " : value.to_s.colorize(color)
  end

  def value=(new_value)
    if given?
      puts "You can't change the value of a given tile."
    else
      @value = new_value
      @possible_values = nil
    end
  end
end
