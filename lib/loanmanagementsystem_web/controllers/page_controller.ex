defmodule LoanmanagementsystemWeb.PageController do
  use LoanmanagementsystemWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
