#!/usr/bin/env ruby

fin = File.open("day_04_input.txt","rt")

stage = 2
covered = 0
while (line = fin.gets)
	ranges = line.chomp.split(",")
	arr = []
	ranges.each { |r| 
		arr << r.split("-").collect { |x| x.to_i }
	}
	first = arr[0]
	second = arr[1]
	if stage == 1
		if ((first[0] >= second[0] && first[1] <= second[1]) || (first[0] <= second[0] && first[1] >= second[1]))
			covered +=1
		end
	else
		first=eval("(#{first[0]}..#{first[1]}).to_a")
		second=eval("(#{second[0]}..#{second[1]}).to_a")
		overlap = first & second
		if !overlap.empty?
			covered +=1
		end		
	end

end

fin.close
puts covered



