defmodule CloudsightElixir.Mixfile do
  use Mix.Project

  @description """
    Simple Elixir wrapper for the Cloudsight API
  """

  def project do
    [
      app: :cloudsight_elixir,
      version: "0.4.0",
      elixir: "~> 1.5",
      name: "Cloudsight API",
      description: @description,
      start_permanent: Mix.env() == :prod,
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.0"},
      {:poison, "~> 3.1"},
      {:oauther, "~> 1.1"},
      {:exvcr, "~> 0.10.2", only: :test},
      {:ex_doc, "~> 0.19", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["mccallumjack"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/cloudsight/cloudsight_elixir"}
    ]
  end
end
