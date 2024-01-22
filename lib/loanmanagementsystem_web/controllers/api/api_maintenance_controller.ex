defmodule LoanmanagementsystemWeb.Api.ApiMaintenanceController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false

  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Maintenance.Country
  alias Loanmanagementsystem.Logs.UserLogs

  def admin_create_country_api(conn, params) do

    IO.inspect(conn, label: "--------------------------------")


    name = params["name"]
    code = params["code"]

    get_name = Repo.get_by(Country, name: name)
    get_code = Repo.get_by(Country, code: code)

    case is_nil(get_code) do
      true ->

      case is_nil(get_name) do
        true ->

        Ecto.Multi.new()
        |> Ecto.Multi.insert(:add_country, Country.changeset(%Country{}, params))
        |> Ecto.Multi.run(:user_logs, fn _repo, %{add_country: _add_country} ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Added Country Successfully",
             user_id: 2
          })
          |> Repo.insert()
        end)
        |> Repo.transaction()
        |> IO.inspect()
        |> case do
          {:ok, %{add_country: _add_country, user_logs: _user_logs}} ->
            conn
            |> put_status(:ok)
            |> json(%{data: [], status: "SUCCESS"})

          {:error} ->
            conn
            |> put_status(:bad_request)
            |> json(%{data: [], status: "DENIED"})
        end

      _ ->
        conn
        |> put_status(:bad_request)
        |> json(%{data: [], status: "County #{name} already exists"})
      end

    _ ->
      conn
      |> put_status(:bad_request)
      |> json(%{data: [], status: "County code #{code} already exists"})
    end
  end

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
