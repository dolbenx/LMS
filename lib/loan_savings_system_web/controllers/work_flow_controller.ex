defmodule LoanSavingsSystemWeb.WorkFlowController do
    use LoanSavingsSystemWeb, :controller

    alias LoanSavingsSystem.WorkFlows
    alias LoanSavingsSystem.WorkFlows.WorkFlow
    alias LoanSavingsSystem.Accounts.UserRole
    alias LoanSavingsSystem.Accounts.User
    alias LoanSavingsSystem.Client.UserBioData
    alias LoanSavingsSystem.Companies.Branch

    plug(
      LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
        when action not in [:new_password, :change_password]
      )
    require Logger
    # alias LoanSavingsSystem.Accounts
    # alias MfzUssd.{Auth, Logs}

    alias LoanSavingsSystem.Repo
    require Record
    import Ecto.Query, only: [from: 2]

  def index(conn, _params) do
    query = from cl in LoanSavingsSystem.WorkFlows.WorkFlow,
            join: user in User,
            join: userBioData in UserBioData,
            join: branch in Branch,
            on:
            cl.createdByUserId == user.id and
            user.id == userBioData.userId and
            cl.branchId == branch.id,
        where: is_nil(cl.deletedAt),
        select: %{cl: cl, user: user, userBioData: userBioData, branch: branch}
    tbl_workflows = Repo.all(query);
    render(conn, "index.html", tbl_workflows: tbl_workflows)
  end

  def new(conn, _params) do
    current_user_role = get_session(conn, :current_user_role);
    query = from cl in LoanSavingsSystem.WorkFlows.WorkFlow,
        join: user in User,
        join: userBioData in UserBioData,
        join: branch in Branch,
        on:
        cl.createdByUserId == user.id and
        user.id == userBioData.userId and
        cl.branchId == branch.id,
    where: is_nil(cl.deletedAt),
    select: %{cl: cl, user: user, userBioData: userBioData, branch: branch}
    tbl_workflows = Repo.all(query);




    Logger.info ">>>>>#{Enum.count(tbl_workflows)}"
    changeset = WorkFlows.change_work_flow(%WorkFlow{})
    query = from cl in LoanSavingsSystem.Companies.Branch, select: cl
        branches = Repo.all(query);
    render(conn, "new.html", changeset: changeset, branches: branches, tbl_workflows: tbl_workflows)
  end

  def create(conn, params) do
        current_user = get_session(conn, :current_user);
        current_user_role = get_session(conn, :current_user_role);
        deletedAt = nil
        branchId = elem Integer.parse(params["branch"]), 0

        query = from cl in LoanSavingsSystem.WorkFlows.WorkFlow,
            where: cl.branchId == ^branchId,
            select: cl
        wflows = Repo.all(query);
        if (Enum.count(wflows)>0) do
            conn
            |> put_flash(:error, "Workflow could not be created successfully. There is already a work flow existing for the branch selected")
            |> redirect(to: Routes.work_flow_path(conn, :new))
        else
            new_param = %LoanSavingsSystem.WorkFlows.WorkFlow{name: params["name"], createdByUserId: current_user, createdByUserRoleId: current_user_role.id,
                branchId: branchId, status: "ACTIVE", deletedAt: deletedAt}
            case Repo.insert(new_param) do
                {:ok, new_param} ->
                    for x <- 0..(Enum.count(params["bankStaff"])-1) do
                        Logger.info ">>>>>>>>>>>>"
                        bankStaff_ = String.split(Enum.at(params["bankStaff"], x), "|||");
                        userId = Enum.at(bankStaff_, (0));
                        userId = elem Integer.parse(userId), 0
                        userRoleId = Enum.at(bankStaff_, (1));
                        userRoleId = elem Integer.parse(userRoleId), 0

                        workflow_member =
                        %LoanSavingsSystem.WorkFlows.WorkFlowMember{
                            branchId: branchId,
                            orderPosition: (x+1),
                            userId:  userId,
                            userRoleId: userRoleId,
                            workFlowId: new_param.id
                        }
                        Repo.insert(workflow_member)
                    end

                    conn
                    |> put_flash(:info, "Workflow created successfully")
                    |> redirect(to: Routes.work_flow_path(conn, :new))
                {:error, changeset} ->
                    conn
                    |> put_flash(:error, "Workflow could not be created successfully")
                    |> redirect(to: Routes.work_flow_path(conn, :new))
            end
        end
  end

  def show(conn, %{"id" => id}) do
    work_flow = WorkFlows.get_work_flow!(id)
    render(conn, "show.html", work_flow: work_flow)
  end

  def edit(conn, %{"id" => id}) do
    work_flow = WorkFlows.get_work_flow!(id)
    changeset = WorkFlows.change_work_flow(work_flow)
    render(conn, "edit.html", work_flow: work_flow, changeset: changeset)
  end

  def update(conn, %{"id" => id, "work_flow" => work_flow_params}) do
    work_flow = WorkFlows.get_work_flow!(id)

    case WorkFlows.update_work_flow(work_flow, work_flow_params) do
      {:ok, work_flow} ->
        conn
        |> put_flash(:info, "Work flow updated successfully.")
        |> redirect(to: Routes.work_flow_path(conn, :show, work_flow))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", work_flow: work_flow, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    work_flow = WorkFlows.get_work_flow!(id)
    {:ok, _work_flow} = WorkFlows.delete_work_flow(work_flow)

    conn
    |> put_flash(:info, "Work flow deleted successfully.")
    |> redirect(to: Routes.work_flow_path(conn, :index))
  end




end
