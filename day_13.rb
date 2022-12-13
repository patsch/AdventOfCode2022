require 'rubytree'

class List

  def initialize

  end

  def comp(a,b)
    puts "Comparing <#{a}> and <#{b}>"
    ret = nil
    xa = nil
    xb = nil
    if a.nil?
      if !b.nil?
        ret = 1
      else
        ret = 0
      end
      return ret
    elsif b.nil?
      # left list runs out of items first
      ret = 1
      return ret
    end

    xa = nil
    xb = nil
    if a.is_a?(Array)
      xa = a
      if !b.is_a?(Array)
        xb = [ b ]
      else
        xb = b
      end
    elsif b.is_a?(Array)
      xb = b
      xa = [ a ]
    end
    if !xa.nil? && !xb.nil?
      ret = nil
      while ret.nil? && !(xa.empty?) && !(xb.empty?)
        na = xa.shift
        nb = xb.shift
        ret = comp(na,nb)
        ret = nil if ret == 0
      end
    else
      if a < b
        ret = 1
      elsif a > b
        ret = -1
      else
        ret = 0
      end
    end
    ret
  end

  def run

    fin = File.open("day_13_input.txt","rt")

    @pairs = []

    while iline = fin.gets
      row = []
      line = iline.chomp
      row << eval(line)
      iline = fin.gets
      line = iline.chomp
      row << eval(line)
      @pairs << row
      break if fin.gets.nil?
    end
    fin.close

    puts "Have #{@pairs.count} pairs"


    sorted = 0
    pix = 0
    nsorted = 0
    @pairs.each { |pair|
      pix +=1
      puts "-"*80
      puts "- #{pix}"
      puts "-"*80
      if comp(pair[0],pair[1]) == 1
        sorted += pix
        nsorted += 1
      end
    }

    puts "#{sorted} are in the right order (#{nsorted})"
  end

  List.new.run

end
