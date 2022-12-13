
class Tree
  attr_accessor :content
  attr_accessor :parent
  attr_accessor :children
  attr_accessor :direction

  @@nodecount = 0


  def initialize(pos, parent = nil, direction = nil)
    @content = pos
    @parent = parent
    if !parent.nil?
      parent.children << self
    end
    @children = []
    @direction = direction
    @@nodecount = @@nodecount + 1
  end


  def Tree.nodecount
    @@nodecount
  end
end

class Reception

  attr_accessor :tree

  def initialize
    @min_steps = nil
    @min_node = nil

    @start = nil
    @ziel = nil
    @width = nil
    @height = nil
    @tree = nil
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

    puts "Map is #{@width} x #{@height} (#{@width*@height} positions); Start is #{@start}, Ziel is #{@ziel}"

    @tree = Tree.new(@start)

    build_tree(@tree,0)

    if false
      ret = bfs

      path = []
      x = ret
      while !x.nil?
        path << x.content
        x = x.parent
      end
      puts "Shortest Path : #{path.reverse} - has #{path.size-1} steps"
    end

    if false
      if !@min_steps.nil?
        puts "The quickest way takes #{@min_steps} steps, like this:"
        node = @min_node
        path = []
        nsteps = 0
        while !node.nil?
          nsteps += 1
          path << node.content
          node = node.parent
        end
        puts "Path has #{path.size} elements : #{path.reverse}"
      end
    end

  end

  def check_content(tree,arr)
    arr << tree.content
    tree.children.each { |c|
      if arr.include?(c.content)
        puts "#{c.content} appears multiple times !"
      else
        arr << c.content
        check_content(c,arr)
      end
    }
  end

  # procedure BFS(G, root) is
  #       let Q be a queue
  #       label root as explored
  #       Q.enqueue(root)
  #       while Q is not empty do
  #           v := Q.dequeue()
  #           if v is the goal then
  #               return v
  #           for all edges from v to w in G.adjacentEdges(v) do
  #               if w is not labeled as explored then
  #                   label w as explored
  #                   w.parent := v
  #                   Q.enqueue(w)
  #

  def bfs
    root = Tree::TreeNode.new("X0", @start)
    q = []
    q << root
    explored = []
    explored << root
    len = 0
    while !q.empty?
      pos = q.pop
      len+=1
      if pos.content == @ziel
        puts "Yeah : #{len}"
        return pos
      end
      destinations_for(pos.content).each { |nx|
        if !explored.include?(nx)
          nxn = Tree::TreeNode.new("X#{explored.size}", nx)
          explored << nx
          q << nxn
        end
      }
    end
  end

  def init_map
    visited = []
    y = 0
    while y < @height
      x = 0
      row = []
      while x < @width
        val = 0
        row << val
        x+=1
      end
      y+=1
      visited << row
    end
    visited
  end

  def mark_node(visited,node)
    row = node.content[1]
    col = node.content[0]
    visited[row][col] = visited[row][col] + 1
    node.children.each do |cn|
      mark_node(visited,cn)
    end
  end

  def print_map(visited)
    y = 0
    visited.each do |row|
      x = 0
      s = nil
      while x < row.length
        if [ x, y ] == @start
          s = "#{s}S"
        elsif [ x, y ] == @ziel
          s = "#{s}E"
        else
          num = row[x]
          if num == 0
            s = "#{s}."
          elsif num < 10
            s = "#{s}#{num.to_i}"
          elsif num < 50
            s = "#{s}L"
          elsif num < 100
            s = "#{s}C"
          else
            s = "#{s}M"
          end
        end
        x+=1
      end
      y+=1
      puts s
    end
    puts
  end

  def build_tree(node,level)
    # given a tree node, check if we are at the destination
    if node.content == @ziel
      # Arrived !
      steps = [ node.content ]
      x = node
      while !x.nil?
        x = x.parent
        if !x.nil?
          steps << x.content
        end
      end
      puts "Found a solution that needs #{steps.size} steps: #{steps.reverse}"
      if @min_steps.nil? || @min_steps > steps.size
        @min_steps = steps.size
        @min_node = node
        puts "New Record !"
      end
    else
      # not there yet... check if we can go anywhere from here we haven't been to before
      #return if Tree.nodecount >= 300

      if Tree.nodecount % 1000 == 0
        len = 0
        x = node
        arr = []
        while !x.nil?
          len+=1
          arr << x.content
          x = x.parent
        end
        puts "Tree size is #{Tree.nodecount} - Map size is #{@width*@height}, current path length is #{len}"


        puts
        puts "Here is the map:"
        puts
        visited = init_map
        mark_node(visited,@tree)
        print_map(visited)
        puts "Here is the current path to #{node.content}:"
        visited = init_map
        x = node
        while !x.nil?
          visited[x.content[1]][x.content[0]] = visited[x.content[1]][x.content[0]] + 1
          x = x.parent
        end
        print_map(visited)
        # check_content(@tree,[])
        # @tree.print_tree
      end
      #return if Tree.nodecount >= 100

      dests = destinations_for(node.content,node.direction)

      if !dests.empty?
        subnode_index = 0
        #puts "Destinations for #{node.content} are #{dests}"
        dests.each do |d|
          next_pos = d[0]
          direction = d[1]
          visited_earlier = false
          x = node
          while !visited_earlier && !x.nil?
            visited_earlier = x.content[0] == next_pos[0] && x.content[1] == next_pos[1]
            x = x.parent
          end

          if !visited_earlier
            new_node = Tree.new(next_pos,node,direction)
            build_tree(new_node,level+1)
          end
        end
      end
    end
  end

  def destinations_for(pos,prevdir)
    nomansland = prevdir.nil? ? nil : [ prevdir[0]*-1, prevdir[1]*-1 ]
    dests = []
    alt = @altmap[pos[1]][pos[0]]
    [ [ -1 , 0], [ 0, -1 ], [ 1, 0], [ 0, 1 ] ].each { |move|
      if nomansland.nil? || move != nomansland
        newx = pos[0] + move[0]
        newy = pos[1] + move[1]
        if newx >= 0 && newx < @width && newy >= 0 && newy < @height
          new_alt = @altmap[newy][newx]
          alti = new_alt - alt
          if alti <= 1
            dests << [ [ newx, newy ], move ]
          end
        end
      end
    }
    # order destination by distance from target, just in case this speeds things up a bit...
    # nope, doing a full traversal, so no point !
    #dests.sort! { |a,b|
    #  d1 = (@ziel[1] - a[1])*(@ziel[1] - a[1]) + (@ziel[0] - a[0])*(@ziel[0] - a[0])
    #  d2 = (@ziel[1] - b[1])*(@ziel[1] - b[1]) + (@ziel[0] - b[0])*(@ziel[0] - b[0])
    #  d1 <=> d2
    #}
    dests
  end

  def same_pos(p1,p2)
    p1[0] == p2[0] && p1[1] == p2[1]
  end

  Reception.new.run

end
