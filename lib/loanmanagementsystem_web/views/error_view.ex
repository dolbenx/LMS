defmodule LoanmanagementsystemWeb.ErrorView do
  use LoanmanagementsystemWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  def render("500.html", _assigns) do
    render("internal_server_error.html", %{})
  end

  def render("413.html", _assigns) do
    render("bad_request.html", %{})
  end

  def render("404.html", _assigns) do
    render("page_not_found.html", %{})
  end

  def render("400.html", _assigns) do
    render("bad_request.html", %{})
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
