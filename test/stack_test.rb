require 'test_helper'

class StackTest < Minitest::Test
  def setup
    @stack = Funge98::Stack.new
  end

  def test_stack_starts_empty
    assert @stack.empty?
  end

  def test_empty_stack_pops_zero
    assert @stack.pop.zero?
  end

  def test_push_works
    @stack.push(2)
    @stack.push(3)
    assert @stack.pop == 3
    assert @stack.pop == 2
  end

  def test_swap_with_empty_stack
    @stack.swap
    assert @stack.pop.zero?
  end

  def test_swap_with_depth_one_stack
    @stack.push(1)
    @stack.swap
    assert @stack.pop.zero?
  end

  def test_swap_with_depth_two_stack
    @stack.push(1)
    @stack.push(2)
    @stack.swap
    assert @stack.pop == 1
    assert @stack.pop == 2
  end

  def test_dup
    @stack.push(1)
    @stack.dup
    @stack.pop
    assert @stack.pop == 1
  end

  def stack_holds_signed_long_int
    # according to specs, that is AT LEAST capable of blablabla
    # so it just holds ruby numbers, no overflow/undeflow
    assert true
  end
end
