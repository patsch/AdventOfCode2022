
# Part 1 : just had a ! condition incorrectly wrapped , baaaaa
#
class Sand


  attr_accessor :cave
  attr_accessor :min_x
  attr_accessor :max_x
  attr_accessor :min_y
  attr_accessor :max_y

  attr_accessor :maxdim_x
  attr_accessor :maxdim_y
  def initialize
    @part = 2
    @cave = []
    @min_x = nil
    @max_x = nil
    @min_y = nil
    @max_y = nil
    @maxdim_x = nil
    @maxdim_y = nil
  end

  def show_cave


    y = 0 #  @min_y
    my = (@part == 2) ? @maxdim_y : @max_y
    mx0 = (@part == 2) ? 0 : @min_x
    mx1 = (@part == 2) ? @maxdim_x : @max_x
    while (y < my)
      x = mx0
      s = "#{sprintf('%3d ',y)}"
      while x <= mx1
        begin
          s = "#{s}#{@cave[y][x]}"
        rescue => e
          puts "Fail for #{x},#{y} : #{e.to_s}"
          raise e
        end
        x+=1
      end
      puts s
      y+=1
    end
  end

  def run

    fin = File.open("day_14_input.txt","rt")


    @lines = []

    min_x = nil
    maxdim_x = nil
    min_y = nil
    maxdim_y = nil

    mindim_x = 0
    mindim_y = 0
    @maxdim_x = 800
    @maxdim_y = (@part == 2) ? 171 : 200 # for part2 - I used 200 initially

    @cave = []
    y = mindim_y
    while y < @maxdim_y
      x = mindim_x
      row = []
      while x < @maxdim_x
        what = @part == 1 || (y < (@maxdim_y - 1)) ? "." : "#"
        row << what # fill with air to start with
        x+=1
      end
      y+=1
      @cave << row
    end


    lix = 0
    while iline = fin.gets
      lix+=1
      line = iline.chomp
      dots = line.split(" -> ")
      points = dots.collect { |x| x.split(",").collect { |m| m.to_i }}

      # calculate real dimensions of rock extent
      points.each { |p|
        @min_x = p[0] if @min_x.nil? || p[0] < @min_x
        @min_y = p[1] if @min_y.nil? || p[1] < @min_y
        @max_x = p[0] if @max_x.nil? || p[0] > @max_x
        @max_y = p[1] if @max_y.nil? || p[1] > @max_y
      }

      start = points.shift
      ziel = points.shift
      while !start.nil? && !ziel.nil?
        x = start[0]
        y = start[1]
        move_x = 0
        move_y = 0
        if start[0] == ziel[0]
          move_y = (start[1] < ziel[1]) ? 1 : -1
        elsif start[1] == ziel[1]
          move_x = (start[0] < ziel[0]) ? 1 : -1
        else
          puts "Oops? Odd points #{start} and #{ziel} given - no straight line !"
        end
        while [ x , y] != ziel
          @cave[y][x] = "#" # make a rock hard line
          x += move_x
          y += move_y
        end
        begin
          @cave[ziel[1]][ziel[0]] = "#"
        rescue => e
          puts "Line #{lix} : Failed to set @cave[#{ziel[1]}][#{ziel[0]}] : #{e.to_s} (#{line}) - @cave[#{ziel[1]}] is a #{@cave[ziel[1]].class}"
          raise e
        end

        start = ziel
        ziel = points.shift
      end
    end
    fin.close

    puts "@cave has #{@cave.size} rows that are each #{@cave.first.size} wide, @min_x is #{@min_x}, @max_x is #{@max_x}"


    # Coordinate System : 483,13 => 534,168
    puts "Coordinate System : #{@min_x},#{@min_y} => #{@max_x},#{@max_y}"

    grains = 0
    overflowing = false
    while !overflowing
      grains += 1
      @grain_x = 500
      @grain_y = 0
      if [1,50,100].include?(grains)
        puts "Adding Grain No. ##{grains} - Starting cave:"
        @cave[@grain_y][@grain_x] = "+"
        show_cave
        @cave[@grain_y][@grain_x] = "."
      end

      resting = false
      overflowing = false
      while !resting && !overflowing
        # move the grain according to the rules
        # air below => keep going
        begin
          overflowing = @grain_y > @max_y if @part == 1
          if overflowing
            puts "Grain #{grains} is overflowing - so #{grains-1} grains are resting (part 1) !!"
            @cave[@grain_y-1][@grain_x] = "X"
            show_cave
          else
            if @cave[@grain_y+1][@grain_x] == "."
              @grain_y = @grain_y + 1
            elsif @cave[@grain_y+1][@grain_x-1] == "."
              @grain_x = @grain_x - 1
              @grain_y = @grain_y + 1
            elsif @cave[@grain_y+1][@grain_x+1] == "."
              @grain_x = @grain_x + 1
              @grain_y = @grain_y + 1
            else
              @cave[@grain_y][@grain_x] = "o"
              resting = true
              if @part == 2
                overflowing = [@grain_y,@grain_x] == [ 0, 500]
                if overflowing
                  puts "Full after #{grains} grains:"
                  puts
                  show_cave
                end
              end
            end
          end

        rescue => e
          @cave[@grain_y][@grain_x] = "X"
          puts "Coordinate System : #{@min_x},#{@min_y} => #{@max_x},#{@max_y} - @max_y is #{@max_y}"

          puts "Grain #{grains} failed for y #{@grain_y},x #{@grain_x}] - max is y #{maxdim_y}, x #{maxdim_x} : #{e.to_s}"
          show_cave
          raise e
        end

      end
    end
  end

  Sand.new.run

end
