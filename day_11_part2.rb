require 'bigdecimal'
class Monkey

	# cannot figure out part 2 - the numbers are getting too big to handle, divisible test is too hard (checksum ?!), I was looking for patterns
	# in the changes, other ways of figuring this out, giving up for now
	#
	# I needed a hint from reddit re: the lcm to keep the numbers from climbing sky high - nice puzzle !!
	
	def Monkey.run

		fin = File.open("day_11_input.txt","rt")

		monkeys = []

		lcm = 1
		while iline = fin.gets
			line = iline.chomp
			if line.index("Monkey ") == 0
				m = Hash.new
				m[:monkey] = line.split(" ").last.to_i
				m[:inspections] = 0
				m[:items] = fin.gets.chomp.split(":")[1].strip.split(",").collect { |x| x.to_i }
				m[:op] = fin.gets.chomp.split(":")[1].strip
				#m[:op] = m[:op].gsub("old","BigDecimal(old)") if part == 2
				m[:divisible_by] = fin.gets.chomp.split(":").last.strip.split(" ").last.to_i
				lcm *= m[:divisible_by]
				m[:true] = fin.gets.chomp.split(" ").last.strip.to_i
				m[:false] = fin.gets.chomp.split(" ").last.strip.to_i
				iline = fin.gets # get blank
				monkeys << m
			end
		end
		fin.close

		max_rounds = 10000
		puts "Start of #{max_rounds} rounds:"
		puts monkeys

		debug = false
		round = 0
		while round < max_rounds
			round += 1
			puts "Round #{round}"
			mix = 0
			monkeys.each { |monkey|
				mix += 1
				icnt = 0
				debug = false # round == 1 # && mix == 1
				while !monkey[:items].empty?
					icnt += 1
					monkey[:inspections] += 1
					old = monkey[:items].shift
					puts "Monkey #{mix} - Item #{icnt} is #{old}" if debug
					new = nil
					eval(monkey[:op])
					new = new % lcm
					puts "After evaluating '#{monkey[:op]}' new is #{new}" if debug
					if (new % monkey[:divisible_by]) == 0
						puts "#{new} is divisible by #{monkey[:divisible_by]}, so we throw #{new} to monkey #{monkey[:true]}" if debug
						monkeys[monkey[:true]][:items] << new
					else
						puts "#{new} is NOT divisible by #{monkey[:divisible_by]}, so we throw #{new} to monkey #{monkey[:false]}" if debug
						monkeys[monkey[:false]][:items] << new
					end
				end
			}
		end

		mix = 0
		monkeys.sort { |a,b| a[:inspections] <=> b[:inspections]}.reverse.each { |m|
			mix +=1
			puts "No. #{mix} (Monkey #{m[:monkey]}) : #{m[:inspections]}"
		}
		nil
	end

	Monkey.run

end
