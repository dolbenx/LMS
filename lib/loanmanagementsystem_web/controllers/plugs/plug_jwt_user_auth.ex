defmodule LoanmanagementsystemWeb.Plug.UserAuth do
  @behaviour Plug
  import Plug.Conn
  import Loanmanagementsystem.Security.JwtToken.UserAuth

  alias LoanmanagementsystemWeb.AuthenticationController, as: Callback

  def init(default), do: default

  def call(conn, _default) do
    if Plug.Conn.get_req_header(conn, "token") != [] do
      [auth_token] = Plug.Conn.get_req_header(conn, "token")

      auth_token
      |> verify_token(conn)
      |> case do
        {:error, message} -> Callback.respond(conn, message, :unauthorized) |> halt()
        {:ok, _claims, client_conn} -> client_conn
      end
    else
      Callback.respond(conn, %{message: "Missing Header Key (token)", status: 400}, :unauthorized)
      |> halt()
    end
  end
end
