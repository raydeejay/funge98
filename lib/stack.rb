module Funge98
  # Implements an infinite stack
  class Stack
    def initialize
      @contents = []
    end

    def empty?
      @contents.empty?
    end

    def push(value)
      @contents << value
    end

    def pop
      @contents.empty? ? 0 : @contents.pop
    end

    def swap
      @contents[-2], @contents[-1] = @contents[-1], @contents[-2] if  @contents.size > 1
      @contents << 0 if @contents.size == 1
    end

    def dup
      @contents << @contents[-1] if @contents.size.positive?
    end
  end
end
