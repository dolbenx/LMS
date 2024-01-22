defmodule LoanSavingsSystemWeb.FcubeReqResController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystem.EndOfDay
  alias LoanSavingsSystem.EndOfDay.FcubeReqRes

  plug(
    LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
      when action not in [:new_password, :change_password]
    )

  def index(conn, _params) do
    fcube_request_responses = EndOfDay.list_fcube_request_responses()
    render(conn, "index.html", fcube_request_responses: fcube_request_responses)
  end

  def new(conn, _params) do
    changeset = EndOfDay.change_fcube_req_res(%FcubeReqRes{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"fcube_req_res" => fcube_req_res_params}) do
    case EndOfDay.create_fcube_req_res(fcube_req_res_params) do
      {:ok, fcube_req_res} ->
        conn
        |> put_flash(:info, "Fcube req res created successfully.")
        |> redirect(to: Routes.fcube_req_res_path(conn, :show, fcube_req_res))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    fcube_req_res = EndOfDay.get_fcube_req_res!(id)
    render(conn, "show.html", fcube_req_res: fcube_req_res)
  end

  def edit(conn, %{"id" => id}) do
    fcube_req_res = EndOfDay.get_fcube_req_res!(id)
    changeset = EndOfDay.change_fcube_req_res(fcube_req_res)
    render(conn, "edit.html", fcube_req_res: fcube_req_res, changeset: changeset)
  end

  def update(conn, %{"id" => id, "fcube_req_res" => fcube_req_res_params}) do
    fcube_req_res = EndOfDay.get_fcube_req_res!(id)

    case EndOfDay.update_fcube_req_res(fcube_req_res, fcube_req_res_params) do
      {:ok, fcube_req_res} ->
        conn
        |> put_flash(:info, "Fcube req res updated successfully.")
        |> redirect(to: Routes.fcube_req_res_path(conn, :show, fcube_req_res))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", fcube_req_res: fcube_req_res, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    fcube_req_res = EndOfDay.get_fcube_req_res!(id)
    {:ok, _fcube_req_res} = EndOfDay.delete_fcube_req_res(fcube_req_res)

    conn
    |> put_flash(:info, "Fcube req res deleted successfully.")
    |> redirect(to: Routes.fcube_req_res_path(conn, :index))
  end
end
