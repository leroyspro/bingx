defmodule BingX.MixProject do
  use Mix.Project

  def project do
    [
      app: :bingx,
      version: "0.1.0",
      elixir: "~> 1.16",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      consolidate_protocols: Mix.env() != :dev,
      description: description(),
      package: package(),
      deps: deps(),
      name: "GenETS",
      source_url: "https://gitlab.com/leroyspro/bingx"
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
      licenses: ["zlib License"],
      links: %{"GitLab" => "https://gitlab.com/leroyspro/bingx"}
    ]
  end

  defp deps() do
    [
      {:httpoison, "~> 2.2"},
      {:jason, "~> 1.4"},
      {:patch, "~> 0.13.0", only: [:test]}
    ]
  end
end
