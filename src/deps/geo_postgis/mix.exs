defmodule GeoPostgis.Mixfile do
  use Mix.Project

  def project do
    [
      app: :geo_postgis,
      version: "2.1.0",
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      package: package(),
      name: "GeoPostGIS",
      elixirc_paths: elixirc_paths(Mix.env()),
      source_url: source_url()
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp source_url do
    "https://github.com/bryanjos/geo_postgis"
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp description do
    """
    PostGIS extension for Postgrex.
    """
  end

  defp deps do
    [
      {:geo, "~> 3.0"},
      {:postgrex, "~> 0.13"},
      {:ex_doc, "~> 0.18.4", only: :dev},
      {:ecto, "~> 2.1", optional: true, only: :test},
      {:poison, "~> 2.2 or ~> 3.0", optional: true},
      {:jason, "~> 1.0", optional: true}
    ]
  end

  defp package do
    # These are the default files included in the package
    [
      files: ["lib", "mix.exs", "README.md", "CHANGELOG.md"],
      maintainers: ["Bryan Joseph"],
      licenses: ["MIT"],
      links: %{"GitHub" => source_url()}
    ]
  end
end
