defmodule LoanmanagementsystemWeb.Api.ApiLoginContoller do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false

  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Accounts
  # alias Loanmanagementsystem.Accounts.User
  alias LoanmanagementsystemWeb.UserController
  alias Loanmanagementsystem.Auth
  alias LoanmanagementsystemWeb.Api.Crypto



  def api_login(conn, params) do
    with {:error, _reason} <- UserController.get_user_by_email(String.trim(params["username"])) do
      conn
      |> put_status(:bad_request)
      |> json(%{data: [], status: false, message: "Email Address does not match"})
    else
      {:ok, user} ->
        with {:error, _reason} <- Auth.confirm_password(user, String.trim(params["password"])) do
          prepare_login_attempt(user)

          conn
          |> put_status(:bad_request)
          |> json(%{data: [], status: false, message: "Password does not match"})
        else
          {:ok, _} ->
            #IO.inspect(user, label: "check my user here \n\n\n")

            cond do
              user.status == "ACTIVE" ->
                {:ok, _} =
                  Loanmanagementsystem.Logs.create_user_logs(%{
                    user_id: user.id,
                    activity: "logged in"
                  })

                logon_dt = Timex.format!(Timex.local(), "%Y-%m-%d %H:%M:%S", :strftime)
                remote_ip = conn.remote_ip |> :inet.ntoa() |> to_string()

                IO.inspect(remote_ip, label: "------------IP-------------")

                {:ok, user} = Accounts.update_user(user, %{remote_ip: remote_ip, last_login_dt: logon_dt, login_attempt: 0})

                user_id = user.id

                IO.inspect(user_id, label: "-------------USER ID-------------")

                query = from(uB in Loanmanagementsystem.Accounts.UserBioData,
                    where: uB.userId == ^user.id,
                    select: uB
                  )

                userBioData = Repo.all(query)
                currentUserBioData = Enum.at(userBioData, 0)

                IO.inspect(currentUserBioData, label: "Am here CHief")

                IO.inspect(conn, label: "Am here CHief")


                query = from(uB in Loanmanagementsystem.Accounts.UserRole,
                      where: uB.userId == ^user_id,
                      select: uB
                    )

                userRoles = Repo.all(query)

                currentUserRole = Enum.at(userRoles, 0)

                # query =
                #   from(uR in Loanmanagementsystem.Accounts.Role,
                #     where: uR.id == ^user_id,
                #     select: uR
                #   )

                # myUserRole = Repo.all(query)

                # mycurrentUserRole = Enum.at(myUserRole, 0)
                IO.inspect(currentUserRole, label: "??????? Dry Wave ??????")

                IO.inspect(user, label: "??????? Dry Wave ??????")

                case currentUserRole.roleType do

                  "ADMIN" ->

                    token = Crypto.encrypt(:auth, %{user: user})

                    user_details =
                      %{user: user}
                      # |> Map.delete(:status)
                      |> Map.put(:token, token)

                    respond(conn, %{status: true, data: %{user_details: user_details, user_bio_details: currentUserBioData}, message: "Logged in"})


                  "Loan Officer" ->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> redirect(to: Routes.user_path(conn, :admin_dashboard))

                  "Senior Loan Officer" ->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> redirect(to: Routes.user_path(conn, :admin_dashboard))

                    "Finance Officer" ->
                      conn
                      |> put_session(:current_user, user.id)
                      |> put_session(:current_user_bio_data, currentUserBioData)
                      |> put_session(:current_user_role, currentUserRole)
                      # |> put_session(:current_user_data, user)
                      |> put_session(:session_timeout_at, session_timeout_at())
                      |> redirect(to: Routes.user_path(conn, :admin_dashboard))

                  "INDIVIDUALS" ->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> redirect(to: Routes.user_path(conn, :individual_dashboard))

                  "EMPLOYEE" ->

                    token = Crypto.encrypt(:auth, %{user: user})

                    user_details =
                      %{user: user}
                      # |> Map.delete(:status)
                      |> Map.put(:token, token)
                      respond(conn, %{status: true, data: user_details, message: "Logged in"})


                  "EMPLOYER" ->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> redirect(to: Routes.user_path(conn, :employer_dashboard))

                  "SME" ->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> redirect(to: Routes.user_path(conn, :sme_dashboard))


                  "FUNDER" ->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> redirect(to: Routes.funder_path(conn, :funder_dashboard))

                  "OFFTAKER"->
                    conn
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> redirect(to: Routes.user_path(conn, :offtaker_dashboard))

                    "MERCHANT"->
                      conn
                      |> put_session(:current_user, user.id)
                      |> put_session(:current_user_bio_data, currentUserBioData)
                      |> put_session(:current_user_role, currentUserRole)
                      # |> put_session(:current_user_data, user)
                      |> put_session(:session_timeout_at, session_timeout_at())
                      |> redirect(to: Routes.user_path(conn, :merchant_dashboard))

                  _->
                    conn
                    |> put_flash(:error, "User Role Not Found")
                    |> put_session(:current_user, user.id)
                    |> put_session(:current_user_bio_data, currentUserBioData)
                    |> put_session(:current_user_role, currentUserRole)
                    # |> put_session(:current_user_data, user)
                    |> put_session(:session_timeout_at, session_timeout_at())
                    |> render("index.html")

                end

              user.status == "INACTIVE" ->
                conn
                # |> put_status(405)
                # |> put_layout(false)
                # |> render("username.html")
                # |> put_flash(:error, "Your account has been blocked!")
                |> put_layout(false)
                |> render("disabled_account.html")

              true ->
                conn
                |> put_status(405)
                |> put_layout(false)
                |> render("username.html")
            end
        end
    end
  end

  defp prepare_login_attempt(user) do
    max_attempts = 3
    status = if user.login_attempt < max_attempts, do: "ACTIVE", else: "INACTIVE"
    Accounts.update_user(user, %{login_attempt: user.login_attempt + 1, status: status})
  end

  defp session_timeout_at do
    DateTime.utc_now() |> DateTime.to_unix() |> (&(&1 + 10_000)).()
  end

  def respond(conn, result) do
    conn
    |> json(%{status: result.status, data: result.data, message: result.message})
  end
end
