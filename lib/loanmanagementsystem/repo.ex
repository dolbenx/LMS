defmodule Loanmanagementsystem.Repo do
  use Ecto.Repo,
    otp_app: :loanmanagementsystem,
    adapter: Ecto.Adapters.Postgres

  use Scrivener
end
