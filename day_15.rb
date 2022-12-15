
# Part 1 : just had a ! condition incorrectly wrapped , baaaaa

class Beacon


  attr_accessor :part

  def initialize
    @part = 1
  end

  def check_overage(sensors, target_y)
    ret = 0
    # for each sensor, calculate all points that CANNOT possibly have a beacon, add up those that are on the given y
    six = 0
    counted = Hash.new


    # mark all positions where there is actual beacons on the target line as 'used' so they are not counted

    sensors.each_key { |pos|
      b = sensors[pos][:beacon]
      counted[b[0]] = b[1] if b[1] == target_y
    }

    sensors.each_key { |pos|
      six+=1
      sensor = sensors[pos]
      x = -1*sensor[:distance] + pos[0]
      max_x = sensor[:distance] + pos[0]
      max_y = sensor[:distance] + pos[1]
      puts "Sensor #{six} : Checking #{sensor[:distance]*2} positions..."
      while x <= max_x
        # y = -1*sensor[:distance] + pos[1]
        # I only need to check y pos given !!
        y = target_y
        while y <= target_y

          dist = taxiride(pos,[x,y])
          if dist <= sensor[:distance]
            # this position cannot have a sensor - if it's on the requested Y add it
            if y == target_y && counted[x].nil?
              ret += 1
              counted[x] = y
              if ret % 1000 == 0
                puts "Found #{ret}..."
              end
            end
          end
          y+=1
        end
        x+=1
      end
    }


    ret
  end

  def is_match(x,y)
    ((x-545406).abs + (y-2945484).abs >= 546548) && ((x-80179).abs + (y-3385522).abs >= 1451813) && ((x-2381966).abs + (y-3154542).abs >= 157990) && ((x-2607868).abs + (y-1728571).abs >= 379187) && ((x-746476).abs + (y-2796469).abs >= 196463) && ((x-911114).abs + (y-2487289).abs >= 277355) && ((x-2806673).abs + (y-3051666).abs >= 369593) && ((x-1335361).abs + (y-3887240).abs >= 1565525) && ((x-2432913).abs + (y-3069935).abs >= 61984) && ((x-1333433).abs + (y-35725).abs >= 1089327) && ((x-2289207).abs + (y-1556729).abs >= 869690) && ((x-2455525).abs + (y-3113066).abs >= 42955) && ((x-3546858).abs + (y-3085529).abs >= 183221) && ((x-3542939).abs + (y-2742086).abs >= 329239) && ((x-2010918).abs + (y-2389107).abs >= 1093815) && ((x-3734968).abs + (y-3024964).abs >= 145668) && ((x-2219206).abs + (y-337159).abs >= 482244) && ((x-1969253).abs + (y-890542).abs >= 401310) && ((x-3522991).abs + (y-3257032).abs >= 378591) && ((x-2303155).abs + (y-3239124).abs >= 321383) && ((x-2574308).abs + (y-111701).abs >= 1062804) && ((x-14826).abs + (y-2490395).abs >= 894145) && ((x-3050752).abs + (y-2366125).abs >= 701251) && ((x-3171811).abs + (y-2935106).abs >= 507347) && ((x-3909938).abs + (y-1033557).abs >= 1996830) && ((x-1955751).abs + (y-452168).abs >= 103780) && ((x-2159272).abs + (y-614653).abs >= 315440) && ((x-3700981).abs + (y-2930103).abs >= 126328) && ((x-3236266).abs + (y-3676457).abs >= 684789) && ((x-3980003).abs + (y-3819278).abs >= 1010591) && ((x-1914391).abs + (y-723058).abs >= 208470) && ((x-474503).abs + (y-1200604).abs >= 1700611) && ((x-2650714).abs + (y-3674470).abs >= 753112) && ((x-1696740).abs + (y-586715).abs >= 289778) && ((x-3818789).abs + (y-2961752).abs >= 212487)
  end

  def add_coverage(covered,x0,x1, min,max)
    any_overlap = false
    ret = covered
    covered.each { |section|
      # starts in this section - may extend the section to the right
      if x0 >= section[0] && x0 <= section[1]
        any_overlap = true
        if x1 >= section[1]
          section[1] = x1
        end
      elsif x1 >= section[0] && x1 <= section[1]
        any_overlap = true
        # ends in this section - may extend the section to the left
        if x0 <= section[0]
          section[0] = x0
        end
      end
    }

    if !any_overlap
      covered << [ x0, x1 ]  # && !covered.include?([x0,x1])
      covered = covered.sort { |a,b| a[0] <=> b[0] }
      if covered.include?([min,max])
        ret = [min,max]
      end
      # check for overlaps
      nc = []
      section = covered.shift
      while !covered.empty?
        next_section = covered.shift
        # previous
        if section[1] <= next_section[0]
          # join
          section[1] = next_section[1]
        else
          nc << section
          section = next_section
        end
      end
      nc << section if !nc.include?(section)
      ret = nc
    end
    ret
  end

  # check if the given position is a possible beacon location - we already know it's on the outline of the sensor indicated as 'six',
  # so no check against the other sensors by testing the manhattan distance to them - if they are all outside range then the location
  # must be the beacon
  def check_position(sensors,six,pos, min,max)
    ret = false
    if pos[0] >= min && pos[0] <= max && pos[1] >= min && pos[1] <= max
      six2 = 0
      ret = true
      sensors.each_key { |sensor_pos|
        break if !ret
        if six2 != six
          ret = taxiride(sensor_pos,pos) > sensors[sensor_pos][:distance]
        end
        six2+=1
      }
    end
    if ret
      puts "Got a match at #{pos} !"
    end
    ret
  end

  def find_beacon(sensors, min,max)
    pozibles = []
    six = 0
    found = false
    sensors.each_key { |pos|
      puts "Checking outline of sensor #{six+1}..."
      break if found
      sensor = sensors[pos]
      # start at sensor level, then work up/down
      # the possible locations are one further away then the current reach of the sensor
      desired_distance = sensor[:distance] + 1
      ymove = 0
      xmove = desired_distance
      while xmove >= 0 && !found
        # don't worry about doubling up
        found ||= check_position(sensors,six,[ pos[0] - xmove, pos[1] + ymove ],min,max)
        found ||= check_position(sensors,six,[ pos[0] + xmove, pos[1] + ymove ],min,max)
        found ||= check_position(sensors,six,[ pos[0] - xmove, pos[1] - ymove ],min,max)
        found ||= check_position(sensors,six,[ pos[0] + xmove, pos[1] - ymove ],min,max)
        ymove += 1
        xmove -= 1
      end
      six += 1
    }
  end

  def find_beacon2(sensors, min,max)
    ret = nil

    t0 = Time.now
    y = min
    while y <= max
      x = 0
      puts "#{Time.now.strftime('%H:%M')} : #{y}/#{max} (#{y*100/max}%)...(#{((Time.now-t0)/60).to_i} minutes)"
      while x <= max
        if is_match(x,y)
          puts "#{x},#{y}"
        end
        x+=1
      end
      y+=1
    end
    nil
  end

  # Manhattan distance
  def taxiride(p1,p2)
    (p1[0]-p2[0]).abs + (p1[1] - p2[1]).abs
  end

  def run

    fin = File.open("day_15_input.txt","rt")

    sensors = Hash.new

    lix = 0
    while iline = fin.gets
      lix+=1
      line = iline.chomp
      fields = line.split("=")
      sensor = [ fields[1].to_i, fields[2].to_i ]
      beacon = [ fields[3].to_i, fields[4].to_i ]
      distance = taxiride(sensor,beacon)
      sensors[sensor] = { distance: distance, beacon: beacon } # record the distance of the beacon, which means any point **this close or closer** than this cannot have a beacon !
    end

    fin.close
    puts "Have #{sensors.size} sensors"

    #ret = check_overage(sensors,2000000)

    #puts "Part 1 : #{ret}"

    ret = find_beacon(sensors,0,4000000)
    puts "Part 2 : #{ret}"
  end
  Beacon.new.run

end
