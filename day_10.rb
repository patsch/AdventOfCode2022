class Cpu


	def Cpu.cyclecheck(cycle,x)
	 [ 20,60,100,140,180,220].include?(cycle) ? x*cycle : 0
	end


	def Cpu.crt(cycle,x,row,col,arr)
		val = [x-1,x,x+1].include?(col) ? "#":"."
		arr[row] << val	
	end

	def Cpu.run
	   
	    
		fin = File.open("day_10_input.txt","rt")

		x = 1
		cycle = 0

		row = 0
		col = 0

		sum = 0
		arr = []
		while (line = fin.gets)
			row = cycle / 40
			col = cycle % 40
			arr << [] if arr.size <= row	

			cycle += 1

			crt(cycle,x,row,col,arr)

			command = line.chomp.split(" ")

			sum += cyclecheck(cycle,x)

			if command[0] == "addx"
				
				row = cycle / 40
				col = cycle % 40
				arr << [] if arr.size <= row	

				crt(cycle,x,row,col,arr)
				cycle+= 1
				
				sum += cyclecheck(cycle,x)
				x += command[1].to_i
			end
		end

		fin.close

		puts "Sum is #{sum}"	

		puts "Art is:"
		arr.each { |row|
			puts row.join('')
		}
	end

  	Cpu.run

end
