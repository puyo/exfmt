defmodule ExfmtTest do
  use ExUnit.Case, async: true
  doctest Exfmt, import: true

  describe "format/2" do
    test "formats valid source code" do
      assert Exfmt.format("[1,2,3]") == {:ok, "[1, 2, 3]"}
    end

    test "formats empty source" do
      #assert Exfmt.format("") == {:ok, ""}
      assert Exfmt.format("\n\n\n\n\n") == {:ok, "\n\n\n\n\n"}
    end

    test "returns error on invalid syntax" do
      message = "Error: syntax error before: ','"
      error = Exfmt.format(",")
      assert %Exfmt.SyntaxError{line: 1, message: message} == error
    end
  end


  describe "format!/2" do
    test "formats valid source code" do
      assert Exfmt.format!("[1,2,3]") == "[1, 2, 3]"
    end

    test "throws on invalid syntax" do
      message = "Error: syntax error before: ','"
      error = catch_error(Exfmt.format!(","))
      assert %Exfmt.SyntaxError{line: 1, message: message} == error
    end
  end


  describe "check/2" do
    test "ok for correctly formatted code" do
      assert Exfmt.check("[1, 2, 3]") == :ok
    end

    test "format_error for incorrectly formatted code" do
      assert Exfmt.check("[1,\n2]") == {:format_error, "[1, 2]"}
    end

    test "returns error on invalid syntax" do
      message = "Error: syntax error before: ','"
      error = Exfmt.check(",")
      assert %Exfmt.SyntaxError{line: 1, message: message} == error
    end
  end
end
