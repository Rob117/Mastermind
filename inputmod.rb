module InputMod

  # Checks to see if a string matches exactly with any number of
  # supplied words. Downcases all first
  def criteria_match?(string, *words)
    contains = false;
    words.each{|w|
      if w.downcase == string.downcase
        contains = true
      end
    }
    return contains
  end
  
  # Check if each element of array one is in array two
  def array_match?(first_array, second_array)
    return first_array.all?{|e|
      second_array.include?(e)
    }
  end
end