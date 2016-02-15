require 'rubygems'
require 'priority_queue'

module AStar

  class NodePath < Array
    def initialize( map )
      @map = map
      super([@map.start])
    end

    def movement_cost
      inject(0) {|sum, c| sum + @map.node(*c) }
    end
  end

  class Map
    attr_reader :start, :goal

    def initialize(map_str)
      @nodes = []
      map_str.each_line do |line|
        @nodes << []
        
        arry = line.chomp.each_char.to_a

        arry.each do |c|
          @nodes.last << case c
                         when "@"
                          0
                         when       ".", "X"
                           1
                         when       "*"
                           2
                         when       "^"
                           3
                         when       "~"
                           nil
                         else
                           nil
                         end
          if '@' == c
            @start = [@nodes.last.length - 1, @nodes.length - 1]
          elsif 'X' == c
            @goal = [@nodes.last.length - 1, @nodes.length - 1]
          end
        end

      end
      unless @start && @goal
        raise "Start and End Node is the same"
      end
    end

    def node(x, y)
      @nodes[y][x]
    end

    def movment_option(x, y)
      if node(x, y) == nil 
        raise "Illegal node"
      end
      choices = []
      (-1..1).each do |i|
        ypos = y + i
        if ypos >= 0 && ypos < @nodes.length
          (-1..1).each do |j|
            xpos = x + j
            if xpos >= 0 && xpos < @nodes[i].length
              new_position = [xpos, ypos]
              if new_position != [x, y] && node(*new_position) != nil #water
                choices << new_position
              end
            end
          end
        end
      end
      choices
    end

    def self.manhattan(point1, point2)
      ((point2[0] - point1[0]) + (point2[1] - point1[1])).abs
    end
  end

  def self.find_path(map)
    
    closed  = []
    open    = PriorityQueue.new
    
    open.push NodePath.new(map), 0
    while ! open.empty?
    

      current_path = open.delete_min_return_key
      pos = current_path.last
      unless closed.include?(pos)
        if pos == map.goal
          return current_path
        end

        closed << pos
        map.movment_option(*pos).each do |p|
          heuristic = Map.manhattan(p, map.goal)
          new_path = current_path.clone << p
          open.push(new_path, new_path.movement_cost + heuristic)
        end

      end
    end
    raise "No movement option"
  end
end



