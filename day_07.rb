#!/usr/bin/env ruby


files = Hash.new

fin = File.open("day_07_input.txt","rt")

debug = true

listmode = false
path = "/"
while iline = fin.gets
	line = iline.chomp
	if line.index("$ ") == 0
		listmode = false
		cmd = line[2,line.length].strip
		if cmd.index("cd ") == 0
			dirname = cmd[3,cmd.length].strip
			if dirname == ".."
				dirs = path.split("/")
				dirs.pop
        oldpath = path
				path = dirs.join("/")
        path = "#{path}/"
        puts "cd .. changed path from <#{oldpath}> to <#{path}>"
      elsif dirname == "/"
        path = "/"
      else
				path = "#{path}#{dirname}/"
			end
			puts "#{cmd} => path is #{path}" if debug

		elsif cmd == "ls"
			listmode = true
      puts "ls =>"
		end
	elsif listmode
		if line.index("dir ") == 0
			# dir indicator
			dirname = line[4,line.length].strip
      puts "have <#{dirname}>"
      # useless ?
		else
			# files
			file = line.split(" ")
			files[path] = [] if files[path].nil?
			files[path] << { size: file[0].to_i, name: file[1] }
      puts "adding #{file[0].to_i} to #{path}" if debug
		end
	else
		puts "oops? no listmode but have <#{line}>"
	end
end

fin.close

total_big = 0
number_big = 0
puts "have #{files.size} directories"
totals = Hash.new
files.keys.each { |path|
  xp = ""
  ptotal = 0
  path.split("/").each { |subpath|
     xp = "#{xp}#{subpath}/"
  	 if totals[xp].nil?
       totals[xp] = 0
       files.keys.each { |p|
         if p.index(xp) == 0
           sm = files[p].collect { |x| x[:size] }.sum
           puts "Adding contents of <#{p}> (#{sm}) for <#{xp}>"
           totals[xp] += sm
         end
       }
     end
  }
}

mintotal = 0
totals.keys.sort.each { |p|
  xtra = totals[p] <= 100000 ? " - added !" : ""
  puts "#{sprintf('%-60s %d%s',p,totals[p],xtra)}"
  mintotal += totals[p] if totals[p] <= 100000
}

puts "Total size of directories with 100,000 or less in it : #{mintotal}"

used = totals["/"]
unused = 70000000 - used
required = 30000000 - unused


puts "Total used is #{used}"
puts "Unused is #{unused}"
puts "Currently required for update : #{required}"

# find the smallest directory with size 'required' or more which we will then delete
totals.keys.sort { |a,b| totals[a] <=> totals[b] }.each { |p|
  # puts "#{p} => #{local_totals[p]}"
  if totals[p] >= required
    puts "Deleting directory '#{p}' would free up #{totals[p]}, which means we would have #{unused + totals[p]} available for the update."
    break
  end
}



