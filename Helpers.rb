# Stephen Gordon
# Global helper functions

def isOp?(value)
  return ( value == '+' || value == '-' || value == '*' || value == '/' )
end

def isLeftParan?(value)
  return value == '('
end

def isRightParan?(value)
  return value == ')'
end

def opPrecedence(value)
  return 2 if (value == '*' || value == '/' )
  return 1 if (value == '+' || value == '-' )
  return 0
end

