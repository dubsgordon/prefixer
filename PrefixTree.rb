# Stephen Gordon
# PrefixTree.rb
require './Helpers'

# Simple node to represent data in the tree
class TreeNode
  attr_accessor :data, :leftChild, :rightChild
  def initialize( value, lhs, rhs )
    @data = value
    @leftChild = lhs
    @rightChild = rhs
  end

  def isNumeric?
    return (@data.match(/\d/) == nil ? false : true)
  end
end

# Tree representation of a prefix expression
class PrefixTree
  attr_accessor :root

  def initialize
    # Nothing to be done 
  end

  # Function expects an array which represents a prefix expression
  # stack. The result is an expression tree with an operator or data
  # value at each node.  An operator node will have as children 
  # its left and right operands represented as lhs and rhs child nodes.
  def buildTree( prefixArray )
    return nil if prefixArray.empty?
    value = prefixArray.pop
    if( root.nil? )
      @root = TreeNode.new(value, nil, nil)
      # the right child comes before left since prefixArray 
      # is really a _stack_
      @root.rightChild = buildTree( prefixArray )
      @root.leftChild  = buildTree( prefixArray )
    elsif( isOp?(value) )
      newNode = TreeNode.new(value, nil, nil)
      newNode.rightChild = buildTree( prefixArray )
      newNode.leftChild  = buildTree( prefixArray )
      return newNode
    else
      return TreeNode.new(value, nil, nil)
    end
  end

  # Print to STDOUT a formated prefix representation of
  # the tree's expression.
  # If no node passed, assume tree's root
  def printPrefixNotation( rootNode=@root )
    return if rootNode.nil?
    
    # print open paran, operator, left operand, right operand, close parans
    if( isOp?(rootNode.data) )
      print '(' + rootNode.data + ' '
      printPrefixNotation( rootNode.leftChild )
      printPrefixNotation( rootNode.rightChild )
      print ') '
    else
      print rootNode.data + ' '
    end
  end

  # Looks at each node in tree recursively.  If current nodes data can be
  # simplified by combining its childrens numeric values with the proper
  # operator, it does so. 
  def reduceTree( rootNode=@root )
    return if rootNode.nil?
    return if (rootNode.leftChild.nil? && rootNode.rightChild.nil? )
    reduceTree( rootNode.leftChild ) 
    reduceTree( rootNode.rightChild )

    # If both children are numeric values, we can just perform the proper
    # operation on the children values and then replace the current node's
    # data with the result
    if( rootNode.leftChild.isNumeric? && rootNode.rightChild.isNumeric? )
      # This is a little verbose
      case rootNode.data
      when '+'
        rootNode.data = ( Float( rootNode.leftChild.data.to_f + rootNode.rightChild.data.to_f).to_s )
      when '-'
        rootNode.data = ( Float( rootNode.leftChild.data.to_f - rootNode.rightChild.data.to_f).to_s )
      when '*'
        rootNode.data = ( Float( rootNode.leftChild.data.to_f * rootNode.rightChild.data.to_f).to_s )
      when '/'
        rootNode.data = ( Float( rootNode.leftChild.data.to_f / rootNode.rightChild.data.to_f).to_s )
      end
      rootNode.leftChild = nil
      rootNode.rightChild = nil
    end

  end

  # For the purpose of testing
  def inOrderTraversal( rootNode )
    return if rootNode == nil
    inOrderTraversal( rootNode.leftChild )
    puts rootNode.data
    inOrderTraversal( rootNode.rightChild )
  end
end

