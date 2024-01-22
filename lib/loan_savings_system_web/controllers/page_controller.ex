defmodule LoanSavingsSystemWeb.PageController do
  use LoanSavingsSystemWeb, :controller

  plug(
    LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
      when action not in [:new_password, :change_password]
    )

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
