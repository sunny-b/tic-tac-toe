module Displayable
  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts "The first to get three in a row wins a point!"
    puts "The first to #{TTTGame::PLAY_TO} points wins the game!"
  end

  def display_goodbye_message
    puts "Thanks for playing! Good bye!"
  end

  def display_game_winner
    winner = (human.score >= TTTGame::PLAY_TO ? human.name : computer.name)
    puts "#{winner} was the first to #{TTTGame::PLAY_TO} points. #{winner} won!"
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker
      puts "#{human.name} Won!"
    when computer.marker
      puts "#{computer.name} Won!"
    else
      puts "It's a tie!"
    end
  end

  def display_score
    puts "------------------------"
    puts "#{human.name}: #{human.score}"
    puts "#{computer.name}: #{computer.score}"
    puts "------------------------"
  end

  def display_board
    puts "#{human.name} is #{human.marker}."\
         " #{computer.name} is #{computer.marker}"
    puts
    board.draw
    puts
  end

  def clear_screen_and_display_board
    clear_screen
    display_board
  end
end
