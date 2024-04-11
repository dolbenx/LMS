defmodule LoanmanagementsystemWeb.Plugs.UserAuthenticate do
  import Plug.Conn
  import Phoenix.Controller

  alias Loanmanagementsystem.Accounts
  alias Loanmanagementsystem.Logs
  alias Loanmanagementsystem.Repo
  require Record
  import Ecto.Query, only: [from: 2]

  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_Loan_management_system_web_user_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]



  def log_in_user(conn, user, params \\ %{}) do
    token = Accounts.generate_user_session_token(user)
    token_user = Phoenix.Token.sign(conn, "user socket", user.id)
    redirect_to = get_session(conn, :user_return_to)
    session_id = "users_sessions:#{Base.url_encode64(token)}"

    Task.start(fn ->
      Accounts.update_user(user, %{failed_attempts: 0})
      Logs.session_logs(
        conn,
        session_id,
        "WEB Session",
        "Successfully logged in",
        user.id,
        true
      )
    end)

    query = from(uB in Loanmanagementsystem.Accounts.UserBioData, where: uB.user_id == ^user.id, select: uB)
    userBioData = Repo.all(query)
    currentUserBioData = Enum.at(userBioData, 0)

    query = from(uB in Loanmanagementsystem.Accounts.UserRole, where: uB.user_id == ^user.id, select: uB)
    userRoles = Repo.all(query)
    currentUserRole = Enum.at(userRoles, 0)

    conn
    |> renew_session()
    |> assign(:user_token, token)
    |> put_session(:user_token, token)
    |> put_session(:token_user, token_user)
    |> put_session(:current_bio_data, currentUserBioData)
    |> put_session(:current_user_role, currentUserRole)
    |> put_session(:live_socket_id, session_id)
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: redirect_to || signed_in_path("ADMIN"))
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end


  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Logs the user out.

  It clears all session data for safety. See renew_session.
  """
  def log_out_user(conn) do
    user_token = get_session(conn, :user_token)
    user_token && Accounts.delete_session_token(user_token)

    if live_socket_id = get_session(conn, :live_socket_id) do
      LoanmanagementsystemWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: new_session())
  end

  @doc """
  Authenticates the user by looking into the session
  and remember me token.
  """

  def fetch_current_user(conn, _opts) do
    {user_token, conn} = ensure_user_token(conn)

    type = if(conn.request_path == "/Admin", do: "ADMIN", else: "OTHER")

    case user_token && Accounts.get_user_by_session_token(user_token, type) do
      nil -> conn
      {nil, _} -> conn

      {user, role} ->
        assign(conn, :current_user, user)
        |> assign(:user, user)
        |> assign(:permissions, Poison.decode!(role.permissions))

      user -> assign(conn, :current_user, user)|> assign(:user, user)
    end
  end

  defp ensure_user_token(conn) do
    if user_token = get_session(conn, :user_token) do
      {user_token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if user_token = conn.cookies[@remember_me_cookie] do
        {user_token, put_session(conn, :user_token, user_token)}
      else
        {nil, conn}
      end
    end
  end

  @doc """
  Used for routes that require the user to not be authenticated.
  """
  def redirect_if_user_is_authenticated(conn, _opts) do
    if conn.assigns[:user] do
      conn
      |> redirect(to: signed_in_path("ADMIN"))
      |> halt()
    else
      conn
    end
  end


  def require_authenticated_user(conn, _opts) do
    IO.inspect "============= here ==========="
    user = conn.assigns[:current_user]
    cond do
      user == nil ->
        conn
        |> put_flash(:error, "You must log in to access this page.")
        |> maybe_store_return_to()
        |> redirect(to: new_session())
        |> halt()

      user.status != "ACTIVE" ->
        kill_session(conn, "Insufficient user privileges")
      true ->
        conn
    end
  end




  defp kill_session(conn, message) do
    user_token = get_session(conn, :user_token)
    user_token && Accounts.delete_session_token(user_token)

    if live_socket_id = get_session(conn, :live_socket_id) do
      LoanmanagementsystemWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> put_flash(:error, message)
    |> maybe_store_return_to()
    |> redirect(to: new_session())
    |> halt()
  end

  def drop_session_on_log_in(conn) do
    renew_session(conn)
    |> delete_resp_cookie(@remember_me_cookie)
  end

  def maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :user_return_to, current_path(conn))
  end

  def maybe_store_return_to(conn), do: conn

  def put_user_type(conn, _),
    do: Plug.Conn.put_session(conn, :user_type, conn.assigns.current_user.user_type)


  def get_tkn(conn) do
    get_session(conn, :token_user)
  end

  def signed_in_path("ADMIN"), do: "/Admin/Dashboard"
  def signed_in_path(_), do: "/Client"
  defp new_session(), do: "/"

end
