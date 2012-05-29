$: << "#{File.dirname(__FILE__)}/.."

require 'scanner/scanner'

class Parser
  def initialize(file)
    @scanner = Scanner.new(file)
    @token = @scanner.get_token
  end

  def parse
    expr
  end

  private

  def expr
    if @token.type == Token::MINUS
      @token = @scanner.get_token
    end

    term

    while @token.type == Token::PLUS or @token.type == Token::MINUS
      @token = @scanner.get_token
      term
    end
  end

  def term
    factor

    while @token.type == Token::MUL or @token.type == Token::DIV
      @token = @scanner.get_token
      factor
    end
  end

  def factor
    while @token.type != Token::ID and @token.type != Token::INT and @token.type != Token::LPAREN
      @token = @scanner.get_token
      puts "ID, INT or LPAREN is required"
    end

    if @token.type == Token::ID or @token.type == Token::INT
      @token = @scanner.get_token
    elsif @token.type == Token::LPAREN
      @token = @scanner.get_token
      expr
      if @token.type == Token::RPAREN
        @token = @scanner.get_token
      else
        puts "')' expected"
      end
    else
      puts "ID, INT or '(' expected"
    end
  end

end

if __FILE__ == $0
  parser = Parser.new('test.a')
  parser.parse
end
