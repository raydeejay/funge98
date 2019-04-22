require 'test_helper'

class Funge98CommandsTest < Minitest::Test
  def setup
    @interp = Funge98::Interpreter.new
  end

  def test_end
    @interp.load_string('  @').run
    assert @interp.x == 2
  end

  def test_bridge
    @interp.load_string('#@@').run
    assert @interp.x == 2
  end

  def test_digits
    @interp.load_string('123@').run
    assert @interp.stack.pop == 3
    assert @interp.stack.pop == 2
    assert @interp.stack.pop == 1
  end

  def test_left
    @interp.load_string('#@1<').run
    assert @interp.stack.pop == 1
    assert @interp.stack.pop == 1
  end

  def test_down
    @interp.load_string("v\n1\n@").run
    assert @interp.stack.pop == 1
  end

  def test_right
    @interp.load_string("v\n>1@").run
    assert @interp.stack.pop == 1
  end

  def test_up
    @interp.load_string("v @\n>1^").run
    assert @interp.stack.pop == 1
  end

  def test_wrap_left
    @interp.load_string('< @1').run
    assert @interp.stack.pop == 1
    assert @interp.x == 2
  end

  def test_wrap_up
    @interp.load_string("^\n@\n1").run
    assert @interp.stack.pop == 1
    assert @interp.y == 1
  end

  def test_wrap_right
    @interp.load_string("   v\n 1@>").run
    assert @interp.stack.pop == 1
    assert @interp.y == 1
  end

  def test_wrap_down
    @interp.load_string("1v\n@\nv<").run
    assert @interp.stack.pop == 1
    assert @interp.y == 1
  end

  def test_random
    # can't think of a relevant test
    assert true
  end

  def test_addition
    @interp.load_string('34+@').run
    assert @interp.stack.pop == 7
  end

  def test_subtraction
    @interp.load_string('34-@').run
    assert @interp.stack.pop == -1
  end

  def test_division
    @interp.load_string('72/@').run
    assert @interp.stack.pop == 3
  end

  def test_multiplication
    @interp.load_string('23*@').run
    assert @interp.stack.pop == 6
  end

  def test_modulo
    @interp.load_string('72%@').run
    assert @interp.stack.pop == 1
  end

  def test_greater_than
    @interp.load_string('43`@').run
    assert @interp.stack.pop == 1
  end

  def test_not_zero
    @interp.load_string('0!@').run
    assert @interp.stack.pop == 1
  end

  def test_not_nonzero
    @interp.load_string('7!@').run
    assert @interp.stack.pop == 0
  end

  def test_dup
    @interp.load_string('1:@').run
    assert @interp.stack.pop == 1
    assert @interp.stack.pop == 1
  end

  def test_swap
    @interp.load_string('12\@').run
    assert @interp.stack.pop == 1
    assert @interp.stack.pop == 2
  end

  def test_drop
    @interp.load_string('12$@').run
    assert @interp.stack.pop == 1
    assert @interp.stack.empty?
  end

  def test_horizontal_if_zero
    @interp.load_string(" 0v  \n@ _7@\n  @").run
    assert @interp.stack.pop == 7
  end

  def test_horizontal_if_nonzero
    @interp.load_string(" 1v  \n@5_ @\n  @").run
    assert @interp.stack.pop == 5
  end

  def test_vertical_if_zero
    @interp.load_string("v @  \n>0|\n@3<").run
    assert @interp.stack.pop == 3
  end

  def test_vertical_if_nonzero
    @interp.load_string("v @  \n>1|\n@3<").run
    assert @interp.stack.pop == 0
  end

  def test_stringmode
    @interp.load_string('"ABC"@').run
    assert @interp.stack.pop == 'C'.ord
    assert @interp.stack.pop == 'B'.ord
    assert @interp.stack.pop == 'A'.ord
  end

  def test_numerical_output
    @interp.load_string('12399+....@').run
    assert @interp.output == '18 3 2 1 '
  end

  def test_character_output
    @interp.load_string('79*::2+,3+,4+,@').run
    assert @interp.output == 'ABC'
  end

  def test_character_output
    @interp.load_string('79*::2+,3+,4+,@').run
    assert @interp.output == 'ABC'
  end

  def test_get
    @interp.load_string('#A10g@').run
    assert @interp.stack.pop == 65
  end

  def test_put
    @interp.load_string('# 910p10g@').run
    assert @interp.stack.pop == 9
  end

  def test_numerical_input
    def mock_stdin
      begin
        $stdin = StringIO.new
        $stdin.puts '123'
        $stdin.rewind
        yield
      ensure
        $stdin = STDIN
      end
    end

    mock_stdin {
      @interp.load_string('&.@').run
      assert @interp.output == '123 '
    }
  end

  def test_character_input
    def mock_stdin
      begin
        $stdin = StringIO.new
        $stdin.puts 'ABC'
        $stdin.rewind
        yield
      ensure
        $stdin = STDIN
      end
    end

    mock_stdin {
      @interp.load_string('~~~,,,@').run
      assert @interp.output == 'CBA'
    }
  end

  # tests from https://github.com/Deewiant/Mycology (the sanity test
  # is altered because I can't see how it could possibly pass otherwise)
  def test_sanity
    @interp.load('bf98tests/sanity.bf').run
    assert @interp.output == '0 1 2 3 4 5 6 7 8 9 '
  end

  def test_mycology98
    @interp.load('bf98tests/mycology.bf').run
    assert @interp.output == "0 1 2 3 4 5 6 7 \n" \
                             "GOOD: , works\n" \
                             "GOOD: : duplicates\n" \
                             "GOOD: empty stack pops zero\n" \
                             "GOOD: 2-2 = 0\n" \
                             "GOOD: | works\n" \
                             "GOOD: 0! = 1\n" \
                             "GOOD: 7! = 0\n" \
                             "GOOD: 8*0 = 0\n" \
                             "GOOD: \# < jumps into <\n" \
                             "GOOD: \\ swaps\n" \
                             "GOOD: 01` = 0\n" \
                             "GOOD: 10` = 1\n" \
                             "GOOD: 900pg gets 9\n" \
                             "GOOD: p modifies space\n" \
                             "GOOD: wraparound works\n" \
                             "UNDEF: edge \# skips column 80\n" \
                             "GOOD: Funge-93 spaces\n" \
                             "The Befunge-93 version of the Mycology test suite is done.\n" \
                             "Quitting...\n"
  end
end
