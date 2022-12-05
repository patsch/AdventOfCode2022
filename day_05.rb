#!/usr/bin/env ruby

fin = File.open("day_05_input.txt","rt")

step = 2
# load stacks
stacks = nil
ncomms = 0
loading_stacks = true
while line = fin.gets
	s = line.chomp
	if s.strip.length == 0
		loading_stacks = false
		puts "-"*80
		puts "I have #{stacks.size} stacks to start with..."
		puts "-"*80
		six = 0
		stacks.each { |stack|
			six += 1
			puts "-"*80
			puts "Stack #{six}:"
			stack.each { |x|
				puts x 
			}
		}
		puts "-"*80
	end 
	if loading_stacks
		if stacks.nil?
			num_stacks = s.length / 4 + 1
			puts "Have #{num_stacks} stacks"
			stacks = []
			for i in (1..num_stacks)
				stacks << []
			end
		end
		col = 0
		while col < s.length
			if (s[col,1] == "[")
				stacks[col/4] << s[col+1,1]
			end
			col+=4
		end
	else
		if !s.index("move").nil?
			ncomms+=1
			fields = s.split(" ")
			number = fields[1].to_i 
			from = fields[3].to_i - 1
			to = fields[5].to_i - 1
			if step == 1
				for i in (1..number)
					what = stacks[from].shift
					stacks[to].insert(0,what)
				end
			else
				# Step 2 : multiple crates
				pulled = stacks[from].slice!(0,number)
				stacks[to].insert(0,pulled)
				stacks[to].flatten!
			end

		end
	end

end

fin.close

puts "-"*80
puts "After #{ncomms} moves, I have these #{stacks.size} stacks"
puts "-"*80
six = 0
stacks.each { |stack|
	six += 1
	puts "-"*80
	puts "Stack #{six}:"
	stack.each { |x|
		puts x 
	}
}

puts "Thus the answer is... #{stacks.collect { |stack| stack[0] }.join('')}"


