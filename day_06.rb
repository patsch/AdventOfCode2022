#!/usr/bin/env ruby

line = File.open("day_06_input.txt","rt").read.chomp

chars = line.chars

stage = 2
len = (stage ==1 ) ? 4 : 14

offset = 0
found = nil
while offset < chars.length && found.nil?
 if chars.slice(offset,len).uniq.size == len	
 	found = offset
 end

 offset +=1 if !found
end

puts found + len




