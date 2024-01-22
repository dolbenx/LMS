defmodule LoanSavingsSystemWeb.CustomerController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystem.Repo
  alias LoanSavingsSystem.Logs.UserLogs
  alias LoanSavingsSystem.Accounts.User
  alias LoanSavingsSystem.Accounts
  alias LoanSavingsSystem.Client
  alias LoanSavingsSystem.Companies
  alias LoanSavingsSystem.Products
  alias LoanSavingsSystem.Accounts
  alias LoanSavingsSystem.Companies.Company
  alias LoanSavingsSystem.Companies.Employee
  alias LoanSavingsSystem.Client.UserBioData
  alias LoanSavingsSystem.Accounts.UserRole
  alias LoanSavingsSystem.UserBioDataUpdate
  alias LoanSavingsSystem.UserBioDataUpdate.UserBioDataUpdates
  alias LoanSavingsSystem.Client.Address
  alias LoanSavingsSystem.SystemSetting
  alias LoanSavingsSystem.Client.NextOfKin
  alias LoanSavingsSystem.Notifications.Sms
  alias LoanSavingsSystem.Emails.Email
  alias LoanSavingsSystem.SystemDirectories

  require Record
    require Logger
    import Ecto.Query, warn: false

    @headers ~w/ firstName lastName otherName mobileNumber dateOfBirth meansOfIdentificationType meansOfIdentificationNumber netPay/a

    plug(
    LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
      when action not in [:new_password, :change_password]
    )

  def all_customer(conn, _params) do
    customers = Accounts.get_customer_details()
    render(conn, "all_customer.html", customers: customers)
  end


  def all_savings_customer(conn, _params) do
    customers = Accounts.get_savings_customer_details()
    render(conn, "all_customer.html", customers: customers)
  end


  def customer_disable_ussd(conn, %{"userId" => userId}) do
    query = from cl in LoanSavingsSystem.Accounts.User, where: (cl.id== ^userId), select: cl
    appuser = Repo.one(query)

    us = User.changesetforupdate(appuser, %{ussdActive: 0 })
    Repo.update(us)


    conn
        |> put_flash(:info, "Customer USSD Disabled")
        |> redirect(to: Routes.customer_path(conn, :all_savings_customer))
  end

  def customer_disable_login(conn, %{"userId" => userId}) do
    query = from cl in LoanSavingsSystem.Accounts.User, where: (cl.id== ^userId), select: cl
    appuser = Repo.one(query)

    us = User.changesetforupdate(appuser, %{status: "DISABLED" })
    Repo.update(us)


    conn
        |> put_flash(:info, "Customer Login Disabled")
        |> redirect(to: Routes.customer_path(conn, :all_savings_customer))
  end

  def customer_enable_ussd(conn, %{"userId" => userId}) do
    query = from cl in LoanSavingsSystem.Accounts.User, where: (cl.id== ^userId), select: cl
    appuser = Repo.one(query)

    us = User.changesetforupdate(appuser, %{ussdActive: 1 })
    Repo.update(us)


    conn
        |> put_flash(:info, "Customer USSD Activated successfully")
        |> redirect(to: Routes.customer_path(conn, :all_savings_customer))
  end

  def customer_enable_login(conn, %{"userId" => userId}) do
    query = from cl in LoanSavingsSystem.Accounts.User, where: (cl.id== ^userId), select: cl
    appuser = Repo.one(query)

    us = User.changesetforupdate(appuser, %{status: "ACTIVE" })
    Repo.update(us)


    conn
        |> put_flash(:info, "Customer Login has been activated")
        |> redirect(to: Routes.customer_path(conn, :all_savings_customer))
  end



  def all_loan_customer(conn, _params) do
    loan_customers = Accounts.get_loan_customer_details()
    render(conn, "all_loan_customer.html", loan_customers: loan_customers)
  end

  def customer_details(conn, %{"userId" => userId}) do
    fixed_deposits = Accounts.get_fixed_deposits(userId)
    customers = Accounts.customer_details(userId)
    customer_d = Client.customer_data(userId)
    render(conn, "customer_details.html", customers: customers, fixed_deposits: fixed_deposits, customer_d: customer_d)
  end

  def loan_customer_details(conn, %{"userId" => userId}) do
    loan_customers = Accounts.get_loan_customers(userId)
    customers = Accounts.customer_details(userId)
    customer_d = Client.customer_data(userId)
    render(conn, "loan_customer_details.html", customers: customers, loan_customers: loan_customers, customer_d: customer_d)
  end

  def employer(conn, _params) do
    loan_products = Products.list_tbl_products()
    employers = Companies.list_tbl_company()
    render(conn, "employer.html", employers: employers, loan_products: loan_products)
  end



  def employer_admin(conn, %{"company_id" => company_id}) do
    current_user_role = get_session(conn, :current_user_role);
    current_user = get_session(conn, :current_user);
    query = from au in Company,
        where: (au.registrationNumber == ^company_id),
        select: au

    companies = Repo.all(query)
    company = Enum.at(companies, 0)
    #client_users = Accounts.get_client_users(company_id)

    roleType = "COMPANY ADMIN"

    clStatus = "ACTIVE";
    query = from cl in UserRole,
            join: user in User,
            join: userBioData in UserBioData,
            join: company in Company,
            on:
            cl.companyId == company.id and
            cl.userId == user.id and
            user.id == userBioData.userId,
        select: %{cl: cl, user: user, userBioData: userBioData}
    client_users = Repo.all(query);
    render(conn, "employer_admin.html", client_users: client_users, company: company, current_user_role: current_user_role, current_user: current_user)
  end

  def employer_staff(conn, params) do
    current_user_role = get_session(conn, :current_user_role);
    current_user = get_session(conn, :current_user);
    query_params = conn.query_params;
    company_id = query_params["company_id"];
    company = nil;
    roleType = "EMPLOYEE"

    clStatus = "ACTIVE";

    if (is_nil(company_id)) do
        query = from au in UserRole,
            join: company in Company,
            on:
            au.companyId == company.id,
            group_by: [au.companyId, au.userId],
            select: %{userId: au.userId, companyId: au.companyId}
       userRoleUserIds = Repo.all(query)
       userRoleUserIdKeys = Enum.uniq(Enum.map(userRoleUserIds, fn line -> line.userId end))

       query = from userBioData in UserBioData,
            join: user in User,
            on:
            user.id == userBioData.userId,
        where: (user.id in ^userRoleUserIdKeys),
        select: %{user: user, userBioData: userBioData}
        client_users = Repo.all(query);
        query = from au in Company,
            select: au

        companies = Repo.all(query)
        #client_users = Accounts.get_client_users(company_id)

        render(conn, "employee.html", client_users: client_users, companies: companies, company: company, current_user_role: current_user_role, current_user: current_user)
    else
        query = from au in Company,
            where: (au.id == ^company_id),
            select: au

        companies = Repo.all(query)
        company = Enum.at(companies, 0)

        query = from au in UserRole,
           where: (au.companyId == ^company.id),
           select: au.userId
       userRoleUserIds = Repo.all(query)

       query = from userBioData in UserBioData,
            join: user in User,
            on:
            user.id == userBioData.userId,
        where: (user.id in ^userRoleUserIds),
        select: %{user: user, userBioData: userBioData}
        client_users = Repo.all(query);
        query = from au in Company,
            select: au

        companies = Repo.all(query)
        #client_users = Accounts.get_client_users(company_id)

        render(conn, "employee.html", client_users: client_users, companies: companies, company: company, current_user_role: current_user_role, current_user: current_user)
    end


