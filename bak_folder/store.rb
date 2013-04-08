=begin


1st
2nd
3rd
4th
5th
6th
7th
8th
9th
10th
11th
12th
13th
14th
15th
16th
17th
18th
19th

20th
21st
22nd
23rd
24th
25th

31st
32nd
33rd
34th


=end


def convert_to_ordinal(number)
 
  y = number.to_s.reverse
    if y[0] == 1
      number.to_s + "st"
    elsif y[0] == 1 && y[1] == 1
      number.to_s + "th"
      
    # elsif y[0] == 2 && y[1] == 1
    #   number.to_s + "th"     
    if y[0] == 2 && y[1] != 1
      number.to_s + "th"
    elsif y[0] == 3 && y[1] != 1
      number.to_s + "rd"
    end
      number.to_s + "th"

end

convert_to_ordinal(24)
