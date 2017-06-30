defmodule Exfmt.Integration.WhitespaceTest do
  use ExUnit.Case
  import Support.Integration

  test "one trailing newline" do
    assert_format "[1, 2, 3]\n"
  end

  test "multiple trailing newlines" do
    assert_format "[1, 2, 3]\n\n\n"
  end

  test "no trailing newline" do
    assert_format "[1, 2, 3]"
  end
end
