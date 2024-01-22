defmodule SavingsWeb.Plugs.SessionTimeout do
  import Plug.Conn

  def init(opts \\ []) do
    Keyword.merge([timeout_after_seconds: 3000], opts)
  end

  def call(conn, opts) do
    timeout_at = get_session(conn, :session_timeout_at)

    if timeout_at && now() > timeout_at do
      logout_user(conn)
    else
      put_session(conn, :session_timeout_at, new_session_timeout_at(opts[:timeout_after_seconds]))
    end
  end

  defp logout_user(conn) do
    case conn.assigns.user do
      nil ->
        conn
        |> clear_session()
        |> configure_session(renew: true)
        |> assign(:session_timeout, true)

      user ->
        Cachex.del(:client, to_string(user.id))

        conn
        |> clear_session()
        |> configure_session(renew: true)
        |> assign(:session_timeout, true)
    end
  end

  def now do
    DateTime.utc_now() |> DateTime.to_unix()
  end

  defp new_session_timeout_at(timeout_after_seconds) do
    now() + timeout_after_seconds
  end
end
