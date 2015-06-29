# This tells it to point at the current directory
$LOAD_PATH << '.'

# This adds the file
require "inputmod"
require "arrayextensions"
# this makes it so we can call the methods without needing to 
# instantiate objects to call those methods on
include InputMod


class MasterMind
    $Colors = ["blue", "green", "red", "orange", "purple", "yellow"]
     attr_accessor :answer_code, :past_guess

    def initialize
        @answer_code = []
        @past_guess = PastGuesses.new
        win_message =  ""
        human = "computer"
        computer = "me"
        puts "だれが当たってみますか？?
              \"#{human}\" or \"#{computer}\""
        input = gets.chomp
        while (!criteria_match?(input, human, computer))
        puts "選択をこのように書いて下さい:
              #{human}
              か
              #{computer}"
              input = gets.chomp
        end
        if input.downcase == computer.downcase
          #choose random Colors indexes. This is our answer
          4.times{ answer_code.push(
                  $Colors.index( $Colors.random_element )) }
          win_message = human_guessing(answer_code)
        else
          puts "秘密なコードと作ってください"
          input = gets.chomp.split
        while (!array_match?(input, $Colors))
          puts "認められる記入の例え:
          yellow green purple orange
          blue red green green
          purple yellow red red"
          input = gets.chomp.split
        end
          answer_code = convert_to_colors_indexes(input)
          win_message = computer_guessing(answer_code)
        end
        
        @answer_code = convert_to_readable_colors(@answer_code)
        puts win_message
        puts "答え： #{@answer_code}"
    end
    
    def human_guessing(answer_code)
      turns_left = 12
      finished = false
      while(turns_left > 0 && finished != true)
        turns_left -= 1
        puts "残っているターン: #{turns_left}"
        puts "当たってみてください。例えば: blue yellow green orange"
        input = gets.chomp.split
        while (!array_match?(input, $Colors))
          puts "認められる記入の例え:
          yellow green purple orange
          blue red green green
          purple yellow red red"
        input = gets.chomp.split
        end
        guess = convert_to_colors_indexes(input)
        results = guess_check(guess, answer_code) # 0 is a red, 1 is a white
        
        if results == [0,0,0,0]
          finished = true
        else
          @past_guess.add_result(guess, results)
        end
        
        if finished
          return "出来た！残っているチャンス: #{turns_left}"
        end
      end
        
      return "チャンスがなくなった。"
    end
    
    # Next
    def computer_guessing(answer_code)
      puts "考えています。少々お待ち下さい。"
      @possibilities = initialize_possibilities([0,1,2,3,4,5])
        turns_left = 12
        finished = false
        first_guess = true
        results = []
        guess = []
        while(turns_left > 0 && finished != true)
          turns_left -= 1
          if first_guess
            first_guess = false
            guess = [0,0,1,1]
          else
            guess = @possibilities[@possibilities.size / 2]
          end
        
          results = guess_check(guess,answer_code)
          @past_guess.add_result(guess, results)
          puts "-----------------------------------------"
        
          if results == [0,0,0,0]
            finished = true
          else
            @possibilities.delete_if{|pos|
              guess_check(pos, guess) != results
            }
          end
        end
        
        if finished
          return "できました。残っているチャンスは：#{turns_left}"
        else
          return "まけた！？これは無理やろう！！！."
        end
    end
    
    def initialize_possibilities(seed) # completely wrong 
        return seed.repeated_permutation(4).to_a
    end
    
    def guess_check(guess, answer_code)
        results = []
        new_code = []
        new_code += answer_code
        guess_array = []
        guess_array += guess
        # check for reds, remove all hits from both arrays and push a red
        # for each hit
        guess.length.times{ |i|
            if guess_array[i] == new_code[i]
                guess_array[i] = nil
                new_code[i] = nil
                results.push(0)
            end
        }
        # check for whites
        guess_array.compact!
        new_code.compact!
        guess_array.each{ |val|
            if new_code.include?(val)
              new_code.delete_at(new_code.index(val))
              results.push(1)
            end
        }
        return results
    end
    
    def convert_to_colors_indexes(colors_array)
        r_array = []
        colors_array.length.times{|i|
            r_array.push($Colors.index(colors_array[i]))
            }
        return r_array
    end

    
    class PastGuesses
      attr_accessor :finished_guess
      def initialize
        @finished_guess = []
      end
      
      def add_result(guess, result)
        @finished_guess += [[guess, result]]
        display
      end
      
      def display
          @finished_guess.each{|guess|
          puts "#{convert_to_readable_colors(guess[0])} --#{convert_to_readable_results(guess[1])}"
          }
          
      end
    end
end

    
    def convert_to_readable_colors(indexes_array)
        r_array = []
        indexes_array.length.times{|i|
            r_array.push($Colors[indexes_array[i]])
            }
        return r_array
    end
    
    def convert_to_readable_results(results_array)
      r_array = []
      results_array.each{|i|
          i == 0 ? r_array.push(" red ") : r_array.push(" white ")
      }
      return r_array
      
    end

input = "yes"
# Initialize
while (input == "yes")
  puts "アスターマインドへようこそ！ゲームのやりかた：
      　blue, yellow, green, orange, red, purpleという色から誰かが秘密なコードをつくります。
      　コード作っていない人は当たってみます。当たり方は、色を使って自分のコードを作る。
      　コードが同じやったら勝ちます。
      　チャンスが無くなったら負けます。
      　色と位置が同じならば、redという結果はでる。
      　色だけが同じやったら、whiteという結果はでる。
      　当たり方はこの通り
      　（例の秘密なコードはblue blue orange yellow）：
      　blue green yellow yellow -- red red (blue と yellow が当たったから、それを消して、残っている色の中で同じ色はないからwhiteなし)
      　orange orange yellow blue -- white white white (位置は当たっていないけど、orangeとyellowとblueは色同じ) 
      　blue yellow orange yellow -- red red red
      　blue blue orange yellow -- WINNER!"
  MasterMind.new
    puts "またしますか？ Yes か No?"
    input = gets.chomp
    while (!criteria_match?(input, "yes", "no"))
      puts "Yes か No を書いて下さい"
      input = gets.chomp
    end
end
puts "僕のゲームをやっていただいてありがとうございます！."