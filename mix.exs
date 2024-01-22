defmodule Loanmanagementsystem.MixProject do
  use Mix.Project

  def project do
    [
      app: :loanmanagementsystem,
      version: "0.1.0",
      elixir: "~> 1.7",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Loanmanagementsystem.Application, []},
      extra_applications: [:logger, :runtime_tools, :quantum]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.9"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.4"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:timex, "~> 3.7"},
      {:soap, "~> 1.0"},
      {:bamboo, "~> 1.3"},
      {:bamboo_smtp, "~> 2.1.0"},
      {:httpoison, "~> 1.6", override: true},
      {:poison, "~> 3.1.0", override: true},
      {:endon, "~> 1.0"},
      {:number, "~> 0.5.6"},
      {:decimal, "~> 1.6"},
      {:xlsxir, "~> 1.6.2"},
      {:csv, "~> 2.3"},
      {:pdf_generator, ">=0.6.2"},
      {:scrivener, "~> 2.0"},
      {:scrivener_ecto, "~> 2.0"},
      {:bbmustache, github: "soranoba/bbmustache"},
      {:quantum, "~> 3.0"},
      {:calendar, "~> 1.0.0"},
      {:nadia, "~> 0.7.0"},
      {:ex_gram, "~> 0.26"},
      {:hackney, "~> 1.12"},
      {:tesla, "~> 1.2"},
      {:hound, "~> 1.0"},
      {:uuid, "~> 1.1" }
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
