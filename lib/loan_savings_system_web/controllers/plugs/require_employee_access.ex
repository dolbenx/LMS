defmodule LoanSavingsSystemWeb.Plugs.RequireEmployeeAccess do
  @behaviour Plug
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  alias LoanSavingsSystem.Accounts.UserRole
  alias LoanSavingsSystem.Accounts

  alias LoanSavingsSystem.Repo
    require Record
    import Ecto.Query, only: [from: 2]


  def init(_params) do
  end

  def call(conn, _params) do
    # user_id = get_session(conn, :current_user) || get_session(conn, :current_client)
    # user = user_id && Accounts.get_user!(user_id)

    # query = from uR in UserRole, where: uR.userId == ^user_id, select: uR
    #   userRole = Repo.all(query)

    # currentUserRole = Enum.at(userRole, 0)

    currentUserRole = get_session(conn, :current_user_role)
    IO.inspect currentUserRole
    with true <- is_nil(currentUserRole) || (!is_nil(currentUserRole) && currentUserRole.roleType != "EMPLOYEE") do
      conn
      |> put_flash(:error, "You need to be logged in as an #{currentUserRole.roleType}")
      |> redirect(to: LoanSavingsSystemWeb.Router.Helpers.session_path(conn, :username))
      |> halt()
    else
      _ -> conn
    end
  end
end