end

  def add_employer(conn, params) do

    current_user_role = get_session(conn, :current_user_role);
    current_user = get_session(conn, :current_user);

    new_param = %{};
    new_param = Map.merge(new_param, %{"companyName" => params["company_name"] })
    new_param = Map.merge(new_param, %{"contactPhone" =>  params["phone"] })
    new_param = Map.merge(new_param, %{"registrationNumber" => params["company_reg_no"] })
    new_param = Map.merge(new_param, %{"taxNo" => (params["tpin_no"]) })
    new_param = Map.merge(new_param, %{"contactEmail" => params["email"] })
    new_param = Map.merge(new_param, %{"isEmployer" => true })
    new_param = Map.merge(new_param, %{"isSme" => false })
    new_param = Map.merge(new_param, %{"isOffTaker" => false })
    new_param = Map.merge(new_param, %{"createdByUserId" => current_user})
    new_param = Map.merge(new_param, %{"createdByUserRoleId" => current_user_role.id })

    Logger.info Jason.encode!(new_param);


    Ecto.Multi.new()
    |> Ecto.Multi.insert(:employers, Company.changeset(%Company{}, new_param))
    |> Ecto.Multi.run(:user_log, fn _repo, %{employers: employers} ->
      activity = "Created new Employer with code \"#{employers.id}\""

      user_log = %{
            user_id: conn.assigns.user.id,
            activity: activity
      }
      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{employers: _employers, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Employer Created successfully.")
        |> redirect(to: Routes.customer_path(conn, :employer))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.customer_path(conn, :employer))
    end
    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occurred, reason unknown. try again")
    #     |> redirect(to: Routes.branch_path(conn, :index))
  end

  def update_employer(conn, params) do
    employers = Companies.get_company!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:employers, Company.changeset(employers, params))
    |> Ecto.Multi.run(:user_log, fn (_, %{employers: employers}) ->
        activity = "Updated Employers with code \"#{employers.id}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{employers: _employers, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Employers details updated successfully")
        |> redirect(to: Routes.customer_path(conn, :employer))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.customer_path(conn, :employer))
    end
  end

  def add_employer_employee(conn, params) do
    %{"company_id" => company_id} = params
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:employee, Employee.changeset(%Employee{}, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{employee: employee} ->
      activity = "Created new Employee with code \"#{employee.id}\""

      user_log = %{
            user_id: conn.assigns.user.id,
            activity: activity
      }
      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{employee: _employee, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Employee Created successfully.")
        |> redirect(to: Routes.customer_path(conn, :employer_staff, company_id: company_id))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.customer_path(conn, :employer_staff, company_id: company_id))
    end
    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occurred, reason unknown. try again")
    #     |> redirect(to: Routes.branch_path(conn, :index))
  end

  def update_employer_employee(conn, params) do
    %{"company_id" => company_id} = params
    employee = Companies.get_employee!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:employee, Employee.changeset(employee, params))
    |> Ecto.Multi.run(:user_log, fn (_, %{employee: employee}) ->
        activity = "Updated Employee with code \"#{employee.id}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{employee: _employee, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Employee details updated successfully")
        |> redirect(to: Routes.customer_path(conn, :employer_staff, company_id: company_id))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.customer_path(conn, :employer_staff, company_id: company_id))
    end
  end

  def approve_employer(conn, params) do
    employers = Companies.get_company!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:employers, Company.changeset(employers, %{status: "ACTIVE" }))
    |> Ecto.Multi.run(:user_log, fn (_, %{employers: _employers}) ->
        activity = "Employer approved with code \"#{employers.company_name}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{employers: _employers, user_log: _user_log}} ->
        conn |> json(%{message: "Employer approved successfully", status: 0})
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn |> json(%{message: reason, status: 1})
    end
  end

  def approve_employee(conn, params) do
    employee = Companies.get_employee!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:employee, Employee.changeset(employee, %{status: "ACTIVE" }))
    |> Ecto.Multi.run(:user_log, fn (_, %{employee: _employee}) ->
        activity = "Employee approved with code \"#{employee.id}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{employee: _employee, user_log: _user_log}} ->
        conn |> json(%{message: "Employee approved successfully", status: 0})
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn |> json(%{message: reason, status: 1})
    end
  end

  def customer_approve(conn, params) do
    users_approve = Accounts.get_user!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:users, User.changeset(users_approve, %{status: "ACTIVE", canOperate: true}))
    |> Ecto.Multi.run(:user_log, fn (_, %{users: _users}) ->
        activity = "User Activated"

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{users: _users, user_log: _user_log}} ->
        conn |> json(%{message: "Customer approved successfully", status: 0})
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn |> json(%{message: reason, status: 1})
    end
  end


































  #------------------- Employee Functions----------------#

  def employee(conn, _params) do
    companies = Companies.list_tbl_company()
    get_comp_id = Companies.get_employee_data()
    employee = Companies.list_tbl_employee()
    render(conn, "employee.html", employee: employee, companies: companies, get_comp_id: get_comp_id)
  end

  def add_employee(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:employee, Employee.changeset(%Employee{}, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{employee: employee} ->
      activity = "Created new Employee with code \"#{employee.id}\""

      user_log = %{
            user_id: conn.assigns.user.id,
            activity: activity
      }
      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{employee: _employee, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Employee Created successfully.")
        |> redirect(to: Routes.customer_path(conn, :employer_staff))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.customer_path(conn, :employer_staff))
    end
    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occurred, reason unknown. try again")
    #     |> redirect(to: Routes.branch_path(conn, :index))
  end

  def update_employee(conn, params) do
    employee = Companies.get_employee!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:employee, Employee.changeset(employee, params))
    |> Ecto.Multi.run(:user_log, fn (_, %{employee: employee}) ->
        activity = "Updated Employee with code \"#{employee.id}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{employee: _employee, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Employee details updated successfully")
        |> redirect(to: Routes.customer_path(conn, :employee))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.customer_path(conn, :employee))
    end
  end






















































  def individual(conn, _params) do
    loan_customers = Client.get_loan_customer_individual()
    countries = SystemSetting.list_tbl_country()
    bio_data = UserBioDataUpdate.list_tbl_user_bio_data_update()
    provinces = SystemSetting.list_tbl_province()
    districts = SystemSetting.list_tbl_district()
    render(conn, "individual.html", loan_customers: loan_customers, bio_data: bio_data, countries: countries, provinces: provinces, districts: districts)
  end

  def update_individual(conn, %{"userId" => userId}) do
    loan_customers = Client.get_customer_individual(userId)
    get_details = Client.get_details(userId)
    get_address_details = Client.get_address_details(userId)
    render(conn, "individual_update.html", loan_customers: loan_customers, get_details: get_details, get_address_details: get_address_details)
  end

  def create_walkin_customer(conn, params) do
    params = Map.put(params, "status", "ACTIVE")
    params = Map.put(params, "productType", "LOANS")
    clientId = get_session(conn, :client_id)
    params = Map.put(params, "clientId", clientId)
    params = Map.put(params, "createdByUserId", conn.assigns.user.id)

    query = from au in LoanSavingsSystem.Accounts.User,
        where: (au.username == ^params["username"]),
        select: au
    au = Repo.all(query)
    if Enum.count(au)>0 do
      us_ = Enum.at(au, 0)
      ur = "INDIVIDUAL"
      query = from au in LoanSavingsSystem.Accounts.UserRole,
        where: (au.userId == ^us_.id and au.roleType == ^ur),
        select: au
      ar = Repo.all(query)

      if Enum.count(ar)>0 do

        #Throw Your error that he already has an individual account
        IO.puts "User Already has been created"
        conn
            |> put_flash(:error, "User Already has been created")
            |> redirect(to: Routes.customer_path(conn, :individual))
      else
        # Ecto.Multi.new()
        # |> Ecto.Multi.insert(:walkin, User.changeset(%User{}, params))
        # |> Ecto.Multi.run(:user_log, fn _repo, %{walkin: walkin} ->
        #   activity = "Created new Walkin Account with code \"#{walkin.id}\""

        #   user_log = %{
        #         user_id: conn.assigns.user.id,
        #         activity: activity
        #   }
        #   UserLogs.changeset(%UserLogs{}, user_log)
        #   |> Repo.insert()
        # end)

        Ecto.Multi.new()
        |> Ecto.Multi.run(:user_role, fn _repo, %{} ->
          walkinClienId = us_.id
          clientId = get_session(conn, :client_id)
          otp = Enum.random(1_000..9_999)
          otp = Integer.to_string(otp)

          user_role = %{
                userId: walkinClienId,
                roleType: "INDIVIDUAL",
                clientId: clientId,
                status: params["status"],
                otp: otp
          }
          UserRole.changeset(%UserRole{}, user_role)
          |> Repo.insert()
        end)


        # |> Ecto.Multi.run(:user_bio_data, fn _repo, %{} ->
        #   walkinClienId = us_.id
        #   clientId = get_session(conn, :client_id)
        #   user_bio_data = %{
        #         title: params["title"],
        #         firstName: params["firstName"],
        #         lastName: params["lastName"],
        #         userId: walkinClienId,
        #         otherName: params["otherName"],
        #         dateOfBirth: params["dateOfBirth"],
        #         meansOfIdentificationType: params["meansOfIdentificationType"],
        #         meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
        #         gender: params["gender"],
        #         mobileNumber: params["username"],
        #         emailAddress: params["emailAddress"],
        #         clientId: clientId
        #   }
        #   UserBioData.changeset(%UserBioData{}, user_bio_data)
        #   |> Repo.insert()
        # end)
        |> Repo.transaction()
        |> case do
          {:ok, %{}} ->
            conn
            |> put_flash(:info, "Walkin Account Created successfully.")
            |> redirect(to: Routes.customer_path(conn, :individual))

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.customer_path(conn, :individual))
        end
      end

    else


      Ecto.Multi.new()
      |> Ecto.Multi.insert(:walkin, User.changeset(%User{}, params))
      |> Ecto.Multi.run(:user_log, fn _repo, %{walkin: walkin} ->
        activity = "Created new Walkin Account with code \"#{walkin.id}\""

        user_log = %{
              user_id: conn.assigns.user.id,
              activity: activity
        }
        UserLogs.changeset(%UserLogs{}, user_log)
        |> Repo.insert()
      end)


      |> Ecto.Multi.run(:user_role, fn _repo, %{walkin: walkin} ->
        walkinClienId = walkin.id
        clientId = get_session(conn, :client_id)
        otp = Enum.random(1_000..9_999)
        otp = Integer.to_string(otp)

        user_role = %{
              userId: walkinClienId,
              roleType: "INDIVIDUAL",
              clientId: clientId,
              status: params["status"],
              otp: otp
        }
        UserRole.changeset(%UserRole{}, user_role)
        |> Repo.insert()
      end)


      |> Ecto.Multi.run(:user_bio_data, fn _repo, %{walkin: walkin} ->
        walkinClienId = walkin.id
        clientId = get_session(conn, :client_id)
        user_bio_data = %{
              title: params["title"],
              firstName: params["firstName"],
              lastName: params["lastName"],
              userId: walkinClienId,
              otherName: params["otherName"],
              dateOfBirth: params["dateOfBirth"],
              meansOfIdentificationType: params["meansOfIdentificationType"],
              meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
              gender: params["gender"],
              mobileNumber: params["username"],
              emailAddress: params["emailAddress"],
              clientId: clientId
        }
        UserBioData.changeset(%UserBioData{}, user_bio_data)
        |> Repo.insert()
      end)

      |> Ecto.Multi.run(:customer_address, fn _repo, %{walkin: walkin} ->
        walkinClienId = walkin.id
        clientId = get_session(conn, :client_id)

        countryVal = params["countryName"];
        countryVal = String.split(countryVal, "|||")
        countryId = Enum.at(countryVal, 0)
        countryName = Enum.at(countryVal, 1)

        districtVal = params["districtName"];
        districtVal = String.split(districtVal, "|||")
        districtId = Enum.at(districtVal, 0)
        districtName = Enum.at(districtVal, 1)

        provinceVal = params["provinceName"];
        provinceVal = String.split(provinceVal, "|||")
        provinceId = Enum.at(provinceVal, 0)
        provinceName = Enum.at(provinceVal, 1)

        customer_address = %{
              addressLine1: params["addressLine1"],
              addressLine2: params["addressLine2"],
              city: params["city"],
              districtId: districtId,
              districtName: districtName,
              provinceId: provinceId,
              provinceName: provinceName,
              countryId: countryId,
              countryName: countryName,
              isCurrent: true,
              userId: walkinClienId,
              clientId: clientId
        }
        Address.changeset(%Address{}, customer_address)
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:next_of_keen, fn _repo, %{walkin: walkin} ->
        walkinClienId = walkin.id
        clientId = get_session(conn, :client_id)

        districtVal = params["next_of_keen"]["districtName"];
        districtVal = String.split(districtVal, "|||")
        districtId = Enum.at(districtVal, 0)
        districtName = Enum.at(districtVal, 1)

        provinceVal = params["next_of_keen"]["provinceName"];
        provinceVal = String.split(provinceVal, "|||")
        provinceId = Enum.at(provinceVal, 0)
        provinceName = Enum.at(provinceVal, 1)

        next_of_keen = %{
              firstName: params["next_of_keen"]["firstName"],
              lastName: params["next_of_keen"]["lastName"],
              otherName: params["next_of_keen"]["otherName"],
              addressLine1: params["next_of_keen"]["addressLine1"],
              addressLine2: params["next_of_keen"]["addressLine2"],
              city: params["next_of_keen"]["city"],
              districtId: districtId,
              districtName: districtName,
              provinceId: provinceId,
              provinceName: provinceName,
              accountId: walkinClienId,
              userId: walkinClienId,
              clientId: clientId
        }
        NextOfKin.changeset(%NextOfKin{}, next_of_keen)
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:sms, fn (_, %{user_bio_data: bio_data}) ->
        naive_datetime = Timex.now
        sms = %{
          mobile: bio_data.mobileNumber,
          msg: "Dear customer, Your Login Credentials. username: #{params["username"]}, Please Create A new password upon login",
          status: "READY",
          type: "SMS",
          msg_count: "1",
          date_sent: naive_datetime
          }
          Sms.changeset(%Sms{}, sms)
          |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{walkin: _walkin, user_log: _user_log}} ->
          Email.walking_creation_email(params["emailAddress"], params["firstName"])

          conn
          |> put_flash(:info, "Walkin Account Created successfully.")
          |> redirect(to: Routes.customer_path(conn, :individual))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.customer_path(conn, :individual))
      end
    end
    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occurred, reason unknown. try again")
    #     |> redirect(to: Routes.branch_path(conn, :index))
  end



  def update_walkin_customer(conn, params) do
      params = Poison.encode!(params, as: %UserBioDataUpdates{})
      IO.inspect "++++++++++++++++++++++++++++++++++++++++++"
      IO.inspect params
      IO.inspect "++++++++++++++++++++++++++++++++++++++++++"
      user_bio_data = %{
              userBioData: params,
              status: "PENDING_APPROVAL"
        }
        UserBioDataUpdates.changeset(%UserBioDataUpdates{}, user_bio_data)
      |> Repo.insert()
          conn
          |> put_flash(:info, "Walkin Bio Date Updated successfully.")
          |> redirect(to: Routes.customer_path(conn, :individual))
  end

  def approve_individual_bio(conn, params) do
    IO.inspect(params, label: "hhh----------------------------------------------------------")
    individuals_data = UserBioDataUpdate.get_user_bio_data_updates!(params["id"])
    user_bio_data = Client.get_user_bio_data!(params["id"])

    query = from uB in LoanSavingsSystem.UserBioDataUpdate.UserBioDataUpdates,
      where: (uB.id == ^user_bio_data),
      select: uB.userBioData
    getpat = Poison.decode!(Repo.all(query))
    %{
      "_csrf_token" => _csrf_token,
      "addressLine1" => _addressLine1,
      "dateOfBirth" => dateOfBirth,
      "emailAddress" => emailAddress,
      "firstName" => firstName,
      "gender" => gender,
      "id" => _id,
      "lastName" => lastName,
      "meansOfIdentificationNumber" => meansOfIdentificationNumber,
      "meansOfIdentificationType" => meansOfIdentificationType,
      "otherName" => otherName,
      "title" => _title,
      "username" => username
      } = getpat
    IO.inspect "++++++++++++++++++++++++++++++++++++++++++"
    IO.inspect individuals_data
    IO.inspect "++++++++++++++++++++++++++++++++++++++++++"
    Ecto.Multi.new()
    |> Ecto.Multi.update(:individuals, UserBioDataUpdates.changeset(individuals_data, %{status: "APPROVED", approvedByUserId: conn.assigns.user.id }))
    |> Ecto.Multi.update(:user_bio, UserBioDataUpdates.changeset(user_bio_data,
    %{

          firstName: firstName,
          lastName: lastName,
          otherName: otherName,
          dateOfBirth: dateOfBirth,
          meansOfIdentificationType: meansOfIdentificationType,
          meansOfIdentificationNumber: meansOfIdentificationNumber,
          gender: gender,
          mobileNumber: username,
          emailAddress: emailAddress
    }))
    |> Repo.transaction()
    |> case do
      {:ok, %{individuals: _individuals, user_bio_data: _user_bio_data}} ->
        conn |> json(%{message: "Individual approved successfully", status: 0})
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn |> json(%{message: reason, status: 1})
    end
  end


    def test(id) do
      query = from au in LoanSavingsSystem.UserBioDataUpdate.UserBioDataUpdates,
        where: (au.id == ^id),
        select: au.userBioData
      getpat = Poison.decode!(Repo.all(query))
      %{
        "_csrf_token" => _csrf_token,
        "addressLine1" => _addressLine1,
        "dateOfBirth" => _dateOfBirth,
        "emailAddress" => _emailAddress,
        "firstName" => _firstName,
        "gender" => _gender,
        "id" => _id,
        "lastName" => _lastName,
        "meansOfIdentificationNumber" => _meansOfIdentificationNumber,
        "meansOfIdentificationType" => _meansOfIdentificationType,
        "otherName" => _otherName,
        "title" => _title,
        "username" => _username
        } = getpat
    end





    def new(params) do
      individuals_data = UserBioDataUpdate.get_user_bio_data_updates!(params["id"])
      user_bio_data = Client.get_user_bio_data!(params["userId"])

      query = from au in LoanSavingsSystem.UserBioDataUpdate.UserBioDataUpdates,
        where: (au.id == ^individuals_data),
        select: au.userBioData
      getpat = Poison.decode!(Repo.all(query))
      %{
        "_csrf_token" => _csrf_token,
        "addressLine1" => _addressLine1,
        "dateOfBirth" => _dateOfBirth,
        "emailAddress" => _emailAddress,
        "firstName" => _firstName,
        "gender" => _gender,
        "id" => _id,
        "lastName" => _lastName,
        "meansOfIdentificationNumber" => _meansOfIdentificationNumber,
        "meansOfIdentificationType" => _meansOfIdentificationType,
        "otherName" => _otherName,
        "title" => _title,
        "username" => _username,
        "userId" => userId
        } = getpat

      if userId == user_bio_data do
        userId
        else
          "User Id does not exist"

        end
    end

  # def update_individual(conn, params) do
  #   individuals = Individuals.get_individual!(params["id"])
  #   Ecto.Multi.new()
  #   |> Ecto.Multi.update(:individuals, Individual.changeset(individuals, params))
  #   |> Ecto.Multi.run(:user_log, fn (_, %{individuals: individuals}) ->
  #       activity = "Updated Individuals with ID \"#{individuals.id}\""

  #       user_logs = %{
  #         user_id: conn.assigns.user.id,
  #         activity: activity
  #       }

  #       UserLogs.changeset(%UserLogs{}, user_logs)
  #       |> Repo.insert()
  #   end)
  #   |> Repo.transaction()
  #   |> case do
  #     {:ok, %{individuals: _individuals, user_log: _user_log}} ->
  #       conn
  #       |> put_flash(:info, "individuals details updated successfully")
  #       |> redirect(to: Routes.customer_path(conn, :individual))

  #       {:error, _failed_operation, failed_value, _changes_so_far} ->
  #         reason = traverse_errors(failed_value.errors) |> List.first()
  #         conn
  #         |> put_flash(:error, reason)
  #         |> redirect(to: Routes.customer_path(conn, :individual))
  #   end
  # end















































































  # def sme(conn, _params) do
  #   smes = Smes.list_tbl_sme()
  #   render(conn, "sme.html", smes: smes)
  # end

  # def add_sme(conn, params) do
  #   Ecto.Multi.new()
  #   |> Ecto.Multi.insert(:smes, Sme.changeset(%Sme{}, params))
  #   |> Ecto.Multi.run(:user_log, fn _repo, %{smes: smes} ->
  #     activity = "Created new SME with id \"#{smes.id}\""

  #     user_log = %{
  #           user_id: conn.assigns.user.id,
  #           activity: activity
  #     }
  #     UserLogs.changeset(%UserLogs{}, user_log)
  #     |> Repo.insert()
  #   end)
  #   |> Repo.transaction()
  #   |> case do
  #     {:ok, %{smes: _smes, user_log: _user_log}} ->
  #       conn
  #       |> put_flash(:info, "SME Created successfully.")
  #       |> redirect(to: Routes.customer_path(conn, :sme))

  #     {:error, _failed_operation, failed_value, _changes_so_far} ->
  #       reason = traverse_errors(failed_value.errors) |> List.first()

  #       conn
  #       |> put_flash(:error, reason)
  #       |> redirect(to: Routes.customer_path(conn, :sme))
  #   end
  #   # rescue
  #   #   _ ->
  #   #     conn
  #   #     |> put_flash(:error, "An error occurred, reason unknown. try again")
  #   #     |> redirect(to: Routes.branch_path(conn, :index))
  # end

  # def update_sme(conn, params) do
  #   smes = Smes.get_sme!(params["id"])
  #   Ecto.Multi.new()
  #   |> Ecto.Multi.update(:smes, Sme.changeset(smes, params))
  #   |> Ecto.Multi.run(:user_log, fn (_, %{smes: smes}) ->
  #       activity = "Updated SME with ID \"#{smes.id}\""

  #       user_logs = %{
  #         user_id: conn.assigns.user.id,
  #         activity: activity
  #       }

  #       UserLogs.changeset(%UserLogs{}, user_logs)
  #       |> Repo.insert()
  #   end)
  #   |> Repo.transaction()
  #   |> case do
  #     {:ok, %{smes: _smes, user_log: _user_log}} ->
  #       conn
  #       |> put_flash(:info, "SME details updated successfully")
  #       |> redirect(to: Routes.customer_path(conn, :sme))

  #       {:error, _failed_operation, failed_value, _changes_so_far} ->
  #         reason = traverse_errors(failed_value.errors) |> List.first()
  #         conn
  #         |> put_flash(:error, reason)
  #         |> redirect(to: Routes.customer_path(conn, :sme))
  #   end
  # end

  # def approve_sme(conn, params) do
  #   smes = Smes.get_sme!(params["id"])
  #   Ecto.Multi.new()
  #   |> Ecto.Multi.update(:smes, Sme.changeset(smes, %{status: "ACTIVE" }))
  #   |> Ecto.Multi.run(:user_log, fn (_, %{smes: _smes}) ->
  #       activity = "SME approved with code \"#{smes.id}\""

  #       user_logs = %{
  #         user_id: conn.assigns.user.id,
  #         activity: activity
  #       }

  #       UserLogs.changeset(%UserLogs{}, user_logs)
  #       |> Repo.insert()
  #   end)
  #   |> Repo.transaction()
  #   |> case do
  #     {:ok, %{smes: _smes, user_log: _user_log}} ->
  #       conn |> json(%{message: "SME approved successfully", status: 0})
  #       {:error, _failed_operation, failed_value, _changes_so_far} ->
  #         reason = traverse_errors(failed_value.errors) |> List.first()
  #         conn |> json(%{message: reason, status: 1})
  #   end
  # end























  # def offtaker(conn, _params) do
  #   offtakers = Offtaker.list_tbl_off_taker()
  #   render(conn, "offtaker.html", offtakers: offtakers)
  # end

  # def offtaker_admin(conn, %{"off_taker_id" => off_taker_id}) do
  #   offtakers = Offtaker.offtaker_id(off_taker_id)
  #   offtaker_users = Accounts.get_offtaker_users(off_taker_id)
  #   render(conn, "offtaker_admin.html", offtaker_users: offtaker_users, offtakers: offtakers)
  # end

  # def add_offtaker(conn, params) do
  #   Ecto.Multi.new()
  #   |> Ecto.Multi.insert(:offtakers, Offtakers.changeset(%Offtakers{}, params))
  #   |> Ecto.Multi.run(:user_log, fn _repo, %{offtakers: offtakers} ->
  #     activity = "Created new Offtaker with code \"#{offtakers.id}\""

  #     user_log = %{
  #           user_id: conn.assigns.user.id,
  #           activity: activity
  #     }
  #     UserLogs.changeset(%UserLogs{}, user_log)
  #     |> Repo.insert()
  #   end)
  #   |> Repo.transaction()
  #   |> case do
  #     {:ok, %{offtakers: _offtakers, user_log: _user_log}} ->
  #       conn
  #       |> put_flash(:info, "Offtaker Created successfully.")
  #       |> redirect(to: Routes.customer_path(conn, :offtaker))

  #     {:error, _failed_operation, failed_value, _changes_so_far} ->
  #       reason = traverse_errors(failed_value.errors) |> List.first()

  #       conn
  #       |> put_flash(:error, reason)
  #       |> redirect(to: Routes.customer_path(conn, :offtaker))
  #   end
  #   # rescue
  #   #   _ ->
  #   #     conn
  #   #     |> put_flash(:error, "An error occurred, reason unknown. try again")
  #   #     |> redirect(to: Routes.branch_path(conn, :index))
  # end

  # def update_offtaker(conn, params) do
  #   offtakers = Offtaker.get_offtakers!(params["id"])
  #   Ecto.Multi.new()
  #   |> Ecto.Multi.update(:offtakers, Offtakers.changeset(offtakers, params))
  #   |> Ecto.Multi.run(:user_log, fn (_, %{offtakers: offtakers}) ->
  #       activity = "Updated Offtaker with code \"#{offtakers.id}\""

  #       user_logs = %{
  #         user_id: conn.assigns.user.id,
  #         activity: activity
  #       }

  #       UserLogs.changeset(%UserLogs{}, user_logs)
  #       |> Repo.insert()
  #   end)
  #   |> Repo.transaction()
  #   |> case do
  #     {:ok, %{offtakers: _offtakers, user_log: _user_log}} ->
  #       conn
  #       |> put_flash(:info, "Offtaker details updated successfully")
  #       |> redirect(to: Routes.customer_path(conn, :offtaker))

  #       {:error, _failed_operation, failed_value, _changes_so_far} ->
  #         reason = traverse_errors(failed_value.errors) |> List.first()
  #         conn
  #         |> put_flash(:error, reason)
  #         |> redirect(to: Routes.customer_path(conn, :offtaker))
  #   end
  # end

  # def approve_offtaker(conn, params) do
  #   offtakers = Offtaker.get_offtakers!(params["id"])
  #   Ecto.Multi.new()
  #   |> Ecto.Multi.update(:offtakers, Offtakers.changeset(offtakers, %{status: "ACTIVE" }))
  #   |> Ecto.Multi.run(:user_log, fn (_, %{offtakers: _offtakers}) ->
  #       activity = "Offtaker approved with code \"#{offtakers.id}\""

  #       user_logs = %{
  #         user_id: conn.assigns.user.id,
  #         activity: activity
  #       }

  #       UserLogs.changeset(%UserLogs{}, user_logs)
  #       |> Repo.insert()
  #   end)
  #   |> Repo.transaction()
  #   |> case do
  #     {:ok, %{offtakers: _offtakers, user_log: _user_log}} ->
  #       conn |> json(%{message: "Offtaker approved successfully", status: 0})
  #       {:error, _failed_operation, failed_value, _changes_so_far} ->
  #         reason = traverse_errors(failed_value.errors) |> List.first()
  #         conn |> json(%{message: reason, status: 1})
  #   end
  # end

































  def handle_bulk_upload_of_employee(conn, params) do
    user = conn.assigns.user
    current_user_role = get_session(conn, :current_user_role);
    company_id = current_user_role.companyId;
    params = Map.put(params, "company_id", current_user_role.companyId)

    {key, msg, _invalid} = handle_file_upload(conn, user, params)

    if key == :info do
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.customer_path(conn, :employer_staff, company_id: company_id))

    else
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.customer_path(conn, :employer_staff, company_id: company_id))
    end
  end

  defp handle_file_upload(conn, user, params) do

    with {:ok, filename, destin_path, _rows} <- is_valide_file(params) do
      user
      |> process_bulk_upload(conn, filename, destin_path, params)
      |> case do
        {:ok, {invalid, valid}} ->
          {:info, "#{valid} Successful entrie(s) and #{invalid} invalid entrie(s)", invalid}

        {:error, reason} ->
          {:error, reason, 0}
      end
    else
      {:error, reason} ->
        {:error, reason, 0}
    end
  end


  def process_csv(file) do
    case File.exists?(file) do
      true ->
        data =
          File.stream!(file)
          |> CSV.decode!(separator: ?,, headers: true)
          |> Enum.map(& &1)

        {:ok, data}

      false ->
        {:error, "File does not exist"}
    end
  end


  def process_bulk_upload(conn, user, filename, path, params) do
    # try do
      {:ok, items} = extract_xlsx(path)

      prepare_bulk_params(conn, user, filename, items, params)
      |> Repo.transaction(timeout: 290_000)
      |> case do
        {:ok, multi_records} ->
          {invalid, valid} =
            multi_records
            |> Map.values()
            |> Enum.reduce({0, 0}, fn item, {invalid, valid} ->
              case item do
                %{staff_file_name: _src} -> {invalid, valid + 1}
                %{col_index: _index} -> {invalid + 1, valid}
                _ -> {invalid, valid}
              end
            end)

          {:ok, {invalid, valid}}

        {:error, _, changeset, _} ->
          # prepare_error_log(changeset, filename)
          reason = traverse_errors(changeset.errors) |> Enum.join("\r\n")
          {:error, reason}
      end
    # after
    #   filename = Path.rootname(filename) |> Path.basename()
    # end
  end

  defp prepare_bulk_params(conn, user, filename, items, params) do
    IO.inspect "++++++++++++++++++++++++++++++++++"
    IO.inspect items
    items
    |> Stream.with_index(2)
    |> Stream.map(fn {item, index} ->
      # changeset =
      #   %Employee{staff_file_name: filename, company_id: params["company_id"], status: params["status"]}
      #   |> Employee.changeset(Map.put(item, :user_id, user.id))

      # Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset)



    end)

    # |> filter_upload_errors(filename)
    |> Enum.reject(fn
      %{operations: [{_, {:run, _}}]} -> false
      %{operations: [{_, {_, changeset, _}}]} -> changeset.valid? == false
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
  end

  # ---------------------- file persistence --------------------------------------
  def is_valide_file(%{"staff_file_name" => params}) do
      if upload = params do
        case Path.extname(upload.filename) do
          ext when ext in ~w(.xlsx .XLSX .xls .XLS .csv .CSV) ->
            with {:ok, destin_path} <- persist(upload) do
              case ext not in ~w(.csv .CSV) do
                true ->
                  case Xlsxir.multi_extract(destin_path, 0, false, extract_to: :memory) do
                    {:ok, table_id} ->
                      row_count = Xlsxir.get_info(table_id, :rows)
                      Xlsxir.close(table_id)
                      {:ok, upload.filename, destin_path, row_count - 1}

                    {:error, reason} ->
                      {:error, reason}
                  end

                _ ->
                  {:ok, upload.filename, destin_path, "N(count)"}
              end
            else
              {:error, reason} ->
                {:error, reason}
            end

          regan ->
            IO.inspect "================================================================================="
            IO.inspect regan
            {:error, "Invalid File Format"}
        end
      else
        {:error, "No File Uploaded"}
      end
  end

  def csv(path, upload) do
    case process_csv(path) do
      {:ok, data} ->
        row_count = Enum.count(data)
        IO.inspect("++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        IO.inspect(row_count)

        case row_count do
          rows when rows in 1..100_000 ->
            {:ok, upload.filename, path, row_count}

          _ ->
            {:error, "File records should be between 1 to 100,000"}
        end

      {:error, reason} ->
        IO.inspect(reason)

        {:error, reason}
    end
  end


  def persist(%Plug.Upload{filename: filename, path: path}) do
      dir_path = SystemDirectories.directories()

      destin_path = (dir_path && dir_path.processed)  ||  "C:/Users/Dolben/Desktop/staffFile" |> default_dir()
      destin_path = Path.join(destin_path, filename)

        {_key, _resp} =
        with true <- File.exists?(destin_path) do
          {:error, "File with the same name aready exists"}
        else
          false ->
            File.cp(path, destin_path)
            {:ok, destin_path}
        end
  end



    def default_dir(path) do
      File.mkdir_p(path)
      path
    end


    def extract_xlsx(path) do
      case Xlsxir.multi_extract(path, 0, false, extract_to: :memory) do
        {:ok, id} ->
          items =
            Xlsxir.get_list(id)
            |> Enum.reject(&Enum.empty?/1)
            |> Enum.reject(&Enum.all?(&1, fn item -> is_nil(item)
          end))
            |> List.delete_at(0)
            |> Enum.map(
              &Enum.zip(
                Enum.map(@headers, fn h -> h end),
                Enum.map(&1, fn v -> strgfy_term(v) end)
              )
            )
            |> Enum.map(&Enum.into(&1, %{}))
            |> Enum.reject(&(Enum.join(Map.values(&1)) == ""))

          Xlsxir.close(id)
          {:ok, items}


        {:error, reason} ->
          {:error, reason}
      end
    end

    defp strgfy_term(term) when is_tuple(term), do: term
    defp strgfy_term(term) when not is_tuple(term), do: String.trim("#{term}")

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end



end
