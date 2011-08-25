# Stephen Gordon
#
# A Class which uses Dijkstra's Shunting-Yard algorithm to parse an infix expression
# into prefix-expression stack. Reference: wikipedia.org/wiki/Shunting-yard_algorithm

require './Helpers'

# Creates a prefixNotation stack given an infix expression
class ShuntingYard
  @infixString = nil
  @prefixStack = nil

  # on creation, build the prefix stack
  def initialize( inputString )
    @infixString = inputString
    @prefixStack = Array.new
    createPrefixStack
  end

  # Returns the prefix stack representation of its infix expression
  def prefixStack
    @prefixStack
  end


  # Creates a prefixStack which represents a prefix expression
  # This function assumes a valid infix expression was used
  # to create this object. This method uses the Shunting-Yard algorithm.
  def createPrefixStack
    opStack = Array.new
    infixArray = Array.new
    infixArray = @infixString.split

    while( !infixArray.empty? )
      currentChar = infixArray.shift

      # Handle case where current object is an 'operator'
      # +, -, *, /
      if( isOp?(currentChar) )
        # Determine if higher precedence operators on opStack
        # should be poped before adding current oper to stack
        if( opStack.empty? ) 
          opStack.push(currentChar) 
        else
          topOp = opStack.pop
          # while there are operators on the opStack with a higher precedence
          # then the current operator, push them to the prefixStack
          while( isOp?(topOp) )
            if( opPrecedence(currentChar) < opPrecedence(topOp) )
              @prefixStack.push(topOp)
              topOp = opStack.pop
            else
              break
            end
          end
          # topOp could be nil or a needed value depending on past precedence comparisons
          opStack.push(topOp) if !topOp.nil?
          opStack.push(currentChar)
        end

        # Current object is a left_paran, '(', push to operator stack
      elsif( isLeftParan?(currentChar) )
        opStack.push(currentChar)

        # Current object is a right_paran, ')'
        # Pop operators until matching left paran is found
      elsif( isRightParan?(currentChar) )
        topOp = opStack.pop
        while( !isLeftParan?(topOp) )
          @prefixStack.push(topOp)
          topOp = opStack.pop
        end # both topOp and currentChar are parans, discard them by doing nothing

        # Current object is a number or variable,
        # push onto prefixStack
      else 
        @prefixStack.push(currentChar) 
      end
    end

    while( !opStack.empty? )
      @prefixStack.push( opStack.pop )
    end

  end # end createPrefixStack
end #end class

