
require "./lib/AStar.rb"

# gem files required
# rubygems
# priority_queue


# Read file passed in as argument
# Example: irb run.rb large_map.txt
if __FILE__ == $0
	Content 	= File.read(ARGV[0])
	map 		= AStar::Map.new( Content )
	results 	= AStar.find_path( map )

	puts "\r\nResult path\r\n================================"
	puts results.map! {|pos| pos.join(",") }.join("  ") 
	puts "================================"
end
