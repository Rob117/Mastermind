The spec: 


Now refactor your code to allow the human player to choose whether she wants to be the creator of the secret code or the guesser.
Build it out so that the computer will guess if you decide to choose your own secret colors. 
Start by having the computer guess randomly (but keeping the ones that match exactly).
Next, add a little bit more intelligence to the computer player so that, if the computer has guessed the right color but the wrong position, 
its next guess will need to include that color somewhere. Feel free to make the AI even smarter.


Logic:
12 turns to guess the code = main game loop runs 12 times, max (make it a finish condition).
Two forms of logic: Human guesses and computer guesses

If human guess - 

Computer randomly chooses colors for array[0..5].

Human makes a guess - "blue green red orange purple yellow"

parse with split(" "), turn into guess array. 

Guess logic check - 

if guess[i] = actual[i], red hit and set guess[i] && actual[i] to nil

then guess.each {|i| if i != nil, if actual.includes?(i), actual.delete(i) and return a white peg }

return results "#{} red, "{} white
if results = all red, end else print results and go again
end of game, print the comp code