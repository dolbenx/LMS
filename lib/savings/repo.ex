defmodule Savings.Repo do
  use Ecto.Repo,
    otp_app: :savings,
    adapter: Ecto.Adapters.Postgres
    #adapter: Ecto.Adapters.Tds
    use Scrivener
end
