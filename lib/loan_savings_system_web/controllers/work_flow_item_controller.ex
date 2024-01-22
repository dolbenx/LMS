defmodule LoanSavingsSystemWeb.WorkFlowItemController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystem.Repo
  alias LoanSavingsSystem.Logs.UserLogs
  alias LoanSavingsSystem.Accounts
  alias LoanSavingsSystem.Accounts.User
  alias LoanSavingsSystem.Accounts.Account
  alias LoanSavingsSystem.Customers
 # alias LoanSavingsSystem.Savings
  alias LoanSavingsSystem.Transactions
  alias LoanSavingsSystem.FixedDeposit
  alias LoanSavingsSystem.Charges
  alias LoanSavingsSystem.Products.Product
  alias LoanSavingsSystem.Accounts.UserRole
  alias LoanSavingsSystem.Accounts.User
  alias LoanSavingsSystem.Client.UserBioData
  alias LoanSavingsSystem.Confirmation_Notification.Confirmation_Loan_Notification
  alias LoanSavingsSystem.Companies.Company
  alias LoanSavingsSystem.Companies.Branch
  alias LoanSavingsSystem.WorkFlows
  alias LoanSavingsSystem.WorkFlows.WorkFlow
  alias LoanSavingsSystem.WorkFlows.WorkFlowMember
  alias LoanSavingsSystem.WorkFlows.WorkFlowItem
  alias LoanSavingsSystem.Loan.Loans



  require Logger
    # alias LoanSavingsSystem.Accounts
    # alias MfzUssd.{Auth, Logs}

    alias LoanSavingsSystem.Repo
    require Record
    import Ecto.Query, only: [from: 2]

    plug(
    LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
      when action not in [:new_password, :change_password]
    )

  def index(conn, _params) do
    current_user = get_session(conn, :current_user);
    current_user_role = get_session(conn, :current_user_role);
    entityType = "LOANS";
    query = from cl in LoanSavingsSystem.WorkFlows.WorkFlowItem,
        join: user in User,
        join: userBioData in UserBioData,
        join: branch in Branch,
        join: loan in Loans,
        join: userRec in User,
        join: userBioDataRec in UserBioData,
        on:
        cl.createdByUserId == user.id and
        user.id == userBioData.userId and
        cl.workflowItemRecipientUserId == userRec.id and
        userRec.id == userBioDataRec.userId and
        branch.id == cl.branchId and
        loan.id == cl.entityId,
    where: ((cl.createdByUserId == ^current_user) or (cl.workflowItemRecipientUserId == ^current_user)) and (cl.entityType == ^entityType),
    select: %{cl: cl, user: user, branch: branch, userBioData: userBioData, loan: loan, userRec: userRec, userBioDataRec: userBioDataRec}
    tbl_workflow_items = Repo.all(query);
    render(conn, "index.html", tbl_workflow_items: tbl_workflow_items)
  end

  def new(conn, _params) do
    changeset = WorkFlows.change_work_flow_item(%WorkFlowItem{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"work_flow_item" => work_flow_item_params}) do
    case WorkFlows.create_work_flow_item(work_flow_item_params) do
      {:ok, work_flow_item} ->
        conn
        |> put_flash(:info, "Work flow item created successfully.")
        |> redirect(to: Routes.work_flow_item_path(conn, :show, work_flow_item))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    work_flow_item = WorkFlows.get_work_flow_item!(id)
    render(conn, "show.html", work_flow_item: work_flow_item)
  end

  def edit(conn, %{"id" => id}) do
    work_flow_item = WorkFlows.get_work_flow_item!(id)
    changeset = WorkFlows.change_work_flow_item(work_flow_item)
    render(conn, "edit.html", work_flow_item: work_flow_item, changeset: changeset)
  end

  def update(conn, %{"id" => id, "work_flow_item" => work_flow_item_params}) do
    work_flow_item = WorkFlows.get_work_flow_item!(id)

    case WorkFlows.update_work_flow_item(work_flow_item, work_flow_item_params) do
      {:ok, work_flow_item} ->
        conn
        |> put_flash(:info, "Work flow item updated successfully.")
        |> redirect(to: Routes.work_flow_item_path(conn, :show, work_flow_item))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", work_flow_item: work_flow_item, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    work_flow_item = WorkFlows.get_work_flow_item!(id)
    {:ok, _work_flow_item} = WorkFlows.delete_work_flow_item(work_flow_item)

    conn
    |> put_flash(:info, "Work flow item deleted successfully.")
    |> redirect(to: Routes.work_flow_item_path(conn, :index))
  end
end
