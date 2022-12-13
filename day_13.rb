require 'rubytree'

# Part 1 : just had a ! condition incorrectly wrapped , baaaaa
#
class List

  def initialize
    @correct = [] # 4, 5, 6, 7, 8, 14, 16, 18, 19, 21, 22, 24, 26, 28, 29, 32, 33, 35, 36, 37, 42, 43, 48, 52, 53, 57, 62, 64, 70, 72, 73, 79, 80, 81, 83, 84, 88, 89, 90, 93, 95, 98, 99, 100, 102, 104, 109, 111, 116, 117, 121, 122, 123, 125, 127, 128, 131, 134, 136, 137, 138, 139, 143, 144]
    @part = 2
  end

  def comp(pix,a,b,level, idx = nil)

    xret = nil

    is_correct = @correct.include?(pix)
    if is_correct
      puts "-----------IN---------------"
      puts "#{pix} - Level #{level}#{" - Index #{idx}" if !idx.nil?} :"
      puts "   #{a}#{' (nil)' if a.nil?}"
      puts "   #{b}#{' (nil)' if b.nil?}"
    end
    ret = nil
    xa = nil
    xb = nil
    # in right order if both are empty now - or if a is empty and b is not

    if a.nil?
      if !b.nil?
        puts "=> correct" if is_correct
        xret = 1
      else
        # same
        puts "=> next" if is_correct
        xret = 0
      end
    end


    if xret.nil?
      # not in right order if a is not nil but b is
      if b.nil?
        puts "=> wrong" if is_correct
        xret = -1
      end
    end



    # now neither a nor b is nil
    if xret.nil?
      xa = nil
      xb = nil
      if a.is_a?(Array)
        xa = a.dup
        if !b.is_a?(Array)
          puts "B #{b} => [ #{b} ]" if is_correct
          xb = [ b ]
        else
          xb = b.dup
        end
      elsif b.is_a?(Array)
        xb = b.dup
        xa = [ a ]
        puts "A #{a} => [ #{a} ]" if is_correct
      end
      puts "XA #{xa} , XB #{xb}" if is_correct

      # lists ?
      if !xa.nil? && !xb.nil?
        ret = 0
        lix = 0
        while ret == 0 && !(xa.empty? && xb.empty?)
          lix+=1
          na = xa.shift
          nb = xb.shift
          puts "Level #{level} - Loop #{lix}..." if is_correct
          ret = comp(pix,na,nb,level+1,lix)
          puts "ret is #{ret.nil? ? 'nil' : ret} from loop #{lix}" if is_correct
        end
        xret = ret
      else
        # nope
        if a < b
          xret = 1
          puts "=> correct" if is_correct
        elsif a > b
          puts "=> wrong" if is_correct
          xret = -1
        else
          puts "=> next" if is_correct
          xret = 0
        end
      end
    end

    if is_correct
      puts "-----------OUT---------------"
      puts "#{pix} - Level #{level}#{" - Index #{idx}" if !idx.nil?} :"
      puts "   #{a}#{' (nil)' if a.nil?}"
      puts "   #{b}#{' (nil)' if b.nil?}"
      puts " => #{xret}"
    end

    xret
  end

  def run

    fin = File.open("day_13_input.txt","rt")


    @pairs = []

    while iline = fin.gets
      line = iline.chomp
      if @part == 2
        if line.length > 0
          @pairs << eval(line)
        end
      else
        row = []

        row << eval(line)
        iline = fin.gets
        line = iline.chomp
        row << eval(line)
        @pairs << row
        break if fin.gets.nil?
      end

    end
    fin.close

    if @part == 1
      puts "Have #{@pairs.count} pairs"
      sorted = 0
      pix = 0
      nsorted = 0
      arr = []
      @pairs.each { |pair|
        pix +=1
        if comp(pix-1,pair[0],pair[1],1) == 1
          sorted += pix
          arr << (pix-1)
          nsorted += 1
          puts "-"*80
          puts "#{nsorted} : #{pair[0]}"
          puts "#{nsorted} : #{pair[1]}"
        end
      }

      puts "#{sorted} are in the right order (#{nsorted})"
      puts "correct = #{arr}"
    else
      # add the divider packets
      @pairs << [[2]]
      @pairs << [[6]]
      puts "Have #{@pairs.count} sequences to sort, first is #{@pairs.first}"
      sorted = @pairs.sort { |a,b|
        comp(1,b,a,1)
      }
      pix = 0
      fac = 1
      sorted.each { |l|
        pix += 1
        if [[[2]],[[6]]].include?(l)
          fac = fac * pix
          puts "*"*120
        end

        puts "[#{pix}] : #{l}"

        if [[[2]],[[6]]].include?(l)
          puts "*"*120
        end

      }
      puts "Key : #{fac}"
    end

  end

  List.new.run

end
