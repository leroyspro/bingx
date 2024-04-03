defmodule BingX.MixProject do
  use Mix.Project

  @source_url "https://github.com/leroyspro/bingx"

  def project do
    [
      app: :bingx,
      version: "0.1.2",
      elixir: "~> 1.16",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      description: description(),
      package: package(),
      test_coverage: [tool: ExCoveralls],
      deps: deps(),
      name: "BingX",
      source_url: @source_url
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description() do
    "BingX - library providing enhanced BingX API clients."
  end

  defp package() do
    [
      # These are the default files included in the package
      files: ~w(lib .formatter.exs mix.exs README* LICENSE*),
      licenses: ["MIT License"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp deps() do
    [
      {:jason, "~> 1.4"},
      {:websockex, "~> 0.4.3"},
      {:patch, "~> 0.13.0", only: [:test]},
      {:excoveralls, "~> 0.18", only: :test}
    ]
  end
end
