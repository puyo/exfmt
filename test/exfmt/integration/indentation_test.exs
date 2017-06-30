defmodule Exfmt.Integration.IndentationTest do
  use ExUnit.Case
  import Support.Integration

  test "one line of code" do
    assert_format "  [1, 2, 3]\n"
  end

  test "multiple lines of code" do
    assert_format """
        fn(x) ->
          y = x + x
          y
        end
    """
  end

  test "multiple lines of code padded with blank lines" do
    assert_format """

        fn(x) ->
          y = x + x
          y
        end


    """
  end
end
