defmodule LoanmanagementsystemWeb.ClientManagementController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false

  # alias Loanmanagementsystem.Maintenance.{Currency, Country, Province, District, Security_questions, Branch, Bank, Classification}
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Accounts.{User, UserBioData, UserRole}
  alias Loanmanagementsystem.Emails.Email
  # alias Loanmanagementsystem.Charges.Charge
  # alias Loanmanagementsystem.Loan.Customer_Balance
  alias Loanmanagementsystem.Accounts.Address_Details
  alias Loanmanagementsystem.Companies.{Employee, Client_company_details}
  alias Loanmanagementsystem.Employment.Employment_Details
  alias Loanmanagementsystem.Employment.Personal_Bank_Details
  alias Loanmanagementsystem.Maintenance.Classification
  alias Loanmanagementsystem.Merchants.Merchant
  alias Loanmanagementsystem.Merchants.Merchant_director
  alias Loanmanagementsystem.Merchants.Merchants_device
  alias Loanmanagementsystem.Accounts.User
  # alias Loanmanagementsystem.OperationsServices

  def client_maintainence(conn, _request) do
    employee =
      Loanmanagementsystem.OperationsServices.get_employer_employee()
      |> Enum.reject(&(&1.roleType != "EMPLOYEE"))

    companies = Loanmanagementsystem.Companies.list_tbl_company()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    branches = Loanmanagementsystem.Maintenance.list_tbl_branch()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()

    render(conn, "client_maintainence.html",
      employee: employee,
      banks: banks,
      branches: branches,
      departments: departments,
      companies: companies
    )
  end

  def add_client(conn, _request) do
    companies = Loanmanagementsystem.Companies.list_tbl_company()
    departments = Loanmanagementsystem.Companies.list_tbl_departments()
    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()
    render(conn, "add_client.html", companies: companies, departments: departments, banks: banks)
  end

  def create_client_user(conn, params) do

    password = "pass-#{Enum.random(1_000_000_000..9_999_999_999)}"

    IO.inspect(params, label: "Param print out")
    check_company = String.length(params["company_id"])

    if check_company < 1 do
      IO.inspect("Pushing For Individual")
      LoanmanagementsystemWeb.ClientManagementController.push_records_individual(conn, params)
    else
      IO.inspect("Pushing For Employee")
      otp = to_string(Enum.random(1111..9999))
      employment_status = params["client_type"]
      client_employment_status = String.split(employment_status, "|||")
      client_type = Enum.at(client_employment_status, 0)
      employment_type = Enum.at(client_employment_status, 1)

      client_company = params["company_id"]
      company_details = String.split(client_company, "|||")
      company_id = Enum.at(company_details, 0)
      company_name = Enum.at(company_details, 1)

      # employment_status = params["client_type"];
      # client_employment_status = String.split(employment_status, "|||")
      # client_type = Enum.at(client_employment_status, 0)
      # employment_type = Enum.at(client_employment_status, 1)

      Ecto.Multi.new()
      |> Ecto.Multi.insert(
        :add_employer_user,
        User.changeset(%User{}, %{
          password: params["password"],
          status: "INACTIVE",
          username: params["emailAddress"],
          auto_password: "Y",
          company_id: company_id,
          pin: otp
        })
      )
      |> Ecto.Multi.run(:add_user_bio_data, fn _repo, %{add_employer_user: add_employer_user} ->
        UserBioData.changeset(%UserBioData{}, %{
          dateOfBirth: params["dateOfBirth"],
          emailAddress: params["emailAddress"],
          firstName: params["firstName"],
          gender: params["gender"],
          lastName: params["lastName"],
          meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
          meansOfIdentificationType: params["meansOfIdentificationType"],
          mobileNumber: params["mobileNumber"],
          otherName: params["otherName"],
          title: params["title"],
          userId: add_employer_user.id,
          idNo: nil,
          bank_id: params["bank_id"],
          bank_account_number: params["bank_account_number"],
          marital_status: params["marital_status"],
          nationality: params["nationality"],
          number_of_dependants: params["number_of_dependants"],
          disability_status: params["disability_status"],
          disability_detail: params["disability_detail"]
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_user_role, fn _repo,
                                           %{
                                             add_employer_user: add_employer_user,
                                             add_user_bio_data: _add_user_bio_data
                                           } ->
        UserRole.changeset(%UserRole{}, %{
          roleType: "EMPLOYEE",
          status: "INACTIVE",
          client_type: client_type,
          userId: add_employer_user.id,
          otp: otp
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_client_company, fn _repo,
                                                %{
                                                  add_employer_user: add_employer_user,
                                                  add_user_bio_data: _add_user_bio_data,
                                                  add_user_role: add_user_role
                                                } ->
        Client_company_details.changeset(%Client_company_details{}, %{
          company_name: company_name,
          company_account_number: params["company_account_number"],
          company_phone: params["company_phone"],
          company_registration_date: params["company_registration_date"],
          contact_email: params["contact_email"],
          registration_number: params["registration_number"],
          taxno: params["taxno"],
          bank_id: params["bank_id"],
          company_department: params["company_department"],
          status: "INACTIVE",
          createdByUserId: add_employer_user.id,
          createdByUserRoleId: add_user_role.id
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_employer_employee, fn _repo,
                                                   %{
                                                     add_user_role: add_user_role,
                                                     add_employer_user: add_employer_user,
                                                     add_user_bio_data: _add_user_bio_data
                                                   } ->
        Employee.changeset(%Employee{}, %{
          companyId: company_id,
          employerId: company_id,
          status: "INACTIVE",
          userId: add_employer_user.id,
          userRoleId: add_user_role.id,
          loan_limit: nil
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_address_details, fn _repo,
                                                 %{
                                                   add_user_role: _add_user_role,
                                                   add_employer_user: add_employer_user,
                                                   add_user_bio_data: _add_user_bio_data,
                                                   add_employer_employee: _add_employer_employee
                                                 } ->
        Address_Details.changeset(%Address_Details{}, %{
          accomodation_status: params["accomodation_status"],
          area: params["area"],
          house_number: params["house_number"],
          street_name: params["street_name"],
          town: params["town"],
          userId: add_employer_user.id,
          year_at_current_address: params["year_at_current_address"]
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_employment_details, fn _repo,
                                                    %{
                                                      add_employer_employee:
                                                        _add_employer_employee,
                                                      add_address_details: _add_address_details,
                                                      add_employer_user: add_employer_user,
                                                      add_user_bio_data: _add_user_bio_data
                                                    } ->
        Employment_Details.changeset(%Employment_Details{}, %{
          area: params["area"],
          date_of_joining: params["date_of_joining"],
          employee_number: params["employee_number"],
          employer: company_name,
          employer_industry_type: params["employer_industry_type"],
          employer_office_building_name: params["employer_office_building_name"],
          employer_officer_street_name: params["employer_officer_street_name"],
          employment_type: employment_type,
          hr_supervisor_email: params["hr_supervisor_email"],
          hr_supervisor_mobile_number: params["hr_supervisor_mobile_number"],
          hr_supervisor_name: params["hr_supervisor_name"],
          job_title: params["job_title"],
          occupation: params["occupation"],
          province: params["province"],
          town: params["town"],
          userId: add_employer_user.id,
          departmentId: params["departmentId"]
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_Personal_details, fn _repo,
                                                  %{
                                                    add_employer_employee: _add_employer_employee,
                                                    add_address_details: _add_address_details,
                                                    add_employer_user: add_employer_user,
                                                    add_user_bio_data: _add_user_bio_data
                                                  } ->
        Personal_Bank_Details.changeset(%Personal_Bank_Details{}, %{
          accountName: params["accountName"],
          accountNumber: params["bank_account_number"],
          bankName: params["bankName"],
          branchName: params["branchName"],
          upload_bank_statement: nil,
          userId: add_employer_user.id
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:client_document, fn _repo,
                                             %{
                                               add_Personal_details: _add_Personal_details,
                                               add_employer_employee: _add_employer_employee,
                                               add_address_details: _add_address_details,
                                               add_employer_user: _add_employer_user,
                                               add_user_bio_data: _add_user_bio_data
                                             } ->
        Loanmanagementsystem.Services.ClientUploads.client_upload(%{
          "process_documents" => params,
          "conn" => conn
        })
      end)
      |> Ecto.Multi.run(:user_logs, fn _repo,
                                       %{
                                         add_Personal_details: _add_Personal_details,
                                         add_employer_employee: _add_employer_employee,
                                         add_address_details: _add_address_details,
                                         add_employer_user: _add_employer_user,
                                         add_user_bio_data: _add_user_bio_data,
                                         client_document: _client_document
                                       } ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Added User Successfully",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{add_user_bio_data: add_user_bio_data}} ->
          Email.send_email(params["emailAddress"], params["password"])

          conn
          |> put_flash(
            :info,
            "You have Successfully Created #{add_user_bio_data.firstName} #{add_user_bio_data.lastName} Aa A Client"
          )
          |> redirect(to: Routes.client_management_path(conn, :client_maintainence))

        {:error, _failed_operations, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors)

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.client_management_path(conn, :client_maintainence))
      end
    end
  end

  def push_records_individual(conn, params) do
    IO.inspect(params, label: "Param print out")
    otp = to_string(Enum.random(1111..9999))

    password = "pass-#{Enum.random(1_000_000_000..9_999_999_999)}"

    client_type = "Individual"
    employment_type = params["employment_type"]

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :add_employer_user,
      User.changeset(%User{}, %{
        password: password,
        status: "INACTIVE",
        username: params["emailAddress"],
        auto_password: "Y",
        company_id: params["company_id"],
        pin: otp
      })
    )
    |> Ecto.Multi.run(:add_user_bio_data, fn _repo, %{add_employer_user: add_employer_user} ->
      UserBioData.changeset(%UserBioData{}, %{
        dateOfBirth: params["dateOfBirth"],
        emailAddress: params["emailAddress"],
        firstName: params["firstName"],
        gender: params["gender"],
        lastName: params["lastName"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
        meansOfIdentificationType: params["meansOfIdentificationType"],
        mobileNumber: params["mobileNumber"],
        otherName: params["otherName"],
        title: params["title"],
        userId: add_employer_user.id,
        idNo: nil,
        bank_id: params["bank_id"],
        bank_account_number: params["bank_account_number"],
        marital_status: params["marital_status"],
        nationality: params["nationality"],
        number_of_dependants: params["number_of_dependants"],
        disability_status: params["disability_status"],
        disability_detail: params["disability_detail"]
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_user_role, fn _repo,
                                         %{
                                           add_employer_user: add_employer_user,
                                           add_user_bio_data: _add_user_bio_data
                                         } ->
      UserRole.changeset(%UserRole{}, %{
        roleType: "EMPLOYEE",
        status: "INACTIVE",
        client_type: client_type,
        userId: add_employer_user.id,
        otp: otp
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_client_company, fn _repo,
                                              %{
                                                add_employer_user: add_employer_user,
                                                add_user_bio_data: _add_user_bio_data,
                                                add_user_role: add_user_role
                                              } ->
      Client_company_details.changeset(%Client_company_details{}, %{
        company_name: params["company_name"],
        company_account_number: params["company_account_number"],
        company_phone: params["company_phone"],
        company_registration_date: params["company_registration_date"],
        contact_email: params["contact_email"],
        registration_number: params["registration_number"],
        taxno: params["taxno"],
        bank_id: params["bank_id"],
        company_department: params["company_department"],
        status: "INACTIVE",
        createdByUserId: add_employer_user.id,
        createdByUserRoleId: add_user_role.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_employer_employee, fn _repo,
                                                 %{
                                                   add_user_role: add_user_role,
                                                   add_employer_user: add_employer_user,
                                                   add_user_bio_data: _add_user_bio_data
                                                 } ->
      Employee.changeset(%Employee{}, %{
        companyId: params["company_id"],
        employerId: params["company_id"],
        status: "INACTIVE",
        userId: add_employer_user.id,
        userRoleId: add_user_role.id,
        loan_limit: nil
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_address_details, fn _repo,
                                               %{
                                                 add_user_role: _add_user_role,
                                                 add_employer_user: add_employer_user,
                                                 add_user_bio_data: _add_user_bio_data,
                                                 add_employer_employee: _add_employer_employee
                                               } ->
      Address_Details.changeset(%Address_Details{}, %{
        accomodation_status: params["accomodation_status"],
        area: params["area"],
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        userId: add_employer_user.id,
        year_at_current_address: params["year_at_current_address"]
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_employment_details, fn _repo,
                                                  %{
                                                    add_employer_employee: _add_employer_employee,
                                                    add_address_details: _add_address_details,
                                                    add_employer_user: add_employer_user,
                                                    add_user_bio_data: _add_user_bio_data
                                                  } ->
      Employment_Details.changeset(%Employment_Details{}, %{
        area: params["area"],
        date_of_joining: params["date_of_joining"],
        employee_number: params["employee_number"],
        employer: params["company_name"],
        employer_industry_type: params["employer_industry_type"],
        employer_office_building_name: params["employer_office_building_name"],
        employer_officer_street_name: params["employer_officer_street_name"],
        employment_type: employment_type,
        hr_supervisor_email: params["hr_supervisor_email"],
        hr_supervisor_mobile_number: params["hr_supervisor_mobile_number"],
        hr_supervisor_name: params["hr_supervisor_name"],
        job_title: params["job_title"],
        occupation: params["occupation"],
        province: params["province"],
        town: params["town"],
        userId: add_employer_user.id,
        departmentId: params["departmentId"]
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:add_Personal_details, fn _repo,
                                                %{
                                                  add_employer_employee: _add_employer_employee,
                                                  add_address_details: _add_address_details,
                                                  add_employer_user: add_employer_user,
                                                  add_user_bio_data: _add_user_bio_data
                                                } ->
      Personal_Bank_Details.changeset(%Personal_Bank_Details{}, %{
        accountName: params["accountName"],
        accountNumber: params["bank_account_number"],
        bankName: params["bankName"],
        branchName: params["branchName"],
        upload_bank_statement: nil,
        userId: add_employer_user.id
      })
      |> Repo.insert()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_Personal_details: _add_Personal_details,
                                       add_employer_employee: _add_employer_employee,
                                       add_address_details: _add_address_details,
                                       add_employer_user: _add_employer_user,
                                       add_user_bio_data: _add_user_bio_data
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Added User Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_user_bio_data: add_user_bio_data}} ->
        Email.send_email(params["emailAddress"], params["password"])

        conn
        |> put_flash(
          :info,
          "You have Successfully Created #{add_user_bio_data.firstName} #{add_user_bio_data.lastName} Aa A Client"
        )
        |> redirect(to: Routes.client_management_path(conn, :client_maintainence))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.client_management_path(conn, :client_maintainence))
    end
  end

  @spec push_records_individual(Plug.Conn.t(), nil | maybe_improper_list | map) :: Plug.Conn.t()
  def push_records_individual(conn, params) do

        IO.inspect(params, label: "Param print out")
        otp = to_string(Enum.random(1111..9999))

        client_type = "Individual"
        employment_type = params["employment_type"]

            Ecto.Multi.new()
            |> Ecto.Multi.insert(
              :add_employer_user,
              User.changeset(%User{}, %{
                password: params["password"],
                status: "INACTIVE",
                username: params["emailAddress"],
                auto_password: "Y",
                company_id: params["company_id"],
                pin: otp
              })
            )
            |> Ecto.Multi.run(:add_user_bio_data, fn _repo, %{add_employer_user: add_employer_user} ->
              UserBioData.changeset(%UserBioData{}, %{
                dateOfBirth: params["dateOfBirth"],
                emailAddress: params["emailAddress"],
                firstName: params["firstName"],
                gender: params["gender"],
                lastName: params["lastName"],
                meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
                meansOfIdentificationType: params["meansOfIdentificationType"],
                mobileNumber: params["mobileNumber"],
                otherName: params["otherName"],
                title: params["title"],
                userId: add_employer_user.id,
                idNo: nil,
                bank_id: params["bank_id"],
                bank_account_number: params["bank_account_number"],
                marital_status: params["marital_status"],
                nationality: params["nationality"],
                number_of_dependants: params["number_of_dependants"],
                disability_status: params["disability_status"],
                disability_detail: params["disability_detail"]
              })
              |> Repo.insert()
            end)
            |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data } ->
              UserRole.changeset(%UserRole{}, %{
                roleType: "INDIVIDUAL",
                status: "INACTIVE",
                client_type: client_type,
                userId: add_employer_user.id,
                otp: otp
              })
              |> Repo.insert()
            end)

            |> Ecto.Multi.run(:add_client_company, fn _repo, %{add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data, add_user_role: add_user_role } ->
              Client_company_details.changeset(%Client_company_details{}, %{
                company_name: params["company_name"],
                company_account_number: params["company_account_number"],
                company_phone: params["company_phone"],
                company_registration_date: params["company_registration_date"],
                contact_email: params["contact_email"],
                registration_number: params["registration_number"],
                taxno: params["taxno"],
                bank_id: params["bank_id"],
                company_department: params["company_department"],
                status: "INACTIVE",
                createdByUserId: add_employer_user.id,
                createdByUserRoleId: add_user_role.id,
              })
              |> Repo.insert()
            end)

            |> Ecto.Multi.run(:add_employer_employee, fn _repo,%{add_user_role: add_user_role, add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data} ->
              Employee.changeset(%Employee{}, %{
                companyId: params["company_id"],
                employerId: params["company_id"],
                status: "INACTIVE",
                userId: add_employer_user.id,
                userRoleId: add_user_role.id,
                loan_limit: nil
              })
              |> Repo.insert()
            end)
            |> Ecto.Multi.run(:add_address_details, fn _repo, %{add_user_role: _add_user_role, add_employer_user: add_employer_user,add_user_bio_data: _add_user_bio_data, add_employer_employee: _add_employer_employee } ->
              Address_Details.changeset(%Address_Details{}, %{

                accomodation_status: params["accomodation_status"],
                area: params["area"],
                house_number: params["house_number"],
                street_name: params["street_name"],
                town: params["town"],
                userId: add_employer_user.id,
                year_at_current_address: params["year_at_current_address"]

              })
              |> Repo.insert()
            end)

            |> Ecto.Multi.run(:add_employment_details, fn _repo,%{add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data} ->
              Employment_Details.changeset(%Employment_Details{}, %{
                area: params["area"],
                date_of_joining: params["date_of_joining"],
                employee_number: params["employee_number"],
                employer: params["company_name"],
                employer_industry_type: params["employer_industry_type"],
                employer_office_building_name: params["employer_office_building_name"],
                employer_officer_street_name: params["employer_officer_street_name"],
                employment_type: employment_type,
                hr_supervisor_email: params["hr_supervisor_email"],
                hr_supervisor_mobile_number: params["hr_supervisor_mobile_number"],
                hr_supervisor_name: params["hr_supervisor_name"],
                job_title: params["job_title"],
                occupation: params["occupation"],
                province: params["province"],
                town: params["town"],
                userId: add_employer_user.id,
                departmentId: params["departmentId"],
              })
              |> Repo.insert()
            end)

            |> Ecto.Multi.run(:add_Personal_details, fn _repo, %{add_employer_employee: _add_employer_employee, add_address_details: _add_address_details, add_employer_user: add_employer_user, add_user_bio_data: _add_user_bio_data} ->
              Personal_Bank_Details.changeset(%Personal_Bank_Details{}, %{
                accountName: params["accountName"],
                accountNumber: params["bank_account_number"],
                bankName: params["bankName"],
                branchName: params["branchName"],
                upload_bank_statement: nil,
                userId: add_employer_user.id
              })
              |> Repo.insert()
            end)
            |> Ecto.Multi.run(:user_logs, fn _repo, %{add_Personal_details: _add_Personal_details, add_employer_employee: _add_employer_employee,add_address_details: _add_address_details, add_employer_user: _add_employer_user,add_user_bio_data: _add_user_bio_data} ->
              UserLogs.changeset(%UserLogs{}, %{
                activity: "Added User Successfully",
                user_id: conn.assigns.user.id
              })
              |> Repo.insert()
            end)


            |> Repo.transaction()
            |> case do
              {:ok, %{add_user_bio_data: add_user_bio_data}} ->
                Email.send_email(params["emailAddress"], params["password"])
                conn
                |> put_flash(:info,"You have Successfully Created #{add_user_bio_data.firstName} #{add_user_bio_data.lastName} Aa A Client")
                |> redirect(to: Routes.client_management_path(conn, :client_maintainence))

              {:error, _failed_operations, failed_value, _changes_so_far} ->
                reason = traverse_errors(failed_value.errors)

                conn
                |> put_flash(:error, reason)
                |> redirect(to: Routes.client_management_path(conn, :client_maintainence))
              end
  end

  def edit_client(conn, params) do
    IO.inspect(params["id"], label: "ppppppppppppppppppppppppppppppppppppppppppppppp")

    userbiodate = Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(params["id"])

    employment_details =
      Loanmanagementsystem.Employment.get_employment__details_by_userId(params["id"])

    personal_bank_details =
      Loanmanagementsystem.Employment.get_personal__bank__details_by_userId(params["id"])

    employee = Loanmanagementsystem.Companies.get_employee_by_userId(params["id"])

    address_details = Loanmanagementsystem.Accounts.get_address__details_by_userId(params["id"])

    update_companyId = Loanmanagementsystem.Accounts.get_user!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :update_userbiodate,
      UserBioData.changeset(userbiodate, %{
        dateOfBirth: params["dateOfBirth"],
        emailAddress: params["emailAddress"],
        firstName: params["firstName"],
        gender: params["gender"],
        lastName: params["lastName"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
        meansOfIdentificationType: params["meansOfIdentificationType"],
        mobileNumber: params["mobileNumber"],
        otherName: params["otherName"],
        title: params["title"],
        marital_status: params["marital_status"]
      })
    )
    |> Ecto.Multi.run(:update_client_id, fn _repo, %{update_userbiodate: _update_userbiodate} ->
      User.changeset(update_companyId, %{
        company_id: params["company_id"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:update_employment_details, fn _repo,
                                                     %{
                                                       update_userbiodate: _update_userbiodate,
                                                       update_client_id: _update_client_id
                                                     } ->
      Employment_Details.changeset(employment_details, %{
        area: params["employment_area"],
        date_of_joining: params["date_of_joining"],
        employee_number: params["employee_number"],
        employer: params["employer"],
        employer_industry_type: params["employer_industry_type"],
        employer_office_building_name: params["employer_office_building_name"],
        employer_officer_street_name: params["employer_officer_street_name"],
        employment_type: params["employment_type"],
        hr_supervisor_email: params["hr_supervisor_email"],
        hr_supervisor_mobile_number: params["hr_supervisor_mobile_number"],
        hr_supervisor_name: params["hr_supervisor_name"],
        job_title: params["job_title"],
        occupation: params["occupation"],
        province: params["employer_province"],
        town: params["employer_town"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:update_address_details, fn _repo,
                                                  %{
                                                    update_userbiodate: _update_userbiodate,
                                                    update_employment_details:
                                                      _update_employment_details,
                                                    update_client_id: _update_client_id
                                                  } ->
      Address_Details.changeset(address_details, %{
        accomodation_status: params["accomodation_status"],
        area: params["area"],
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        year_at_current_address: params["year_at_current_address"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:update_personal_bank, fn _repo,
                                                %{
                                                  update_userbiodate: _update_userbiodate,
                                                  update_employment_details:
                                                    _update_employment_details,
                                                  update_address_details: _update_address_details,
                                                  update_client_id: _update_client_id
                                                } ->
      Personal_Bank_Details.changeset(personal_bank_details, %{
        accountName: params["accountName"],
        accountNumber: params["bank_account_number"],
        bankName: params["bankName"],
        branchName: params["branchName"],
        upload_bank_statement: params["upload_bank_statement"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:update_employee, fn _repo,
                                           %{
                                             update_userbiodate: _update_userbiodate,
                                             update_employment_details:
                                               _update_employment_details,
                                             update_address_details: _update_address_details,
                                             update_personal_bank: _update_personal_bank,
                                             update_client_id: _update_client_id
                                           } ->
      Employee.changeset(employee, %{
        companyId: params["company_id"],
        employerId: params["company_id"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{update_employment_details: _update_employment_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated Client Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Updated Client Details")
        |> redirect(to: Routes.client_management_path(conn, :client_maintainence))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.client_management_path(conn, :client_maintainence))
    end
  end

  def activate_client(conn, params) do

    Ecto.Multi.new()
    |> Ecto.Multi.update(:activate_user, User.changeset(Loanmanagementsystem.Accounts.get_user!(params["id"]), Map.merge(params, %{"status" => "ACTIVE"})))

    |> Ecto.Multi.run(:activate_user_role, fn _repo, %{activate_user: _activate_user} ->
    user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    UserRole.changeset(user_role, %{

      status: "ACTIVE"

    })|>Repo.update()

    end)

    |> Ecto.Multi.run(:user_logs, fn (_,%{activate_user: _activate_user, activate_user_role: _activate_user_role}) ->

      UserLogs.changeset(%UserLogs{}, %{

        activity: "Activated Client Successfully ",
        user_id: conn.assigns.user.id,
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Client activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first
        json(conn, %{error: reason})
    end
  end

  def deactivate_client(conn, params) do

    Ecto.Multi.new()
    |> Ecto.Multi.update(:activate_user, User.changeset(Loanmanagementsystem.Accounts.get_user!(params["id"]), Map.merge(params, %{"status" => "INACTIVE"})))

    |> Ecto.Multi.run(:activate_user_role, fn _repo, %{activate_user: _activate_user} ->
    user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])
    UserRole.changeset(user_role, %{

      status: "INACTIVE"

    })|>Repo.update()

    end)

    |> Ecto.Multi.run(:user_logs, fn (_,%{activate_user: _activate_user, activate_user_role: _activate_user_role}) ->

      UserLogs.changeset(%UserLogs{}, %{

        activity: "Deactivated Client Successfully ",
        user_id: conn.assigns.user.id,
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Client Deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first
        json(conn, %{error: reason})
    end
  end

  def mobile_money_argents(conn, _params) do
    render(conn, "mobile_money_argents.html",
      banks: Loanmanagementsystem.Maintenance.list_tbl_banks(),
      momo_list: Loanmanagementsystem.Merchants.list_all_momo_merchants()
    )
  end

  @spec employer_maintainence(Plug.Conn.t(), any) :: Plug.Conn.t()
  def employer_maintainence(conn, _params) do
    IO.inspect(conn, label: "issgejwgsjagsjaja")

    render(conn, "employer_maintainence.html")
  end

  def employee_maintainence(conn, _params) do
    IO.inspect(conn, label: "issgejwgsjagsjaja")

    render(conn, "employee_maintainence.html")
  end

  def client_managers_relationship(conn, _params) do
    render(conn, "client_managers_relationship.html",
      client_relationship_managers: Loanmanagementsystem.Accounts.client_relationship_managers()
    )
  end

  def blacklisted_clients(conn, _params) do
    render(conn, "blacklisted_clients.html")
  end

  def fuel_importer_maintenance(conn, _params) do
    render(conn, "fuel_importer_maintenance.html")
  end

  def merchant_maintenance(conn, _params) do
    render(conn, "merchant_maintenance.html",
      banks: Loanmanagementsystem.Maintenance.list_tbl_banks(),
      agent_merchant_list: Loanmanagementsystem.Merchants.list_merchants_agent()
    )
  end

  def oct_company_lookup(conn, %{"company_id" => company_id}) do
    company_details = Loanmanagementsystem.Companies.otc_company_details_lookup(company_id)
    json(conn, %{"data" => List.wrap(company_details)})
  end

  def admin_activate_classification(conn, params) do
    classification = Loanmanagementsystem.Maintenance.get_classification!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_class,
      Classification.changeset(classification, Map.merge(params, %{"status" => "ACTIVE"}))
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{activate_class: activate_class} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated #{activate_class.classification} Classification Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{activate_class: activate_class}} ->
        json(conn, %{
          data: "#{activate_class.classification} Classification activated successfully"
        })

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_edit_employer_employee(conn, params) do
    userbiodate = Loanmanagementsystem.Accounts.get_user_boi_data_by_user_id(params["id"])
    # userrole = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])

    employment_details =
      Loanmanagementsystem.Employment.get_employment__details_by_userId(params["id"])

    personal_bank_details =
      Loanmanagementsystem.Employment.get_personal__bank__details_by_userId(params["id"])

    employee = Loanmanagementsystem.Companies.get_employee_by_userId(params["id"])
    address_details = Loanmanagementsystem.Accounts.get_address__details_by_userId(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:userbiodate, UserBioData.changeset(userbiodate, params))
    |> Ecto.Multi.run(:employment_details, fn _repo, %{userbiodate: _userbiodate} ->
      Employment_Details.changeset(employment_details, %{
        area: params["employment_area"],
        date_of_joining: params["date_of_joining"],
        employee_number: params["employee_number"],
        employer: params["employer"],
        employer_industry_type: params["employer_industry_type"],
        employer_office_building_name: params["employer_office_building_name"],
        employer_officer_street_name: params["employer_officer_street_name"],
        employment_type: params["employment_type"],
        hr_supervisor_email: params["hr_supervisor_email"],
        hr_supervisor_mobile_number: params["hr_supervisor_mobile_number"],
        hr_supervisor_name: params["hr_supervisor_name"],
        job_title: params["job_title"],
        occupation: params["occupation"],
        province: params["employer_province"],
        town: params["employer_town"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:update_address_details, fn _repo,
                                                  %{
                                                    userbiodate: _userbiodate,
                                                    employment_details: _employment_details
                                                  } ->
      Address_Details.changeset(address_details, %{
        accomodation_status: params["accomodation_status"],
        area: params["area"],
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        year_at_current_address: params["year_at_current_address"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:update_personal_bank, fn _repo,
                                                %{
                                                  userbiodate: _userbiodate,
                                                  employment_details: _employment_details,
                                                  update_address_details: _update_address_details
                                                } ->
      Personal_Bank_Details.changeset(personal_bank_details, %{
        accountName: params["accountName"],
        accountNumber: params["bank_account_number"],
        bankName: params["bankName"],
        branchName: params["branchName"],
        upload_bank_statement: params["upload_bank_statement"]
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:update_employee, fn _repo,
                                           %{
                                             userbiodate: _userbiodate,
                                             employment_details: _employment_details,
                                             update_address_details: _update_address_details,
                                             update_personal_bank: _update_personal_bank
                                           } ->
      Employee.changeset(employee, %{
        companyId: params["company_id"],
        employerId: params["company_id"]
      })
      |> Repo.update()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Updated Employee details")
        |> redirect(to: Routes.client_management_path(conn, :employee_maintainence))

      {:error, _failed_operations, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.client_management_path(conn, :employee_maintainence))
    end
  end

  def admin_activate_user(conn, params) do
    user = Loanmanagementsystem.Accounts.get_user!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_user,
      User.changeset(user, Map.merge(params, %{"status" => "ACTIVE"}))
    )
    |> Ecto.Multi.run(:activate_user_role, fn _repo, %{activate_user: _activate_user} ->
      user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])

      UserRole.changeset(user_role, %{
        status: "ACTIVE"
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:user_logs, fn _,
                                     %{
                                       activate_user: _activate_user,
                                       activate_user_role: _activate_user_role
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Activated User Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "User Activated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_deactivate_user(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :activate_user,
      User.changeset(
        Loanmanagementsystem.Accounts.get_user!(params["id"]),
        Map.merge(params, %{"status" => "INACTIVE"})
      )
    )
    |> Ecto.Multi.run(:activate_user_role, fn _repo, %{activate_user: _activate_user} ->
      user_role = Loanmanagementsystem.Accounts.get_user_role_by_user_id(params["id"])

      UserRole.changeset(user_role, %{
        status: "INACTIVE"
      })
      |> Repo.update()
    end)
    |> Ecto.Multi.run(:user_logs, fn _,
                                     %{
                                       activate_user: _activate_user,
                                       activate_user_role: _activate_user_role
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Deactivated User Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "User Deactivated successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_update_employer_maintainence(conn, params) do
    bank_id = String.to_integer(params["bank_id"])
    company = Loanmanagementsystem.Companies.get_company!(params["id"])

    params =
      Map.merge(params, %{
        "status" => "INACTIVE",
        "bank_id" => bank_id
      })

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :add_company,
      Company.changeset(company, %{
        approval_trail: params["approval_trail"],
        auth_level: params["auth_level"],
        companyName: params["companyName"],
        companyPhone: params["companyPhone"],
        contactEmail: params["contactEmail"],
        registrationNumber: params["registrationNumber"],
        status: "INACTIVE",
        taxno: params["taxno"],
        companyRegistrationDate: params["companyRegistrationDate"],
        companyAccountNumber: params["companyAccountNumber"],
        bank_id: bank_id
      })
    )
    |> Ecto.Multi.run(:user_logs, fn _repo,
                                     %{
                                       add_company: _add_company
                                     } ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Updated Company Successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    # |>Ecto.Multi.run(:document, fn (_REPO_, %{add_company: add_company}) ->
    #     upload_documents(add_company, params["document"])
    #   end)
    |> Repo.transaction()
    |> case do
      {:ok,
       %{
         add_company: _add_company,
         user_logs: _user_logs
       }} ->
        conn
        |> put_flash(:info, "You Have Successfully Updated A Company ")
        |> redirect(to: Routes.client_management_path(conn, :employer_maintainence))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.client_management_path(conn, :employer_maintainence))
    end
  end

  # LoanmanagementsystemWeb.ClientManagementController.init_acc_no_generation("10")
  # LoanmanagementsystemWeb.ClientManagementController.reset_sequence()

  #################################### RUSSELL ##############################################
  def init_acc_no_generation(product_id) do
    "#{product_id |> String.pad_leading(2, "0")}#{sequence_no()}#{to_string(Timex.day(Timex.now())) |> String.pad_leading(3, "0")}"

    # "#{sequence_no()}#{Timex.now().year}#{to_string(Timex.day(Timex.now())) |> String.pad_leading(3, "0")}"
  end

  def sequence_no() do
    query = """
    SELECT nextval('GenSequenceNumber');
    """

    {:ok, %{columns: _columns, rows: rows}} = Loanmanagementsystem.Repo.query(query, [])
    rows |> List.flatten() |> List.first() |> to_string() |> String.pad_leading(8, "0")
  end

  def reset_sequence() do
    query = """
    ALTER SEQUENCE GenSequenceNumber RESTART WITH 1
    """

    {:ok, %{columns: columns, rows: rows}} = Repo.query(query, [])
  end

  def push_to_users(multi, params) do
    otp = to_string(Enum.random(1111..9999))

    multi
    |> Ecto.Multi.run(:add_user, fn _repo, %{add_mobile_money_agent: _add_mobile_money_agent} ->
      User.changeset(%User{}, %{
        password: params["password"],
        status: "INACTIVE",
        username: params["emailAddress"],
        auto_password: "Y",
        pin: otp
      })
      |> Repo.insert()
    end)
  end

  def push_to_user_role(multi, params) do
    multi
    |> Ecto.Multi.run(:add_user_role, fn _repo,
                                         %{
                                           add_mobile_money_agent: _add_mobile_money_agent,
                                           add_user: add_user
                                         } ->
      UserRole.changeset(%UserRole{}, %{
        roleType: "Merchant",
        status: "INACTIVE",
        userId: add_user.id,
        otp: add_user.pin
      })
      |> Repo.insert()
    end)
  end

  def push_to_user_bio_data(multi, params) do
    multi
    |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                             %{
                                               add_mobile_money_agent: _add_mobile_money_agent,
                                               add_user: add_user
                                             } ->
      UserBioData.changeset(%UserBioData{}, %{
        dateOfBirth: params["dateOfBirth"],
        emailAddress: params["emailAddress"],
        firstName: params["firstName"],
        gender: params["gender"],
        lastName: params["lastName"],
        meansOfIdentificationNumber: params["meansOfIdentificationNumber"],
        meansOfIdentificationType: params["meansOfIdentificationType"],
        mobileNumber: params["mobileNumber"],
        otherName: params["otherName"],
        title: params["title"],
        userId: add_user.id,
        idNo: nil
      })
      |> Repo.insert()
    end)
  end

  def client_relationship_manager_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Accounts.get_client_and_rm(search_params, start, length)
    total_entries = total_entries(results)
    entries = entries(results)

    results = %{
      draw: draw,
      recordsTotal: total_entries,
      recordsFiltered: total_entries,
      data: entries
    }

    json(conn, results)
  end

  def total_entries(%{total_entries: total_entries}), do: total_entries
  def total_entries(_), do: 0

  def entries(%{entries: entries}), do: entries
  def entries(_), do: []

  def search_options(params) do
    length = calculate_page_size(params["length"])
    page = calculate_page_num(params["start"], length)
    draw = String.to_integer(params["draw"])
    params = Map.put(params, "isearch", params["search"]["value"])

    new_params =
      Enum.reduce(~w(columns order search length draw start _csrf_token), params, fn key, acc ->
        Map.delete(acc, key)
      end)

    {draw, page, length, new_params}
  end

  def calculate_page_num(nil, _), do: 1

  def calculate_page_num(start, length) do
    start = String.to_integer(start)
    round(start / length + 1)
  end

  def calculate_page_size(nil), do: 10
  def calculate_page_size(length), do: String.to_integer(length)

  def client_manager_item_lookup(conn, %{
        "userId" => userId
      }) do
    user_details = Loanmanagementsystem.Accounts.client_relationship_manager_lookup(userId)

    json(conn, %{"data" => List.wrap(user_details)})
  end

  def change_client_manager(conn, params) do


    IO.inspect(params, label: "CHeck Params here #####\n")
    client_account = Loanmanagementsystem.Accounts.get_customer_account!(params["id"])

    new_params =
      Map.merge(params, %{
        "loan_officer_id" => params["loan_officer_id"],
        "assignment_date" => params["assignment_date"]
      })

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :client_account,
      Loanmanagementsystem.Accounts.Customer_account.changeset(client_account, new_params)
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{client_account: client_account} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "Client Transfered to CRM with User ID #{client_account.loan_officer_id} successfully",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{client_account: _client_account}} ->
        json(conn, %{data: "Client Transfered successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  ################################### RUSSELL ##############################################














  ################################### MIZ ##############################################

  def customer_category(conn, params) do
    render(conn, "customer_category.html")
  end

  def customer_types(conn, params) do
    render(conn, "customer_types.html")
  end

  def mis_classifications(conn, params) do
    render(conn, "mis_classifications.html")
  end

  def admin_client_classifications(conn, params) do
    render(conn, "admin_client_classifications.html")
  end

  def cost_center(conn, params) do
    render(conn, "cost_center.html")
  end


  def region(conn, params) do
    render(conn, "region.html")
  end

  def town_or_district(conn, params) do
    render(conn, "town_or_district.html")
  end

  def province(conn, params) do
    render(conn, "province.html")
  end

  def relationship_manager(conn, params) do
    render(conn, "relationship_manager.html")
  end

  def relationship_officer(conn, params) do
    render(conn, "relationship_officer.html")
  end

  def business_type(conn, params) do
    render(conn, "business_type.html")
  end



  ################################### MIZ END ##############################################


  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
