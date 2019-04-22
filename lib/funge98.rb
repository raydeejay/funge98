require "funge98/version"
require_relative 'stack'

module Funge98
  class Interpreter
    attr_reader :stack, :program, :output, :width, :height, :x, :y, :dir, :stringmode

    def initialize
      @stringmode = false
      @stack = Stack.new
      @output = ''
      @width = 0
      @height = 0
      @x = 0
      @y = 0
      @dir = :right
    end

    def load_string(s)
      @program = []

      s.lines.each do | line |
        code = line.delete("\n").chars[0..79]
        code << ' ' while code.length < 80
        @program << code
      end

      @program << ([' '] * 80) while @program.length < 25

      @height = 25
      @width = 80
      return self
    end

    def load(filename)
      @program = []

      File.open(filename, "r") do |s|
        s.each do | line |
          code = line.delete("\n").chars[0..79]
          code << ' ' while code.length < 80
          @program << code
        end
      end

      @program << ([' '] * 80) while @program.length < 25

      @height = 25
      @width = 80
      return self
    end

    def arithmetic(op)
      a = @stack.pop
      b = @stack.pop

      case op
      when '+'
        b + a
      when '-'
        b - a
      when '*'
        b * a
      when '/'
        b / a
      when '%'
        b % a
      when '`'
        b > a ? 1 : 0
      end
    end

    def execute
      if @stringmode and @program[@y][@x] != '"'
        @stack.push(@program[@y][@x].ord)
      else
        case @program[@y][@x]
        when /\d/
          @stack.push(@program[@y][@x].to_i)
        when '@'
          return :end
        when '#'
          self.advance

        when '<'
          @dir = :left
        when '>'
          @dir = :right
        when '^'
          @dir = :up
        when 'v'
          @dir = :down
        when '?'
          @dir = [:up, :down, :left, :right].sample

        when /\+|-|\*|\/|%|`/
          @stack.push(arithmetic(@program[@y][@x]))

        when '!'
          @stack.push(@stack.pop.zero? ? 1 : 0)

        when ':'
          @stack.dup
        when '\\'
          @stack.swap
        when '$'
          @stack.pop

        when '_'
          @dir = @stack.pop.zero? ? :right : :left
        when '|'
          @dir = @stack.pop.zero? ? :down : :up

        when '"'
          @stringmode = !@stringmode

        when '.'
          @output << @stack.pop.to_s << ' '
        when ','
          @output << @stack.pop.chr

        when 'g'
          posy = @stack.pop
          posx = @stack.pop
          @stack.push(@program[posy][posx].ord)
        when 'p'
          posy = @stack.pop
          posx = @stack.pop
          val = @stack.pop
          @program[posy][posx] = val.chr

        when '&'
          @stack.push($stdin.gets.to_i)
        when '~'
          @stack.push($stdin.getc.ord)

        end
      end
    end

    def advance
      @x -= 1 if @dir == :left
      @x += 1 if @dir == :right
      @y -= 1 if @dir == :up
      @y += 1 if @dir == :down
      @x %= 80
      @y %= 25
    end

    def run
      result = nil
      loop {
        break if self.execute == :end
        self.advance
      }
      puts @output
    end
  end
end
