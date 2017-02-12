Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

class TTTGame
  include Displayable, Clearable

  X_MARKER = 'X'.freeze
  O_MARKER = 'O'.freeze
  FIRST_TO_MOVE = X_MARKER
  PLAY_TO = 5

  attr_reader :human, :computer
  attr_accessor :board

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = Computer.new
    @current_player = FIRST_TO_MOVE
  end

  def play
    clear_screen
    display_welcome_message
    set_names
    set_markers
    game_loop
    display_goodbye_message
  end

  private

  def game_loop
    loop do
      loop do
        play_one_round
        break if someone_won_game?
        ask_for_another_round
        reset_round
      end
      display_game_winner
      break unless play_again?
      reset_game
    end
  end

  def set_markers
    human.set_marker

    computer.marker = case human.marker
                      when X_MARKER then O_MARKER
                      else X_MARKER
                      end
  end

  def set_names
    human.set_name
    computer.set_name
  end

  def play_one_round
    display_board
    loop do
      current_player_moves
      alternate_player
      break if board.someone_won? || board.full?
      clear_screen_and_display_board if human_turn?
    end
    increase_winner_score
    display_result
    display_score
  end

  def reset_game
    reset_round
    human.reset_score
    computer.reset_score
  end

  def someone_won_game?
    human.score >= PLAY_TO || computer.score >= PLAY_TO
  end

  def die
    display_goodbye_message
    exit
  end

  def ask_for_another_round
    puts "Enter 'Q' if you want to quit. Otherwise enter any key to play again."
    answer = gets.chomp.downcase
    die if answer == 'q'
  end

  def increase_winner_score
    case board.winning_marker
    when human.marker then human.increase_score
    when computer.marker then computer.increase_score
    end
  end

  def human_moves
    puts "#{human.name} choose a square: #{joinor(board.unmarked_keys)}"
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    board[computer_strategy] = computer.marker
  end

  def computer_strategy
    if board.middle_empty?
      5
    elsif !!board.at_risk_square(O_MARKER)
      board.at_risk_square(O_MARKER)
    elsif !!board.at_risk_square(X_MARKER)
      board.at_risk_square(X_MARKER)
    else
      board.unmarked_keys.sample
    end
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (Y/N)"
      answer = gets.chomp.downcase
      break if %w(y n).include?(answer)
      puts "Please answer with a Y or N"
    end
    answer == 'y'
  end

  def reset_round
    board.reset
    clear_screen
    @current_player = FIRST_TO_MOVE
    puts "Let's play again!"
  end

  def human_turn?
    @current_player == human.marker
  end

  def alternate_player
    @current_player = case @current_player
                      when X_MARKER then O_MARKER
                      else X_MARKER
                      end
  end

  def current_player_moves
    case @current_player
    when human.marker then human_moves
    else computer_moves
    end
  end

  def joinor(array, delimiter = ', ', word = 'or')
    return array.first if array.size == 1
    string = array[0...-1].join(delimiter)
    string << " #{word} #{array.last}"
  end
end

game = TTTGame.new
game.play
