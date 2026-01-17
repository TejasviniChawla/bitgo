defmodule Aura.MixProject do
  use Mix.Project

  def project do
    [
      app: :aura,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {Aura.Application, []},
      extra_applications: [:logger, :runtime_tools, :ecto_sql, :postgrex]
    ]
  end

  defp deps do
    [
      {:ecto_sql, "~> 3.11"},
      {:postgrex, ">= 0.0.0"},
      {:jason, "~> 1.4"},
      {:uuid, "~> 1.1"}
    ]
  end
end
