defmodule Mix.Tasks.Exfmt do
  @moduledoc """
  Formats Elixir source code.

      mix exfmt path/to/file.ex

  Or

      cat "[1,2,3]" | mix exfmt --pipe

  ## Command line options

    * `--unsafe` - Disable the semantics check that verifies
      that `exmft` has not altered the semantic meaning of
      the input file.
    * `--pipe` - Read input from stdin instead of a file.

  """

  @shortdoc  "Format Elixir source code"
  @usage """
  USAGE:
      mix exfmt path/to/file.ex

  PIPED USAGE:
      cat "[1,2,3]" | mix exfmt --pipe
  """

  use Mix.Task
  alias Exfmt.{SyntaxError, SemanticsError}

  def run(args) do
    option_parser_options = [strict: [unsafe: :boolean, pipe: :boolean]]

    with {opts, paths, []} <- OptionParser.parse(args, option_parser_options),
         {:ok, _, input} <- load_input(paths, opts),
         {:ok, formatted} <- format(input, opts) do
      IO.write formatted
    else
      {:err, [], {:error, :enoent}} ->
        @usage
        |> red()
        |> IO.puts

      {:err, path, {:error, :enoent}} ->
        "Error: No such file or directory:\n    #{path}"
        |> red()
        |> IO.puts

      {:err, path, {:error, :eisdir}} ->
        "Error: Input is a directory, not an Elixir source file:\n   #{path}"
        |> red()
        |> IO.puts


      {:err, path, {:error, :eacces}} ->
        "Error: Incorrect permissions, unable to read file:\n   #{path}"
        |> red()
        |> IO.puts

      {:err, path, {:error, :enomem}} ->
        "Error: Not enough memory to read file:\n   #{path}"
        |> red()
        |> IO.puts

      {:input, path, {:error, :enotdir}} ->
        "Error: Unable to open a parent directory:\n   #{path}"
        |> red()
        |> IO.puts

      %SemanticsError{message: message} ->
        message
        |> red()
        |> IO.puts

      %SyntaxError{message: message} ->
        message
        |> red()
        |> IO.puts
    end
  end


  defp load_input([path], opts) do
    load_input(path, opts)
  end

  defp load_input(path, opts) do
    pipe? = Keyword.get(opts, :pipe, false)
    do_load_input(path, pipe?)
  end


  defp do_load_input(path, false) do
    with {:ok, input} <- File.read(path) do
      {:ok, path, input}
    else
      err -> {:err, path, err}
    end
  end

  defp do_load_input(_, true) do
    {:ok, "(stdin)", IO.read(:stdio, :all)}
  end


  defp format(source, opts) do
    if opts[:unsafe] do
      Exfmt.unsafe_format(source)
    else
      Exfmt.format(source, 100)
    end
  end


  defp red(msg) do
    [IO.ANSI.red, msg, IO.ANSI.reset]
  end
end
