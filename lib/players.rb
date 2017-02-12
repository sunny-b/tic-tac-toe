class Player
  include Clearable, Displayable
  attr_accessor :marker, :score, :name

  def initialize
    @score = 0
  end

  def increase_score
    self.score += 1
  end

  def reset_score
    self.score = 0
  end
end

class Human < Player
  def set_name
    name = nil
    loop do
      puts "Please enter your name:"
      name = gets.chomp
      break unless name.empty?
      puts "Invalid entry."
    end
    @name = name
  end

  def set_marker
    marker = nil
    loop do
      puts "Do you want your marker to be X or O? (X goes first)"
      marker = gets.chomp.downcase
      break if ['x', 'o'].include?(marker)
      puts "Invalid choice"
    end
    @marker = (marker == 'x' ? TTTGame::X_MARKER : TTTGame::O_MARKER)
  end
end

class Computer < Player
  def set_name
    @name = %w(Computer Hal R2D2 Chappie Hal Bender Big-Brother).sample
  end
end
