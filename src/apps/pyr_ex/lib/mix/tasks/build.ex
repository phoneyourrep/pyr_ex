defmodule Mix.Tasks.PyrEx.Build do
  @moduledoc """
  Build task for contributing to the PYREx umbrella app.

    * Runs the formatter
    * Runs tests on all sub apps
    * Generates docs

  Run it in the `./src` directory with command `mix pyr_ex.build`.
  """
  import IO.ANSI, only: [cyan: 0, bright: 0, normal: 0, default_color: 0]

  use Mix.Task

  @preferred_cli_env :test

  @doc """
  Runs the `pyr_ex.build` task.
  """
  @spec run(argv :: [String.t()]) :: {atom, non_neg_integer}
  def run(argv) do
    {opts, _, _} = OptionParser.parse(argv, strict: [format: :boolean])
    run_formatter(argv, opts)
    run_tests(argv)
    build_docs(argv)
  end

  @spec run_formatter([binary()], keyword()) :: any()
  defp run_formatter(argv, opts) do
    if Keyword.get(opts, :format, true) do
      Mix.shell().info("#{cyan()}#{bright()}Running formatter")
      Mix.shell().info("#{normal()}#{default_color()}")
      Mix.Task.run("format", ["--check-equivalent" | argv])
    end
  end

  @spec run_tests([binary()]) :: any()
  defp run_tests(argv), do: Mix.Task.run("test", argv)

  @spec build_docs([binary()]) :: any()
  defp build_docs(argv) do
    Mix.Task.run("docs", argv)
    File.rm_rf!("../docs")
    System.cmd("mv", ["doc/", "../docs/"])
  end
end
