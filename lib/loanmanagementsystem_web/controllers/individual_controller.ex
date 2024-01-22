defmodule LoanmanagementsystemWeb.IndividualController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false

  alias Loanmanagementsystem.{Repo, Logs.UserLogs}
  # alias Loanmanagementsystem.Accounts.User
  # alias Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Accounts.UserBioData
  # alias Loanmanagementsystem.Products
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Loan
  alias Loanmanagementsystem.Accounts
  alias Loanmanagementsystem.Loan.LoanRepayment
  alias Loanmanagementsystem.Loan.Loan_applicant_collateral
  alias Loanmanagementsystem.Accounts.Nextofkin
  alias Loanmanagementsystem.Loan.Loan_applicant_reference
  alias Loanmanagementsystem.Loan.Loan_customer_details
  alias Loanmanagementsystem.Accounts.Address_Details

  plug(
    LoanmanagementsystemWeb.Plugs.Authenticate,
    [module_callback: &LoanmanagementsystemWeb.IndividualController.authorize_role/1]
    when action not in [
           :apply_for_loans,
           :calculate_interest_and_repaymnent_amt,
           :create_loan_application,
           :create_loan_repayment,
           :create_loan_repayment_view,
           :customer_360_view,
           :generate_reference_no,
           :historic_statements,
           :loan_products,
           :loan_products_capturing,
           :loan_repayment_datatable,
           :loan_tracking,
           :mini_statements,
           :pending_loans,
           :rejected_loans,
           :repayment_loan,
           :select_loan_to_apply,
           :traverse_errors,
           :update_profile,
           :individual_maintainence,
           :individual_instant_loan_application
         ]
  )

  use PipeTo.Override

  def apply_for_loans(conn, _params),
    do:
      render(conn, "apply_for_loans.html",
        loan_details: Loan.get_loan_by_userId_individualview_pending_loan(conn.assigns.user.id)
      )

  def pending_loans(conn, _params) do
    loan_details = Loan.get_loan_by_userId_individualview_pending_loan(conn.assigns.user.id)

    render(conn, "pending_loans.html", loan_details: loan_details)
  end

  def rejected_loans(conn, _params) do
    loan_details = Loan.get_loan_by_userId_individualview_reject(conn.assigns.user.id)
    render(conn, "rejected_loan.html", loan_details: loan_details)
  end

  def loan_tracking(conn, _params) do
    loan_details =
      Loanmanagementsystem.Operations.get_loan_by_userId_individualview_loan_tracking(
        conn.assigns.user.id
      )

    render(conn, "loan_tracking.html", loan_details: loan_details)
  end

  def repayment_loan(conn, _params) do
    products =
      Loanmanagementsystem.Operations.get_products_individual()
      |> Enum.reject(&(&1.status != "ACTIVE"))

    render(conn, "repayment_loan.html", products: products)
  end

  def customer_360_view(conn, _params),
    do:
      render(conn, "customer_360_view.html",
        current_user_details: Loanmanagementsystem.Accounts.get_details(conn.assigns.user.id),
        loan_details: Loanmanagementsystem.Operations.get_loan_by_userid(conn.assigns.user.id)
      )

  def mini_statements(conn, _params),
    do:
      render(conn, "mini_statements.html",
        loan_details:
          Loanmanagementsystem.Operations.get_user_info_by_user_id(conn.assigns.user.id)
      )

  def historic_statements(conn, _params),
    do:
      render(conn, "historic_statements.html",
        loan_details:
          Loanmanagementsystem.Operations.get_loan_by_userId_individualview_loan_tracking(
            conn.assigns.user.id
          )
      )

  def loan_products(conn, _params),
    do:
      render(conn, "loan_products.html",
        products:
          Loanmanagementsystem.Operations.get_products_individual()
          |> Enum.reject(&(&1.status != "ACTIVE"))
      )

  def select_loan_to_apply(conn, _params),
    do:
      render(conn, "select_loan_product.html",
        products:
          Loanmanagementsystem.Operations.get_products_individual()
          |> Enum.reject(&(&1.status != "ACTIVE"))
      )

  def loan_products_capturing(conn, %{"product_id" => product_id}) do
    user_id = conn.assigns.user.id
    get_bio_datas = Accounts.get_details(user_id)
    product_details = Loanmanagementsystem.Products.otc_product_details_lookup(product_id)
    address_details = Loanmanagementsystem.Operations.get_individual_address_details(user_id)
    reference_details = Loan.list_customer_reference_details(user_id)
    client_data = Loanmanagementsystem.Operations.get_client_by_userid(user_id)

    nextofkin =
      try do
        Loan.list_customer_nextofkin_details(user_id) ||
          %{
            applicant_nrc: "",
            kin_ID_number: "",
            kin_first_name: "",
            kin_gender: "",
            kin_last_name: "",
            kin_mobile_number: "",
            kin_other_name: "",
            kin_personal_email: "",
            kin_relationship: "",
            kin_status: "",
            userID: "",
            reference_no: ""
          }
      rescue
        _ -> nil
      end

    render(conn, "apply_for_loans_registration.html",
      product_details: product_details,
      get_bio_datas: get_bio_datas,
      address_details: address_details,
      reference_details: reference_details,
      nextofkin: nextofkin,
      client_data: client_data,
      employment_details:
        Loanmanagementsystem.Employment.list_customer_reference_details_validation(
          client_data.userId
        ),
      relationship_officer: Loan.list_customer_relationship_officer()
    )
  end

  def loan_repayment_datatable(conn, _params) do
    loan_details =
      Loanmanagementsystem.Operations.get_loan_by_user_id_for_repayment(conn.assigns.user.id)

    render(conn, "loan_repayment_datatable.html", loan_details: loan_details)
  end

  def create_loan_repayment_view(conn, params),
    do:
      render(conn, "create_repayment.html",
        loan_details: Loanmanagementsystem.Operations.get_loan_by_loan_id(params["loan_id"]),
        get_bio_datas: Accounts.get_details(conn.assigns.user.id),
        product_details:
          Loanmanagementsystem.Operations.get_products_individual_by_product_id(
            params["product_id"]
          )
      )

  def calculate_interest_and_repaymnent_amt(params) do
    interest_rate =
      Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).interest

    yearLengthInDays =
      Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).yearLengthInDays

    principle_amt =
      try do
        String.to_integer(params["amount"])
      rescue
        _ -> String.to_float(params["amount"])
      end

    tenor =
      try do
        String.to_integer(params["tenor"])
      rescue
        _ -> String.to_float(params["tenor"])
      end

    interest = principle_amt * interest_rate * tenor / yearLengthInDays / 100
    repayment = principle_amt + interest

    %{
      interest_amt: interest,
      repayement_amt: repayment
    }
  end

  def create_loan_application(conn, params) do
    loan_calculations = calculate_interest_and_repaymnent_amt(params)

    new_params =
      Map.merge(params, %{
        "customer_id" => conn.assigns.user.id,
        "principal_amount_proposed" => params["amount"],
        "loan_status" => "PENDING_APPROVAL",
        "status" => "PENDING_APPROVAL",
        "currency_code" => params["currency_code"],
        "loan_type" => params["product_type"],
        "principal_amount" => params["amount"],
        "repayment_amount" => loan_calculations.repayement_amt,
        "interest_amount" => loan_calculations.interest_amt,
        "balance" => loan_calculations.repayement_amt,
        "reference_no" =>
          LoanmanagementsystemWeb.LoanController.generate_reference_no(
            Integer.to_string(conn.assigns.user.id)
          ),
        "requested_amount" => params["amount"],
        "application_date" => Date.utc_today()
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:add_loan, Loans.changeset(%Loans{}, new_params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Loan Application Successfully Submitted",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_loan: _add_loan, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Loan Application Submitted")
        |> redirect(to: Routes.individual_path(conn, :pending_loans))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.individual_path(conn, :pending_loans))
    end
  end



  def individual_instant_loan_application(conn, params) do
    customer_id = conn.assigns.user.id
    reference_no = generate_reference_no(Integer.to_string(customer_id))

    monthly_installment =
      if is_float(params["monthly_installment"]) do
        params["monthly_installment"]
      else
        String.to_float(params["monthly_installment"])
      end

    loan_duration_month = Loanmanagementsystem.SmallOperations.change_datatype(params["loan_duration_month"])

    balance = (monthly_installment * loan_duration_month)

    IO.inspect(params, label: "---------------------------- params")

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :laon_details,
      Loans.changeset(%Loans{}, %{
        product_id: params["product_id"],
        customer_id: customer_id,
        loan_type: params["loan_type"],
        principal_amount: params["requested_amount"],
        principal_amount_proposed: params["requested_amount"],
        loan_status: "PENDING_CREDIT_ANALYST",
        status: "PENDING_CREDIT_ANALYST",
        loan_userroleid: conn.private.plug_session["current_user_role"].id,
        reference_no: reference_no,
        requested_amount: params["requested_amount"],
        loan_duration_month: params["loan_duration_month"],
        monthly_installment: params["monthly_installment"],
        proposed_repayment_date: params["proposed_repayment_date"],
        loan_purpose: params["loan_purpose"],
        application_date: Date.utc_today(),
        cro_id: params["cro_id"],
        term_frequency: params["term_frequency"],
        balance: balance
      })
    )
    |> Ecto.Multi.run(:address_update, fn _repo, %{laon_details: _laon_details} ->
      address = Loanmanagementsystem.Operations.get_address_by_userId(conn.assigns.user.id)

      address_details = %{
        house_number: params["house_number"],
        street_name: params["street_name"],
        town: params["town"],
        province: params["province"],
        land_mark: params["land_mark"]
      }

      case Repo.update(Address_Details.changeset(address, address_details)) do
        {:ok, message} -> {:ok, message}
        {:error, reason} -> {:error, reason}
      end
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo, %{laon_details: laon_details} ->
      #    # ----------------------------------- Collateral
      collateral = params["name_of_collateral"]

      if collateral == nil || collateral == [] || collateral == ["undefined"] do
        IO.puts("No Reference Attachment Detected")
      else
        for x <- 0..(Enum.count(collateral) - 1) do
          collateral_params = %{
            customer_id: laon_details.customer_id,
            reference_no: laon_details.reference_no,
            asset_value: Enum.at(params["asset_value"], x),
            color: Enum.at(params["color"], x),
            id_number: Enum.at(params["id_number_collateral"], x),
            name_of_collateral: Enum.at(params["name_of_collateral"], x),
            #  applicant_signature: applicant_signature_encode_img,
            name_of_witness: params["name_of_witness"],
            #  witness_signature: witness_signature_encode_img,
            cro_staff_name: params["cro_staff_name"]
            #  cro_staff_signature:  cro_staff_signature_encode_img,
          }

          Loan_applicant_collateral.changeset(%Loan_applicant_collateral{}, collateral_params)
          |> Repo.insert()
        end
      end

      # -------------------------------------Next of Kin
      Nextofkin.changeset(%Nextofkin{}, %{
        userID: customer_id,
        reference_no: reference_no,
        kin_first_name: params["kin_first_name"],
        kin_last_name: params["kin_last_name"],
        kin_other_name: params["kin_other_name"],
        kin_status: params["kin_status"],
        kin_relationship: params["kin_relationship"],
        kin_gender: params["kin_gender"],
        kin_mobile_number: params["kin_mobile_number"]
      })
      |> Repo.insert()

      # ----------------------------------- Reference
      reference_name = params["name"]

      if reference_name == nil || reference_name == [] || reference_name == ["undefined"] do
        IO.puts("No Reference Attachment Detected")
      else
        for x <- 0..(Enum.count(reference_name) - 1) do
          reference_params = %{
            customer_id: customer_id,
            reference_no: reference_no,
            name: Enum.at(reference_name, x),
            contact_no: Enum.at(params["contact_no"], x)
          }

          Loan_applicant_reference.changeset(%Loan_applicant_reference{}, reference_params)
          |> Repo.insert()
        end
      end

      Loan_customer_details.changeset(%Loan_customer_details{}, %{
        customer_id: customer_id,
        reference_no: reference_no,
        firstname: params["firstname"],
        surname: params["surname"],
        othername: params["othername"],
        id_type: params["id_type"],
        id_number: params["id_number"],
        gender: params["gender"],
        marital_status: params["marital_status"],
        cell_number: params["cell_number"],
        email: params["email"],
        dob: params["dob"],
        residential_address: params["house_number"],
        landmark: params["landmark"],
        town: params["town"],
        province: params["province"]
      })
      |> Repo.insert()
    end)
    |> IO.inspect(label: "---------------------------- all records")
    |> Repo.transaction()
    |> case do
      {:ok, %{laon_details: _laon_details}} ->
        loan_details = Loans.find_by(reference_no: reference_no)

        nrc =
          try do
            Loanmanagementsystem.Accounts.UserBioData.find_by(userId: customer_id).meansOfIdentificationNumber
          rescue
            _ -> ""
          end

        Loanmanagementsystem.Services.LoanDocumentsUploads.client_upload(%{
          "process_documents" => params,
          "conn" => conn,
          "nrc" => nrc,
          "loan_id" => loan_details.id,
          "file_category" => "LOAN_DOCUMENTS"
        })

        conn
        |> put_flash(:info, "Loan Application Submitted")
        |> redirect(to: Routes.individual_path(conn, :pending_loans))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.individual_path(conn, :pending_loans))
    end
  end

  def generate_reference_no(customer_id) do
    date = Timex.today()
    year = to_string(date.year)
    month = to_string(date.month)
    day = to_string(date.day)
    start_of_year_date = Timex.beginning_of_year(date)
    current_year = date
    date_difference = to_string(Date.diff(current_year, start_of_year_date))

    "A-" <>
      "" <>
      year <>
      "" <>
      month <>
      "" <>
      day <>
      "" <>
      "." <>
      "" <>
      date_difference <>
      "" <> "" <> "." <> "" <> customer_id <> "" <> "." <> to_string(System.system_time(:second))
  end

  def generate_reference_no do
    date = Timex.today()
    year = to_string(date.year)
    month = to_string(date.month)
    day = to_string(date.day)
    start_of_year_date = Timex.beginning_of_year(date)
    current_year = date
    date_difference = to_string(Date.diff(current_year, start_of_year_date))

    "LRP" <>
      "" <>
      year <>
      "" <>
      month <>
      "" <>
      day <>
      "" <> "." <> "" <> date_difference <> "" <> to_string(System.system_time(:microsecond))
  end

  def create_loan_repayment(conn, params) do
    new_params =
      Map.merge(params, %{
        "reference_no" => generate_reference_no(),
        "repayment" => params["repayment_type"],
        "modeOfRepayment" => params["repayment_method"],
        "dateOfRepayment" => to_string(Timex.today()),
        "loan_product" => params["product_name"],
        "status" => "SUCCESS",
        # "status" => "PENDING_PAYMENT",
        "loan_id" => String.to_integer(String.trim(params["loan_primary_id"])),
        "registeredByUserId" => conn.assigns.user.id
      })

    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :create_loan_repayment_view,
      LoanRepayment.changeset(%LoanRepayment{}, new_params)
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{create_loan_repayment_view: _add_loan} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Loan Repayment is in progress ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{create_loan_repayment_view: _create_loan_repayment_view, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Loan Repayment is in progress.")
        |> redirect(
          to:
            Routes.individual_path(conn, :loan_repayment_datatable,
              loan_id: params["loan_id"],
              product_id: params["product_id"]
            )
        )

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(
          to:
            Routes.individual_path(conn, :loan_repayment_datatable,
              loan_id: params["loan_id"],
              product_id: params["product_id"]
            )
        )
    end
  end

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")

  def update_profile(conn, params) do
    clients_profile = Loanmanagementsystem.Accounts.get_user_bio_data!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(:clients_profile, UserBioData.changeset(clients_profile, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{clients_profile: _clients_profile} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Updated the profile Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{clients_profile: _clients_profile, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Updated the profile successfully!")
        |> redirect(to: Routes.individual_path(conn, :customer_360_view))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.individual_path(conn, :customer_360_view))
    end
  end

  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:client, :create}
      act when act in ~w(index view)a -> {:client, :view}
      act when act in ~w(update edit)a -> {:client, :edit}
      act when act in ~w(change_status)a -> {:client, :change_status}
      _ -> {:client, :unknown}
    end
  end
end
