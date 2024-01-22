defmodule SavingsWeb.Plugs.SetUser do
  @behaviour Plug
  import Plug.Conn
  use PipeTo.Override

  alias Savings.Accounts

  def init(_params) do
  end

  def call(conn, _params) do
    user_id = get_session(conn, :current_user)

    cond do
      user = user_id && Accounts.get_user!(user_id) ->
        user =
          case Accounts.get_role!(user.role_id) do
            %{status: "INACTIVE", role_desc: role_desc} = _role ->
              Map.put(user, :role, %{})
              |> Map.put(:role_desc, role_desc)

            %{role_str: role_str, role_desc: role_desc} ->
              role_str
              |> AtomicMap.convert(%{safe: false})
              |> Map.put(user, :role, _)
              |> Map.put(:role_desc, role_desc)
          end

        IO.inspect(user, label: "check my user here")

        assign(
          conn,
          :user,
          user
        )

      true ->
        assign(conn, :user, nil)
    end
  end
end
