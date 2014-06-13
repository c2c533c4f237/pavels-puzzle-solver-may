class Square

	attr_accessor :number, :group, 
	:possible_numbers, :impossible_numbers,
	:coordinates, :is_black

	def initialize(coordinates)#, group, coordinates, is_black = false)
		#@number = number
		#@group = group
		@coordinates = coordinates
		@is_black = false
	end

	def group=(group)
		@group = group
		@possible_numbers = *(1.. group.max_number) 
	end

	def cant_be_numbers
	end

	def can_be_numbers
	end

	def solve

	end

	def to_s
		"Coordinates of square: #{@coordinates}, associated group: #{@group}, is black? #{@is_black}, possible nums: #{@possible_numbers}"
	end


end

class Group
  attr_accessor :coordinates

  def initialize(coordinates)
  	@coordinates = coordinates
  end

  def max_number
  	return @coordinates.length
  end

  def to_s
  	"Coordinates in this group: #{@coordinates}"
  end

end

class Board
	attr_accessor :squares, :groups, :size, :solved_squares, :unsolved_squares

	def initialize(size, groups, black_squares, known_squares)
		@size = size
		@squares = Array.new(size[0]) { |x| Array.new(size[1]) { |y| Square.new([x, y]) }}
		@unsolved_squares = Array.new(size[0]) { |x| Array.new(size[1]) { |y| [x, y] }}
		@solved_squares = []
		@groups = groups
		associate_and_check_groups
		set_black_squares(black_squares)
		known_squares.each do |object|
			coordinate = object[0]
			num = object[1]
			add_known_square(num, coordinate)
		end
	end

	def associate_and_check_groups

		all_coordinates = []

		@groups.each do |group|
			group.coordinates.each do |coordinate|
				all_coordinates << coordinate
				current_square = squares[coordinate[0]][coordinate[1]]
				current_square.group = group
			end
		
		end
		puts "All coordinates accounted for? #{ check_coordinates(all_coordinates)}"
	end

	def set_black_squares(coordinates)
		coordinates.each do |coordinate|
			squares[coordinate[0]][coordinate[1]].is_black = true
		end
	end

	def check_coordinates(coordinates)

	    @size[0].times do |x|
	    	@size[1].times do |y|
	    		if !( coordinates.include?([x,y]) )
	    			puts "OMG, [#{x}, #{y}], missing from groups!"
	    			return false
	    		end
	    	end
	    end
	    return true
	end

	def set_impossible_squares(number, coordinate)
		square_coordinates = []
		x = coordinate[0]
		y = coordinate[1]
		number.times do |num|
			num += 1
			square_coordinates << [x - num, y] if (x - num >= 0)
			square_coordinates << [x + num, y] if (x + num < @size[0])
			square_coordinates << [x, y - num] if (y - num >= 0)
			square_coordinates << [x, y + num] if (y + num < @size[1])
		end

        square_coordinates.each do |coordinate|
        	other_square = squares[coordinate[0]][coordinate[1]]
        	other_square.possible_numbers.delete(number)
        end

	end

	def add_known_square(number, coordinate)
		square = squares[coordinate[0]][coordinate[1]]
		square.number = number, square.possible_numbers = [number]
		set_impossible_squares(number, coordinate)
		@solved_squares << coordinate
		@unsolved_squares.delete(coordinate)
	end
end

#Input sample puzzle

example_groups = [

	Group.new([[0,0],[0,1]]),
	Group.new([[1,0],[2,0],[3,0],[1,1],[3,1]]),
	Group.new([[0,2],[1,2],[1,3]]),
	Group.new([[0,3],[0,4],[0,5]]),
	Group.new([[0,6]]),
	Group.new([[2,1],[2,2],[3,2],[3,3],[3,4]]),
	Group.new([[1,4],[1,5],[1,6],[2,3],[2,4],[2,5]]),
	Group.new([[2,6],[3,6],[4,6],[5,6],[3,5]]),
	Group.new([[4,5]]),
	Group.new([[4,0],[5,0]]),
	Group.new([[4,1],[4,2],[5,1]]),
	Group.new([[6,0],[6,1],[6,2],[5,2]]),
	Group.new([[4,3],[5,3],[6,3]]),
	Group.new([[4,4],[5,4],[6,4],[5,5],[6,5],[6,6]])
]

black_squares = [
	[0,1],[0,2],[0,4],[0,5],[0,6],[1,0],[1,2],[1,4],[2,2],[2,4],[3,0],
	[3,2],[3,3],[3,5],[4,1],[4,2],[4,5],[5,0],[5,2],[5,4],[6,1],[6,2],
	[6,3],[6,4]
]

known_squares = [
  [[2,3], 5],
  [[1,5], 1],
  [[3,6], 1],
  [[5,1], 3],
  [[6,6], 1]
]

a = Board.new([7,7], example_groups, black_squares, known_squares)

#Testing

#puts a.groups
#puts a.squares[2][3]
#puts a.unsolved_squares
#print a.solved_squares
