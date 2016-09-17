require 'byebug'
require_relative 'board'

class Solver
  attr_reader :board

  def initialize(board)
    @board = board
  end

  def restrict_neighbors(pos, val)
    row, col = pos
    @board.neighbors([row,col]).map do |neighbor|
      neighbor.restrict_possible(val) if neighbor.possible_values
    end
  end

  def restriction_phase

    @board.rows.each.with_index do |row, idy|
      row.each.with_index do |tile, idx|
        if tile.value > 0
          restrict_neighbors([idy, idx], tile.value)
        end
      end
    end
  end

  def most_restricted
    min_pos = nil
    min_set = nil

    @board.rows.each_with_index do |row,idy|
      row.each_with_index do |tile,idx|
        if tile.value == 0 && ( min_set.nil? ||
           min_set.length > tile.possible_values.length)
          min_pos, min_set = [idy,idx] , tile.possible_values
        end
      end
    end
    min_set && [min_pos,min_set]
  end

  def solve
    #return @board if @board.solved?
    restriction_phase
    while (mr = most_restricted)
      pos, values = mr
      if values.count == 0
        return nil
      elsif values.count == 1
        val = values.to_a[0]
        @board[pos] = val
        restrict_neighbors(pos, val)
      else
        values.each do |value|
          # cycle through, dup board, set value, recurse
          puts "Guessing #{value} @ #{pos}"
          board_dup = @board.dup
          board_dup[pos] = value
          board_dup.render
          solution = Solver.new(board_dup).solve
          return solution if solution
        end
        return nil
      end
    end
    return (@board.solved? ? @board : nil)
  end

end

if __FILE__ == $PROGRAM_NAME
  board = Board.from_file('puzzles/zeroes.txt')
  s = Solver.new(board)
  solution = s.solve
  solution.render

end
