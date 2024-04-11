defmodule LoanmanagementsystemWeb.Plugs.RequireAuth do
  @behaviour Plug
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2, json: 2]

  def init(_params) do
  end

  def call(%{assigns: assigns} = conn, _params) do
    if Map.has_key?(assigns, :user) do
      conn
    else
      access_denied(conn, get_req_header(conn, "accept"), "You need to be logged in", false)
    end
  end

  defp access_denied(conn, ["application/json" <> _header_accept], msg, drop_session?) do
    conn
    |> (&((drop_session? && clear_session(&1)) || &1)).()
    |> json(%{error: msg})
    |> halt()
  end

  defp access_denied(conn, _accepts, msg, drop_session?) do
    conn
    |> (&((drop_session? && clear_session(&1)) || &1)).()
    |> put_flash(:error, msg)
    |> redirect(to: LoanmanagementsystemWeb.Router.Helpers.session_index_path(conn, :index))
    |> halt()
  end
end
