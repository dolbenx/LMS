defmodule LoanmanagementsystemWeb.Plugs.Authenticate do
  @behaviour Plug
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  alias Loanmanagementsystem.Accounts

  def init(params), do: params

  def call(conn, opts) do
    user_id = get_session(conn, :current_user)
    user = user_id && Accounts.get_user!(user_id)
    callback = opts[:module_callback]
    role = user_role(user.role_id)
    # IO.inspect(role, label: "role role role role role")
    {module, action} = callback.(conn)

    cond do
      # user.status == "ACTIVE" ->
      get_in(role, [module, action]) == "Y" and user.status == "ACTIVE" ->
        conn

      true ->
        conn
        |> put_flash(:error, "Access denied!!!")
        |> redirect(to: LoanmanagementsystemWeb.Router.Helpers.session_path(conn, :username))
        |> halt()
    end
  end

  # LoanmanagementsystemWeb.Plugs.Authenticate.user_role(12)

  def user_role(role_id) do
    Accounts.get_role!(role_id)
    |> Map.get(:role_str)
    |> AtomicMap.convert(%{safe: false})
  end
end
