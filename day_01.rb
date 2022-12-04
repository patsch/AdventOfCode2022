#!/usr/bin/env ruby

max_elve = nil
max_calories = nil
total = 0
elvix = 0
fin = File.open("day_01_input.txt","rt")
totals = []
while (line = fin.gets)
	if line.strip.length > 0
		total+=line.to_i
	else
		elvix += 1
		puts "Elve #{elvix} carries #{total} calories"
		if max_calories.nil? || total > max_calories
			max_elve = elvix
			max_calories = total
		end
		totals << total
		total = 0
	end
end
fin.close 
puts "Elve #{max_elve} carries the most, namely #{max_calories} calories"
topix = 0
tt = 0
totals.sort { |a,b| b <=> a }.each { |cal|
	topix += 1
	puts "Top ##{topix} : #{cal}"
	tt += cal 
	break if topix == 3
}
puts "The top 3 elves carry #{tt} calories in total."
