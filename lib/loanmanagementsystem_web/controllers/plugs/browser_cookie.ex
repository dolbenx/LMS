defmodule LoanmanagementsystemWeb.Plugs.BrowserCookie do
  @behaviour Plug
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    if conn.cookies["_browser_id"] do
      conn
    else
      put_resp_cookie(conn, "_browser_id", "#{:os.system_time()}", sign: true)
    end
  end
end
