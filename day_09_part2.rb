class Rope

  def Rope.prettyMap(covered_positions)
    minx = nil
    miny = nil
    maxx = nil
    maxy = nil
    covered_positions.each { |pos|
      minx = pos[0] if minx.nil? || pos[0] < minx
      maxx = pos[0] if maxx.nil? || pos[0] > maxx
      miny = pos[1] if miny.nil? || pos[1] < miny
      maxy = pos[1] if maxy.nil? || pos[1] > maxy
    }
    row = miny - 2
    while row < maxy + 2
      col = minx - 2
      s = nil
      while col < maxx + 2
        s = "#{s}#{covered_positions.include?([col,row]) ? 'x':'.'}"
        col+=1
      end
      puts s
      row+=1
    end

  end


  def Rope.pretty(no,oh,ot,h,t,dir,covered_positions)
    minx = nil
    miny = nil
    maxx = nil
    maxy = nil
    [oh,ot,h,t].each { |pos|
      minx = pos[0] if minx.nil? || pos[0] < minx
      maxx = pos[0] if maxx.nil? || pos[0] > maxx
      miny = pos[1] if miny.nil? || pos[1] < miny
      maxy = pos[1] if maxy.nil? || pos[1] > maxy
    }

    #puts "minx #{minx}"
    #puts "maxx #{maxx}"
    #puts "miny #{miny}"
    #puts "maxy #{maxy}"


    ix = 0
    [[oh,ot],[h,t]].each do |a|
      ix += 1
      if ix == 1
        # puts "[#{no}] Before going one #{dir}:"
      else
        puts "-"*80
        puts "[#{no}] After going one #{dir}:"
      end
      puts
      if ix == 2 # true
        x = minx - 2
        y = miny - 2
        row = y
        while row < maxy + 2
          col = x
          srow = nil
          while col < maxx + 2
            c = "."
            if [col,row] == a[0]
              c = "H"
              if a[0] == a[1]
                c = "B"
              end
            elsif [col,row] == a[1]
              c = "T"
            end
            srow = "#{srow}#{c}"
            col+=1
          end
          puts srow
          row += 1
        end
      end

    end
  end # pretty

  def Rope.run
    # tree visibility
    fin = File.open("day_09_input.txt","rt")

    debug = false

    # arbitrary starting coordinates
    x = 0
    y = 0

    num_knots = 10
    knots = []
    k = 0
    while k < num_knots
      knots << [ x, y]
      k+=1
    end

    covered_positions = []
    no = 0

    covered_positions << [knots[num_knots-1][0],knots[num_knots-1][1]] if !covered_positions.include?([knots[num_knots-1][0],knots[num_knots-1][1]])

    dirs = { "U" => "up", "D" => "down", "L" => "left", "R" => "right" }
    while iline = fin.gets
      cmds = iline.chomp.split
      dir = cmds[0]
      steps = cmds[1].to_i
      step = 0
      puts "#{dirs[dir]} #{steps}"
      while step < steps
        step+=1
        no+=1

        head = knots[0]

        case dir
        when "U"
          head[1] = head[1] - 1
          when "D"
            head[1] = head[1] + 1
          when "L"
            head[0] = head[0] - 1
          when "R"
            head[0] = head[0] + 1
        end


        # check if any other knots need adjustment
        kix = 1
        while kix < num_knots

          tail = knots[kix]

          xdiff = head[0] - tail[0]
          ydiff = head[1] - tail[1]
          need_diag = (xdiff > 1) || (ydiff > 1) || (xdiff < -1) || (ydiff < -1)

          puts "[#{no}]#{'*'*80} (xdiff = #{xdiff}, ydiff = #{ydiff}, need_diag = #{need_diag})" if debug

          any_move = false
          puts "-"*80
          if xdiff > 1 || (need_diag && xdiff > 0)
            puts "Moving knot #{kix} right because #{xdiff > 1 ? 'not adjacent' : 'diag required'}" if debug
            any_move = true
            tail[0] = tail[0] + 1
          elsif xdiff < -1 || (need_diag && xdiff == -1)
            puts "Moving knot #{kix} left because #{xdiff < -1 ? 'not adjacent' : 'diag required'}" if debug
            any_move = true
            tail[0] = tail[0] - 1
          end

          if ydiff > 1 || (need_diag && ydiff > 0)
            any_move = true
            puts "Moving knot #{kix} down because #{ydiff > 1 ? 'not adjacent' : 'diag required'}" if debug
            tail[1] = tail[1] + 1
          elsif ydiff < -1 || (need_diag && ydiff == -1)
            puts "Moving knot #{kix} up because #{ydiff < -1 ? 'not adjacent' : 'diag required'}" if debug
            tail[1] = tail[1] - 1
            any_move = true
          end
          puts "Not moving knot #{kix} as we're adjacent, overlapping or touching diagonally" if !any_move && debug

          head = tail
          kix += 1
        end


        # for some reason I have to dup...

        tail = knots[num_knots-1]
        covered_positions << [tail[0],tail[1]] if !covered_positions.include?([tail[0],tail[1]])


        #puts "H[#{ohead[0]},#{ohead[1]}],T[#{otail[0]},#{otail[1]}] going #{dirs[dir]} => H[#{head[0]},#{head[1]}],T[#{tail[0]},#{tail[1]}] (#{covered_positions.size})" if debug

      end
    end

    fin.close

    Rope.prettyMap(covered_positions)

    puts "Tail9 covered #{covered_positions.size} unique positions."

  end

  Rope.run


end
