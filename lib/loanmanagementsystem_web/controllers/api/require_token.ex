defmodule LoanmanagementsystemWeb.Plugs.RequireToken do
  @behaviour Plug
  import Plug.Conn
  import LoanmanagementsystemWeb.Api.Crypto
  require Logger

  alias LoanmanagementsystemWeb.Api.ApiLoginContoller

  def init(default), do: default

  def call(conn, _default) do
    if Plug.Conn.get_req_header(conn, "authorization") != [] do
      case Plug.Conn.get_req_header(conn, "authorization") |> List.first() |> String.split(" ") do
        [""] ->
          LoanmanagementsystemWeb.Api.ApiLoginContoller.respond(conn, %{
            status: :unauthorized,
            status_code: 700,
            user_params: conn.params,
            msg: "Invalid token"
          })
          |> halt()

        [_, auth_key] ->
          case decrypt(:auth, auth_key) do
            {:ok, user} ->
              conn
              |> assign(:current_user, user)

            _ ->
              IO.inspect("Failed to decode")

              LoanmanagementsystemWeb.Api.ApiLoginContoller.respond(conn, %{
                status: :unauthorized,
                status_code: 700,
                user_params: conn.params,
                msg: "Invalid / Expired token"
              })
              |> halt()
          end

        _ ->
          LoanmanagementsystemWeb.Api.ApiLoginContoller.respond(conn, %{
            status: :unauthorized,
            status_code: 700,
            user_params: conn.params,
            msg: "Invalid token"
          })
          |> halt()
      end
    else
      LoanmanagementsystemWeb.Api.ApiLoginContoller.respond(conn, %{
        status: :unauthorized,
        status_code: 700,
        user_params: conn.params,
        msg: "Missing header token"
      })
      |> halt()
    end
  end
end
