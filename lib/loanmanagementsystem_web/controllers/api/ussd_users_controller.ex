defmodule LoanmanagementsystemWeb.Api.UssdUsersController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false
  # alias Loanmanagementsystem.Repo

  # alias Loanmanagementsystem.Accounts.User

  def ussd_users(conn, _params) do
    response = Loanmanagementsystem.Services.Api.ApiServices.get_admin_users()
    IO.inspect("[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]")
    IO.inspect(response)

    case response do
      [] ->
        conn
        |> put_status(:bad_request)
        |> json(%{data: [], status: "NIL"})

      nil ->
        conn
        |> put_status(:bad_request)
        |> json(%{data: [], status: "NIL"})

      response ->
        conn
        |> put_status(:ok)
        |> json(%{data: response, status: "SUCCESS"})
    end
  end

  # def application_requirements(conn, _params) do
  #   response = %{
  #     idType: "NRC",
  #     payslip: "Latest Payslip",
  #     statement: "Bank Statement",
  #     introletter: "Letter of Introduction from Employer"
  #   }

  #   IO.inspect("[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]")
  #   IO.inspect(response)

  #   case response do
  #     [] ->
  #       conn
  #       |> put_status(:bad_request)
  #       |> json(%{data: [], status: "NIL"})

  #     nil ->
  #       conn
  #       |> put_status(:bad_request)
  #       |> json(%{data: [], status: "NIL"})

  #     response ->
  #       conn
  #       |> put_status(:ok)
  #       |> json(%{data: response, status: "SUCCESS"})
  #   end
  # end

  def loan_application(conn, params) do
    case Loanmanagementsystem.Services.Api.ApiServices.register_user(params) do
      {:error, reason} ->
        IO.inspect("]]]]]]]]]]]]]]]]]]][[[[[[[[[[[[[[[[[[[[")
        IO.inspect(reason)
        conn
        |> put_status(:bad_request)
        |> json(%{status: "FAILED", reason: reason})

      {:ok, _response} ->
        conn
        |> put_status(:ok)
        |> json(%{data: "You have Successfully added", status: "SUCCESS"})
    end
  end

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
