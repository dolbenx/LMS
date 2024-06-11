defmodule LoanmanagementsystemWeb.UserLiveAuth do
  @moduledoc false
  import Phoenix.LiveView

  alias Loanmanagementsystem.Accounts
  alias LoanmanagementsystemWeb.Router.Helpers, as: Routes

  def mount(_params, %{"user_token" => user_token} = session, socket) do
    data = String.replace(to_string(socket.view), ".", ",")
    |> String.split(",")
    |> Enum.at(2)
    |> String.upcase()


    socket1 = assign(socket, :browser_id, session["uuid_browser"])
    socket =
      case user_token && Accounts.get_user_by_session_token(user_token, data) do
        nil -> socket1
        {nil, _} -> socket1
        {user, role} ->
          assign(socket1, :current_user, user)
          |> assign(:user, user)
          |> assign(:permits, Poison.decode!(role.permissions))
        user -> set_client_user(user, socket, "")
      end

    {:cont, socket}
  end

  def on_mount(:default, _params, %{"user_token" => user_token} = session, socket) do

    IO.inspect "socket --------------------------------"
    IO.inspect user_token
    IO.inspect socket

    data = String.replace(to_string(socket.view), ".", ",")
    |> String.split(",")
    |> Enum.at(2)
    |> String.upcase()
    socket =
      fetch_current_user(data, user_token, socket)
      |> assign(:browser_id, session["uuid_browser"])


    if user = socket.assigns[:current_user] do
      if user.status == "ACTIVE" do
        {:cont,
         assign(socket, :live_socket_identifier, session["live_socket_id"])
         |> assign(:live_layout_render, :user_session)
         |> assign(remote_ip: session["remote_ip"])
         |> assign(browser_info: session["browser_info"])
         |> assign(user_agent: session["user_agent"])
         |> assign(:nav_type, "CLIENT")
        }
      else
        {:halt, redirect(socket, to: Routes.session_index_path(socket, redirect_to()))}
      end
    else
      {:halt, redirect(socket, to: Routes.session_index_path(socket, redirect_to()))}
    end
  end

  def fetch_current_user(type, user_token, socket) do
    case user_token && Accounts.get_user_by_session_token(user_token, type) do
      nil -> socket
      {nil, _} -> socket

      {user, role} ->
        token = Phoenix.Token.sign(%Phoenix.Socket{endpoint: socket.endpoint}, "user socket", user.id)
        assign(socket, :current_user, user)
        |> assign(:user, user)
        |> assign(:user_token, token)
        # |> assign(:permits, role.permissions)

      user ->
        token =
          Phoenix.Token.sign(%Phoenix.Socket{endpoint: socket.endpoint}, "user socket", user.id)
          set_client_user(user, socket, token)
    end
  end

  def redirect_to(), do: :index


  def set_client_user(user, socket1, token) do
    user = Map.from_struct(user) |> Map.drop([:role, :user, :maker, :__meta__, :checker])

    assign(socket1, :current_user, user)
    |> assign(:user, user)
    |> assign(:user_token, token)
    |> assign(:announcements, [])
  end
end
