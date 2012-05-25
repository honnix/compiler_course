$: << "#{File.dirname(__FILE__)}/.."

require 'scanner/scanner'

class ParserSemantics
  def initialize(file)
    @scanner = Scanner.new(file)
    @token = @scanner.get_token
  end

  def parse
    expr
  end

  private

  def expr
    value = 1

    if @token.type == Token::MINUS
      @token = @scanner.get_token
      value = -1
    end

    value = value * term

    while @token.type == Token::PLUS or @token.type == Token::MINUS
      type = @token.type

      @token = @scanner.get_token

      if type == Token::PLUS
        value = value + term
      else
        value = value - term
      end
    end

    value
  end

  def term
    value = factor

    while @token.type == Token::MUL or @token.type == Token::DIV
      type = @token.type

      @token = @scanner.get_token

      if type == Token::MUL
        value = value * factor
      else
        value = value / factor
      end
    end

    value
  end

  def factor
    value = nil

    if @token.type == Token::ID or @token.type == Token::INT
      value = @token.value.to_i
      @token = @scanner.get_token
    elsif @token.type == Token::LPAREN
      @token = @scanner.get_token
      value = expr
      if @token.type == Token::RPAREN
        @token = @scanner.get_token
      else
        puts "')' expected"
        nil
      end
    else
      puts "ID, INT or '(' expected"
      nil
    end

    value
  end
end

if __FILE__ == $0
  parser = Parser.new('test.a')
  puts parser.parse
end
