class Reception

  def initialize
    @min_steps = nil
    @start = nil
    @ziel = nil
    @width = nil
    @height = nil
    @tries = 0
  end

  def run

    fin = File.open("day_12_input.txt","rt")

    @altmap = []

    start = nil
    ziel = nil

    row = 0
    while iline = fin.gets
      line = iline.chomp
      @width = line.length if @width.nil?
      arr = []
      col = 0
      line.each_byte { |c|
        if c >= 97 && c <= 122
          arr << (c - 97)
        else
          case c
          when 83 # S
            @start = [ col , row ]
            # start at altitude 0 (min altitude)
            arr << 0
          when 69 # E
            # finish is at max altitude (25)
            arr << 25
            @ziel = [ col, row ]
          end
        end
        col+=1
      }
      @altmap << arr
      row+=1
    end
    @height = row
    fin.close

    puts "Map is #{@width} x #{@height} ; Start is #{@start}, Ziel is #{@ziel}"

    find_routes(@start,1, been = [ ])
  end

  def destinations_for(pos,been)
    dests = []
    alt = @altmap[pos[1]][pos[0]]
    [ [ -1 , 0], [ 0, -1 ], [ 1, 0], [ 0, 1 ] ].each { |move|
      newx = pos[0] + move[0]
      newy = pos[1] + move[1]
      if newx >= 0 && newx < @width && newy >= 0 && newy < @height
        new_alt = @altmap[newy][newx]
        alti = new_alt - alt
        if alti <= 1
          dests << [ newx, newy ] if !been.include?([newx, newy])
        end
      end
    }
    # order destination by distance from target
    dests.sort! { |a,b|
      d1 = (@ziel[1] - a[1])*(@ziel[1] - a[1]) + (@ziel[0] - a[0])*(@ziel[0] - a[0])
      d2 = (@ziel[1] - b[1])*(@ziel[1] - b[1]) + (@ziel[0] - b[0])*(@ziel[0] - b[0])
      d1 <=> d2
    }
    dests
  end

  def same_pos(p1,p2)
    p1[0] == p2[0] && p1[1] == p2[1]
  end

  def find_routes(pos,steps, been)
    @tries += 1
    puts "Pos is #{pos}, Ziel is #{@ziel} , Tries : #{@tries} - Steps is #{steps}, min steps is #{@min_steps} been has #{been.size}" if @tries % 20000 == 0
    if same_pos(pos,@ziel)
      if @min_steps.nil? || @min_steps > steps
        puts "*"*80
        puts "Found new minimum length route involving #{steps} steps!"
        puts "*"*80
        @min_steps = steps
        File.open("min_steps.txt","wt") { |f| f.puts @min_steps }
      end
    elsif @min_steps.nil? || @min_steps >= steps
      pozibles = destinations_for(pos,been)
      while !pozibles.empty?
        b2 = been.dup
        b2 << pos
        find_routes(pozibles.shift,steps+1,b2)
      end
    end
  end
  Reception.new.run

end
