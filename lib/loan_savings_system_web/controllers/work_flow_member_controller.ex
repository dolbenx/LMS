defmodule LoanSavingsSystemWeb.WorkFlowMemberController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystem.WorkFlows
  alias LoanSavingsSystem.WorkFlows.WorkFlowMember

  plug(
    LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
      when action not in [:new_password, :change_password]
    )

  def index(conn, _params) do
    tbl_workflow_members = WorkFlows.list_tbl_workflow_members()
    render(conn, "index.html", tbl_workflow_members: tbl_workflow_members)
  end

  def new(conn, _params) do
    changeset = WorkFlows.change_work_flow_member(%WorkFlowMember{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"work_flow_member" => work_flow_member_params}) do
    case WorkFlows.create_work_flow_member(work_flow_member_params) do
      {:ok, work_flow_member} ->
        conn
        |> put_flash(:info, "Work flow member created successfully.")
        |> redirect(to: Routes.work_flow_member_path(conn, :show, work_flow_member))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    work_flow_member = WorkFlows.get_work_flow_member!(id)
    render(conn, "show.html", work_flow_member: work_flow_member)
  end

  def edit(conn, %{"id" => id}) do
    work_flow_member = WorkFlows.get_work_flow_member!(id)
    changeset = WorkFlows.change_work_flow_member(work_flow_member)
    render(conn, "edit.html", work_flow_member: work_flow_member, changeset: changeset)
  end

  def update(conn, %{"id" => id, "work_flow_member" => work_flow_member_params}) do
    work_flow_member = WorkFlows.get_work_flow_member!(id)

    case WorkFlows.update_work_flow_member(work_flow_member, work_flow_member_params) do
      {:ok, work_flow_member} ->
        conn
        |> put_flash(:info, "Work flow member updated successfully.")
        |> redirect(to: Routes.work_flow_member_path(conn, :show, work_flow_member))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", work_flow_member: work_flow_member, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    work_flow_member = WorkFlows.get_work_flow_member!(id)
    {:ok, _work_flow_member} = WorkFlows.delete_work_flow_member(work_flow_member)

    conn
    |> put_flash(:info, "Work flow member deleted successfully.")
    |> redirect(to: Routes.work_flow_member_path(conn, :index))
  end
end
