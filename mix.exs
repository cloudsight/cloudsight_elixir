defmodule CloudsightElixir.Mixfile do
  use Mix.Project

  @description """
    Simple Elixir wrapper for the Cloudsight API
  """

  def project do
    [
      app: :cloudsight_elixir,
      version: "0.1.0",
      elixir: "~> 1.3",
      name: "Cloudsight API",
      description: @description,
      start_permanent: Mix.env == :prod,
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
      {:httpoison, "~> 0.13"},
      {:poison, "~> 3.1"},
      {:exvcr, "~> 0.8", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [ maintainers: ["mccallumjack"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/cloudsight/cloudsight_elixir"} ]
  end
end
