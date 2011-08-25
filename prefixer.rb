#!/usr/bin/env ruby
# Stephen Gordon
#
# Infix to Prefix converter
require './PrefixTree'
require './ShuntingYard'

# Display how to properly execute the program
def usage
  puts "Usage: ./prefixer [-r] input_file_name"
  exit(1)
end

def main
  
  if( ARGV.size == 0 )
    usage()
  end
  
  # Check if reduce flag is set
  reduceSet = (ARGV[0].downcase == '-r' ? true : false )

  # Input file is first or second argument, depending if reduce was set
  inputFileName = ( reduceSet ? ARGV[1] : ARGV[0] )
  if( inputFileName.nil? )
    usage()
  end
   
  # For each expression in the input file:
  # first build a prefix stack useing shunting yard algorithim
  # next, build an expression tree and then reduce if flag was set 
  File.read( inputFileName ).each_line { |line| 
    myTree = PrefixTree.new
    myTree.buildTree( ShuntingYard.new( line ).prefixStack )
    myTree.reduceTree if reduceSet
    myTree.printPrefixNotation
    puts ""
  }

end

# Run the program
main
