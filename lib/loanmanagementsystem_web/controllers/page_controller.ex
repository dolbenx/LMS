defmodule LoanmanagementsystemWeb.PageController do
  use LoanmanagementsystemWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def self_register_index(conn, _params) do
    render(conn, "self_register_index.html")
  end
end
