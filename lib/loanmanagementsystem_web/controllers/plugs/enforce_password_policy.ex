defmodule LoanmanagementsystemWeb.Plugs.EnforcePasswordPolicy do
  @behaviour Plug
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]



  def init(_params) do
  end

  def call(%{assigns: assigns} = conn, _params) do
    case Map.has_key?(assigns, :user) do
      false -> conn
      true ->
        user = assigns.user

        with true <- not is_nil(user) && user.auto_password == true do
          conn
          |> put_flash(:error, "Password reset is required!")
          |> redirect(to: LoanmanagementsystemWeb.Router.Helpers.session_reset_path(conn, :index))
          |> halt()
        else
          _ -> conn
        end

    end
  end
end
