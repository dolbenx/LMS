defmodule LoanmanagementsystemWeb.WebsiteController do
  use LoanmanagementsystemWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def about(conn, _params) do
    render(conn, "about.html")
  end

  def services(conn, _params) do
    render(conn, "services.html")
  end

  def contact_us(conn, _params) do
    render(conn, "contact_us.html")
  end

  def team(conn, _params) do
    render(conn, "team.html")
  end

  def portfolio(conn, _params) do
    render(conn, "portfolio.html")
  end

  def how_it_works(conn, _params) do
    render(conn, "how_it_works.html")
  end

  def testimonial(conn, _params) do
    render(conn, "testimonial.html")
  end

  def faq(conn, _params) do
    render(conn, "faq.html")
  end
end
