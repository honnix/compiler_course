class Token
  EOF = 0
  ID = 1
  INT = 2
  LPAREN = 3
  RPAREN = 4
  LBR = 5
  RBR = 6
  NEQ = 7
  NOT = 8
  EQ = 9
  ASSIGN = 10
  KEYWORD = 11
  SCOLON = 12

  attr_reader :type
  attr_reader :value

  def initialize(type, value = nil)
    @type = type
    @value = value
  end
end

class Scanner
  def initialize(file)
    @file = File.open(file, 'r')
    @next = @file.readchar
  end

  def get_token
    skip_whitespace

    if @file.eof?
      @file.close
      Token.new(Token::EOF)
    else
      move_on
    end
  end

  private

  KEYWORD_TABLE = %w{while do for if else return}

  def move_on
    case @next
    when ';'
      @next = @file.readchar
      Token.new(Token::SCOLON)
    when '('
      @next = @file.readchar
      Token.new(Token::LPAREN)
    when ')'
      @next = @file.readchar
      Token.new(Token::RPAREN)
    when '{'
      @next = @file.readchar
      Token.new(Token::LBR)
    when '}'
      @next = @file.readchar
      Token.new(Token::RBR)
    when /\d/
      number = @next

      @next = @file.readchar
      while @next =~ /\d/
        number += @next
      end

      Token.new(Token::INT, number.to_i)
    when '='
      @next = @file.readchar
      if @next == '='
        @next = @file.readchar
        Token.new(Token::EQ)
      else
        Token.new(Token::ASSIGN)
      end
    when '!'
      @next = @file.readchar
      if @next == '='
        @next = @file.readchar
        Token.new(Token::NEQ)
      else
        Token.new(Token::NOT)
      end
    when /[a-zA-Z]/
      str = @next

      @next = @file.readchar
      while @next =~ /[_a-zA-Z0-9]/
        str += @next
        @next = @file.readchar
      end

      if keyword?(str)
        Token.new(Token::KEYWORD, str)
      else
        Token.new(Token::ID, str)
      end
    end
  end

  def keyword?(str)
    KEYWORD_TABLE.include? str
  end

  def skip_whitespace
    while @next =~ /\s/ and not @file.eof?
      @next = @file.readchar
    end
  end
end

scanner = Scanner.new('test.c')
token = scanner.get_token
while token.type != Token::EOF
  p token
  token = scanner.get_token
end
