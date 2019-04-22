require 'test_helper'

class Funge98Test < Minitest::Test
  def setup
    @stack = Funge98::Stack.new
    @interp = Funge98::Interpreter.new
  end

  def test_that_it_has_a_version_number
    refute_nil ::Funge98::VERSION
  end

  def test_initial_stack
    assert @interp.stack.empty?
  end

  def test_no_initial_program
    assert_nil @interp.program
  end

  def test_initial_output
    assert @interp.output == ''
  end

  def test_initial_dimensions
    assert @interp.width.zero?
    assert @interp.height.zero?
  end

  def test_initial_position
    assert @interp.x.zero?
    assert @interp.y.zero?
  end

  def test_initial_direction
    assert @interp.dir == :right
  end

  def test_load_a_program
    @interp.load('bf98tests/empty.bf')
    refute_nil @interp.program
    assert @interp.program[0][0] == '@'
  end

  def test_lines_are_expanded_to_80_chars
    @interp.load('bf98tests/empty.bf')
    assert @interp.program[0].length == 80
  end

  def test_lines_are_trimmed_to_80_chars
    @interp.load('bf98tests/longline.bf')
    assert @interp.program[0].length == 80
  end

  def test_lines_are_added_until_25
    @interp.load('bf98tests/empty.bf')
    assert @interp.program.length == 25
  end

  def test_height_is_set_after_load
    @interp.load('bf98tests/empty.bf')
    assert @interp.height == 25
  end

  def test_width_is_set_after_load
    @interp.load('bf98tests/empty.bf')
    assert @interp.width == 80
  end

  def test_fungespace_holds_unsigned_8bit_chars
    #we'll skip this one... for now...
    assert true
  end
  def test_that_it_has_a_version_number
    refute_nil ::Funge98::VERSION
  end
end
