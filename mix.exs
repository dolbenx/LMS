defmodule LoanSystem.MixProject do
  use Mix.Project

  def project do
    [
      app: :loan_system,
      version: "0.1.0",
      elixir: "~> 1.5",
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
      mod: {LoanSystem.Application, []},
      extra_applications: [:logger, :runtime_tools, :bamboo,]

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
      {:phoenix, "~> 1.4.9"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.1"},
      {:tds, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:timex, "~> 3.6"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:soap, "~> 1.0"},
      {:bamboo, "~> 1.3"},
      {:bamboo_smtp, "~> 2.1.0"},
      {:poison, "~> 3.1"},
      {:csv, "~> 2.3"},
      {:calendar, "~> 0.17.0"},
      {:xlsxir, "~> 1.6.2"},
      {:endon, "~> 1.0"},
      {:quantum, "~> 3.0"},
      {:elixlsx, "~>  0.1.1"},
      {:arc_ecto, "~> 0.11.3"},
      {:number, "~> 0.5.6"},
      {:mtn_momo, git: "https://gitlab.probasegroup.com/probase-dependency-library/mobile-money/mtn_momo.git", tag: "momo-0.8"},
      {:airtel_momo, git: "https://gitlab.probasegroup.com/probase-dependency-library/mobile-money/airtel_momo.git", tag: "0.2.0"},
      {:scrivener, "~> 2.0"},
      {:scrivener_ecto, "~> 2.7", override: true}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
