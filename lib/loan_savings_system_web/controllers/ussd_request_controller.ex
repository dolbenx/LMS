defmodule LoanSavingsSystemWeb.UssdRequestController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystem.Ussd
  alias LoanSavingsSystem.Ussd.UssdRequest

  plug(
    LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
      when action not in [:new_password, :change_password]
    )

  def index(conn, _params) do
    ussd_requests = Ussd.list_ussd_requests()
    render(conn, "index.html", ussd_requests: ussd_requests)
  end

  def new(conn, _params) do
    changeset = Ussd.change_ussd_request(%UssdRequest{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"ussd_request" => ussd_request_params}) do
    case Ussd.create_ussd_request(ussd_request_params) do
      {:ok, ussd_request} ->
        conn
        |> put_flash(:info, "Ussd request created successfully.")
        |> redirect(to: Routes.ussd_request_path(conn, :show, ussd_request))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    ussd_request = Ussd.get_ussd_request!(id)
    render(conn, "show.html", ussd_request: ussd_request)
  end

  def edit(conn, %{"id" => id}) do
    ussd_request = Ussd.get_ussd_request!(id)
    changeset = Ussd.change_ussd_request(ussd_request)
    render(conn, "edit.html", ussd_request: ussd_request, changeset: changeset)
  end

  def update(conn, %{"id" => id, "ussd_request" => ussd_request_params}) do
    ussd_request = Ussd.get_ussd_request!(id)

    case Ussd.update_ussd_request(ussd_request, ussd_request_params) do
      {:ok, ussd_request} ->
        conn
        |> put_flash(:info, "Ussd request updated successfully.")
        |> redirect(to: Routes.ussd_request_path(conn, :show, ussd_request))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", ussd_request: ussd_request, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    ussd_request = Ussd.get_ussd_request!(id)
    {:ok, _ussd_request} = Ussd.delete_ussd_request(ussd_request)

    conn
    |> put_flash(:info, "Ussd request deleted successfully.")
    |> redirect(to: Routes.ussd_request_path(conn, :index))
  end
end
