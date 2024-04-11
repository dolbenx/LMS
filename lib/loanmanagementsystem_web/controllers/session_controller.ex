defmodule LoanmanagementsystemWeb.SessionController do
  use LoanmanagementsystemWeb, :controller
  import Plug.Conn

  alias Loanmanagementsystem.Logs
  alias Loanmanagementsystem.Accounts
  alias LoanmanagementsystemWeb.Plugs.UserAuthenticate
  alias Loanmanagementsystem.Workers.Utlis.Cache

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def login(conn, _params) do
    params = Cache.get(:login)
    with false <- is_nil(Map.get(params, :username)),
        false <- is_nil(Map.get(params, :password)) do

        case Accounts.get_user_by_username_and_password(conn, params.username, params.password) do
          {:error, message} -> error_resp(conn, message)
          user ->
            Cache.delete(:login)
            UserAuthenticate.log_in_user(conn, user, params)
        end
    else
      _-> error_resp(conn, "Could Not login, Please Try Again!")
    end
  end

  defp error_resp(conn, message) do
    Cache.delete(:login)
    conn
    |> put_flash(:error, message)
    |> redirect(to: Routes.session_index_path(conn, :index))
  end

  def signout(conn, _params) do
    user = Accounts.get_user!(conn.assigns.current_user.id)
    Task.start(fn ->
      Accounts.get_session_by_user_id(user.id)
      |> Enum.map(fn session2 ->
        Logs.find_and_update_session_id_log_out(
          "users_sessions:#{Base.url_encode64(session2.token)}",
          user.id,
          "Successfully Logged Out")
      end)

      Logs.create_user_logs(%{user_id: user.id, activity: "Logged Out"})
    end)

    conn
    |> put_flash(:info, "Successfully Logged Out .")
    |> UserAuthenticate.log_out_user()
  end


end
