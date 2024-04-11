defmodule LoanmanagementsystemWeb.Plugs.SessionConn do
  @moduledoc false
  import Plug.Conn
  alias Loanmanagementsystem.Logs

  def put_client_ip(conn, _),
    do: put_session(conn, :remote_ip, Logs.ip_address(conn))
    |> put_session(:user_agent, Logs.device_uuid(conn))
    |> put_session(:browser_info, %{
      "full_browser_name" => Browser.full_browser_name(conn),
      "browser_details" => Browser.full_display(conn),
      "system_platform_name" => Browser.full_platform_name(conn),
      "device_type" => Browser.device_type(conn),
      "known_browser" => Browser.known?(conn)
    })

  def put_browser_id(conn, _) do
    put_session(conn, :uuid_browser, conn.cookies["uuid_browser"])
  end
end
