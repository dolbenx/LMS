defmodule LoanmanagementsystemWeb.Plugs.RequireAuth do
  @behaviour Plug
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(_params) do
  end

  def call(conn, _params) do
    if get_session(conn, :current_user) do
      conn
    else
      conn
      |> put_flash(:error, "Session Timed Out")
      |> redirect(to: LoanmanagementsystemWeb.Router.Helpers.session_path(conn, :username))
      |> halt()
    end
  end
end
