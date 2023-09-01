defmodule LoanmanagementsystemWeb.Plugs.RequireAuth do
  @behaviour Plug
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias Loanmanagementsystem.Accounts

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :current_user)
    # remote_ip = conn.remote_ip |> :inet.ntoa() |> to_string()

    if user_id do
      user = Accounts.get_user!(user_id)

      if(user.status == "ACTIVE") do
        conn
      else
        conn
        # |> configure_session(drop: true)
        |> clear_session()
        |> put_flash(:error, "Session closed")
        # |> redirect(to: LoanmanagementsystemWeb.Router.Helpers.session_path(conn, :username))
        |> redirect(to: LoanmanagementsystemWeb.Router.Helpers.session_path(conn, :username))
        |> halt()
      end
    else
      conn
      |> put_flash(:error, "Session Expired, Please Log in.")
      # |> redirect(to: LoanmanagementsystemWeb.Router.Helpers.session_path(conn, :username))
      |> redirect(to: LoanmanagementsystemWeb.Router.Helpers.session_path(conn, :username))
      |> halt()
    end
  end
end
