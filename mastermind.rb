# This tells it to point at the current directory
$LOAD_PATH << '.'

# This adds the file
require "inputmod"
require "arrayextensions"
# this makes it so we can call the methods without needing to 
# instantiate objects to call those methods on
include InputMod


class MasterMind
    Colors = ["blue", "green", "red", "orange", "purple", "yellow"]
     attr_accessor :answer_code
    def initialize
        @answer_code = []
        win_message =  ""
        human = "Computer will guess"
        computer = "I will guess"
        puts "Would you like to guess or have the computer guess?
              Please write \"#{human}\" or \"#{computer}\""
        input = gets.chomp
        while (!criteria_match?(input, human, computer))
        puts "Sorry, please write either:
              #{human}
              or
              #{computer}"
              input = gets.chomp
        end
        if input.downcase == computer.downcase
            #choose random Colors indexes. This is our answer
            4.times{ answer_code.push(
                     Colors.index( Colors.random_element )) }
            win_message = human_guessing(answer_code)
        else
            win_message = computer_guessing(answer_code)
            puts "not ready yet"
        end
        
        answer_code = convert_to_readable_colors(answer_code)
        puts "The code was #{answer_code}"
        puts win_message
    end
    
    def human_guessing(answer_code)
      turns_left = 12
      finished = false
      while(turns_left > 0 && finished != true)
      new_code =[]
      new_code += answer_code
        turns_left -= 1
        puts "Answer is #{new_code}"
        puts "Remaining turns: #{turns_left}"
        puts "please make your guess. Example: blue yellow green orange"
        input = gets.chomp.split
        while (!array_match?(input, Colors))
          puts "Example acceptable input:
          yellow green purple orange
          blue red green green
          purple yellow red red"
        input = gets.chomp.split
        end
        guess = convert_to_colors_indexes(input)
        results = guess_check(guess, new_code) # 0 is a red, 1 is a white
        print results.to_s + " are the results"
        
        # process results here, if four 0, game won! Else, return results
        if results = [0,0,0,0]
          finished = true
        else
          puts "#{results.count(0)} red pins and #{results.count(1)} white pins"
        end
        
        if finished
          return "Wow, you guessed it! Remaining chances: #{turns_left}"
        end
      end
        
      return "Sorry, ran out of guesses"
    end
    
    # Next
    def computer_guessing(answer_code)
        turns_left = 12
        finished = false
        while(turns_left > 0 && finished != true)
        turns_left -= 1
        end
        
        if finished
            return "I have guessed your code, human. Remaining chances: #{turns_left}"
        else
            return "Somehow I ran out of guesses. Tell my engineer."
        end
    end
    
    def guess_check(guess, new_code)
        results = []
        # check for reds, remove all hits from both arrays and push a red
        # for each hit
        guess.length.times{ |i|
            if guess[i] == new_code[i]
                guess[i] = nil
                new_code[i] = nil
                results.push(0)
            end
        }
        # check for whites
        guess.compact!
        new_code.compact!
        guess.each{ |val|
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
            r_array.push(Colors.index(colors_array[i]))
            }
        return r_array
    end
    
    def convert_to_readable_colors(indexes_array)
        r_array = []
        indexes_array.length.times{|i|
        # untested
                r_array.push(Color[answer_code[i]])
            }
        return r_array
    end
end

input = "yes"






# Initialize
while (input == "yes")
  # welcome to mastermind
  MasterMind.new
    puts "Play again?"
    input = gets.chomp
    while (!criteria_match?(input, "yes", "no"))
      puts "Please type yes or no"
      input = gets.chomp
    end
end
puts "Thank you for playing my game."