defmodule LoanmanagementsystemWeb.Plugs.SetUser do
  @behaviour Plug
  import Plug.Conn
  use PipeTo.Override

  alias Loanmanagementsystem.Accounts

  def init(_params) do
  end

  # def call(conn, _params) do
  #   user_id = get_session(conn, :current_user)

  #   cond do
  #     user = user_id && Accounts.get_user!(user_id) ->
  #       user =
  #         case Accounts.get_role!(user.role_id) do
  #           %{status: "INACTIVE", role_desc: role_desc} = _role ->
  #             Map.put(user, :role, %{})
  #             |> Map.put(:role_desc, role_desc)

  #           %{role_str: role_str, role_desc: role_desc} ->
  #             role_str
  #             |> AtomicMap.convert(%{safe: false})
  #             |> Map.put(user, :role, _)
  #             |> Map.put(:role_desc, role_desc)
  #         end

  #       assign(
  #         conn,
  #         :user,
  #         user
  #       )


  #     true ->
  #       assign(conn, :user, nil)
  #   end
  # end


  def call(conn, _params) do
    user_id = get_session(conn, :current_user)

    cond do
      user = user_id && Accounts.get_user!(user_id) ->
        case is_nil(user.role_id) do
          true ->  assign(conn, :user, user)
          false ->
            users = case  Loanmanagementsystem.Accounts.get_role!(user.role_id) do
              %{status: "INACTIVE", role_desc: role_desc} = _role ->
                Map.put(user, :role, %{})
                |> Map.put(:role_desc, role_desc)
              %{role_str: role_str, role_desc: role_desc} ->
                  role_str
                  |> AtomicMap.convert(%{safe: false})
                  |> Map.put(user, :role, _)
                  |> Map.put(:role_desc, role_desc)
            end
          assign(conn,:user,users)
        end
      true ->
        assign(conn, :user, :user_role)
    end
  end
end
