defmodule Mix.Tasks.ExfmtTest do
  use ExUnit.Case, async: true
  import ExUnit.CaptureIO

  describe "mix exfmt" do
    test "with no args" do
      io = capture_io(:stderr, fn->
        Mix.Tasks.Exfmt.run([])
      end)
      assert io =~ "USAGE"
      assert io =~ "mix exfmt path/to/file.ex"
    end

    test "file path" do
      io = capture_io(fn->
        Mix.Tasks.Exfmt.run(["priv/examples/ok.ex"])
      end)
      assert io == ":ok\n"
    end

    test "STDIN to STDOUT" do
      io = capture_io("   [1,2,3] ", fn->
        Mix.Tasks.Exfmt.run(["--stdin"])
      end)
      assert io == "   [1, 2, 3]"
    end
  end
end
