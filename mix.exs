defmodule Loanmanagementsystem.MixProject do
  use Mix.Project

  def project do
    [
      app: :loanmanagementsystem,
      version: "0.1.0",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
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
      extra_applications: [:logger, :runtime_tools]
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
      {:phoenix, "~> 1.6.15"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.6"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.5"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:esbuild, "~> 0.4", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:endon, "~> 1.0"},
      # --------- mssql
      # {:tds, "~> 2.3"},
      {:scrivener, "~> 2.0"},
      {:scrivener_ecto, "~> 2.7", override: true},
      {:httpoison, "~> 0.13.0"},
      {:pipe_to, "~> 0.2"},
      {:bamboo, "~> 1.3"},
      {:bamboo_smtp, "~> 2.1.0"},
      {:elixir_uuid, "~> 1.2" },
      {:elixlsx, "~> 0.4.2"},
      {:xlsxir, "~> 1.6.2"},
      {:atomic_map, "~> 0.8"},
      {:csv, "~> 2.4"},
      {:number, "~> 1.0"},
      {:timex, "~> 3.6"},
      {:calendar, "~> 0.17.0"},
      {:nimble_csv, "~> 1.0"},
      {:skooma, "~> 0.2.0"},
      {:poison, "~> 3.1"},
      {:cachex, "~> 3.2"},
      {:quantum, "~> 3.4"},
      {:sweet_xml, "~> 0.6.6"},
      {:bbmustache, "~> 1.11"},
      {:logger_file_backend, "~> 0.0.10"},
      {:flow, "~> 1.1"},
      {:pbkdf2_elixir, "~> 1.0"},
      # {:pdf_generator, "~> 0.6.0"},
      {:browser, "~> 0.5.1"},
      {:json, "~> 1.4"}

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
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
