defmodule LoanmanagementsystemWeb.LoanController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Loan.LoanTransaction
  alias Loanmanagementsystem.Notifications.Sms
  alias Loanmanagementsystem.Loan.Loan_customer_details
  alias Loanmanagementsystem.Accounts.Nextofkin
  alias Loanmanagementsystem.Loan.Loan_applicant_reference
  alias Loanmanagementsystem.Loan.Loan_applicant_collateral
  alias Loanmanagementsystem.Loan.Loan_applicant_guarantor
  alias Loanmanagementsystem.Loan
  alias Loanmanagementsystem.Loan.Loan_recommendation_and_assessment
  alias Loanmanagementsystem.Loan.Loan_market_info
  alias Loanmanagementsystem.Loan.Loan_employment_info
  alias Loanmanagementsystem.Loan.Loan_disbursement_schedule
  alias Loanmanagementsystem.Loan.Loan_amortization_schedule
  # alias Loanmanagementsystem.Employment.Employment_Details
  alias Loanmanagementsystem.Loan.Loan_5cs
  alias Loanmanagementsystem.Loan.Loan_checklist
  alias Loanmanagementsystem.Loan.Loan_credit_score
  alias Loanmanagementsystem.Loan.Loan_disbursement
  alias Loanmanagementsystem.Core_transaction.Journal_entries
  alias Loanmanagementsystem.Loan.Loan_income_assessment
  alias Loanmanagementsystem.Loan.Writtenoff_loans
  alias Loanmanagementsystem.Accounts.Address_Details


  plug LoanmanagementsystemWeb.Plugs.Authenticate,
          [module_callback: &LoanmanagementsystemWeb.LoanController.authorize_role/1]
          when action not in [
            :admin_disbursed_loan,
            :admin_write_off_loan,
            :approve_loan,
            :calculate_interest_and_repaymnent_amt,
            :calculate_maturity_repayments,
            :calculate_page_num,
            :calculate_page_size,
            :calculates_page_num,
            :calculates_page_size,
            :client_statement_item_lookup,
            :create_float_advance_application,
            :create_invoice_discounting_application,
            :create_loan_application,
            :create_order_finance_application,
            :create_universal_loan_application,
            :create_quick_loan_application,
            :create_trade_advance_application,
            :customer_disbursed_item_lookup,
            :customer_loans_item_lookup,
            :customer_loans_list_write_off,
            :customer_pending_item_lookup,
            :disbursed_loans,
            :edit_loan_application,
            :entries,
            :entriess,
            :export_loan_statement_pdf,
            :float_advance_application_datatable,
            :float_advance_capturing,
            :float_advance_item_lookup,
            :get_all_complete_loan_statement,
            :get_all_complete_loan_statement_pdf,
            :get_otp,
            :init,
            :invoice_discounting_application_datatable,
            :invoice_discounting_capturing,
            :invoice_discounting_item_lookup,
            :loan_client_statement_datatable,
            :loans,
            :order_finance_application_datatable,
            :order_finance_capturing,
            :order_finance_item_lookup,
            :otp_validation,
            :outstanding_loans,
            :pending_loans,
            :quick_advance_application_datatable,
            :quick_advance_loan_item_lookup,
            :universal_loan_application_capturing,
            :quick_loan_application_datatable,
            :quick_loan_capturing,
            :quick_loan_item_lookup,
            :reject_loan,
            :reports_generators_loan_statement,
            :return_off_loans,
            :earch_options,
            :searchs_loan_statement_options,
            :select_quick_advance,
            :send_otp,
            :total_entries,
            :totals_entries,
            :tracking_loans,
            :trade_advance_application_datatable,
            :trade_advance_capturing,
            :trade_advance_item_lookup,
            :traverse_errors,
            :validate_otp,
            :view_loan_application,
            :view_universal_loan_application,
            :edit_universal_loan_application,
            :update_universal_loan_application,
            :update_loan_reference,
            :discard_loan_reference,
            :create_loan_reference,
            :update_loan_collateral_details,
            :discard_loan_collateral,
            :create_loan_collateral,
            :view_before_approving_loan_application,
            :credit_analyst_loan_approval,
            :reject_loan_application,
            :edit_rejected_universal_loan_application,
            :credit_manager_approving_loan_application_view,
            :credit_manager_loan_approval,
            :accounts_assistant_approving_loan_application_view,
            :accounts_assistant_loan_approval,
            :finance_manager_approving_loan_application_view,
            :finance_manager_loan_approval,
            :executive_committe_approving_loan_application_view,
            :executive_committe_loan_approval,
            :create_instant_loan_application,
            :create_salarybacked_loan_application,
            :update_salarybacked_loan_application,
            :update_instant_loan_application,
            :render_amortization,
            :calculate_amortization,
            :view_before_approving_loan_application_operations,
            :operations_loan_approval,
            :legal_counsel_loan_approval,
            :legal_approving_loan_application_view,
            :sales_loan_approval,
            :view_before_approving_loan_application_sales,
            :payment_requisition_form,
            :create_loan_payment_requisition,
            :cfo_approve_loan_payment_requisition,
            :cfo_payment_requisition_form,
            :ceo_approve_loan_payment_requisition,
            :ceo_payment_requisition_form,
            :add_client_documents,
            :writeoff_loan,
            :loan_bulkupload,
            :handle_loan_bulkupload,
            :handle_legal_document_posting,
            :mark_has_repaid_loan,
            :edit_credit_analyst_loan_file_input,
            :update_credit_analyst_loan_application,
            :add_client_crb_documents



       ]

use PipeTo.Override


  def loans(conn, _params), do: render(conn, "loans.html")
  def pending_loans(conn, _params), do: render(conn, "pending_loans.html")
  def tracking_loans(conn, _params), do: render(conn, "tracking_loans.html")
  def disbursed_loans(conn, _params), do: render(conn, "disbursed_loans.html")
  def outstanding_loans(conn, _params), do: render(conn, "outstanding_loans.html")
  def return_off_loans(conn, _params), do: render(conn, "return_off_loans.html")

  def quick_advance_application_datatable(conn, _params),
    do: render(conn, "quick_advance_application.html")

  def quick_loan_application_datatable(conn, _params),
    do: render(conn, "quick_loan_application.html")

  def float_advance_application_datatable(conn, _params),
    do: render(conn, "float_advance_application.html")

  def order_finance_application_datatable(conn, _params),
    do: render(conn, "order_finance_application.html")

  def trade_advance_application_datatable(conn, _params),
    do: render(conn, "trade_advance_application.html")

  def invoice_discounting_application_datatable(conn, _params),
    do: render(conn, "invoice_discounting_application.html")

  def current_time do
    {_erl_date, erl_time} = :calendar.local_time()
    {:ok, time} = Time.from_erl(erl_time)
    Calendar.strftime(time, "%c", preferred_datetime: "%H:%M:%S")
  end

  def universal_loan_application_capturing(conn, params) do
   product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
   if product_type == "Instant Loan" do
    nrc = params["nrc"]
    client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
    customers_address = try do Loanmanagementsystem.Accounts.get_client_address_details(client_data.userId) ||
    %{
      accomodation_status: "",
      area: "",
      house_number: "",
      landmark: "",
      street_name: "",
      town: "",
      province: "",
      year_at_current_address: "",
    }
    rescue _->
      conn
      |> put_flash(:error, "Something went wrong, try again.")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
     end
    nextofkin = try do  Loan.list_customer_nextofkin_details(client_data.userId) ||
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
        reference_no: "",
      }
    rescue _->
    conn
    |> put_flash(:error, "Something went wrong, try again.")
    |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end
    render(conn, "instant_loan_application.html",
      current_time: current_time(),
      product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
      product_rate_details:
        Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
      frequencies:
        Loanmanagementsystem.Products.Product_rates.find_by(product_id: params["product_id"]),
        client_data: client_data,
        customers_address: customers_address,
        nextofkin: nextofkin,
        reference_details: Loan.list_customer_reference_details(client_data.userId),
        market_info: Loan.list_business_market_info_validation_instant_loan(client_data.userId),
        relationship_officer: Loan.list_customer_relationship_officer()

    )
   else
    if product_type == "Business Loan" do
      nrc = params["nrc"]
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      company_details = Loanmanagementsystem.Accounts.get_client_company_details(client_data.userId)
      customers_address = try do Loanmanagementsystem.Accounts.get_client_address_details(client_data.userId) ||
    %{
      accomodation_status: "",
      area: "",
      house_number: "",
      landmark: "",
      street_name: "",
      town: "",
      province: "",
      year_at_current_address: "",
    }
    rescue _->
      conn
      |> put_flash(:error, "Something went wrong, try again.")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
     end
    nextofkin = try do  Loan.list_customer_nextofkin_details(client_data.userId) ||
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
        reference_no: "",
      }
    rescue _->
    conn
    |> put_flash(:error, "Something went wrong, try again.")
    |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end

      render(conn, "universal_loan_application.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details:
          Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        frequencies:
          Loanmanagementsystem.Products.Product_rates.find_by(product_id: params["product_id"]),
          client_data: client_data,
          customers_address: customers_address,
          company_details: company_details,
          nextofkin: nextofkin,
          reference_details: Loan.list_customer_reference_details(client_data.userId),
          relationship_officer: Loan.list_customer_relationship_officer()
      )
    else
      if product_type == "Salary Backed Loan" do
        nrc = params["nrc"]
        client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
        customers_address = try do Loanmanagementsystem.Accounts.get_client_address_details(client_data.userId) ||
        %{
          accomodation_status: "",
          area: "",
          house_number: "",
          landmark: "",
          street_name: "",
          town: "",
          province: "",
          year_at_current_address: "",
        }
        rescue _->
          conn
          |> put_flash(:error, "Something went wrong, try again.")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
        end
        nextofkin = try do  Loan.list_customer_nextofkin_details(client_data.userId) ||
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
            reference_no: "",
          }
        rescue _->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
        end

        render(conn, "salary_loan_application.html",
          current_time: current_time(),
          product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
          product_rate_details:
            Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
          frequencies:
            Loanmanagementsystem.Products.Product_rates.find_by(product_id: params["product_id"]),
            client_data: client_data,
            customers_address: customers_address,
            nextofkin: nextofkin,
            reference_details: Loan.list_customer_reference_details(client_data.userId),
            employment_details: Loanmanagementsystem.Employment.list_customer_reference_details_validation(client_data.userId),
            relationship_officer: Loan.list_customer_relationship_officer()
        )
      else
          conn
          |> put_flash(:error, "Something went wrong, try again.")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
    end
   end
  end

  def quick_loan_capturing(conn, params),
    do:
      render(conn, "quick_loan_capturing.html",
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details:
          Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        frequencies:
          Loanmanagementsystem.Products.Product_rates.find_by(product_id: params["product_id"]).repayment
      )

  def float_advance_capturing(conn, params),
    do:
      render(conn, "float_advance_capturing.html",
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details:
          Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        frequencies:
          Loanmanagementsystem.Products.Product_rates.find_by(product_id: params["product_id"]).repayment
      )

  def order_finance_capturing(conn, params),
    do:
      render(conn, "order_finance_loan_capturing.html",
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details:
          Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        frequencies:
          Loanmanagementsystem.Products.Product_rates.find_by(product_id: params["product_id"]).repayment
      )

  def trade_advance_capturing(conn, params),
    do:
      render(conn, "trade_advance_loan_capturing.html",
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details:
          Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        frequencies:
          Loanmanagementsystem.Products.Product_rates.find_by(product_id: params["product_id"]).repayment
      )

  def invoice_discounting_capturing(conn, params),
    do:
      render(conn, "invoice_discounting_capturing.html",
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details:
          Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        frequencies:
          Loanmanagementsystem.Products.Product_rates.find_by(product_id: params["product_id"]).repayment
      )

  def loan_client_statement_datatable(conn, _params) do
    date = Timex.now()

    date =
      date
      |> Timex.to_datetime()
      |> Calendar.DateTime.shift_zone!("Africa/Cairo")
      |> Calendar.Strftime.strftime!("%d %B, %Y")

    render(conn, "client_statement.html", date: date)
  end

  def view_loan_application(conn, params) do
    loan = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])
    customer_details = Loanmanagementsystem.Accounts.get_user_by_bio_data(loan.customer_id)
    product_details = Loanmanagementsystem.Products.product_details_list(loan.product_id)

    loan_details = Loanmanagementsystem.Loan.get_loan_by_userId_and_loanId(loan.customer_id, loan.id)

    render(conn, "view_loan_application.html", product_details: product_details, loan_details: loan_details, customer_details: customer_details)
  end

  def edit_loan_application(conn, params) do
    loan = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])
    customer_details = Loanmanagementsystem.Accounts.get_user_by_bio_data(loan.customer_id)
    product_details = Loanmanagementsystem.Products.product_details_list(loan.product_id)

    loan_details =
      Loanmanagementsystem.Loan.get_loan_by_userId_and_loanId(loan.customer_id, loan.id)

    render(conn, "edit_loan_application.html",
      product_details: product_details,
      loan_details: loan_details,
      customer_details: customer_details
    )
  end

  def customer_loans_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.customer_loans_list(search_params, start, length)
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

  def customer_pending_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.customer_pending_list(search_params, start, length)
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

  def customer_disbursed_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.customer_disbursed_list(search_params, start, length)
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

  def quick_advance_loan_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.loan_application_listing(search_params, start, length)
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

  def quick_loan_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.quick_loan_list(search_params, start, length)
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

  def float_advance_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.float_advance_list(search_params, start, length)
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

  def order_finance_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.order_finance_list(search_params, start, length)
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

  def trade_advance_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.trade_advance_list(search_params, start, length)
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

  def invoice_discounting_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.invoice_discounting_list(search_params, start, length)
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

  def admin_disbursed_loan(conn, params) do
    loan_details = Loanmanagementsystem.Loan.get_loans!(String.to_integer(params["id"]))
    maturity_date = Date.add(Timex.today(), loan_details.tenor)

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :disburse_loan,
      Loans.changeset(
        Loanmanagementsystem.Loan.get_loans!(String.to_integer(params["id"])),
        Map.merge(params, %{
          "status" => "DISBURSED",
          "closedon_date" => maturity_date,
          "loan_status" => "DISBURSED",
          "disbursedon_date" => Date.utc_today()
        })
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{disburse_loan: _disburse_loan} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Loan Disbursed Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Loan Disbursed successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def admin_write_off_loan(conn, params) do
    current_user = conn.assigns.user.id

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :disburse_loan,
      Loans.changeset(
        Loanmanagementsystem.Loan.get_loans!(String.to_integer(params["id"])),
        Map.merge(params, %{
          "status" => "WRITTEN_OFF",
          "loan_status" => "WRITTEN_OFF",
          "writtenoffon_date" => Date.utc_today()
        })
      )
    )
    |> Ecto.Multi.run(:user_logs, fn _, %{disburse_loan: _disburse_loan} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "Loan with id #{params["id"]} has been Written Off Successfully by user with USER ID #{current_user}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        json(conn, %{data: "Loan Written Off successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  def calculate_interest_and_repaymnent_amt(params) do
    with(false <- params["product_id"] == "" || params["tenor_log"] == "") do
      repayment_frequency =
        Loanmanagementsystem.Products.Product_rates.find_by(
          product_id: params["product_id"],
          tenor: params["tenor_log"]
        ).repayment

      rate =
        Loanmanagementsystem.Products.Product_rates.find_by(
          product_id: params["product_id"],
          tenor: params["tenor_log"]
        ).interest_rates

      processing_fee =
        Loanmanagementsystem.Products.Product_rates.find_by(
          product_id: params["product_id"],
          tenor: params["tenor_log"]
        ).processing_fee

      currency =
        Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).currencyName

      principle_amt =
        try do
          String.to_integer(params["amount"])
        rescue
          _ -> String.to_float(params["amount"])
        end

      tenor =
        try do
          String.to_integer(params["tenor_log"])
        rescue
          _ -> String.to_float(params["tenor_log"])
        end

      case repayment_frequency do
        "Daily" ->
          days = 1
          interest_rate = rate + processing_fee
          interest = days / tenor * principle_amt * interest_rate / 100
          repayment = principle_amt + interest

          %{
            interest_amt: Float.round(interest, 2),
            repayement_amt: Float.round(repayment, 2),
            tenor: tenor,
            currency_code: currency
          }

        "Weekly" ->
          days = 7
          interest_rate = rate + processing_fee
          interest = days / tenor * principle_amt * interest_rate / 100
          repayment = principle_amt + interest

          %{
            interest_amt: Float.round(interest, 2),
            repayement_amt: Float.round(repayment, 2),
            tenor: tenor,
            currency_code: currency
          }

        "Monthly" ->
          days = 30
          interest_rate = rate
          interest = days / tenor * principle_amt * interest_rate / 100
          repayment = principle_amt + interest

          %{
            interest_amt: Float.round(interest, 2),
            repayement_amt: Float.round(repayment, 2),
            tenor: tenor,
            currency_code: currency
          }
      end
    else
      _ ->
        %{
          interest_amt: "",
          repayement_amt: "",
          tenor: "",
          currency_code: ""
        }
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
    "A-" <> "" <> year <> "" <> month <> "" <> day <>"" <> "." <> "" <> date_difference <> "" <> "" <> "." <> "" <> customer_id <> "" <> "." <> to_string(System.system_time(:second))
  end

  def generate_reference_no_bulkupload(customer_id) do
    cust_id = to_string(customer_id)
    date = Timex.today()
    year = to_string(date.year)
    month = to_string(date.month)
    day = to_string(date.day)
    start_of_year_date = Timex.beginning_of_year(date)
    current_year = date
    date_difference = to_string(Date.diff(current_year, start_of_year_date))
    "A-" <> "" <> year <> "" <> month <> "" <> day <>"" <> "." <> "" <> date_difference <> "" <> "" <> "." <> "" <> cust_id <> "" <> "." <> to_string(System.system_time(:second))
  end

  def image_data_applicant_signature(params) do
    case Map.has_key?(params, "applicant_signature_image") do
      true -> %{filename: _img_name, path: _img_path} = params["applicant_signature_image"]
      false -> false
    end
  end

  def image_data_witness_signature(params) do
    case Map.has_key?(params, "witness_signature_image") do
      true -> %{filename: _img_name, path: _img_path} = params["witness_signature_image"]
      false -> false
    end
  end

  def image_data_cro_staff_signature(params) do
    case Map.has_key?(params, "cro_staff_signature_image") do
      true -> %{filename: _img_name, path: _img_path} = params["cro_staff_signature_image"]
      false -> false
    end
  end

  def image_data_gaurantor_signature(params) do
    case Map.has_key?(params, "gaurantor_signature_image") do
      true -> %{filename: _img_name, path: _img_path} = params["gaurantor_signature_image"]
      false -> false
    end
  end

  def image_data_guarantor_witness_signature(params) do
    case Map.has_key?(params, "guarantor_witness_signature_image") do
      true -> %{filename: _img_name, path: _img_path} = params["guarantor_witness_signature_image"]
      false -> false
    end
  end

  def parse_image(path) do
    path
    |> File.read!()
    |> Base.encode64()
  end

  def create_universal_loan_application(conn, params) do
    # if Enum.dedup(params["filename"]) != [""] do
      new_params =
        Map.merge(params, %{
          "principal_amount_proposed" => params["requested_amount"],
          "loan_status" => "PENDING_CREDIT_ANALYST",
          "status" => "PENDING_CREDIT_ANALYST",
          "reference_no" =>  generate_reference_no(params["customer_id"]),
        })
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:add_loan, Loans.changeset(%Loans{}, new_params))
      |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Loan Application Successfully Submitted",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
        # ------------------------------------Loan Customer details
        Loan_customer_details.changeset(%Loan_customer_details{}, %{
          customer_id: params["customer_id"],
          reference_no: new_params["reference_no"],
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
          residential_address: params["residential_address"],
          landmark: params["landmark"],
          town: params["town"],
          province: params["province"],
          designation: params["designation"],
          company_name: params["company_name"],
          company_phone_no: params["company_phone_no"],
          company_email: params["company_email"],
          company_tpin: params["company_tpin"],
        })
        |> Repo.insert()
        # ---------------------------------------- Client income statement assessment
     Loan_income_assessment.changeset(%Loan_income_assessment{}, %{
      customer_id: params["customer_id"],
      reference_no: new_params["reference_no"],
      business_type: params["business_type"],
      jan: params["jan"],
      jan_bank_stat: params["jan_bank_stat"],
      jan_mobile_stat: params["jan_mobile_stat"],
      jan_total: params["jan_total"],
      dec: params["dec"],
      dec_bank_stat: params["dec_bank_stat"],
      dec_mobile_stat: params["dec_mobile_stat"],
      dec_total: params["dec_total"],
      nov: params["nov"],
      nov_bank_stat: params["nov_bank_stat"],
      nov_mobile_stat: params["nov_mobile_stat"],
      nov_total: params["nov_total"],
      average_income: params["average_income"],
      dstv: params["dstv"],
      food: params["food"],
      school: params["school"],
      utilities: params["utilities"],
      loan_installment: params["loan_installment"],
      salaries: params["salaries"],
      stationery: params["stationery"],
      transport: params["transport"],
      total_expenses: params["total_expenses"],
      available_income: params["available_income"],
      loan_installment_total: params["loan_installment_total"],
      dsr: params["dsr"],

    })
    |> Repo.insert()
        # ----------------------------------- Reference
        reference_name = params["name"]
        if reference_name == nil || reference_name == [] || reference_name == ["undefined"] do
          IO.puts "No Reference Attachment Detected"
        else
          for x <- 0..(Enum.count(reference_name)-1) do
            reference_params =
            %{
                 customer_id: params["customer_id"],
                 reference_no: new_params["reference_no"],
                 name: Enum.at(reference_name, x),
                 contact_no:  Enum.at(params["contact_no"], x),
              }
            Loan_applicant_reference.changeset(%Loan_applicant_reference{}, reference_params)
            |> Repo.insert()
          end
        end
        # -------------------------------------------Base 64 image Encoder
        applicant_signature = image_data_applicant_signature(params)
        IO.inspect applicant_signature, label: "applicant_signature ***************************"
        applicant_signature_encode_img = if applicant_signature != false do parse_image(applicant_signature.path) else "" end
        witness_signature = image_data_witness_signature(params)
        witness_signature_encode_img = if witness_signature != false  do parse_image(witness_signature.path) else "" end
        cro_staff_signature = image_data_cro_staff_signature(params)
        cro_staff_signature_encode_img = if  cro_staff_signature != false do parse_image(cro_staff_signature.path) else "" end
        gaurantor_signature = image_data_gaurantor_signature(params)
        gaurantor_signature_encode_img = if gaurantor_signature != false do parse_image(gaurantor_signature.path) else "" end
        guarantor_witness_signature = image_data_guarantor_witness_signature(params)
        guarantor_witness_signature_encode_img = if guarantor_witness_signature != false do parse_image(guarantor_witness_signature.path) else "" end
       # ----------------------------------- Collateral
        collateral = params["name_of_collateral"]
        if collateral == nil || collateral == [] || collateral == ["undefined"] do
          IO.puts "No Reference Attachment Detected"
        else
          for x <- 0..(Enum.count(collateral)-1) do

            collateral_params =
            %{
                 customer_id: params["customer_id"],
                 reference_no: new_params["reference_no"],
                 asset_value: Enum.at(params["asset_value"], x),
                 color:  Enum.at(params["color"], x),
                 id_number: Enum.at(params["id_number_collateral"], x),
                 name_of_collateral:  Enum.at(params["name_of_collateral"], x),
                 applicant_signature: applicant_signature_encode_img,
                 name_of_witness:  params["name_of_witness"],
                 witness_signature: witness_signature_encode_img,
                 cro_staff_name:  params["cro_staff_name"],
                 cro_staff_signature:  cro_staff_signature_encode_img,
              }
            Loan_applicant_collateral.changeset(%Loan_applicant_collateral{}, collateral_params)
            |> Repo.insert()
          end
         end
        # ----------------------------------- Guarantor
          Loan_applicant_guarantor.changeset(%Loan_applicant_guarantor{}, %{
          customer_id: params["customer_id"],
          reference_no: new_params["reference_no"],
          cost_of_sales: params["cost_of_sales"],
          occupation: params["occupation"],
          email: params["guarantor_email"],
          employer: params["employer"],
          gaurantor_sign_date: params["gaurantor_sign_date"],
          gaurantor_signature: gaurantor_signature_encode_img,
          guarantor_name: params["guarantor_name"],
          guarantor_phone_no: params["guarantor_phone_no"],
          loan_applicant_name: params["loan_applicant_name"],
          name_of_cro_staff: params["gaurantor_cro_staff"],
          name_of_witness: params["guarantor_witness_name"],
          guarantor_witness_signature: guarantor_witness_signature_encode_img,
          witness_sign_date: params["witness_sign_date"],
          net_profit_loss: params["net_profit_loss"],
          nrc: params["guarantor_nrc"],
          other_expenses: params["other_expenses"],
          other_income_bills: params["other_income_bills"],
          relationship: params["guarantor_relationship"],
          salary_loan: params["salary_loan"],
          sale_business_rentals: params["sale_business_rentals"],
          staff_sign_date: params["staff_sign_date"],
          staff_signature: cro_staff_signature_encode_img,
          total_income_expense: params["total_income_expense"],
          salary: params["salary"],
          other_income: params["other_income"],
          business_sales: params["business_sales"],
          total_income: params["total_income"]
        })
        |> Repo.insert()
        # -------------------------------------Next of Kin
        Nextofkin.changeset(%Nextofkin{}, %{
          userID: params["customer_id"],
          reference_no: new_params["reference_no"],
          kin_first_name: params["kin_first_name"],
          kin_last_name: params["kin_last_name"],
          kin_other_name: params["kin_other_name"],
          kin_status: params["kin_status"],
          kin_relationship: params["kin_relationship"],
          kin_gender: params["kin_gender"],
          kin_mobile_number: params["kin_mobile_number"],
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{add_loan: _add_loan, user_logs: _user_logs}} ->
          loan_details = Loans.find_by(reference_no: new_params["reference_no"])
          nrc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(userId: params["customer_id"]).meansOfIdentificationNumber rescue _-> "" end
          Loanmanagementsystem.Services.LoanDocumentsUploads.client_upload(%{"process_documents" => params, "conn" => conn, "nrc" => nrc, "loan_id" => loan_details.id, "file_category" => "LOAN_DOCUMENTS"})
          conn
          |> put_flash(:info, "Loan Application Submitted")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
    # else
    #   conn
    #   |> put_flash(:error,"Kindly attach document(s) and Try again")
    #   |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    # end
  end


  def view_universal_loan_application(conn, params) do
    product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
    if product_type == "Instant Loan" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      market_info = Loan.list_business_market_info_validation(params["userId"], params["reference_no"])
      sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
      amortization_schedule = Loan.list_amortization_table(params["userId"], params["reference_no"])
      amortised_schedule = Loan.list_amortization_table_inputs_validation(params["userId"], params["reference_no"])
      disbursement_schedule = Loan.list_disbursement_schedule_validation(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      legal_documents =  Loanmanagementsystem.OperationsServices.get_loan_legal_docs(loan_id)
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
      loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
      loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
      loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
      loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
      credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
      credit_manager_recommedation = Loan.credit_manager_validation(params["userId"], params["reference_no"])
      accounts_assistant_recommedation = Loan.assistant_accountant_validation(params["userId"], params["reference_no"])
      finance_manager_recommedation = Loan.finance_manager_validation(params["userId"], params["reference_no"])
      legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
      ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
      operations_recommedation = Loan.operations_recomendation_validation(params["userId"], params["reference_no"])
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      cro_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).cro_id rescue _-> 0 end
      customer_relationship_officer = Loan.customer_relationship_officer(cro_id)
      render(conn, "view_instant_loan_application.html",
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        market_info: market_info,
        sales_recommedation: sales_recommedation,
        amortization_schedule: amortization_schedule,
        amortised_schedule: amortised_schedule,
        disbursement_schedule: disbursement_schedule,
        legal_documents: legal_documents,
        loan_documents: loan_documents,
        crb_loan_documents: crb_loan_documents,
        loan_5cs: loan_5cs,
        loan_checklist: loan_checklist,
        loan_credit_details: loan_credit_details,
        loan_property_documents: loan_property_documents,
        credit_analyst_recommedation: credit_analyst_recommedation,
        credit_manager_recommedation: credit_manager_recommedation,
        accounts_assistant_recommedation: accounts_assistant_recommedation,
        finance_manager_recommedation: finance_manager_recommedation,
        legal_recommedation: legal_recommedation,
        ceo_recommedation: ceo_recommedation,
        operations_recommedation: operations_recommedation,
        client_income_statement: client_income_statement,
        client_details: client_details,
        relationship_officer: Loan.list_customer_relationship_officer(),
        cro: customer_relationship_officer
      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "Business Loan" do
        with(
          client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
        ) do
         nrc = client_details.id_number
        client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
        client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
        nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
        client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
        loan_details = Loanmanagementsystem.Loan.list_customer_loan_details(params["userId"], params["reference_no"])
        collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
        extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
        guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
        amortization_schedule = Loan.list_amortization_table(params["userId"], params["reference_no"])
        amortised_schedule = Loan.list_amortization_table_inputs_validation(params["userId"], params["reference_no"])
        disbursement_schedule = Loan.list_disbursement_schedule_validation(params["userId"], params["reference_no"])
        sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
        loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
        legal_documents =  Loanmanagementsystem.OperationsServices.get_loan_legal_docs(loan_id)
        loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
        crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
        loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
        loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
        loan_credit_details = Loanmanagementsystem.Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
        loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
        credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
        credit_manager_recommedation = Loan.credit_manager_validation(params["userId"], params["reference_no"])
        accounts_assistant_recommedation = Loan.assistant_accountant_validation(params["userId"], params["reference_no"])
        finance_manager_recommedation = Loan.finance_manager_validation(params["userId"], params["reference_no"])
        legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
        ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
        operations_recommedation = Loan.operations_recomendation_validation(params["userId"], params["reference_no"])
        client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
        company_details = Loanmanagementsystem.Accounts.get_client_company_details(params["userId"])
        cro_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).cro_id rescue _-> 0 end
        customer_relationship_officer = Loanmanagementsystem.Operations.customer_relationship_officer(cro_id)
        render(conn, "view_universal_loan_application.html",
          product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
          product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
          client_data: client_data,
          client_kyc: client_kyc,
          nextofkin: nextofkin,
          client_references: client_references,
          loan_details: loan_details,
          collateral_details: collateral_details,
          extracted_other_collateral_details: extracted_other_collateral_details,
          guarantors_details: guarantors_details,
          amortization_schedule: amortization_schedule,
          amortised_schedule: amortised_schedule,
          disbursement_schedule: disbursement_schedule,
          legal_documents: legal_documents,
          loan_documents: loan_documents,
          sales_recommedation: sales_recommedation,
          crb_loan_documents: crb_loan_documents,
          loan_5cs: loan_5cs,
          loan_checklist: loan_checklist,
          loan_credit_details: loan_credit_details,
          loan_property_documents: loan_property_documents,
          credit_analyst_recommedation: credit_analyst_recommedation,
          credit_manager_recommedation: credit_manager_recommedation,
          accounts_assistant_recommedation: accounts_assistant_recommedation,
          finance_manager_recommedation: finance_manager_recommedation,
          legal_recommedation: legal_recommedation,
          ceo_recommedation: ceo_recommedation,
          operations_recommedation: operations_recommedation,
          client_income_statement: client_income_statement,
          company_details: company_details,
          client_details: client_details,
          relationship_officer: Loan.list_customer_relationship_officer(),
          cro: customer_relationship_officer
        )
        else
          _ ->
          conn
          |> put_flash(:error, "Something went wrong, try again.")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
        end

      else
        if product_type == "Salary Backed Loan" do
          with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loanmanagementsystem.Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loanmanagementsystem.Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loanmanagementsystem.Loan.collateral_details_validation(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
          guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
          sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info_validation(params["userId"], params["reference_no"])
          loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
          employment_verifications =  Loanmanagementsystem.OperationsServices.get_loan_employememt_verification_docs(loan_id)
          amortization_schedule = Loan.list_amortization_table(params["userId"], params["reference_no"])
          amortised_schedule = Loan.list_amortization_table_inputs_validation(params["userId"], params["reference_no"])
          disbursement_schedule = Loan.list_disbursement_schedule_validation(params["userId"], params["reference_no"])
          legal_documents =  Loanmanagementsystem.OperationsServices.get_loan_legal_docs(loan_id)
          loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
          crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
          loan_5cs = Loanmanagementsystem.Loan.loan_5cs_validation(params["userId"], params["reference_no"])
          loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
          loan_credit_details = Loanmanagementsystem.Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
          loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
          credit_analyst_recommedation = Loanmanagementsystem.Loan.credit_analyst_validation(params["userId"], params["reference_no"])
          credit_manager_recommedation = Loan.credit_manager_validation(params["userId"], params["reference_no"])
          accounts_assistant_recommedation = Loan.assistant_accountant_validation(params["userId"], params["reference_no"])
          finance_manager_recommedation = Loan.finance_manager_validation(params["userId"], params["reference_no"])
          legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
          ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
          operations_recommedation = Loan.operations_recomendation_validation(params["userId"], params["reference_no"])
          client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
          cro_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).cro_id rescue _-> 0 end
          customer_relationship_officer = Loanmanagementsystem.Operations.customer_relationship_officer(cro_id)
          render(conn, "view_salary_loan_application.html",
            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
            client_data: client_data,
            client_kyc: client_kyc,
            nextofkin: nextofkin,
            client_references: client_references,
            loan_details: loan_details,
            collateral_details: collateral_details,
            extracted_other_collateral_details: extracted_other_collateral_details,
            guarantors_details: guarantors_details,
            sales_recommedation: sales_recommedation,
            employment_details: employment_details,
            employment_verifications: employment_verifications,
            amortization_schedule: amortization_schedule,
            amortised_schedule: amortised_schedule,
            disbursement_schedule: disbursement_schedule,
            legal_documents: legal_documents,
            loan_documents: loan_documents,
            crb_loan_documents: crb_loan_documents,
            loan_5cs: loan_5cs,
            loan_checklist: loan_checklist,
            loan_credit_details: loan_credit_details,
            loan_property_documents: loan_property_documents,
            credit_analyst_recommedation: credit_analyst_recommedation,
            credit_manager_recommedation: credit_manager_recommedation,
            accounts_assistant_recommedation: accounts_assistant_recommedation,
            finance_manager_recommedation: finance_manager_recommedation,
            legal_recommedation: legal_recommedation,
            ceo_recommedation: ceo_recommedation,
            operations_recommedation: operations_recommedation,
            client_income_statement: client_income_statement,
            client_details: client_details,
            relationship_officer: Loan.list_customer_relationship_officer(),
            cro: customer_relationship_officer
          )
          else
            _ ->
            conn
            |> put_flash(:error, "Something went wrong, try again.")
            |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end

        else
          conn
          |> put_flash(:error, "Something went wrong, try again.")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
        end
      end
    end


  end

  def edit_universal_loan_application(conn, params) do
    product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
    if product_type == "Instant Loan" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
      market_details = Loan.list_loan_market_info(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      cro_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).cro_id rescue _-> 0 end
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      customer_relationship_officer = Loan.customer_relationship_officer(cro_id)
      render(conn, "edit_instant_loan_application.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        sales_recommedation: sales_recommedation,
        market_details: market_details,
        loan_documents: loan_documents,
        client_income_statement: client_income_statement,
        relationship_officer: Loan.list_customer_relationship_officer(),
        cro: customer_relationship_officer,
        client_details: client_details
      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "Business Loan" do
        with(
          client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
        ) do
         nrc = client_details.id_number
        client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
        client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
        nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
        client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
        loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
        collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
        extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
        guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
        loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
        cro_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).cro_id rescue _-> 0 end
        loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
        client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
        company_details = Loanmanagementsystem.Accounts.get_client_company_details(params["userId"])
        customer_relationship_officer = Loan.customer_relationship_officer(cro_id)
        render(conn, "edit_universal_loan_application.html",
          current_time: current_time(),
          product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
          product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
          client_data: client_data,
          client_kyc: client_kyc,
          nextofkin: nextofkin,
          client_references: client_references,
          loan_details: loan_details,
          collateral_details: collateral_details,
          extracted_other_collateral_details: extracted_other_collateral_details,
          guarantors_details: guarantors_details,
          loan_documents: loan_documents,
          client_income_statement: client_income_statement,
          company_details: company_details,
          relationship_officer: Loan.list_customer_relationship_officer(),
          cro: customer_relationship_officer,
          client_details: client_details
        )
        else
          _ ->
          conn
          |> put_flash(:error, "Something went wrong, try again.")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
        end

      else
        if product_type == "Salary Backed Loan" do
          with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
          guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info_validation(params["userId"], params["reference_no"])
          loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
          cro_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).cro_id rescue _-> 0 end
          employment_verifications =  Loanmanagementsystem.OperationsServices.get_loan_employememt_verification_docs(loan_id)
          loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
          client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
          customer_relationship_officer = Loan.customer_relationship_officer(cro_id)
          render(conn, "edit_salary_loan_application.html",
            current_time: current_time(),
            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
            client_data: client_data,
            client_kyc: client_kyc,
            nextofkin: nextofkin,
            client_references: client_references,
            loan_details: loan_details,
            collateral_details: collateral_details,
            extracted_other_collateral_details: extracted_other_collateral_details,
            guarantors_details: guarantors_details,
            sales_recommedation: sales_recommedation,
            employment_details: employment_details,
            employment_verifications: employment_verifications,
            loan_documents: loan_documents,
            client_income_statement: client_income_statement,
            relationship_officer: Loan.list_customer_relationship_officer(),
            cro: customer_relationship_officer,
            client_details: client_details

          )
          else
            _ ->
            conn
            |> put_flash(:error, "Something went wrong, try again.")
            |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end

        else
          conn
          |> put_flash(:error, "Something went wrong, try again.")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
        end
      end
    end



  end

  def edit_rejected_universal_loan_application(conn, params) do
    product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
    if product_type == "Instant Loan" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
      market_details = Loan.list_loan_market_info(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      render(conn, "edit_rejected_instant_loan_application.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        sales_recommedation: sales_recommedation,
        market_details: market_details,
        loan_documents: loan_documents,
        client_income_statement: client_income_statement,
        client_details: client_details
      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "Business Loan" do
        with(
      client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
        ) do
        nrc = client_details.id_number
        client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
        client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
        nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
        client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
        loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
        collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
        extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
        guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
        loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
        loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
        client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
        company_details = Loanmanagementsystem.Accounts.get_client_company_details(params["userId"])
        render(conn, "edit_rejected_universal_loan_application.html",
          current_time: current_time(),
          product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
          product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
          client_data: client_data,
          client_kyc: client_kyc,
          nextofkin: nextofkin,
          client_references: client_references,
          loan_details: loan_details,
          collateral_details: collateral_details,
          extracted_other_collateral_details: extracted_other_collateral_details,
          guarantors_details: guarantors_details,
          loan_documents: loan_documents,
          client_income_statement: client_income_statement,
          company_details: company_details,
          client_details: client_details
        )
        else
          _ ->
          conn
          |> put_flash(:error, "Something went wrong, try again.")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
        end

      else
        if product_type == "Salary Backed Loan" do
          with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
          guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info_validation(params["userId"], params["reference_no"])
          loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
          employment_verifications =  Loanmanagementsystem.OperationsServices.get_loan_employememt_verification_docs(loan_id)
          loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
          client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
          render(conn, "edit_rejected_salary_loan_application.html",
            current_time: current_time(),
            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
            client_data: client_data,
            client_kyc: client_kyc,
            nextofkin: nextofkin,
            client_references: client_references,
            loan_details: loan_details,
            collateral_details: collateral_details,
            extracted_other_collateral_details: extracted_other_collateral_details,
            guarantors_details: guarantors_details,
            sales_recommedation: sales_recommedation,
            employment_details: employment_details,
            employment_verifications: employment_verifications,
            loan_documents: loan_documents,
            client_income_statement: client_income_statement,
            client_details: client_details
          )
          else
            _ ->
            conn
            |> put_flash(:error, "Something went wrong, try again.")
            |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end

        else

        end
      end
    end
  end

  def update_universal_loan_application(conn, params) do
   with(
    update_loan when update_loan != nil <- Loanmanagementsystem.Loan.Loans.find_by(id: params["loan_id"])
    ) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_loan, Loans.changeset(update_loan, params))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{update_loan: _update_loan} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Loan Application Successfully Updated for #{params["firstname"]} #{params["surname"]} with ID #{params["id_number"]}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
      # ------------------------------------Loan Customer details -------
      loan_customer_kyc = %{
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
        residential_address: params["residential_address"],
        landmark: params["landmark"],
        town: params["town"],
        province: params["province"],
        sector: params["sector"],
        geographical_location: params["geographical_location"],
        type_of_facility: params["type_of_facility"],
        employee_number: params["employee_number"]
      }
      update_loan_customer_kyc = Loan_customer_details.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
      Ecto.Multi.new()
      |> Ecto.Multi.update(:update_loan_customer_kyc, Loan_customer_details.changeset(update_loan_customer_kyc, loan_customer_kyc))
      |> Repo.transaction()

      update_loan_collateral = Loan_applicant_collateral.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
      collateral_params = %{
            applicant_signature: "",
            name_of_witness:  params["name_of_witness"],
            witness_signature: "",
            cro_staff_name:  params["cro_staff_name"],
            cro_staff_signature: "",
          }

       case update_loan_collateral do
        nil ->
          Loan_applicant_collateral.changeset(%Loan_applicant_collateral{}, %{
            customer_id: update_loan.customer_id,
            reference_no: update_loan.reference_no,
            applicant_signature: "",
            name_of_witness:  params["name_of_witness"],
            witness_signature: "",
            cro_staff_name:  params["cro_staff_name"],
            cro_staff_signature: "",
          })
          |> Repo.insert()
         _ ->
        Ecto.Multi.new()
        |> Ecto.Multi.update(:update_loan_collateral, Loan_applicant_collateral.changeset(update_loan_collateral, collateral_params))
        |> Repo.transaction()
       end
      # ----------------------------------- Guarantor
      update_loan_guarantor = Loan_applicant_guarantor.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
      case update_loan_guarantor do
        nil ->
          Loan_applicant_guarantor.changeset(%Loan_applicant_guarantor{}, %{
            customer_id: update_loan.customer_id,
            reference_no: update_loan.reference_no,
            cost_of_sales: params["cost_of_sales"],
            occupation: params["occupation"],
            email: params["guarantor_email"],
            employer: params["employer"],
            gaurantor_sign_date: params["gaurantor_sign_date"],
            gaurantor_signature: "",
            guarantor_name: params["guarantor_name"],
            guarantor_phone_no: params["guarantor_phone_no"],
            loan_applicant_name: params["loan_applicant_name"],
            name_of_cro_staff: params["gaurantor_cro_staff"],
            name_of_witness: params["guarantor_witness_name"],
            guarantor_witness_signature: "",
            witness_sign_date: params["witness_sign_date"],
            net_profit_loss: params["net_profit_loss"],
            nrc: params["guarantor_nrc"],
            other_expenses: params["other_expenses"],
            other_income_bills: params["other_income_bills"],
            relationship: params["guarantor_relationship"],
            salary_loan: params["salary_loan"],
            sale_business_rentals: params["sale_business_rentals"],
            staff_sign_date: params["staff_sign_date"],
            staff_signature: "",
            total_income_expense: params["total_income_expense"],
            salary: params["salary"],
            other_income: params["other_income"],
            business_sales: params["business_sales"],
            total_income: params["total_income"],
          })
          |> Repo.insert()
         _ ->
          applicant_guarantor_params = %{
            cost_of_sales: params["cost_of_sales"],
            occupation: params["occupation"],
            email: params["guarantor_email"],
            employer: params["employer"],
            gaurantor_sign_date: params["gaurantor_sign_date"],
            gaurantor_signature: "",
            guarantor_name: params["guarantor_name"],
            guarantor_phone_no: params["guarantor_phone_no"],
            loan_applicant_name: params["loan_applicant_name"],
            name_of_cro_staff: params["gaurantor_cro_staff"],
            name_of_witness: params["guarantor_witness_name"],
            guarantor_witness_signature: "",
            witness_sign_date: params["witness_sign_date"],
            net_profit_loss: params["net_profit_loss"],
            nrc: params["guarantor_nrc"],
            other_expenses: params["other_expenses"],
            other_income_bills: params["other_income_bills"],
            relationship: params["guarantor_relationship"],
            salary_loan: params["salary_loan"],
            sale_business_rentals: params["sale_business_rentals"],
            staff_sign_date: params["staff_sign_date"],
            staff_signature: "",
            total_income_expense: params["total_income_expense"],
            salary: params["salary"],
            other_income: params["other_income"],
            business_sales: params["business_sales"],
            total_income: params["total_income"]
        }
        Ecto.Multi.new()
        |> Ecto.Multi.update(:update_loan_guarantor, Loan_applicant_guarantor.changeset(update_loan_guarantor, applicant_guarantor_params))
        |> Repo.transaction()
      end
      #  --------------client income statement ---------------
        update_income_statement = Loan_income_assessment.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
        case update_income_statement do
          nil ->
            Loan_income_assessment.changeset(%Loan_income_assessment{}, %{
              customer_id: update_loan.customer_id,
              reference_no: update_loan.reference_no,
              business_type: params["business_type"],
              jan: params["jan"],
              jan_bank_stat: params["jan_bank_stat"],
              jan_mobile_stat: params["jan_mobile_stat"],
              jan_total: params["jan_total"],
              dec: params["dec"],
              dec_bank_stat: params["dec_bank_stat"],
              dec_mobile_stat: params["dec_mobile_stat"],
              dec_total: params["dec_total"],
              nov: params["nov"],
              nov_bank_stat: params["nov_bank_stat"],
              nov_mobile_stat: params["nov_mobile_stat"],
              nov_total: params["nov_total"],
              average_income: params["average_income"],
              dstv: params["dstv"],
              food: params["food"],
              school: params["school"],
              utilities: params["utilities"],
              loan_installment: params["loan_installment"],
              salaries: params["salaries"],
              stationery: params["stationery"],
              transport: params["transport"],
              total_expenses: params["total_expenses"],
              available_income: params["available_income"],
              loan_installment_total: params["loan_installment_total"],
              dsr: params["dsr"],
            })
            |> Repo.insert()
          _ ->
            client_income_statement = %{
              business_type: params["business_type"],
              jan: params["jan"],
              jan_bank_stat: params["jan_bank_stat"],
              jan_mobile_stat: params["jan_mobile_stat"],
              jan_total: params["jan_total"],
              dec: params["dec"],
              dec_bank_stat: params["dec_bank_stat"],
              dec_mobile_stat: params["dec_mobile_stat"],
              dec_total: params["dec_total"],
              nov: params["nov"],
              nov_bank_stat: params["nov_bank_stat"],
              nov_mobile_stat: params["nov_mobile_stat"],
              nov_total: params["nov_total"],
              average_income: params["average_income"],
              dstv: params["dstv"],
              food: params["food"],
              school: params["school"],
              utilities: params["utilities"],
              loan_installment: params["loan_installment"],
              salaries: params["salaries"],
              stationery: params["stationery"],
              transport: params["transport"],
              total_expenses: params["total_expenses"],
              available_income: params["available_income"],
              loan_installment_total: params["loan_installment_total"],
              dsr: params["dsr"],
          }
          Ecto.Multi.new()
          |> Ecto.Multi.update(:update_income_statement, Loan_income_assessment.changeset(update_income_statement, client_income_statement))
          |> Repo.transaction()
        end
      # ------------------------------------------------------
      # -------------------------------------Next of Kin -----
      loan_nextofkin_params = %{
        kin_first_name: params["kin_first_name"],
        kin_last_name: params["kin_last_name"],
        kin_other_name: params["kin_other_name"],
        kin_status: params["kin_status"],
        kin_relationship: params["kin_relationship"],
        kin_gender: params["kin_gender"],
        kin_mobile_number: params["kin_mobile_number"],
      }
      update_loan_nextofkin = Nextofkin.find_by(userID: update_loan.customer_id, reference_no: update_loan.reference_no)
      Ecto.Multi.new()
      |> Ecto.Multi.update(:update_loan_nextofkin, Nextofkin.changeset(update_loan_nextofkin, loan_nextofkin_params))
      |> Repo.transaction()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{update_loan: _update_loan, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Loan Application Updated")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end
  else
    _ ->
    conn
    |> put_flash(:error, "Something went wrong, try again.")
    |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
end


def update_salarybacked_loan_application(conn, params) do
  with(
   update_loan when update_loan != nil <- Loanmanagementsystem.Loan.Loans.find_by(id: params["loan_id"])
   ) do
   Ecto.Multi.new()
   |> Ecto.Multi.update(:update_loan, Loans.changeset(update_loan, params))
   |> Ecto.Multi.run(:user_logs, fn _repo, %{update_loan: _update_loan} ->
     UserLogs.changeset(%UserLogs{}, %{
       activity: "Loan Application Successfully Updated for #{params["firstname"]} #{params["surname"]} with ID #{params["id_number"]}",
       user_id: conn.assigns.user.id
     })
     |> Repo.insert()
     # ------------------------------------Loan Customer details -------
     loan_customer_kyc = %{
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
       residential_address: params["residential_address"],
       landmark: params["landmark"],
       town: params["town"],
       province: params["province"],
       sector: params["sector"],
       geographical_location: params["geographical_location"],
       type_of_facility: params["type_of_facility"],
       employee_number: params["employee_number"]
     }

     update_loan_customer_kyc = Loan_customer_details.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)

     Ecto.Multi.new()
     |> Ecto.Multi.update(:update_loan_customer_kyc, Loan_customer_details.changeset(update_loan_customer_kyc, loan_customer_kyc))
     |> Repo.transaction()
    #  --------------------------------------- Employment Details
    employment_details = %{
      accrued_gratuity: params["accrued_gratuity_info"],
      address: params["address_info"],
      othername: params["othername_info"],
      applicant_name: params["applicant_name_info"],
      authorised_signature: params["authorised_signature_info"],
      company_name: params["company_name_info"],
      contact_no: params["contact_no_info"],
      date: params["date_info"],
      date_to: params["date_to_info"],
      employer: params["employer_info"],
      employer_email_address: params["employer_email_address_info"],
      employer_phone: params["employer_phone_info"],
      employment_date: params["employment_date_info"],
      employment_status: params["employment_status_info"],
      granted_loan_amt: params["granted_loan_amt_info"],
      gross_salary: params["gross_salary_info"],
      job_title: params["job_title_info"],
      net_salary: params["net_salary_info"],
      other_outstanding_loans: params["other_outstanding_loans_info"],
      province: params["province_info"],
      supervisor_name: params["supervisor_name_info"],
      town: params["town_info"],
    }
    update_employment_details = Loan_employment_info.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
    case update_employment_details do
      nil ->
        Loan_employment_info.changeset(%Loan_employment_info{}, %{
          customer_id: update_loan.customer_id,
          reference_no: update_loan.reference_no,
          accrued_gratuity: params["accrued_gratuity_info"],
          address: params["address_info"],
          othername: params["othername_info"],
          applicant_name: params["applicant_name_info"],
          authorised_signature: params["authorised_signature_info"],
          company_name: params["company_name_info"],
          contact_no: params["contact_no_info"],
          date: params["date_info"],
          date_to: params["date_to_info"],
          employer: params["employer_info"],
          employer_email_address: params["employer_email_address_info"],
          employer_phone: params["employer_phone_info"],
          employment_date: params["employment_date_info"],
          employment_status: params["employment_status_info"],
          granted_loan_amt: params["granted_loan_amt_info"],
          gross_salary: params["gross_salary_info"],
          job_title: params["job_title_info"],
          net_salary: params["net_salary_info"],
          other_outstanding_loans: params["other_outstanding_loans_info"],
          province: params["province_info"],
          supervisor_name: params["supervisor_name_info"],
          town: params["town_info"]
        })
        |> Repo.insert()
       _ ->
        Ecto.Multi.new()
        |> Ecto.Multi.update(:update_employment_details, Loan_employment_info.changeset(update_employment_details, employment_details))
        |> Repo.transaction()
    end
     # ----------------------------------- Guarantor
     update_loan_guarantor = Loan_applicant_guarantor.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
     case update_loan_guarantor do
       nil ->
         Loan_applicant_guarantor.changeset(%Loan_applicant_guarantor{}, %{
           customer_id: update_loan.customer_id,
           reference_no: update_loan.reference_no,
           cost_of_sales: params["cost_of_sales"],
           occupation: params["occupation"],
           email: params["guarantor_email"],
           employer: params["employer"],
           gaurantor_sign_date: params["gaurantor_sign_date"],
           gaurantor_signature: "",
           guarantor_name: params["guarantor_name"],
           guarantor_phone_no: params["guarantor_phone_no"],
           loan_applicant_name: params["loan_applicant_name"],
           name_of_cro_staff: params["gaurantor_cro_staff"],
           name_of_witness: params["guarantor_witness_name"],
           guarantor_witness_signature: "",
           witness_sign_date: params["witness_sign_date"],
           net_profit_loss: params["net_profit_loss"],
           nrc: params["guarantor_nrc"],
           other_expenses: params["other_expenses"],
           other_income_bills: params["other_income_bills"],
           relationship: params["guarantor_relationship"],
           salary_loan: params["salary_loan"],
           sale_business_rentals: params["sale_business_rentals"],
           staff_sign_date: params["staff_sign_date"],
           staff_signature: "",
           total_income_expense: params["total_income_expense"],
           salary: params["salary"],
           other_income: params["other_income"],
           business_sales: params["business_sales"],
           total_income: params["total_income"],
         })
         |> Repo.insert()
        _ ->
         applicant_guarantor_params = %{
           cost_of_sales: params["cost_of_sales"],
           occupation: params["occupation"],
           email: params["guarantor_email"],
           employer: params["employer"],
           gaurantor_sign_date: params["gaurantor_sign_date"],
           gaurantor_signature: "",
           guarantor_name: params["guarantor_name"],
           guarantor_phone_no: params["guarantor_phone_no"],
           loan_applicant_name: params["loan_applicant_name"],
           name_of_cro_staff: params["gaurantor_cro_staff"],
           name_of_witness: params["guarantor_witness_name"],
           guarantor_witness_signature: "",
           witness_sign_date: params["witness_sign_date"],
           net_profit_loss: params["net_profit_loss"],
           nrc: params["guarantor_nrc"],
           other_expenses: params["other_expenses"],
           other_income_bills: params["other_income_bills"],
           relationship: params["guarantor_relationship"],
           salary_loan: params["salary_loan"],
           sale_business_rentals: params["sale_business_rentals"],
           staff_sign_date: params["staff_sign_date"],
           staff_signature: "",
           total_income_expense: params["total_income_expense"],
           salary: params["salary"],
           other_income: params["other_income"],
           business_sales: params["business_sales"],
           total_income: params["total_income"]
       }
       Ecto.Multi.new()
       |> Ecto.Multi.update(:update_loan_guarantor, Loan_applicant_guarantor.changeset(update_loan_guarantor, applicant_guarantor_params))
       |> Repo.transaction()
     end
    #  --------------client income statement ---------------
    update_income_statement = Loan_income_assessment.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
      case update_income_statement do
        nil ->
          Loan_income_assessment.changeset(%Loan_income_assessment{}, %{
            customer_id: update_loan.customer_id,
            reference_no: update_loan.reference_no,
            business_type: params["business_type"],
            jan: params["jan"],
            jan_bank_stat: params["jan_bank_stat"],
            jan_mobile_stat: params["jan_mobile_stat"],
            jan_total: params["jan_total"],
            dec: params["dec"],
            dec_bank_stat: params["dec_bank_stat"],
            dec_mobile_stat: params["dec_mobile_stat"],
            dec_total: params["dec_total"],
            nov: params["nov"],
            nov_bank_stat: params["nov_bank_stat"],
            nov_mobile_stat: params["nov_mobile_stat"],
            nov_total: params["nov_total"],
            average_income: params["average_income"],
            dstv: params["dstv"],
            food: params["food"],
            school: params["school"],
            utilities: params["utilities"],
            loan_installment: params["loan_installment"],
            salaries: params["salaries"],
            stationery: params["stationery"],
            transport: params["transport"],
            total_expenses: params["total_expenses"],
            available_income: params["available_income"],
            loan_installment_total: params["loan_installment_total"],
            dsr: params["dsr"],
          })
          |> Repo.insert()
         _ ->
          client_income_statement = %{
            business_type: params["business_type"],
            jan: params["jan"],
            jan_bank_stat: params["jan_bank_stat"],
            jan_mobile_stat: params["jan_mobile_stat"],
            jan_total: params["jan_total"],
            dec: params["dec"],
            dec_bank_stat: params["dec_bank_stat"],
            dec_mobile_stat: params["dec_mobile_stat"],
            dec_total: params["dec_total"],
            nov: params["nov"],
            nov_bank_stat: params["nov_bank_stat"],
            nov_mobile_stat: params["nov_mobile_stat"],
            nov_total: params["nov_total"],
            average_income: params["average_income"],
            dstv: params["dstv"],
            food: params["food"],
            school: params["school"],
            utilities: params["utilities"],
            loan_installment: params["loan_installment"],
            salaries: params["salaries"],
            stationery: params["stationery"],
            transport: params["transport"],
            total_expenses: params["total_expenses"],
            available_income: params["available_income"],
            loan_installment_total: params["loan_installment_total"],
            dsr: params["dsr"],
        }
        Ecto.Multi.new()
        |> Ecto.Multi.update(:update_income_statement, Loan_income_assessment.changeset(update_income_statement, client_income_statement))
        |> Repo.transaction()
      end
    # ------------------------------------------------------
    user_bio_details = %{
      employee_number: params["employee_number"]
    }
    user_bio = UserBioData.find_by(userId: update_loan.customer_id)
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user_bio, UserBioData.changeset(user_bio, user_bio_details))
    |> Repo.transaction()
    #  -------------------------------------- CRO
    # cro_recommendation = %{
    #   recommended: params["recommended_feedback"],
    #   on_hold: params["on_hold_feedback"],
    #   file_sent_to_sale: params["file_sent_to_sale_feedback"],
    #   comments: params["comments_feedback"],
    #   name: params["name_feedback"],
    #   signature: params["signature_feedback"],
    #   position: params["position_feedback"],
    #   date: params["date_feedback"],
    #   time_received: params["time_received_feedback"],
    #   time_out: params["time_out_feedback"],
    #   date_received: params["date_received_feedback"],
    # }
    # update_cro_recommendation = Loan_recommendation_and_assessment.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no, user_type: "SALES")
    # Ecto.Multi.new()
    # |> Ecto.Multi.update(:update_cro_recommendation, Loan_recommendation_and_assessment.changeset(update_cro_recommendation, cro_recommendation))
    # |> Repo.transaction()
     # -------------------------------------Next of Kin
     loan_nextofkin_params = %{
       kin_first_name: params["kin_first_name"],
       kin_last_name: params["kin_last_name"],
       kin_other_name: params["kin_other_name"],
       kin_status: params["kin_status"],
       kin_relationship: params["kin_relationship"],
       kin_gender: params["kin_gender"],
       kin_mobile_number: params["kin_mobile_number"],
     }
     update_loan_nextofkin = Nextofkin.find_by(userID: update_loan.customer_id, reference_no: update_loan.reference_no)
     Ecto.Multi.new()
     |> Ecto.Multi.update(:update_loan_nextofkin, Nextofkin.changeset(update_loan_nextofkin, loan_nextofkin_params))
     |> Repo.transaction()
   end)
   |> Repo.transaction()
   |> case do
     {:ok, %{update_loan: _update_loan, user_logs: _user_logs}} ->
       conn
       |> put_flash(:info, "Loan Application Updated")
       |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

     {:error, _failed_operation, failed_value, _changes_so_far} ->
       reason = traverse_errors(failed_value.errors) |> List.first()
       conn
       |> put_flash(:error, reason)
       |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
   end
 else
   _ ->
   conn
   |> put_flash(:error, "Something went wrong, try again.")
   |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
 end
end

def update_credit_analyst_loan_application(conn, params) do
  with(
   update_loan when update_loan != nil <- Loanmanagementsystem.Loan.Loans.find_by(id: params["loan_id"])
   ) do
   Ecto.Multi.new()
   |> Ecto.Multi.update(:update_loan, Loans.changeset(update_loan, %{}))
   |> Ecto.Multi.run(:user_logs, fn _repo, %{update_loan: _update_loan} ->
     UserLogs.changeset(%UserLogs{}, %{
       activity: "Loan Application Successfully Updated for #{params["firstname"]} #{params["surname"]} with ID #{params["id_number"]}",
       user_id: conn.assigns.user.id
     })
     |> Repo.insert()
     # ----------------------------------- credit score --------
     update_credit_score = Loan_credit_score.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
     case update_credit_score do
       nil ->
        Loan_credit_score.changeset(%Loan_credit_score{}, %{
          applicant_character: params["applicant_character"],
          applicant_name: params["applicant_name"],
          borrowing_history: params["borrowing_history"],
          business_employment_experience: params["business_employment_experience"],
          collateral_assessment: params["collateral_assessment"],
          credit_analyst: params["credit_analyst"],
          cro_staff: params["cro_staff"],
          date_of_credit_score: params["date_of_credit_score"],
          dti_ratio: params["dti_ratio"],
          family_situation: params["family_situation"],
          # loan_amount: params["loan_amount"],
          number_of_reference: params["number_of_reference"],
          signature: params["signature"],
          total_score: params["total_score"],
          type_of_collateral: params["type_of_collateral"],
          type_of_loan: params["type_of_loan"],
          weighted_credit_score: params["weighted_credit_score"],
          customer_id: update_loan.customer_id,
          reference_no: update_loan.reference_no,
        })
        |> Repo.insert()
        _ ->
        credit_score_params = %{
          applicant_character: params["applicant_character"],
          applicant_name: params["applicant_name"],
          borrowing_history: params["borrowing_history"],
          business_employment_experience: params["business_employment_experience"],
          collateral_assessment: params["collateral_assessment"],
          credit_analyst: params["credit_analyst"],
          cro_staff: params["cro_staff"],
          date_of_credit_score: params["date_of_credit_score"],
          dti_ratio: params["dti_ratio"],
          family_situation: params["family_situation"],
          # loan_amount: params["loan_amount"],
          number_of_reference: params["number_of_reference"],
          signature: params["signature"],
          total_score: params["total_score"],
          type_of_collateral: params["type_of_collateral"],
          type_of_loan: params["type_of_loan"],
          weighted_credit_score: params["weighted_credit_score"],
          customer_id: update_loan.customer_id,
          reference_no: update_loan.reference_no
       }

       Ecto.Multi.new()
       |> Ecto.Multi.update(:update_credit_score, Loan_credit_score.changeset(update_credit_score, credit_score_params))
       |> Repo.transaction()
     end
    #  -------------------------------------- 5 cs analysis
    update_loan5cs = Loan_5cs.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
    case update_loan5cs do
      nil ->
        Loan_5cs.changeset(%Loan_5cs{}, %{
          capacity: params["capacity"],
          capital: params["capital"],
          character: params["character"],
          collateral: params["collateral"],
          condition: params["condition"],
          customer_id: update_loan.customer_id,
          reference_no: update_loan.reference_no
        })
        |> Repo.insert()
       _ ->
       loan5cs_params = %{
        capacity: params["capacity"],
        capital: params["capital"],
        character: params["character"],
        collateral: params["collateral"],
        condition: params["condition"],
        customer_id: update_loan.customer_id,
        reference_no: update_loan.reference_no
      }
      Ecto.Multi.new()
      |> Ecto.Multi.update(:update_loan5cs, Loan_5cs.changeset(update_loan5cs, loan5cs_params))
      |> Repo.transaction()
    end
    # ----------------------------------------- loan checklist ----------
    update_loan_checklist = Loan_checklist.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
    case update_loan_checklist do
      nil ->
          Loan_checklist.changeset(%Loan_checklist{}, %{
            gross_monthly_income: params["gross_monthly_income"],
            prood_of_resident: params["prood_of_resident"],
            home_visit_done: params["home_visit_done"],
            latest_pacra_print_out: params["latest_pacra_print_out"],
            desired_term: params["desired_term"],
            company_bank_statement: params["company_bank_statement"],
            bank_name: params["bank_name"],
            trading_license: params["trading_license"],
            id_no: params["id_no"],
            collateral_pictures: params["collateral_pictures"],
            employer_name: params["employer_name"],
            loan_amount_checklist: params["loan_amount_checklist"],
            telephone: params["telephone"],
            contract_agreements: params["contract_agreements"],
            correct_account_number: params["correct_account_number"],
            payslip_3months_verified: params["payslip_3months_verified"],
            latest_audited_financial_statement: params["latest_audited_financial_statement"],
            call_memo: params["call_memo"],
            marital_status: params["marital_status"],
            citizenship_status: params["citizenship_status"],
            employment_status: params["employment_status"],
            has_running_loan: params["has_running_loan"],
            loan_purpose_checklist: params["loan_purpose_checklist"],
            completed_application_form: params["completed_application_form"],
            preferred_loan_repayment_method: params["preferred_loan_repayment_method"],
            certificate_of_incorporation: params["certificate_of_incorporation"],
            passport_size_photo: params["passport_size_photo"],
            passport_size_photo_from_director: params["passport_size_photo_from_director"],
            rent_payment: params["rent_payment"],
            sales_record: params["sales_record"],
            board_allow_company_to_borrow: params["board_allow_company_to_borrow"],
            employer_letter: params["employer_letter"],
            crb: params["crb"],
            loan_verified: params["loan_verified"],
            bank_standing_payment_order: params["bank_standing_payment_order"],
            email_address: params["email_address"],
            social_security_no: params["social_security_no"],
            insurance_for_motor_vehicle: params["insurance_for_motor_vehicle"],
            bank_statement: params["bank_statement"],
            customer_id: update_loan.customer_id,
            reference_no: update_loan.reference_no,
          })
          |> Repo.insert()
       _ ->
       loan_checklist_params = %{
          gross_monthly_income: params["gross_monthly_income"],
          prood_of_resident: params["prood_of_resident"],
          home_visit_done: params["home_visit_done"],
          latest_pacra_print_out: params["latest_pacra_print_out"],
          desired_term: params["desired_term"],
          company_bank_statement: params["company_bank_statement"],
          bank_name: params["bank_name"],
          trading_license: params["trading_license"],
          id_no: params["id_no"],
          collateral_pictures: params["collateral_pictures"],
          employer_name: params["employer_name"],
          loan_amount_checklist: params["loan_amount_checklist"],
          telephone: params["telephone"],
          contract_agreements: params["contract_agreements"],
          correct_account_number: params["correct_account_number"],
          payslip_3months_verified: params["payslip_3months_verified"],
          latest_audited_financial_statement: params["latest_audited_financial_statement"],
          call_memo: params["call_memo"],
          marital_status: params["marital_status"],
          citizenship_status: params["citizenship_status"],
          employment_status: params["employment_status"],
          has_running_loan: params["has_running_loan"],
          loan_purpose_checklist: params["loan_purpose_checklist"],
          completed_application_form: params["completed_application_form"],
          preferred_loan_repayment_method: params["preferred_loan_repayment_method"],
          certificate_of_incorporation: params["certificate_of_incorporation"],
          passport_size_photo: params["passport_size_photo"],
          passport_size_photo_from_director: params["passport_size_photo_from_director"],
          rent_payment: params["rent_payment"],
          sales_record: params["sales_record"],
          board_allow_company_to_borrow: params["board_allow_company_to_borrow"],
          employer_letter: params["employer_letter"],
          crb: params["crb"],
          loan_verified: params["loan_verified"],
          bank_standing_payment_order: params["bank_standing_payment_order"],
          email_address: params["email_address"],
          social_security_no: params["social_security_no"],
          insurance_for_motor_vehicle: params["insurance_for_motor_vehicle"],
          bank_statement: params["bank_statement"],
          customer_id: update_loan.customer_id,
          reference_no: update_loan.reference_no
        }

      Ecto.Multi.new()
      |> Ecto.Multi.update(:update_loan_checklist, Loan_checklist.changeset(update_loan_checklist, loan_checklist_params))
      |> Repo.transaction()
    end
    # --------------------------------- recommendation -------
    update_loan_recommendation = Loan_recommendation_and_assessment.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
    case update_loan_recommendation do
      nil ->
        Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
          recommended: params["recommended_feedback"],
          user_type: "CREDIT_ANALYST",
          on_hold: params["on_hold_feedback"],
          file_sent_to_sale: params["file_sent_to_sale_feedback"],
          comments: params["comments_feedback"],
          name: params["name_feedback"],
          position: params["position_feedback"],
          date: params["date_feedback"],
          time_received: params["time_received_feedback"],
          time_out: params["time_out_feedback"],
          date_received: params["date_received_feedback"],
          customer_id: update_loan.customer_id,
          reference_no: update_loan.reference_no,
        })
        |> Repo.insert()
       _ ->
       recommended_params = %{
          recommended: params["recommended_feedback"],
          user_type: "CREDIT_ANALYST",
          on_hold: params["on_hold_feedback"],
          file_sent_to_sale: params["file_sent_to_sale_feedback"],
          comments: params["comments_feedback"],
          name: params["name_feedback"],
          position: params["position_feedback"],
          date: params["date_feedback"],
          time_received: params["time_received_feedback"],
          time_out: params["time_out_feedback"],
          date_received: params["date_received_feedback"],
          customer_id: update_loan.customer_id,
          reference_no: update_loan.reference_no,
      }
      Ecto.Multi.new()
      |> Ecto.Multi.update(:update_loan_recommendation, Loan_recommendation_and_assessment.changeset(update_loan_recommendation, recommended_params))
      |> Repo.transaction()
    end
    # -----------------------------

   end)
   |> Repo.transaction()
   |> case do
     {:ok, %{update_loan: _update_loan, user_logs: _user_logs}} ->
       conn
       |> put_flash(:info, "Loan Application Updated")
       |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

     {:error, _failed_operation, failed_value, _changes_so_far} ->
       reason = traverse_errors(failed_value.errors) |> List.first()
       conn
       |> put_flash(:error, reason)
       |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
   end
 else
   _ ->
   conn
   |> put_flash(:error, "Something went wrong, try again.")
   |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
 end
end


def update_instant_loan_application(conn, params) do
  with(
   update_loan when update_loan != nil <- Loanmanagementsystem.Loan.Loans.find_by(id: params["loan_id"])
   ) do
   Ecto.Multi.new()
   |> Ecto.Multi.update(:update_loan, Loans.changeset(update_loan, params))
   |> Ecto.Multi.run(:user_logs, fn _repo, %{update_loan: _update_loan} ->
     UserLogs.changeset(%UserLogs{}, %{
       activity: "Loan Application Successfully Updated",
       user_id: conn.assigns.user.id
     })
     |> Repo.insert()
     # ------------------------------------Loan Customer details -------
     loan_customer_kyc = %{
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
       residential_address: params["residential_address"],
       landmark: params["landmark"],
       town: params["town"],
       province: params["province"],
     }
     update_loan_customer_kyc = Loan_customer_details.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
     Ecto.Multi.new()
     |> Ecto.Multi.update(:update_loan_customer_kyc, Loan_customer_details.changeset(update_loan_customer_kyc, loan_customer_kyc))
     |> Repo.transaction()
    #  --------------------------------------- Employment Details
    market_details = %{
      duration_at_market: params["duration_at_market"],
      location_of_market: params["location_of_market"],
      mobile_of_market_leader: params["mobile_of_market_leader"],
      name_of_market: params["name_of_market"],
      name_of_market_leader: params["name_of_market_leader"],
      name_of_market_vice: params["name_of_market_vice"],
      type_of_business: params["type_of_business"],
      mobile_of_market_vice: params["mobile_of_market_vice"],
      stand_number: params["stand_number"],

    }
    update_market_details = Loan_market_info.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_market_details, Loan_market_info.changeset(update_market_details, market_details))
    |> Repo.transaction()
    #  -------------------------------------- CRO
    # cro_recommendation = %{
    #   recommended: params["recommended_feedback"],
    #   on_hold: params["on_hold_feedback"],
    #   file_sent_to_sale: params["file_sent_to_sale_feedback"],
    #   comments: params["comments_feedback"],
    #   name: params["name_feedback"],
    #   signature: params["signature_feedback"],
    #   position: params["position_feedback"],
    #   date: params["date_feedback"],
    #   time_received: params["time_received_feedback"],
    #   time_out: params["time_out_feedback"],
    #   date_received: params["date_received_feedback"],
    # }
    # update_cro_recommendation = Loan_recommendation_and_assessment.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no, user_type: "SALES")
    # Ecto.Multi.new()
    # |> Ecto.Multi.update(:update_cro_recommendation, Loan_recommendation_and_assessment.changeset(update_cro_recommendation, cro_recommendation))
    # |> Repo.transaction()
     # -------------------------------------Next of Kin
     loan_nextofkin_params = %{
       kin_first_name: params["kin_first_name"],
       kin_last_name: params["kin_last_name"],
       kin_other_name: params["kin_other_name"],
       kin_status: params["kin_status"],
       kin_relationship: params["kin_relationship"],
       kin_gender: params["kin_gender"],
       kin_mobile_number: params["kin_mobile_number"],
     }
     update_loan_nextofkin = Nextofkin.find_by(userID: update_loan.customer_id, reference_no: update_loan.reference_no)
     Ecto.Multi.new()
     |> Ecto.Multi.update(:update_loan_nextofkin, Nextofkin.changeset(update_loan_nextofkin, loan_nextofkin_params))
     |> Repo.transaction()
   end)
   |> Repo.transaction()
   |> case do
     {:ok, %{update_loan: _update_loan, user_logs: _user_logs}} ->
       conn
       |> put_flash(:info, "Loan Application Updated")
       |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

     {:error, _failed_operation, failed_value, _changes_so_far} ->
       reason = traverse_errors(failed_value.errors) |> List.first()
       conn
       |> put_flash(:error, reason)
       |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
   end
 else
   _ ->
   conn
   |> put_flash(:error, "Something went wrong, try again.")
   |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
 end
end


def create_instant_loan_application(conn, params) do
  # if Enum.dedup(params["filename"]) != [""] do
  new_params =
    Map.merge(params, %{
      "principal_amount_proposed" => params["requested_amount"],
      "loan_status" => "PENDING_CREDIT_ANALYST",
      "status" => "PENDING_CREDIT_ANALYST",
      "reference_no" =>  generate_reference_no(params["customer_id"]),
    })
  Ecto.Multi.new()
  |> Ecto.Multi.insert(:add_loan, Loans.changeset(%Loans{}, new_params))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "Loan Application Successfully Submitted",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
    # ------------------------------------Loan Customer details
    Loan_customer_details.changeset(%Loan_customer_details{}, %{
      customer_id: params["customer_id"],
      reference_no: new_params["reference_no"],
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
      residential_address: params["residential_address"],
      landmark: params["landmark"],
      town: params["town"],
      province: params["province"],
    })
    |> Repo.insert()
     # ---------------------------------------- Client income statement assessment
     Loan_income_assessment.changeset(%Loan_income_assessment{}, %{
      customer_id: params["customer_id"],
      reference_no: new_params["reference_no"],
      business_type: params["business_type"],
      jan: params["jan"],
      jan_bank_stat: params["jan_bank_stat"],
      jan_mobile_stat: params["jan_mobile_stat"],
      jan_total: params["jan_total"],
      dec: params["dec"],
      dec_bank_stat: params["dec_bank_stat"],
      dec_mobile_stat: params["dec_mobile_stat"],
      dec_total: params["dec_total"],
      nov: params["nov"],
      nov_bank_stat: params["nov_bank_stat"],
      nov_mobile_stat: params["nov_mobile_stat"],
      nov_total: params["nov_total"],
      average_income: params["average_income"],
      dstv: params["dstv"],
      food: params["food"],
      school: params["school"],
      utilities: params["utilities"],
      loan_installment: params["loan_installment"],
      salaries: params["salaries"],
      stationery: params["stationery"],
      transport: params["transport"],
      total_expenses: params["total_expenses"],
      available_income: params["available_income"],
      loan_installment_total: params["loan_installment_total"],
      dsr: params["dsr"],

    })
    |> Repo.insert()
    # ----------------------------------- Reference
    reference_name = params["name"]
    if reference_name == nil || reference_name == [] || reference_name == ["undefined"] do
      IO.puts "No Reference Attachment Detected"
    else
      for x <- 0..(Enum.count(reference_name)-1) do
        reference_params =
        %{
             customer_id: params["customer_id"],
             reference_no: new_params["reference_no"],
             name: Enum.at(reference_name, x),
             contact_no:  Enum.at(params["contact_no"], x),
          }
        Loan_applicant_reference.changeset(%Loan_applicant_reference{}, reference_params)
        |> Repo.insert()
      end
    end
    # -------------------------------------------Base 64 image Encoder
    applicant_signature = image_data_applicant_signature(params)
    IO.inspect applicant_signature, label: "applicant_signature ***************************"
    applicant_signature_encode_img = if applicant_signature != false do parse_image(applicant_signature.path) else "" end
    witness_signature = image_data_witness_signature(params)
    witness_signature_encode_img = if witness_signature != false  do parse_image(witness_signature.path) else "" end
    cro_staff_signature = image_data_cro_staff_signature(params)
    cro_staff_signature_encode_img = if  cro_staff_signature != false do parse_image(cro_staff_signature.path) else "" end
    # gaurantor_signature = image_data_gaurantor_signature(params)
    # gaurantor_signature_encode_img = if gaurantor_signature != false do parse_image(gaurantor_signature.path) else "" end
    # guarantor_witness_signature = image_data_guarantor_witness_signature(params)
    # guarantor_witness_signature_encode_img = if guarantor_witness_signature != false do parse_image(guarantor_witness_signature.path) else "" end
   # ----------------------------------- Collateral
    collateral = params["name_of_collateral"]
    if collateral == nil || collateral == [] || collateral == ["undefined"] do
      IO.puts "No Reference Attachment Detected"
    else
      for x <- 0..(Enum.count(collateral)-1) do

        collateral_params =
        %{
             customer_id: params["customer_id"],
             reference_no: new_params["reference_no"],
             asset_value: Enum.at(params["asset_value"], x),
             color:  Enum.at(params["color"], x),
             id_number: Enum.at(params["id_number_collateral"], x),
             name_of_collateral:  Enum.at(params["name_of_collateral"], x),
             applicant_signature: applicant_signature_encode_img,
             name_of_witness:  params["name_of_witness"],
             witness_signature: witness_signature_encode_img,
             cro_staff_name:  params["cro_staff_name"],
             cro_staff_signature:  cro_staff_signature_encode_img,
          }
        Loan_applicant_collateral.changeset(%Loan_applicant_collateral{}, collateral_params)
        |> Repo.insert()
      end
     end
    # ---------------------------------------- Market Info
    Loan_market_info.changeset(%Loan_market_info{}, %{
      customer_id: params["customer_id"],
      reference_no: new_params["reference_no"],
      name_of_market: params["name_of_market"],
      location_of_market: params["location_of_market"],
      duration_at_market: params["duration_at_market"],
      type_of_business: params["type_of_business"],
      name_of_market_leader: params["name_of_market_leader"],
      mobile_of_market_leader: params["mobile_of_market_leader"],
      name_of_market_vice: params["name_of_market_vice"],
      mobile_of_market_vice: params["mobile_of_market_vice"],
      stand_number: params["stand_number"],
    })
    |> Repo.insert()
    # -------------------------------------- Recommendation
    # Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
    #   customer_id: params["customer_id"],
    #   reference_no: new_params["reference_no"],
    #   recommended: params["recommended_feedback"],
    #   user_type: "SALES",
    #   on_hold: params["on_hold_feedback"],
    #   file_sent_to_sale: params["file_sent_to_sale_feedback"],
    #   comments: params["comments_feedback"],
    #   name: params["name_feedback"],
    #   signature: params["signature_feedback"],
    #   position: params["position_feedback"],
    #   date: params["date_feedback"],
    #   time_received: params["time_received_feedback"],
    #   time_out: params["time_out_feedback"],
    #   date_received: params["date_received_feedback"],
    # })
    # |> Repo.insert()
    # -------------------------------------Next of Kin
    Nextofkin.changeset(%Nextofkin{}, %{
      userID: params["customer_id"],
      reference_no: new_params["reference_no"],
      kin_first_name: params["kin_first_name"],
      kin_last_name: params["kin_last_name"],
      kin_other_name: params["kin_other_name"],
      kin_status: params["kin_status"],
      kin_relationship: params["kin_relationship"],
      kin_gender: params["kin_gender"],
      kin_mobile_number: params["kin_mobile_number"],
    })
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, %{add_loan: _add_loan, user_logs: _user_logs}} ->
      loan_details = Loans.find_by(reference_no: new_params["reference_no"])
      nrc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(userId: params["customer_id"]).meansOfIdentificationNumber rescue _-> "" end
      Loanmanagementsystem.Services.LoanDocumentsUploads.client_upload(%{"process_documents" => params, "conn" => conn, "nrc" => nrc, "loan_id" => loan_details.id, "file_category" => "LOAN_DOCUMENTS"})

      conn
      |> put_flash(:info, "Loan Application Submitted")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors) |> List.first()
      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
# else
#   conn
#   |> put_flash(:error,"Kindly attach document(s) and Try again")
#   |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
# end
end

def update_loan_reference(conn, params) do
  reference_details = Loan.get_loan_applicant_reference!(params["id"])
  Ecto.Multi.new()
  |> Ecto.Multi.update(:reference_details, Loan_applicant_reference.changeset(reference_details, params))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{reference_details: _reference_details} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "You have Successfully Updated reference",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, _} ->
      conn
      |> put_flash(:info, "You have Successfully Updated")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors)

      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
end


def create_salarybacked_loan_application(conn, params) do
  # if Enum.dedup(params["filename"]) != [""] do
  new_params =
    Map.merge(params, %{
      "principal_amount_proposed" => params["requested_amount"],
      "loan_status" => "PENDING_CREDIT_ANALYST",
      "status" => "PENDING_CREDIT_ANALYST",
      "reference_no" =>  generate_reference_no(params["customer_id"]),
    })
  Ecto.Multi.new()
  |> Ecto.Multi.insert(:add_loan, Loans.changeset(%Loans{}, new_params))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "Loan Application Successfully Submitted",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
    # ------------------------------------Loan Customer details
    Loan_customer_details.changeset(%Loan_customer_details{}, %{
      customer_id: params["customer_id"],
      reference_no: new_params["reference_no"],
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
      residential_address: params["residential_address"],
      landmark: params["landmark"],
      town: params["town"],
      province: params["province"],
      crb_consent: params["crb_consent"],
      sector: params["sector"],
      geographical_location: params["geographical_location"],
      type_of_facility: params["type_of_facility"],
      employee_number: params["employee_number"]
    })
    |> Repo.insert()
    # ---------------------------------------- Client income statement assessment
    Loan_income_assessment.changeset(%Loan_income_assessment{}, %{
      customer_id: params["customer_id"],
      reference_no: new_params["reference_no"],
      business_type: params["business_type"],
      jan: params["jan"],
      jan_bank_stat: params["jan_bank_stat"],
      jan_mobile_stat: params["jan_mobile_stat"],
      jan_total: params["jan_total"],
      dec: params["dec"],
      dec_bank_stat: params["dec_bank_stat"],
      dec_mobile_stat: params["dec_mobile_stat"],
      dec_total: params["dec_total"],
      nov: params["nov"],
      nov_bank_stat: params["nov_bank_stat"],
      nov_mobile_stat: params["nov_mobile_stat"],
      nov_total: params["nov_total"],
      average_income: params["average_income"],
      dstv: params["dstv"],
      food: params["food"],
      school: params["school"],
      utilities: params["utilities"],
      loan_installment: params["loan_installment"],
      salaries: params["salaries"],
      stationery: params["stationery"],
      transport: params["transport"],
      total_expenses: params["total_expenses"],
      available_income: params["available_income"],
      loan_installment_total: params["loan_installment_total"],
      dsr: params["dsr"],

    })
    |> Repo.insert()
    # ----------------------------------- user bio
    user_bio_details = %{
      employee_number: params["employee_number"]
    }
    user_bio = UserBioData.find_by(userId: params["customer_id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user_bio, UserBioData.changeset(user_bio, user_bio_details))
    |> Repo.transaction()
    # ----------------------------------- Reference
    reference_name = params["name"]
    if reference_name == nil || reference_name == [] || reference_name == ["undefined"] do
      IO.puts "No Reference Attachment Detected"
    else
      for x <- 0..(Enum.count(reference_name)-1) do
        reference_params =
        %{
             customer_id: params["customer_id"],
             reference_no: new_params["reference_no"],
             name: Enum.at(reference_name, x),
             contact_no:  Enum.at(params["contact_no"], x),
          }
        Loan_applicant_reference.changeset(%Loan_applicant_reference{}, reference_params)
        |> Repo.insert()
      end
    end

    # ---------------------------------------- Employment Info
    Loan_employment_info.changeset(%Loan_employment_info{}, %{
      customer_id: params["customer_id"],
      reference_no: new_params["reference_no"],
      employer: params["employer_info"],
      address: params["address_info"],
      employment_status: params["employment_status_info"],
      town: params["town_info"],
      employer_email_address: params["employer_email_address_info"],
      employer_phone: params["employer_phone_info"],
      job_title: params["job_title_info"],
      supervisor_name: params["supervisor_name_info"],
      province: params["province_info"],
      employment_date: params["employment_date_info"],
      date_to: params["date_to_info"],
      applicant_name: params["applicant_name_info"],
      company_name: params["company_name_info"],
      granted_loan_amt: params["granted_loan_amt_info"],
      gross_salary: params["gross_salary_info"],
      net_salary: params["net_salary_info"],
      other_outstanding_loans: params["other_outstanding_loans_info"],
      accrued_gratuity: params["accrued_gratuity_info"],
      contact_no: params["contact_no_info"],
      authorised_signature: params["authorised_signature_info"],
      date: params["date_info"],

    })
    |> Repo.insert()
     # -------------------------------------------Base 64 image Encoder
        applicant_signature = image_data_applicant_signature(params)
        IO.inspect applicant_signature, label: "applicant_signature ***************************"
        applicant_signature_encode_img = if applicant_signature != false do parse_image(applicant_signature.path) else "" end
        witness_signature = image_data_witness_signature(params)
        witness_signature_encode_img = if witness_signature != false  do parse_image(witness_signature.path) else "" end
        cro_staff_signature = image_data_cro_staff_signature(params)
        cro_staff_signature_encode_img = if  cro_staff_signature != false do parse_image(cro_staff_signature.path) else "" end
        gaurantor_signature = image_data_gaurantor_signature(params)
        gaurantor_signature_encode_img = if gaurantor_signature != false do parse_image(gaurantor_signature.path) else "" end
        guarantor_witness_signature = image_data_guarantor_witness_signature(params)
        guarantor_witness_signature_encode_img = if guarantor_witness_signature != false do parse_image(guarantor_witness_signature.path) else "" end
       # ----------------------------------- Collateral
        collateral = params["name_of_collateral"]
        if collateral == nil || collateral == [] || collateral == ["undefined"] do
          IO.puts "No Reference Attachment Detected"
        else
          for x <- 0..(Enum.count(collateral)-1) do

            collateral_params =
            %{
                 customer_id: params["customer_id"],
                 reference_no: new_params["reference_no"],
                 asset_value: Enum.at(params["asset_value"], x),
                 color:  Enum.at(params["color"], x),
                 id_number: Enum.at(params["id_number_collateral"], x),
                 name_of_collateral:  Enum.at(params["name_of_collateral"], x),
                 applicant_signature: applicant_signature_encode_img,
                 name_of_witness:  params["name_of_witness"],
                 witness_signature: witness_signature_encode_img,
                 cro_staff_name:  params["cro_staff_name"],
                 cro_staff_signature:  cro_staff_signature_encode_img,
              }
            Loan_applicant_collateral.changeset(%Loan_applicant_collateral{}, collateral_params)
            |> Repo.insert()
          end
         end
        # ----------------------------------- Guarantor
         Loan_applicant_guarantor.changeset(%Loan_applicant_guarantor{}, %{
          customer_id: params["customer_id"],
          reference_no: new_params["reference_no"],
          cost_of_sales: params["cost_of_sales"],
          occupation: params["occupation"],
          email: params["guarantor_email"],
          employer: params["employer"],
          gaurantor_sign_date: params["gaurantor_sign_date"],
          gaurantor_signature: gaurantor_signature_encode_img,
          guarantor_name: params["guarantor_name"],
          guarantor_phone_no: params["guarantor_phone_no"],
          loan_applicant_name: params["loan_applicant_name"],
          name_of_cro_staff: params["gaurantor_cro_staff"],
          name_of_witness: params["guarantor_witness_name"],
          guarantor_witness_signature: guarantor_witness_signature_encode_img,
          witness_sign_date: params["witness_sign_date"],
          net_profit_loss: params["net_profit_loss"],
          nrc: params["guarantor_nrc"],
          other_expenses: params["other_expenses"],
          other_income_bills: params["other_income_bills"],
          relationship: params["guarantor_relationship"],
          salary_loan: params["salary_loan"],
          sale_business_rentals: params["sale_business_rentals"],
          staff_sign_date: params["staff_sign_date"],
          staff_signature: cro_staff_signature_encode_img,
          total_income_expense: params["total_income_expense"],
          salary: params["salary"],
          other_income: params["other_income"],
          business_sales: params["business_sales"],
          total_income: params["total_income"]
        })
        |> Repo.insert()
   # -------------------------------------- Recommendation
    # Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
    #   customer_id: params["customer_id"],
    #   reference_no: new_params["reference_no"],
    #   recommended: params["recommended_feedback"],
    #   user_type: "SALES",
    #   on_hold: params["on_hold_feedback"],
    #   file_sent_to_sale: params["file_sent_to_sale_feedback"],
    #   comments: params["comments_feedback"],
    #   name: params["name_feedback"],
    #   signature: params["signature_feedback"],
    #   position: params["position_feedback"],
    #   date: params["date_feedback"],
    #   time_received: params["time_received_feedback"],
    #   time_out: params["time_out_feedback"],
    #   date_received: params["date_received_feedback"],
    # })
    # |> Repo.insert()
    # -------------------------------------Next of Kin
    Nextofkin.changeset(%Nextofkin{}, %{
      userID: params["customer_id"],
      reference_no: new_params["reference_no"],
      kin_first_name: params["kin_first_name"],
      kin_last_name: params["kin_last_name"],
      kin_other_name: params["kin_other_name"],
      kin_status: params["kin_status"],
      kin_relationship: params["kin_relationship"],
      kin_gender: params["kin_gender"],
      kin_mobile_number: params["kin_mobile_number"],
    })
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, %{add_loan: _add_loan, user_logs: _user_logs}} ->
      loan_details = Loans.find_by(reference_no: new_params["reference_no"])
      nrc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(userId: params["customer_id"]).meansOfIdentificationNumber rescue _-> "" end
      Loanmanagementsystem.Services.LoanDocumentsUploads.client_upload(%{"process_documents" => params, "conn" => conn, "nrc" => nrc, "loan_id" => loan_details.id, "file_category" => "EMPLOYMENT_VERIFICATION"})
      conn
      |> put_flash(:info, "Loan Application Submitted")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors) |> List.first()
      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
# else
#   conn
#   |> put_flash(:error,"Kindly attach document(s) and Try again")
#   |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
# end
end

def discard_loan_reference(conn, params) do
  reference_details = Loan_applicant_reference.find_by(id: params["id"])
  param =  %{
    "reference_no" => "#{reference_details.reference_no}_DISCARDED",
  }
  Ecto.Multi.new()
  |> Ecto.Multi.update(:reference_details, Loan_applicant_reference.changeset(reference_details, param))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{reference_details: _reference_details} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "You have Successfully Updated reference",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, _} ->
      json(conn, %{data: "You have Successfully Updated."})

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors)
      json(conn, %{error: reason})
  end
end

def create_loan_reference(conn,%{"reference_contact_no" => reference_contact_no, "reference_name" => reference_name} = params) do
  IO.inspect(params, label: "----------------------------------")

  IO.inspect(reference_contact_no, label: "reference_contact_no ----------------------------------")
  IO.inspect(reference_name, label: "reference_name ----------------------------------")

    with(
      loan_details when loan_details  != nil <- Loanmanagementsystem.Loan.Loans.find_by(id: params["id"])
    ) do
    Ecto.Multi.new()
    |> Ecto.Multi.run(:add_reference, fn _repo, _changes ->
      loan_details = Loanmanagementsystem.Loan.Loans.find_by(id: params["id"])

      new_params = for {name, contact_no} <- Enum.zip(reference_name, reference_contact_no) do
        %{
          name: name,
          contact_no: contact_no,
          customer_id: loan_details.customer_id,
          reference_no: loan_details.reference_no
        }
      end

      result = Enum.reduce(new_params, {:ok, []}, fn element, {:ok, acc} ->
        case Loan_applicant_reference.changeset(%Loan_applicant_reference{}, element) |> Repo.insert() do
          {:ok, inserted} -> {:ok, [inserted | acc]}
          {:error, reason} -> {:error, reason}
        end
      end)

      case result do
        {:ok, inserted_records} -> {:ok, inserted_records}
        {:error, reason} -> {:error, reason}
      end
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_reference: _add_reference} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully created reference",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Created")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end
  else
    _->
      conn
      |> put_flash(:error, "Something went wrong, try again.")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
end



def reject_loan_application(conn, params) do
  loan_details = Loanmanagementsystem.Loan.Loans.find_by(id: params["loan_id"])
  Ecto.Multi.new()
  |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, params))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_details: _loan_details} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "You have Successfully Rejected loan",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, _} ->
      conn
      |> put_flash(:info, "You have Successfully rejected the loan")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors)

      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
end

def update_loan_collateral_details(conn, params) do
  collateral_details = Loan_applicant_collateral.find_by(id: params["id"])
  asset_value_k = String.replace(params["asset_value_k"], ",", "")
  new_params = Map.merge(params, %{
    "asset_value" => asset_value_k,
  })
  Ecto.Multi.new()
  |> Ecto.Multi.update(:collateral_details, Loan_applicant_collateral.changeset(collateral_details, new_params))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{collateral_details: _collateral_details} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "You have Successfully Updated Collateral",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, _} ->
      conn
      |> put_flash(:info, "You have Successfully Updated")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors)

      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
end

def discard_loan_collateral(conn, params) do
  collateral_details = Loan_applicant_collateral.find_by(id: params["id"])
  param =  %{
    "reference_no" => "#{collateral_details.reference_no}_DISCARDED",
  }
  Ecto.Multi.new()
  |> Ecto.Multi.update(:collateral_details, Loan_applicant_collateral.changeset(collateral_details, param))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{collateral_details: _collateral_details} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "You have Successfully Updated Collateral",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, _} ->
      json(conn, %{data: "You have Successfully Updated."})

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors)
      json(conn, %{error: reason})
  end
end

def create_loan_collateral(conn, params) do
  with(
    loan_details when loan_details  != nil <- Loanmanagementsystem.Loan.Loans.find_by(id: params["id"])
  ) do
  new_params = Map.merge(params, %{
    "customer_id" => loan_details.customer_id,
    "reference_no" =>  loan_details.reference_no,
  })
  Ecto.Multi.new()
  |> Ecto.Multi.insert(:add_reference, Loan_applicant_collateral.changeset(%Loan_applicant_collateral{}, new_params))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{add_reference: _add_reference} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "You have Successfully created Collateral with name - #{params["name_of_collateral"]}",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, _} ->
      conn
      |> put_flash(:info, "You have Successfully Created")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors)

      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
else
  _->
    conn
    |> put_flash(:error, "Something went wrong, try again.")
    |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
end
end

def view_before_approving_loan_application_operations(conn, params) do
  product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
    if product_type == "Instant Loan" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
      credit_manager_recommedation = Loan.credit_manager_validation(params["userId"], params["reference_no"])
      accounts_assistant_recommedation = Loan.assistant_accountant_validation(params["userId"], params["reference_no"])
      finance_manager_recommedation = Loan.finance_manager_validation(params["userId"], params["reference_no"])
      legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
      ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
      sales_recommedation = if Loan.sales_recommedation_validation(params["userId"], params["reference_no"]) != "FAILED"  do
      Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
      else
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
      market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
      loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
      loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
      loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
      loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      render(conn, "operations_instant_loan_application.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        sales_recommedation: sales_recommedation,
        market_info: market_info,
        loan_documents: loan_documents,
        credit_analyst_recommedation: credit_analyst_recommedation,
        credit_manager_recommedation: credit_manager_recommedation,
        accounts_assistant_recommedation: accounts_assistant_recommedation,
        finance_manager_recommedation: finance_manager_recommedation,
        legal_recommedation: legal_recommedation,
        ceo_recommedation: ceo_recommedation,
        crb_loan_documents: crb_loan_documents,
        loan_5cs: loan_5cs,
        loan_checklist: loan_checklist,
        loan_credit_details: loan_credit_details,
        loan_property_documents: loan_property_documents,
        client_income_statement: client_income_statement,
      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "Business Loan" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
      nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
      credit_manager_recommedation = Loan.credit_manager_validation(params["userId"], params["reference_no"])
      accounts_assistant_recommedation = Loan.assistant_accountant_validation(params["userId"], params["reference_no"])
      finance_manager_recommedation = Loan.finance_manager_validation(params["userId"], params["reference_no"])
      legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
      ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      sales_recommedation = if Loan.sales_recommedation_validation(params["userId"], params["reference_no"]) != "FAILED"  do
        Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
      else
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
      crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
      loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
      loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
      loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
      loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      company_details = Loanmanagementsystem.Accounts.get_client_company_details(params["userId"])
      render(conn, "operations_approve_universal_loan_application.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        sales_recommedation: sales_recommedation,
        loan_documents: loan_documents,
        credit_analyst_recommedation: credit_analyst_recommedation,
        credit_manager_recommedation: credit_manager_recommedation,
        accounts_assistant_recommedation: accounts_assistant_recommedation,
        finance_manager_recommedation: finance_manager_recommedation,
        legal_recommedation: legal_recommedation,
        ceo_recommedation: ceo_recommedation,
        crb_loan_documents: crb_loan_documents,
        loan_5cs: loan_5cs,
        loan_checklist: loan_checklist,
        loan_credit_details: loan_credit_details,
        loan_property_documents: loan_property_documents,
        client_income_statement: client_income_statement,
        company_details: company_details
      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

      else
        if product_type == "Salary Backed Loan" do
          with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
          guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
          credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
          credit_manager_recommedation = Loan.credit_manager_validation(params["userId"], params["reference_no"])
          accounts_assistant_recommedation = Loan.assistant_accountant_validation(params["userId"], params["reference_no"])
          finance_manager_recommedation = Loan.finance_manager_validation(params["userId"], params["reference_no"])
          legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
          ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
          sales_recommedation = if Loan.sales_recommedation_validation(params["userId"], params["reference_no"]) != "FAILED"  do
            Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
          else
            conn
            |> put_flash(:error, "Something went wrong, try again.")
            |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end
          employment_details = Loan.list_employment_info_validation(params["userId"], params["reference_no"])
          loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
          employment_verifications =  Loanmanagementsystem.OperationsServices.get_loan_employememt_verification_docs(loan_id)
          loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
          crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
          loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
          loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
          loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
          loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
          client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
          render(conn, "operations_salary_loan_application.html",
            current_time: current_time(),
            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
            client_data: client_data,
            client_kyc: client_kyc,
            nextofkin: nextofkin,
            client_references: client_references,
            loan_details: loan_details,
            collateral_details: collateral_details,
            extracted_other_collateral_details: extracted_other_collateral_details,
            guarantors_details: guarantors_details,
            sales_recommedation: sales_recommedation,
            employment_details: employment_details,
            employment_verifications: employment_verifications,
            loan_documents: loan_documents,
            credit_analyst_recommedation: credit_analyst_recommedation,
            credit_manager_recommedation: credit_manager_recommedation,
            accounts_assistant_recommedation: accounts_assistant_recommedation,
            finance_manager_recommedation: finance_manager_recommedation,
            legal_recommedation: legal_recommedation,
            ceo_recommedation: ceo_recommedation,
            crb_loan_documents: crb_loan_documents,
            loan_5cs: loan_5cs,
            loan_checklist: loan_checklist,
            loan_credit_details: loan_credit_details,
            loan_property_documents: loan_property_documents,
            client_income_statement: client_income_statement,
          )
          else
            _ ->
            conn
            |> put_flash(:error, "Something went wrong, try again.")
            |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end

        else
          conn
          |> put_flash(:error, "Something went wrong, try again.")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
        end
      end
    end
end


def view_before_approving_loan_application_sales(conn, params) do
  product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
    if product_type == "Instant Loan" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      sales_recommedation = if Loan.sales_recommedation_validation(params["userId"], params["reference_no"]) != "FAILED"  do
        Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
      else
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
      market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      render(conn, "sales_instant_loan_application.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        sales_recommedation: sales_recommedation,
        market_info: market_info,
        loan_documents: loan_documents,
        client_income_statement: client_income_statement,
      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "Business Loan" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
      nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      sales_recommedation = if Loan.sales_recommedation_validation(params["userId"], params["reference_no"]) != "FAILED"  do
        Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
      else
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
      render(conn, "sales_approve_universal_loan_application.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        sales_recommedation: sales_recommedation,
        loan_documents: loan_documents,
        client_income_statement: client_income_statement,
      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

      else
        if product_type == "Salary Backed Loan" do
          with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
          guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
          client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
          sales_recommedation = if Loan.sales_recommedation_validation(params["userId"], params["reference_no"]) != "FAILED"  do
            Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
          else
            conn
            |> put_flash(:error, "Something went wrong, try again.")
            |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end
          employment_details = Loan.list_employment_info_validation(params["userId"], params["reference_no"])
          loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
          employment_verifications =  Loanmanagementsystem.OperationsServices.get_loan_employememt_verification_docs(loan_id)
          loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
          render(conn, "sales_salary_loan_application.html",
            current_time: current_time(),
            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
            client_data: client_data,
            client_kyc: client_kyc,
            nextofkin: nextofkin,
            client_references: client_references,
            loan_details: loan_details,
            collateral_details: collateral_details,
            extracted_other_collateral_details: extracted_other_collateral_details,
            guarantors_details: guarantors_details,
            sales_recommedation: sales_recommedation,
            employment_details: employment_details,
            employment_verifications: employment_verifications,
            loan_documents: loan_documents,
            client_income_statement: client_income_statement,
          )
          else
            _ ->
            conn
            |> put_flash(:error, "Something went wrong, try again.")
            |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end

        else
          conn
          |> put_flash(:error, "Something went wrong, try again.")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
        end
      end
    end
end



def view_before_approving_loan_application(conn, params) do
  product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
    if product_type == "Instant Loan" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loanmanagementsystem.Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loanmanagementsystem.Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loanmanagementsystem.Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loanmanagementsystem.Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
      market_info = Loanmanagementsystem.Loan.list_loan_market_info(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      cro_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).cro_id rescue _-> 0 end
      cro_staff =  Loan.get_loan_cro_staff_by_croid(cro_id)
      applicant_name = "#{client_kyc.firstname || ""}"<> " " <> "#{client_kyc.surname || ""}"<> " " <> "#{client_kyc.othername || ""}"
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      render(conn, "credit_analyst_instant_loan_application.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        sales_recommedation: sales_recommedation,
        market_info: market_info,
        loan_documents: loan_documents,
        cro_staff: cro_staff,
        applicant_name: applicant_name,
        client_income_statement: client_income_statement,
        client_details: client_details
      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "Business Loan" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
      nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      cro_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).cro_id rescue _-> 0 end
      cro_staff =  Loan.get_loan_cro_staff_by_croid(cro_id)
      applicant_name = "#{client_kyc.firstname || ""}"<> " " <> "#{client_kyc.surname || ""}"<> " " <> "#{client_kyc.othername || ""}"
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      company_details = Loanmanagementsystem.Accounts.get_client_company_details(params["userId"])
      render(conn, "approve_universal_loan_application.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        sales_recommedation: sales_recommedation,
        loan_documents: loan_documents,
        cro_staff: cro_staff,
        applicant_name: applicant_name,
        client_income_statement: client_income_statement,
        company_details: company_details,
        client_details: client_details
      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

      else
        if product_type == "Salary Backed Loan" do
          with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
          guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
          sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info_validation(params["userId"], params["reference_no"])
          loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
          employment_verifications =  Loanmanagementsystem.OperationsServices.get_loan_employememt_verification_docs(loan_id)
          loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
          cro_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).cro_id rescue _-> 0 end
          cro_staff =  Loan.get_loan_cro_staff_by_croid(cro_id)
          applicant_name = "#{client_kyc.firstname || ""}"<> " " <> "#{client_kyc.surname || ""}"<> " " <> "#{client_kyc.othername || ""}"
          client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
          render(conn, "credit_analyst_salary_loan_application.html",
            current_time: current_time(),
            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
            client_data: client_data,
            client_kyc: client_kyc,
            nextofkin: nextofkin,
            client_references: client_references,
            loan_details: loan_details,
            collateral_details: collateral_details,
            extracted_other_collateral_details: extracted_other_collateral_details,
            guarantors_details: guarantors_details,
            sales_recommedation: sales_recommedation,
            employment_details: employment_details,
            employment_verifications: employment_verifications,
            loan_documents: loan_documents,
            cro_staff: cro_staff,
            applicant_name: applicant_name,
            client_income_statement: client_income_statement,
            client_details: client_details
          )
          else
            _ ->
            conn
            |> put_flash(:error, "Something went wrong, try again.")
            |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end

        else
          conn
          |> put_flash(:error, "Something went wrong, try again.")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
        end
      end
    end
end

def edit_credit_analyst_loan_file_input(conn, params) do
  product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
  if product_type == "Instant Loan" do
    with(
      client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
    ) do
     nrc = client_details.id_number
    client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
    client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
    nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
    client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
    loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
    collateral_details = Loanmanagementsystem.Loan.collateral_details_validation(params["userId"], params["reference_no"])
    extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
    sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
    market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
    credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
    loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
    loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
    legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
    crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
    loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
    loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
    loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
    loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
    client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
    cro_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).cro_id rescue _-> 0 end
    customer_relationship_officer = Loanmanagementsystem.Operations.customer_relationship_officer(cro_id)
    render(conn, "edit_credit_analyst_instant_loan_application.html",
      current_time: current_time(),
      product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
      product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
      client_data: client_data,
      client_kyc: client_kyc,
      nextofkin: nextofkin,
      client_references: client_references,
      loan_details: loan_details,
      collateral_details: collateral_details,
      extracted_other_collateral_details: extracted_other_collateral_details,
      sales_recommedation: sales_recommedation,
      market_info: market_info,
      credit_analyst_recommedation: credit_analyst_recommedation,
      loan_documents: loan_documents,
      legal_recommedation: legal_recommedation,
      crb_loan_documents: crb_loan_documents,
      loan_5cs: loan_5cs,
      loan_checklist: loan_checklist,
      loan_credit_details: loan_credit_details,
      loan_property_documents: loan_property_documents,
      client_income_statement: client_income_statement,
      client_details: client_details,
      cro: customer_relationship_officer
    )
    else
      _ ->
      conn
      |> put_flash(:error, "Something went wrong, try again.")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end


  else
    if product_type == "Business Loan" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
      sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
      crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
      loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
      loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
      loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
      loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      company_details = Loanmanagementsystem.Accounts.get_client_company_details(params["userId"])
      cro_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).cro_id rescue _-> 0 end
      customer_relationship_officer = Loanmanagementsystem.Operations.customer_relationship_officer(cro_id)
      render(conn, "edit_credit_analyst_universal_loan_application.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        credit_analyst_recommedation: credit_analyst_recommedation,
        loan_documents: loan_documents,
        legal_recommedation: legal_recommedation,
        sales_recommedation: sales_recommedation,
        crb_loan_documents: crb_loan_documents,
        loan_5cs: loan_5cs,
        loan_checklist: loan_checklist,
        loan_credit_details: loan_credit_details,
        loan_property_documents: loan_property_documents,
        client_income_statement: client_income_statement,
        company_details: company_details,
        cro: customer_relationship_officer

      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "Salary Backed Loan" do
        with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
          guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
          sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info_validation(params["userId"], params["reference_no"])
          credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
          loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
          employment_verifications =  Loanmanagementsystem.OperationsServices.get_loan_employememt_verification_docs(loan_id)
          loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
          legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
          crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
          loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
          loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
          loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
          loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
          client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
          cro_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).cro_id rescue _-> 0 end
          customer_relationship_officer = Loanmanagementsystem.Operations.customer_relationship_officer(cro_id)
          render(conn, "edit_credit_analyst_salary_loan_application.html",
            current_time: current_time(),
            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
            client_data: client_data,
            client_kyc: client_kyc,
            nextofkin: nextofkin,
            client_references: client_references,
            loan_details: loan_details,
            collateral_details: collateral_details,
            extracted_other_collateral_details: extracted_other_collateral_details,
            guarantors_details: guarantors_details,
            sales_recommedation: sales_recommedation,
            employment_details: employment_details,
            credit_analyst_recommedation: credit_analyst_recommedation,
            employment_verifications: employment_verifications,
            loan_documents: loan_documents,
            legal_recommedation: legal_recommedation,
            crb_loan_documents: crb_loan_documents,
            loan_5cs: loan_5cs,
            loan_checklist: loan_checklist,
            loan_credit_details: loan_credit_details,
            loan_property_documents: loan_property_documents,
            client_income_statement: client_income_statement,
            client_details: client_details,
            cro: customer_relationship_officer
          )
          else
            _ ->
            conn
            |> put_flash(:error, "Something went wrong, try again.")
            |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end

      else
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
    end
  end
 end


 def credit_manager_approving_loan_application_view(conn, params) do
  product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
  if product_type == "Instant Loan" do
    with(
      client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
    ) do
     nrc = client_details.id_number
    client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
    client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
    nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
    client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
    loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
    collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
    extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
    sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
    market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
    credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
    loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
    loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
    legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
    crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
    loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
    loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
    loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
    loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
    client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
    render(conn, "credit_manager_instant_loan_application.html",
      current_time: current_time(),
      product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
      product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
      client_data: client_data,
      client_kyc: client_kyc,
      nextofkin: nextofkin,
      client_references: client_references,
      loan_details: loan_details,
      collateral_details: collateral_details,
      extracted_other_collateral_details: extracted_other_collateral_details,
      sales_recommedation: sales_recommedation,
      market_info: market_info,
      credit_analyst_recommedation: credit_analyst_recommedation,
      loan_documents: loan_documents,
      legal_recommedation: legal_recommedation,
      crb_loan_documents: crb_loan_documents,
      loan_5cs: loan_5cs,
      loan_checklist: loan_checklist,
      loan_credit_details: loan_credit_details,
      loan_property_documents: loan_property_documents,
      client_income_statement: client_income_statement,
      client_details: client_details
    )
    else
      _ ->
      conn
      |> put_flash(:error, "Something went wrong, try again.")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end


  else
    if product_type == "Business Loan" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
      sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
      crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
      loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
      loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
      loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
      loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      company_details = Loanmanagementsystem.Accounts.get_client_company_details(params["userId"])
      render(conn, "credit_manager_loan_application_approval.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        credit_analyst_recommedation: credit_analyst_recommedation,
        loan_documents: loan_documents,
        legal_recommedation: legal_recommedation,
        sales_recommedation: sales_recommedation,
        crb_loan_documents: crb_loan_documents,
        loan_5cs: loan_5cs,
        loan_checklist: loan_checklist,
        loan_credit_details: loan_credit_details,
        loan_property_documents: loan_property_documents,
        client_income_statement: client_income_statement,
        company_details: company_details

      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "Salary Backed Loan" do
        with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
          guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
          sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info_validation(params["userId"], params["reference_no"])
          credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
          loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
          employment_verifications =  Loanmanagementsystem.OperationsServices.get_loan_employememt_verification_docs(loan_id)
          loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
          legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
          crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
          loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
          loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
          loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
          loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
          client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
          render(conn, "credit_manager_salary_loan_application.html",
            current_time: current_time(),
            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
            client_data: client_data,
            client_kyc: client_kyc,
            nextofkin: nextofkin,
            client_references: client_references,
            loan_details: loan_details,
            collateral_details: collateral_details,
            extracted_other_collateral_details: extracted_other_collateral_details,
            guarantors_details: guarantors_details,
            sales_recommedation: sales_recommedation,
            employment_details: employment_details,
            credit_analyst_recommedation: credit_analyst_recommedation,
            employment_verifications: employment_verifications,
            loan_documents: loan_documents,
            legal_recommedation: legal_recommedation,
            crb_loan_documents: crb_loan_documents,
            loan_5cs: loan_5cs,
            loan_checklist: loan_checklist,
            loan_credit_details: loan_credit_details,
            loan_property_documents: loan_property_documents,
            client_income_statement: client_income_statement,
            client_details: client_details
          )
          else
            _ ->
            conn
            |> put_flash(:error, "Something went wrong, try again.")
            |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end

      else
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
    end
  end
 end

 def legal_approving_loan_application_view(conn, params) do
  product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
  if product_type == "Instant Loan" do
    with(
      client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
    ) do
     nrc = client_details.id_number
    client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
    client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
    nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
    client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
    loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
    collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
    extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
    sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
    market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
    credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
    credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
    loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
    loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
    crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
    loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
    loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
    loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
    client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
    ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
    render(conn, "legal_instant_loan_application.html",
      current_time: current_time(),
      product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
      product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
      client_data: client_data,
      client_kyc: client_kyc,
      nextofkin: nextofkin,
      client_references: client_references,
      loan_details: loan_details,
      collateral_details: collateral_details,
      extracted_other_collateral_details: extracted_other_collateral_details,
      sales_recommedation: sales_recommedation,
      market_info: market_info,
      credit_analyst_recommedation: credit_analyst_recommedation,
      credit_manager_recommedation: credit_manager_recommedation,
      loan_documents: loan_documents,
      crb_loan_documents: crb_loan_documents,
      loan_5cs: loan_5cs,
      loan_checklist: loan_checklist,
      loan_credit_details: loan_credit_details,
      client_income_statement: client_income_statement,
      ceo_recommedation: ceo_recommedation,
      client_details: client_details
    )
    else
      _ ->
      conn
      |> put_flash(:error, "Something went wrong, try again.")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end


  else
    if product_type == "Business Loan" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
      credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
      sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
      loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
      loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
      loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
      render(conn, "legal_loan_application_approval.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        credit_analyst_recommedation: credit_analyst_recommedation,
        credit_manager_recommedation: credit_manager_recommedation,
        loan_documents: loan_documents,
        sales_recommedation: sales_recommedation,
        crb_loan_documents: crb_loan_documents,
        loan_5cs: loan_5cs,
        loan_checklist: loan_checklist,
        loan_credit_details: loan_credit_details,
        client_income_statement: client_income_statement,
        ceo_recommedation: ceo_recommedation,
        client_details: client_details

      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "Salary Backed Loan" do
        with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
          guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
          sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info_validation(params["userId"], params["reference_no"])
          credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
          credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
          loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
          employment_verifications =  Loanmanagementsystem.OperationsServices.get_loan_employememt_verification_docs(loan_id)
          loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
          crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
          loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
          loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
          loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
          client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
          ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
          render(conn, "legal_salary_loan_application.html",
            current_time: current_time(),
            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
            client_data: client_data,
            client_kyc: client_kyc,
            nextofkin: nextofkin,
            client_references: client_references,
            loan_details: loan_details,
            collateral_details: collateral_details,
            extracted_other_collateral_details: extracted_other_collateral_details,
            guarantors_details: guarantors_details,
            sales_recommedation: sales_recommedation,
            employment_details: employment_details,
            credit_analyst_recommedation: credit_analyst_recommedation,
            credit_manager_recommedation: credit_manager_recommedation,
            employment_verifications: employment_verifications,
            loan_documents: loan_documents,
            crb_loan_documents: crb_loan_documents,
            loan_5cs: loan_5cs,
            loan_checklist: loan_checklist,
            loan_credit_details: loan_credit_details,
            client_income_statement: client_income_statement,
            ceo_recommedation: ceo_recommedation,
            client_details: client_details
          )
          else
            _ ->
            conn
            |> put_flash(:error, "Something went wrong, try again.")
            |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end

      else
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
    end
  end
 end



def accounts_assistant_approving_loan_application_view(conn, params) do
  product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
  if product_type == "Instant Loan" do
    with(
      client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
    ) do
     nrc = client_details.id_number
    client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
    client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
    nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
    client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
    loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
    collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
    extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
    sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
    market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
    credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
    credit_manager_recommedation = Loan.credit_manager_validation(params["userId"], params["reference_no"])
    accounts_assistant_recommedation = Loan.assistant_accountant_validation(params["userId"], params["reference_no"])
    finance_manager_recommedation = Loan.finance_manager_validation(params["userId"], params["reference_no"])
    legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
    ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
    operations_recommedation = Loan.operations_recomendation_validation(params["userId"], params["reference_no"])
    loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
    loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
    client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
    render(conn, "accounts_asistant_instant_loan_application.html",
      current_time: current_time(),
      product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
      product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
      client_data: client_data,
      client_kyc: client_kyc,
      nextofkin: nextofkin,
      client_references: client_references,
      loan_details: loan_details,
      collateral_details: collateral_details,
      extracted_other_collateral_details: extracted_other_collateral_details,
      sales_recommedation: sales_recommedation,
      market_info: market_info,
      credit_analyst_recommedation: credit_analyst_recommedation,
      credit_manager_recommedation: credit_manager_recommedation,
      legal_recommedation: legal_recommedation,
      loan_documents: loan_documents,
      accounts_assistant_recommedation: accounts_assistant_recommedation,
      ceo_recommedation: ceo_recommedation,
      finance_manager_recommedation: finance_manager_recommedation,
      operations_recommedation: operations_recommedation,
      client_income_statement: client_income_statement,
    )
    else
      _ ->
      conn
      |> put_flash(:error, "Something went wrong, try again.")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end


  else
    if product_type == "Business Loan" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
      credit_manager_recommedation = Loan.credit_manager_validation(params["userId"], params["reference_no"])
      accounts_assistant_recommedation = Loan.assistant_accountant_validation(params["userId"], params["reference_no"])
      finance_manager_recommedation = Loan.finance_manager_validation(params["userId"], params["reference_no"])
      legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
      ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
      operations_recommedation = Loan.operations_recomendation_validation(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      render(conn, "accounts_asistant_loan_application_approval.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        credit_analyst_recommedation: credit_analyst_recommedation,
        credit_manager_recommedation: credit_manager_recommedation,
        legal_recommedation: legal_recommedation,
        loan_documents: loan_documents,
        accounts_assistant_recommedation: accounts_assistant_recommedation,
        ceo_recommedation: ceo_recommedation,
        finance_manager_recommedation: finance_manager_recommedation,
        operations_recommedation: operations_recommedation,
        client_income_statement: client_income_statement,

      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "Salary Backed Loan" do
        with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
          guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
          sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info_validation(params["userId"], params["reference_no"])
          credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
          credit_manager_recommedation = Loan.credit_manager_validation(params["userId"], params["reference_no"])
          accounts_assistant_recommedation = Loan.assistant_accountant_validation(params["userId"], params["reference_no"])
          finance_manager_recommedation = Loan.finance_manager_validation(params["userId"], params["reference_no"])
          legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
          ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
          operations_recommedation = Loan.operations_recomendation_validation(params["userId"], params["reference_no"])
          loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
          employment_verifications =  Loanmanagementsystem.OperationsServices.get_loan_employememt_verification_docs(loan_id)
          loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
          client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
          render(conn, "accounts_asistant_salary_loan_application.html",
            current_time: current_time(),
            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
            client_data: client_data,
            client_kyc: client_kyc,
            nextofkin: nextofkin,
            client_references: client_references,
            loan_details: loan_details,
            collateral_details: collateral_details,
            extracted_other_collateral_details: extracted_other_collateral_details,
            guarantors_details: guarantors_details,
            sales_recommedation: sales_recommedation,
            employment_details: employment_details,
            credit_analyst_recommedation: credit_analyst_recommedation,
            credit_manager_recommedation: credit_manager_recommedation,
            legal_recommedation: legal_recommedation,
            employment_verifications: employment_verifications,
            loan_documents: loan_documents,
            accounts_assistant_recommedation: accounts_assistant_recommedation,
            ceo_recommedation: ceo_recommedation,
            finance_manager_recommedation: finance_manager_recommedation,
            operations_recommedation: operations_recommedation,
            client_income_statement: client_income_statement,
          )
          else
            _ ->
            conn
            |> put_flash(:error, "Something went wrong, try again.")
            |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end

      else
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

      end
    end
  end

end


def finance_manager_approving_loan_application_view(conn, params) do
  product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
  if product_type == "Instant Loan" do
    with(
      client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
    ) do
     nrc = client_details.id_number
    client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
    client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
    nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
    client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
    loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
    collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
    extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
    sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
    market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
    credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
    credit_manager_recommedation = Loan.credit_manager_validation(params["userId"], params["reference_no"])
    accounts_assistant_recommedation = Loan.assistant_accountant_validation(params["userId"], params["reference_no"])
    finance_manager_recommedation = Loan.finance_manager_validation(params["userId"], params["reference_no"])
    legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
    ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
    operations_recommedation = Loan.operations_recomendation_validation(params["userId"], params["reference_no"])
    loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
    loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
    client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
    render(conn, "finance_manager_instant_loan_application.html",
      current_time: current_time(),
      product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
      product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
      client_data: client_data,
      client_kyc: client_kyc,
      nextofkin: nextofkin,
      client_references: client_references,
      loan_details: loan_details,
      collateral_details: collateral_details,
      extracted_other_collateral_details: extracted_other_collateral_details,
      sales_recommedation: sales_recommedation,
      market_info: market_info,
      credit_analyst_recommedation: credit_analyst_recommedation,
      credit_manager_recommedation: credit_manager_recommedation,
      accounts_assistant_recommedation: accounts_assistant_recommedation,
      legal_recommedation: legal_recommedation,
      loan_documents: loan_documents,
      finance_manager_recommedation: finance_manager_recommedation,
      ceo_recommedation: ceo_recommedation,
      operations_recommedation: operations_recommedation,
      client_income_statement: client_income_statement,
    )
    else
      _ ->
      conn
      |> put_flash(:error, "Something went wrong, try again.")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end

  else
    if product_type == "Business Loan" do
      with(
    client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
      nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
      credit_manager_recommedation = Loan.credit_manager_validation(params["userId"], params["reference_no"])
      accounts_assistant_recommedation = Loan.assistant_accountant_validation(params["userId"], params["reference_no"])
      finance_manager_recommedation = Loan.finance_manager_validation(params["userId"], params["reference_no"])
      legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
      ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
      operations_recommedation = Loan.operations_recomendation_validation(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      render(conn, "finance_manager_loan_application_approval.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        credit_analyst_recommedation: credit_analyst_recommedation,
        credit_manager_recommedation: credit_manager_recommedation,
        accounts_assistant_recommedation: accounts_assistant_recommedation,
        legal_recommedation: legal_recommedation,
        loan_documents: loan_documents,
        finance_manager_recommedation: finance_manager_recommedation,
        ceo_recommedation: ceo_recommedation,
        operations_recommedation: operations_recommedation,
        client_income_statement: client_income_statement,

      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "Salary Backed Loan" do
        with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
          guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
          sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info_validation(params["userId"], params["reference_no"])
          credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
          credit_manager_recommedation = Loan.credit_manager_validation(params["userId"], params["reference_no"])
          accounts_assistant_recommedation = Loan.assistant_accountant_validation(params["userId"], params["reference_no"])
          finance_manager_recommedation = Loan.finance_manager_validation(params["userId"], params["reference_no"])
          legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
          ceo_recommedation = Loan.ceo_recomendation_validation(params["userId"], params["reference_no"])
          operations_recommedation = Loan.operations_recomendation_validation(params["userId"], params["reference_no"])
          loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
          employment_verifications =  Loanmanagementsystem.OperationsServices.get_loan_employememt_verification_docs(loan_id)
          loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
          client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
          render(conn, "finance_manager_salary_loan_application.html",
            current_time: current_time(),
            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
            client_data: client_data,
            client_kyc: client_kyc,
            nextofkin: nextofkin,
            client_references: client_references,
            loan_details: loan_details,
            collateral_details: collateral_details,
            extracted_other_collateral_details: extracted_other_collateral_details,
            guarantors_details: guarantors_details,
            sales_recommedation: sales_recommedation,
            employment_details: employment_details,
            credit_analyst_recommedation: credit_analyst_recommedation,
            credit_manager_recommedation: credit_manager_recommedation,
            accounts_assistant_recommedation: accounts_assistant_recommedation,
            legal_recommedation: legal_recommedation,
            employment_verifications: employment_verifications,
            loan_documents: loan_documents,
            finance_manager_recommedation: finance_manager_recommedation,
            ceo_recommedation: ceo_recommedation,
            operations_recommedation: operations_recommedation,
            client_income_statement: client_income_statement,
          )
          else
            _ ->
            conn
            |> put_flash(:error, "Something went wrong, try again.")
            |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end

      else
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

      end
    end
  end

end


def executive_committe_approving_loan_application_view(conn, params) do
  product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
  if product_type == "Instant Loan" do
    with(
      client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
    ) do
     nrc = client_details.id_number
    client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
    client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
    nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
    client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
    loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
    collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
    extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
    sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
    market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
    credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
    credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
    accounts_assistant_recommedation = Loan.list_accounts_assistant_recommendation(params["userId"], params["reference_no"])
    finance_manager_recommedation = Loan.list_finance_manager_recommendation(params["userId"], params["reference_no"])
    legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
    loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
    loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
    crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
    loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
    loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
    loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
    loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
    client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
    render(conn, "executive_committe_instant_loan_application.html",
      current_time: current_time(),
      product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
      product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
      client_data: client_data,
      client_kyc: client_kyc,
      nextofkin: nextofkin,
      client_references: client_references,
      loan_details: loan_details,
      collateral_details: collateral_details,
      extracted_other_collateral_details: extracted_other_collateral_details,
      sales_recommedation: sales_recommedation,
      market_info: market_info,
      credit_analyst_recommedation: credit_analyst_recommedation,
      credit_manager_recommedation: credit_manager_recommedation,
      accounts_assistant_recommedation: accounts_assistant_recommedation,
      finance_manager_recommedation: finance_manager_recommedation,
      legal_recommedation: legal_recommedation,
      loan_documents: loan_documents,
      crb_loan_documents: crb_loan_documents,
      loan_5cs: loan_5cs,
      loan_checklist: loan_checklist,
      loan_credit_details: loan_credit_details,
      loan_property_documents: loan_property_documents,
      client_income_statement: client_income_statement,
      client_details: client_details
    )
    else
      _ ->
      conn
      |> put_flash(:error, "Something went wrong, try again.")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end

  else
    if product_type == "Business Loan" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
      guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
      sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
      credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
      credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
      accounts_assistant_recommedation = Loan.list_accounts_assistant_recommendation(params["userId"], params["reference_no"])
      finance_manager_recommedation = Loan.list_finance_manager_recommendation(params["userId"], params["reference_no"])
      legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
      loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
      loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
      crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
      loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
      loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
      loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
      loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
      client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
      company_details = Loanmanagementsystem.Accounts.get_client_company_details(params["userId"])
      render(conn, "executive_committe_loan_application_approval.html",
        current_time: current_time(),
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        credit_analyst_recommedation: credit_analyst_recommedation,
        credit_manager_recommedation: credit_manager_recommedation,
        accounts_assistant_recommedation: accounts_assistant_recommedation,
        finance_manager_recommedation: finance_manager_recommedation,
        legal_recommedation: legal_recommedation,
        loan_documents: loan_documents,
        sales_recommedation: sales_recommedation,
        crb_loan_documents: crb_loan_documents,
        loan_5cs: loan_5cs,
        loan_checklist: loan_checklist,
        loan_credit_details: loan_credit_details,
        loan_property_documents: loan_property_documents,
        client_income_statement: client_income_statement,
        company_details: company_details,
        client_details: client_details

      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "Salary Backed Loan" do
        with(
          client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
        ) do
         nrc = client_details.id_number
        client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
        client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
        nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
        client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
        loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
        collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
        extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
        guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
        sales_recommedation = Loan.sales_recommedation_validation(params["userId"], params["reference_no"])
        employment_details = Loan.list_employment_info_validation(params["userId"], params["reference_no"])
        credit_analyst_recommedation = Loan.credit_analyst_validation(params["userId"], params["reference_no"])
        credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
        accounts_assistant_recommedation = Loan.list_accounts_assistant_recommendation(params["userId"], params["reference_no"])
        finance_manager_recommedation = Loan.list_finance_manager_recommendation(params["userId"], params["reference_no"])
        legal_recommedation = Loan.legal_validation(params["userId"], params["reference_no"])
        loan_id = try do Loanmanagementsystem.Loan.Loans.find_by(customer_id: params["userId"], reference_no: params["reference_no"]).id rescue _-> 0 end
        employment_verifications =  Loanmanagementsystem.OperationsServices.get_loan_employememt_verification_docs(loan_id)
        loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_docs(loan_id)
        crb_loan_documents =  Loanmanagementsystem.OperationsServices.get_loan_crb_docs(loan_id)
        loan_5cs = Loan.loan_5cs_validation(params["userId"], params["reference_no"])
        loan_checklist = Loan.list_loan_checklist_details_validation(params["userId"], params["reference_no"])
        loan_credit_details = Loan.list_credit_score_details_validation(params["userId"], params["reference_no"])
        loan_property_documents = Loanmanagementsystem.OperationsServices.get_loan_property_docs(loan_id)
        client_income_statement = Loan.list_client_income_statement_validation(params["userId"], params["reference_no"])
        render(conn, "executive_committe_salary_loan_application.html",
          current_time: current_time(),
          product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
          product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
          client_data: client_data,
          client_kyc: client_kyc,
          nextofkin: nextofkin,
          client_references: client_references,
          loan_details: loan_details,
          collateral_details: collateral_details,
          extracted_other_collateral_details: extracted_other_collateral_details,
          guarantors_details: guarantors_details,
          sales_recommedation: sales_recommedation,
          employment_details: employment_details,
          credit_analyst_recommedation: credit_analyst_recommedation,
          credit_manager_recommedation: credit_manager_recommedation,
          accounts_assistant_recommedation: accounts_assistant_recommedation,
          finance_manager_recommedation: finance_manager_recommedation,
          legal_recommedation: legal_recommedation,
          employment_verifications: employment_verifications,
          loan_documents: loan_documents,
          crb_loan_documents: crb_loan_documents,
          loan_5cs: loan_5cs,
          loan_checklist: loan_checklist,
          loan_credit_details: loan_credit_details,
          loan_property_documents: loan_property_documents,
          client_income_statement: client_income_statement,
          client_details: client_details
        )
        else
          _ ->
          conn
          |> put_flash(:error, "Something went wrong, try again.")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
        end

      else
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
    end
  end
end


def sales_loan_approval(conn, params) do
  loan_details = Loans.find_by(id: params["loan_id"])
  new_param =  %{
    "loan_status" => "PENDING_CREDIT_ANALYST",
    "status" => "PENDING_CREDIT_ANALYST",
  }
  Ecto.Multi.new()
  |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, new_param))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_details: _loan_details} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "You have Successfully Approved Loan for #{params["firstname"]} #{params["surname"]} #{params["othername"]} with email: #{params["email"]} Worth #{params["requested_amount"]}",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
    Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
      recommended: params["recommended_feedback"],
      user_type: "SALES",
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      # signature: params["signature_feedback"],
      position: params["position_feedback"],
      date: params["date_feedback"],
      time_received: params["time_received_feedback"],
      time_out: params["time_out_feedback"],
      date_received: params["date_received_feedback"],
      customer_id: loan_details.customer_id,
      reference_no: loan_details.reference_no,
    })
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, _} ->
      conn
      |> put_flash(:info, "You have Successfully Approved the loan")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors)

      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
end


def operations_loan_approval(conn, params) do
  # if Enum.dedup(params["filename"]) != [""] do
   if params["date"] != "" do
  loan_details = Loans.find_by(id: params["loan_id"])
  new_param =  %{
    "loan_status" => "APPROVED",
    "status" => "APPROVED",
    "approvedon_date" => Timex.today,
  }
  Ecto.Multi.new()
  |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, new_param))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_details: _loan_details} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "You have Successfully Approved Loan for #{params["firstname"]} #{params["surname"]} #{params["othername"]} with email: #{params["email"]} Worth #{params["requested_amount"]}",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
    Loan_checklist.changeset(%Loan_checklist{}, %{
      completed_approved_application: params["completed_approved_application"],
      valid_id: params["valid_id"],
      passport_size_photos: params["passport_size_photos"],
      trading_license_or_other: params["trading_license_or_other"],
      three_months_sale: params["three_months_sale"],
      moveable_or_immovable_collateral: params["moveable_or_immovable_collateral"],
      motor_vehicle_insurance: params["motor_vehicle_insurance"],
      crb_report: params["crb_report"],
      proof_of_residence: params["proof_of_residence"],
      reference_letter: params["reference_letter"],
      three_months_pay_slip: params["three_months_pay_slip"],
      incorporation_doc: params["incorporation_doc"],
      latest_pacra_print_out: params["latest_pacra_print_out"],
      tax_clearance: params["tax_clearance"],
      rep_valid_id: params["rep_valid_id"],
      tenancy_agreement: params["tenancy_agreement"],
      board_resolution: params["board_resolution"],
      six_month_statement: params["six_month_statement"],
      loan_id: loan_details.id,
      customer_id: loan_details.customer_id,
      reference_no: loan_details.reference_no,
    })
    |> Repo.insert()
    Loan_disbursement_schedule.changeset(%Loan_disbursement_schedule{}, %{
      customer_id: loan_details.customer_id,
      reference_no: loan_details.reference_no,
      account_number: params["account_number"],
      applicant_name: params["applicant_name"],
      applicant_signature: params["applicant_signature"],
      applied_amount: params["applied_amount"],
      approved_amount: params["approved_amount"],
      bank_name: params["bank_name"],
      branch: params["branch"],
      crb: params["crb"],
      credit_manager: params["credit_manager"],
      date: params["date_disbursed"],
      finance_manager: params["finance_manager"],
      insurance: params["insurance"],
      interet_per_month: params["interet_per_month"],
      loan_id: params["loan_id"],
      month_installment: params["month_installment"],
      motor_insurance: params["motor_insurance"],
      net_disbiursed: params["net_disbiursed"],
      prepared_by: params["prepared_by"],
      processing_fee: params["processing_fee"],
      repayment_period: params["repayment_period"],
      senior_operation_officer: params["senior_operation_officer"],
    })
    |> Repo.insert()
    amortization_schedule =  generate_schedule(params["loan_amount"], params["interest_rate"], params["loan_term"], params["loan_cal_date"], params["loan_id"], loan_details.customer_id, loan_details.reference_no)

    amortization_schedule
    |> Enum.map(fn amortization ->
      amortization_params =
      %{
            loan_id: loan_details.id,
            customer_id: loan_details.customer_id,
            reference_no: loan_details.reference_no,
            loan_amount: amortization.loan_amount,
            interest_rate: amortization.interest_rate,
            term_in_months: amortization.term_in_months,
            month: amortization.month,
            beginning_balance: amortization.beginning_balance,
            payment: amortization.payment,
            interest: amortization.interest,
            principal: amortization.principal,
            ending_balance: amortization.ending_balance,
            date: amortization.date,
            calculation_date: amortization.calculation_date,
        }
      Loan_amortization_schedule.changeset(%Loan_amortization_schedule{}, amortization_params)
      |> Repo.insert()
    end)

    nrc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(userId: loan_details.customer_id).meansOfIdentificationNumber rescue _-> "" end
    Loanmanagementsystem.Services.LoanDocumentsUploads.client_upload(%{"process_documents" => params, "conn" => conn, "nrc" => nrc, "loan_id" => loan_details.id, "file_category" => "LEGAL_DOCUMENTS" })
    Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
      recommended: params["recommended_feedback"],
      user_type: "OPERATIONS",
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      # signature: params["signature_feedback"],
      position: params["position_feedback"],
      date: params["date_feedback"],
      time_received: params["time_received_feedback"],
      time_out: params["time_out_feedback"],
      date_received: params["date_received_feedback"],
      customer_id: loan_details.customer_id,
      reference_no: loan_details.reference_no,
    })
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, _} ->
      conn
      |> put_flash(:info, "You have Successfully Approved the loan")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors)

      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
else
  conn
  |> put_flash(:error,"Kindly add calculation date and Try again")
  |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
end
# else
#   conn
#   |> put_flash(:error,"Kindly attach document(s) and Try again")
#   |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
# end
end





def credit_analyst_loan_approval(conn, params) do
  # if Enum.dedup(params["filename"]) != [""] do
  loan_details = Loans.find_by(id: params["loan_id"])
    new_param =
    %{
      "loan_status" => "PENDING_CREDIT_MANAGER",
      "status" => "PENDING_CREDIT_MANAGER",
    }
  Ecto.Multi.new()
  |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, new_param))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_details: _loan_details} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "You have Successfully Approved Loan for #{params["firstname"]} #{params["surname"]} #{params["othername"]} with email: #{params["email"]} Worth #{params["requested_amount"]}",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
     Loan_5cs.changeset(%Loan_5cs{}, %{
      capacity: params["capacity"],
      capital: params["capital"],
      character: params["character"],
      collateral: params["collateral"],
      condition: params["condition"],
      loan_id: loan_details.id,
      customer_id: loan_details.customer_id,
      reference_no: loan_details.reference_no,
    })
    |> Repo.insert()
    # nrc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(userId: loan_details.customer_id).meansOfIdentificationNumber rescue _-> "" end
    # Loanmanagementsystem.Services.LoanDocumentsUploads.client_upload(%{"process_documents" => params, "conn" => conn, "nrc" => nrc, "loan_id" => loan_details.id, "file_category" => "CRB_REPORT" })
     Loan_credit_score.changeset(%Loan_credit_score{}, %{
      applicant_character: params["applicant_character"],
      applicant_name: params["applicant_name"],
      borrowing_history: params["borrowing_history"],
      business_employment_experience: params["business_employment_experience"],
      collateral_assessment: params["collateral_assessment"],
      credit_analyst: params["credit_analyst"],
      cro_staff: params["cro_staff"],
      date_of_credit_score: Date.utc_today(),
      dti_ratio: params["dti_ratio"],
      family_situation: params["family_situation"],
      loan_amount: params["loan_amount"],
      number_of_reference: params["number_of_reference"],
      signature: params["signature"],
      total_score: params["total_score"],
      type_of_collateral: params["type_of_collateral"],
      type_of_loan: params["type_of_loan"],
      weighted_credit_score: params["weighted_credit_score"],
      loan_id: loan_details.id,
      customer_id: loan_details.customer_id,
      reference_no: loan_details.reference_no,
    })
    |> Repo.insert()

    Loan_checklist.changeset(%Loan_checklist{}, %{
      gross_monthly_income: params["gross_monthly_income"],
      prood_of_resident: params["prood_of_resident"],
      home_visit_done: params["home_visit_done"],
      latest_pacra_print_out: params["latest_pacra_print_out"],
      desired_term: params["desired_term"],
      company_bank_statement: params["company_bank_statement"],
      bank_name: params["bank_name"],
      trading_license: params["trading_license"],
      id_no: params["id_no"],
      collateral_pictures: params["collateral_pictures"],
      employer_name: params["employer_name"],
      loan_amount_checklist: params["loan_amount_checklist"],
      telephone: params["telephone"],
      contract_agreements: params["contract_agreements"],
      correct_account_number: params["correct_account_number"],
      payslip_3months_verified: params["payslip_3months_verified"],
      latest_audited_financial_statement: params["latest_audited_financial_statement"],
      call_memo: params["call_memo"],
      marital_status: params["marital_status"],
      citizenship_status: params["citizenship_status"],
      employment_status: params["employment_status"],
      has_running_loan: params["has_running_loan"],
      loan_purpose_checklist: params["loan_purpose_checklist"],
      completed_application_form: params["completed_application_form"],
      preferred_loan_repayment_method: params["preferred_loan_repayment_method"],
      certificate_of_incorporation: params["certificate_of_incorporation"],
      passport_size_photo: params["passport_size_photo"],
      passport_size_photo_from_director: params["passport_size_photo_from_director"],
      rent_payment: params["rent_payment"],
      sales_record: params["sales_record"],
      board_allow_company_to_borrow: params["board_allow_company_to_borrow"],
      employer_letter: params["employer_letter"],
      crb: params["crb"],
      loan_verified: params["loan_verified"],
      bank_standing_payment_order: params["bank_standing_payment_order"],
      email_address: params["email_address"],
      social_security_no: params["social_security_no"],
      insurance_for_motor_vehicle: params["insurance_for_motor_vehicle"],
      bank_statement: params["bank_statement"],
      loan_id: loan_details.id,
      customer_id: loan_details.customer_id,
      reference_no: loan_details.reference_no,
    })
    |> Repo.insert()
    Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
      recommended: params["recommended_feedback"],
      user_type: "CREDIT_ANALYST",
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      # signature: params["signature_feedback"],
      position: params["position_feedback"],
      date: params["date_feedback"],
      time_received: params["time_received_feedback"],
      time_out: params["time_out_feedback"],
      date_received: params["date_received_feedback"],
      customer_id: loan_details.customer_id,
      reference_no: loan_details.reference_no,
    })
    |> Repo.insert()

  end)
  |> Repo.transaction()
  |> case do
    {:ok, _} ->
      conn
      |> put_flash(:info, "You have Successfully Approved the loan")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors)

      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
# else
#   conn
#   |> put_flash(:error,"Kindly attach document(s) and Try again")
#   |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
# end
end

def credit_manager_loan_approval(conn, params) do
  loan_details = Loans.find_by(id: params["loan_id"])
  if params["loan_type"] == "Instant Loan" do
  user = conn.assigns.user.id
  handle_legal_document_posting(params, user)
  |> case do
    {:ok, _} ->
      new_param = %{
        "loan_status" => "APPROVED",
        "status" => "APPROVED",
        "approvedon_date" => Timex.today,
      }
      Ecto.Multi.new()
      |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, new_param))
      |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_details: _loan_details} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "You have Successfully Approved Loan for #{params["firstname"]} #{params["surname"]} #{params["othername"]} with email: #{params["email"]} Worth #{params["requested_amount"]}",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
        Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
          recommended: params["recommended_feedback"],
          user_type: "CREDIT_MANAGER",
          on_hold: params["on_hold_feedback"],
          file_sent_to_sale: params["file_sent_to_sale_feedback"],
          comments: params["comments_feedback"],
          name: params["name_feedback"],
          # signature: params["signature_feedback"],
          position: params["position_feedback"],
          date: params["date_feedback"],
          time_received: params["time_received_feedback"],
          time_out: params["time_out_feedback"],
          date_received: params["date_received_feedback"],
          customer_id: loan_details.customer_id,
          reference_no: loan_details.reference_no,
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, _} ->
          conn
          |> put_flash(:info, "You have Successfully Approved the loan")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors)

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)
      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end

  else
    new_param = %{
        "loan_status" => "PENDING_CEO",
        "status" => "PENDING_CEO",
        "credit_mgt_committe_comment" => params["credit_mgt_committe_comment"],
    }
    Ecto.Multi.new()
    |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, new_param))
    |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_details: _loan_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "You have Successfully Approved Loan for #{params["firstname"]} #{params["surname"]} #{params["othername"]} with email: #{params["email"]} Worth #{params["requested_amount"]}",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
      Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
        recommended: params["recommended_feedback"],
        user_type: "CREDIT_MANAGER",
        on_hold: params["on_hold_feedback"],
        file_sent_to_sale: params["file_sent_to_sale_feedback"],
        comments: params["comments_feedback"],
        name: params["name_feedback"],
        # signature: params["signature_feedback"],
        position: params["position_feedback"],
        date: params["date_feedback"],
        time_received: params["time_received_feedback"],
        time_out: params["time_out_feedback"],
        date_received: params["date_received_feedback"],
        customer_id: loan_details.customer_id,
        reference_no: loan_details.reference_no,
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} ->
        conn
        |> put_flash(:info, "You have Successfully Approved the loan")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors)

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end


  end
end


def legal_counsel_loan_approval(conn, params) do
  # if Enum.dedup(params["filename"]) != [""] do
  loan_details = Loans.find_by(id: params["loan_id"])
  new_param =  %{
    "loan_status" => "PENDING_OPERATIONS",
    "status" => "PENDING_OPERATIONS",
    "legal_collateral_comment" => params["collateral_comment"],
  }
  Ecto.Multi.new()
  |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, new_param))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_details: _loan_details} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "You have Successfully Approved Loan for #{params["firstname"]} #{params["surname"]} #{params["othername"]} with email: #{params["email"]} Worth #{params["requested_amount"]}",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
    nrc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(userId: loan_details.customer_id).meansOfIdentificationNumber rescue _-> "" end
    Loanmanagementsystem.Services.LoanDocumentsUploads.client_upload(%{"process_documents" => params, "conn" => conn, "nrc" => nrc, "loan_id" => loan_details.id, "file_category" => "PROPERTY_DOCUMENTS" })
    Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
      recommended: params["recommended_feedback"],
      user_type: "LEGAL",
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      # signature: params["signature_feedback"],
      position: params["position_feedback"],
      date: params["date_feedback"],
      time_received: params["time_received_feedback"],
      time_out: params["time_out_feedback"],
      date_received: params["date_received_feedback"],
      customer_id: loan_details.customer_id,
      reference_no: loan_details.reference_no,
    })
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, _} ->
      conn
      |> put_flash(:info, "You have Successfully Approved the loan")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors)

      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
# else
#   conn
#   |> put_flash(:error,"Kindly attach document(s) and Try again")
#   |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
# end
end

def accounts_assistant_loan_approval(conn, params) do
  loan_details = Loans.find_by(id: params["loan_id"])
  new_param =  %{
    "loan_status" => "PENDING_FINANCE_MANAGER",
    "status" => "PENDING_FINANCE_MANAGER",
  }
  Ecto.Multi.new()
  |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, new_param))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_details: _loan_details} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "You have Successfully Approved Loan for #{params["firstname"]} #{params["surname"]} #{params["othername"]} with email: #{params["email"]} Worth #{params["requested_amount"]}",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
    Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
      recommended: params["recommended_feedback"],
      user_type: "ACCOUNTS_ASSISTANT",
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      # signature: params["signature_feedback"],
      position: params["position_feedback"],
      date: params["date_feedback"],
      time_received: params["time_received_feedback"],
      time_out: params["time_out_feedback"],
      date_received: params["date_received_feedback"],
      customer_id: loan_details.customer_id,
      reference_no: loan_details.reference_no,
    })
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, _} ->
      conn
      |> put_flash(:info, "You have Successfully Approved the loan")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors)

      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
end

def finance_manager_loan_approval(conn, params) do
  loan_details = Loans.find_by(id: params["loan_id"])
  new_param =  %{
    "loan_status" => "DISBURSED",
    "status" => "DISBURSED",
  }
  Ecto.Multi.new()
  |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, new_param))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_details: _loan_details} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "You have Successfully Approved Loan for #{params["firstname"]} #{params["surname"]} #{params["othername"]} with email: #{params["email"]} Worth #{params["requested_amount"]}",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
    Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
      recommended: params["recommended_feedback"],
      user_type: "FINANCE_MANAGER",
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      # signature: params["signature_feedback"],
      position: params["position_feedback"],
      date: params["date_feedback"],
      time_received: params["time_received_feedback"],
      time_out: params["time_out_feedback"],
      date_received: params["date_received_feedback"],
      customer_id: loan_details.customer_id,
      reference_no: loan_details.reference_no,
    })
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, _} ->
      conn
      |> put_flash(:info, "You have Successfully Approved the loan")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors)

      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
end

def executive_committe_loan_approval(conn, params) do
  loan_details = Loans.find_by(id: params["loan_id"])
  has_customer_have_mou = Loanmanagementsystem.Accounts.User.find_by(id: loan_details.customer_id).with_mou
  new_param =
  if has_customer_have_mou == false do
    %{
      "loan_status" => "PENDING_LEGAL",
      "status" => "PENDING_LEGAL",
      }
  else
    %{
      "loan_status" => "PENDING_OPERATIONS",
      "status" => "PENDING_OPERATIONS",
      }
  end
  Ecto.Multi.new()
  |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, new_param))
  |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_details: _loan_details} ->
    UserLogs.changeset(%UserLogs{}, %{
      activity: "You have Successfully Approved Loan for #{params["firstname"]} #{params["surname"]} #{params["othername"]} with email: #{params["email"]} Worth #{params["requested_amount"]}",
      user_id: conn.assigns.user.id
    })
    |> Repo.insert()
    Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
      recommended: params["recommended_feedback"],
      user_type: "EXECUTIVE_COMMITTE",
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      position: "Executive committe",
      date: params["date_feedback"],
      time_received: params["time_received_feedback"],
      time_out: params["time_out_feedback"],
      date_received: params["date_received_feedback"],
      customer_id: loan_details.customer_id,
      reference_no: loan_details.reference_no,
    })
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, _} ->
      conn
      |> put_flash(:info, "You have Successfully Approved the loan")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors)

      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
end

  def create_quick_loan_application(conn, params) do
    loan_calculations = calculate_interest_and_repaymnent_amt(params)
    otp = to_string(Enum.random(1111..9999))

    if params["customer_id"] != "" || params["customer_id"] != nil do
      new_params =
        Map.merge(params, %{
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => loan_calculations.currency_code,
          "loan_type" => params["product_type"],
          "tenor" => loan_calculations.tenor,
          "principal_amount" => params["amount"],
          "repayment_amount" => loan_calculations.repayement_amt,
          "interest_amount" => loan_calculations.interest_amt,
          "balance" => loan_calculations.repayement_amt
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
          |> redirect(to: Routes.loan_path(conn, :quick_loan_application_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :quick_loan_application_datatable))
      end
    else
      my_password = LoanmanagementsystemWeb.UserController.random_string()

      Ecto.Multi.new()
      |> Ecto.Multi.insert(
        :add_user,
        User.changeset(%User{}, %{
          password: my_password,
          status: "INACTIVE",
          username: params["emailAddress"],
          auto_password: "Y"
        })
      )
      |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
        UserRole.changeset(%UserRole{}, %{
          roleType: params["roleType"],
          status: "INACTIVE",
          userId: add_user.id,
          otp: otp
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                               %{
                                                 add_user: add_user,
                                                 add_user_role: _add_user_role
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
      |> Ecto.Multi.run(:user_logs, fn _repo,
                                       %{
                                         add_user: _add_user,
                                         add_user_role: _add_user_role,
                                         add_user_bio_data: _add_user_bio_data
                                       } ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "user creations and loan application Successfully",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:loan_application, fn _repo,
                                              %{add_user: _add_user, add_user_role: _add_user_role} ->
        Loans.changeset(%Loans{}, %{
          "customer_id" => params["customer_id"],
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => params["currency_code"],
          "loan_type" => params["product_type"],
          "principal_amount" => params["amount"]
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{add_user: _add_user}} ->
          conn
          |> put_flash(:info, "Loan Application Submitted")
          |> redirect(to: Routes.loan_path(conn, :quick_loan_application_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :quick_loan_application_datatable))
      end
    end
  end

  def select_quick_advance(conn, _params) do
    # LoanmanagementsystemWeb.LoanController.send_otp(conn, params)
    product_details = Loanmanagementsystem.Products.product_details_listing()
    render(conn, "select_quick_advance.html", product_details: product_details)
  end

  def get_otp(conn, %{"product_id" => product_id}) do
    render(conn, "get_otp.html", product_id: product_id)
  end

  def otp_validation(conn, %{"client_line" => client_line, "product_id" => product_id, "nrc" => nrc}) do
    render(conn, "otp_validation.html", client_line: client_line, product_id: product_id, nrc: nrc)
  end

  def send_otp(conn, params) do
    nrc = params["nrc"]
    product_id = params["product_id"]
    check_customer = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
    # if Enum.count(check_customer) > 0 do
      if check_customer != nil do
      case Loans.exists?(customer_id: check_customer.userId, loan_status: "DISBURSED") do
       false ->
      client_line = check_customer.mobileNumber
      generate_otp = to_string(Enum.random(1111..9999))
      text = "To verify your loan initiation, please provide the OTP - #{generate_otp}"
      params = Map.put(params, "mobile", client_line)
      params = Map.put(params, "msg", text)
      params = Map.put(params, "status", "SUCCESS")
      params = Map.put(params, "type", "SMS")
      params = Map.put(params, "msg_count", "1")
      my_client_role = Loanmanagementsystem.Accounts.get_user_role!(check_customer.role_id)
      # Loanmanagementsystem.Accounts.update_user_role(my_client_role, %{otp: generate_otp})
      Loanmanagementsystem.Accounts.update_user_role(my_client_role, %{otp: "1234"})
      Ecto.Multi.new()
        |> Ecto.Multi.insert(:loan_otp, Sms.changeset(%Sms{}, params))
        |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_otp: _loan_otp} ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Customer OTP Successfully sent",
            user_id: conn.assigns.user.id
          })
          |> Repo.insert()
        end)
          |> Repo.transaction()
          |> case do
            {:ok, %{loan_otp: _loan_otp, user_logs: _user_logs}} ->
              Loanmanagementsystem.Workers.Sms.send()
              conn
              |> put_flash(:info, "OTP has been sent to your Mobile Number")
              |> redirect(to: Routes.loan_path(conn, :otp_validation, client_line: "#{client_line}", product_id: "#{product_id}", nrc: "#{nrc}"))

          {:error, _failed_operation, _failed_value, _changes_so_far} ->
        end
       true ->
          conn
          |> put_flash(:error,"Can't Proceed the customer has already have an active loan, kindly confirm to close the old loan and try again.")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
       end
    else
      conn
        |> put_flash(:error, "The ID number you entered is not registered, Please Check the ID number and try again.")
        |> redirect(to: Routes.loan_path(conn, :get_otp, product_id: "#{product_id}"))

    end
  end

  def validate_otp(conn, params) do

    nrc = params["nrc"]
    product_id = params["product_id"]

    # generate_otp = to_string(Enum.random(1111..9999))

    otp1 = params["otp1"]
    otp2 = params["otp2"]
    otp3 = params["otp3"]
    otp4 = params["otp4"]
    user_otp = "#{otp1}#{otp2}#{otp3}#{otp4}"

    client_role = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)

    client_line = client_role.mobileNumber
    my_client_role = Loanmanagementsystem.Accounts.get_user_role!(client_role.role_id)

    if my_client_role.otp == user_otp && user_otp != nil do


          Ecto.Multi.new()
          |> Ecto.Multi.update(
            :otp_validate,
            UserRole.changeset(
              my_client_role,
              Map.merge(params, %{"otp" => ""})
            )
          )
          |> Ecto.Multi.run(:user_logs, fn _, %{otp_validate: _otp_validate} ->
            UserLogs.changeset(%UserLogs{}, %{
              activity: "OTP Validated Successfully ",
              user_id: conn.assigns.user.id
            })
            |> Repo.insert()
          end)
          |> Repo.transaction()
          |> case do
            {:ok, %{otp_validate: _otp_validate, user_logs: _user_logs}} ->
              conn
              |> put_flash(:info, "OTP Validated Successfully Proceed With Your Loan Application")
              |> redirect(to: Routes.loan_path(conn, :universal_loan_application_capturing, client_line: "#{client_line}", product_id: "#{product_id}", nrc: "#{nrc}"))

            {:error, _failed_operation, failed_value, _changes_so_far} ->
              reason = traverse_errors(failed_value.errors) |> List.first()

              conn
              |> put_flash(:error, reason)
              |> redirect(to: Routes.loan_path(conn, :otp_validation))
          end
    else

    conn
      |> put_flash(:error, "OTP does not match")
      |> redirect(to: Routes.loan_path(conn, :otp_validation, client_line: "#{client_line}", product_id: "#{product_id}", nrc: "#{nrc}"))


    end
  end


  def create_float_advance_application(conn, params) do
    loan_calculations = calculate_interest_and_repaymnent_amt(params)
    otp = to_string(Enum.random(1111..9999))

    if params["customer_id"] != "" || params["customer_id"] != nil do
      new_params =
        Map.merge(params, %{
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => loan_calculations.currency_code,
          "loan_type" => params["product_type"],
          "tenor" => loan_calculations.tenor,
          "principal_amount" => params["amount"],
          "repayment_amount" => loan_calculations.repayement_amt,
          "interest_amount" => loan_calculations.interest_amt,
          "balance" => loan_calculations.repayement_amt
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
          |> redirect(to: Routes.loan_path(conn, :float_advance_application_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :float_advance_application_datatable))
      end
    else
      my_password = LoanmanagementsystemWeb.UserController.random_string()

      Ecto.Multi.new()
      |> Ecto.Multi.insert(
        :add_user,
        User.changeset(%User{}, %{
          password: my_password,
          status: "INACTIVE",
          username: params["emailAddress"],
          auto_password: "Y"
        })
      )
      |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
        UserRole.changeset(%UserRole{}, %{
          roleType: params["roleType"],
          status: "INACTIVE",
          userId: add_user.id,
          otp: otp
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                               %{
                                                 add_user: add_user,
                                                 add_user_role: _add_user_role
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
      |> Ecto.Multi.run(:user_logs, fn _repo,
                                       %{
                                         add_user: _add_user,
                                         add_user_role: _add_user_role,
                                         add_user_bio_data: _add_user_bio_data
                                       } ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "user creations and loan application Successfully",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:loan_application, fn _repo,
                                              %{add_user: _add_user, add_user_role: _add_user_role} ->
        Loans.changeset(%Loans{}, %{
          "customer_id" => params["customer_id"],
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => params["currency_code"],
          "loan_type" => params["product_type"],
          "principal_amount" => params["amount"]
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{add_user: _add_user}} ->
          conn
          |> put_flash(:info, "Loan Application Submitted")
          |> redirect(to: Routes.loan_path(conn, :float_advance_application_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :float_advance_application_datatable))
      end
    end
  end

  def create_order_finance_application(conn, params) do
    loan_calculations = calculate_interest_and_repaymnent_amt(params)
    otp = to_string(Enum.random(1111..9999))

    if params["customer_id"] != "" || params["customer_id"] != nil do
      new_params =
        Map.merge(params, %{
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => loan_calculations.currency_code,
          "loan_type" => params["product_type"],
          "tenor" => loan_calculations.tenor,
          "principal_amount" => params["amount"],
          "repayment_amount" => loan_calculations.repayement_amt,
          "interest_amount" => loan_calculations.interest_amt,
          "balance" => loan_calculations.repayement_amt
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
          |> redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
      end
    else
      my_password = LoanmanagementsystemWeb.UserController.random_string()

      Ecto.Multi.new()
      |> Ecto.Multi.insert(
        :add_user,
        User.changeset(%User{}, %{
          password: my_password,
          status: "INACTIVE",
          username: params["emailAddress"],
          auto_password: "Y"
        })
      )
      |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
        UserRole.changeset(%UserRole{}, %{
          roleType: params["roleType"],
          status: "INACTIVE",
          userId: add_user.id,
          otp: otp
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                               %{
                                                 add_user: add_user,
                                                 add_user_role: _add_user_role
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
      |> Ecto.Multi.run(:user_logs, fn _repo,
                                       %{
                                         add_user: _add_user,
                                         add_user_role: _add_user_role,
                                         add_user_bio_data: _add_user_bio_data
                                       } ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "user creations and loan application Successfully",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:loan_application, fn _repo,
                                              %{add_user: _add_user, add_user_role: _add_user_role} ->
        Loans.changeset(%Loans{}, %{
          "customer_id" => params["customer_id"],
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => params["currency_code"],
          "loan_type" => params["product_type"],
          "principal_amount" => params["amount"]
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{add_user: _add_user}} ->
          conn
          |> put_flash(:info, "Loan Application Submitted")
          |> redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
      end
    end
  end

  def create_trade_advance_application(conn, params) do
    loan_calculations = calculate_interest_and_repaymnent_amt(params)
    otp = to_string(Enum.random(1111..9999))

    if params["customer_id"] != "" || params["customer_id"] != nil do
      new_params =
        Map.merge(params, %{
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => loan_calculations.currency_code,
          "loan_type" => params["product_type"],
          "tenor" => loan_calculations.tenor,
          "principal_amount" => params["amount"],
          "repayment_amount" => loan_calculations.repayement_amt,
          "interest_amount" => loan_calculations.interest_amt,
          "balance" => loan_calculations.repayement_amt
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
          |> redirect(to: Routes.loan_path(conn, :trade_advance_application_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :trade_advance_application_datatable))
      end
    else
      my_password = LoanmanagementsystemWeb.UserController.random_string()

      Ecto.Multi.new()
      |> Ecto.Multi.insert(
        :add_user,
        User.changeset(%User{}, %{
          password: my_password,
          status: "INACTIVE",
          username: params["emailAddress"],
          auto_password: "Y"
        })
      )
      |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
        UserRole.changeset(%UserRole{}, %{
          roleType: params["roleType"],
          status: "INACTIVE",
          userId: add_user.id,
          otp: otp
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                               %{
                                                 add_user: add_user,
                                                 add_user_role: _add_user_role
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
      |> Ecto.Multi.run(:user_logs, fn _repo,
                                       %{
                                         add_user: _add_user,
                                         add_user_role: _add_user_role,
                                         add_user_bio_data: _add_user_bio_data
                                       } ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "user creations and loan application Successfully",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:loan_application, fn _repo,
                                              %{add_user: _add_user, add_user_role: _add_user_role} ->
        Loans.changeset(%Loans{}, %{
          "customer_id" => params["customer_id"],
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => params["currency_code"],
          "loan_type" => params["product_type"],
          "principal_amount" => params["amount"]
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{add_user: _add_user}} ->
          conn
          |> put_flash(:info, "Loan Application Submitted")
          |> redirect(to: Routes.loan_path(conn, :trade_advance_application_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :trade_advance_application_datatable))
      end
    end
  end

  def create_invoice_discounting_application(conn, params) do
    loan_calculations = calculate_interest_and_repaymnent_amt(params)
    otp = to_string(Enum.random(1111..9999))

    if params["customer_id"] != "" || params["customer_id"] != nil do
      new_params =
        Map.merge(params, %{
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => loan_calculations.currency_code,
          "loan_type" => params["product_type"],
          "tenor" => loan_calculations.tenor,
          "principal_amount" => params["amount"],
          "repayment_amount" => loan_calculations.repayement_amt,
          "interest_amount" => loan_calculations.interest_amt,
          "balance" => loan_calculations.repayement_amt
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
          |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
      end
    else
      my_password = LoanmanagementsystemWeb.UserController.random_string()

      Ecto.Multi.new()
      |> Ecto.Multi.insert(
        :add_user,
        User.changeset(%User{}, %{
          password: my_password,
          status: "INACTIVE",
          username: params["emailAddress"],
          auto_password: "Y"
        })
      )
      |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
        UserRole.changeset(%UserRole{}, %{
          roleType: params["roleType"],
          status: "INACTIVE",
          userId: add_user.id,
          otp: otp
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                               %{
                                                 add_user: add_user,
                                                 add_user_role: _add_user_role
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
      |> Ecto.Multi.run(:user_logs, fn _repo,
                                       %{
                                         add_user: _add_user,
                                         add_user_role: _add_user_role,
                                         add_user_bio_data: _add_user_bio_data
                                       } ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "user creations and loan application Successfully",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:loan_application, fn _repo,
                                              %{add_user: _add_user, add_user_role: _add_user_role} ->
        Loans.changeset(%Loans{}, %{
          "customer_id" => params["customer_id"],
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => params["currency_code"],
          "loan_type" => params["product_type"],
          "principal_amount" => params["amount"]
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{add_user: _add_user}} ->
          conn
          |> put_flash(:info, "Loan Application Submitted")
          |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
      end
    end
  end

  def create_loan_application(conn, params) do
    # loan_calculations = calculate_interest_and_repaymnent_amt(params)
    otp = to_string(Enum.random(1111..9999))

    if params["customer_id"] != "" || params["customer_id"] != nil do
      new_params =
        Map.merge(params, %{
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          # "currency_code" => loan_calculations.currency_code,
          "loan_type" => params["product_type"],
          # "tenor" => loan_calculations.tenor,
          "principal_amount" => params["amount"],
          # "repayment_amount" => loan_calculations.repayement_amt,
          # "interest_amount" => loan_calculations.interest_amt,
          # "balance" => loan_calculations.repayement_amt
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
          json(conn, %{data: "Loan Application Submitted"})

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          json(conn, %{error: reason})
      end
    else
      my_password = LoanmanagementsystemWeb.UserController.random_string()

      Ecto.Multi.new()
      |> Ecto.Multi.insert(
        :add_user,
        User.changeset(%User{}, %{
          password: my_password,
          status: "INACTIVE",
          username: params["emailAddress"],
          auto_password: "Y"
        })
      )
      |> Ecto.Multi.run(:add_user_role, fn _repo, %{add_user: add_user} ->
        UserRole.changeset(%UserRole{}, %{
          roleType: params["roleType"],
          status: "INACTIVE",
          userId: add_user.id,
          otp: otp
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:add_user_bio_data, fn _repo,
                                               %{
                                                 add_user: add_user,
                                                 add_user_role: _add_user_role
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
      |> Ecto.Multi.run(:user_logs, fn _repo,
                                       %{
                                         add_user: _add_user,
                                         add_user_role: _add_user_role,
                                         add_user_bio_data: _add_user_bio_data
                                       } ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "user creations and loan application Successfully",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:loan_application, fn _repo,
                                              %{add_user: _add_user, add_user_role: _add_user_role} ->
        Loans.changeset(%Loans{}, %{
          "customer_id" => params["customer_id"],
          "principal_amount_proposed" => params["amount"],
          "loan_status" => "PENDING_APPROVAL",
          "status" => "PENDING_APPROVAL",
          "currency_code" => params["currency_code"],
          "loan_type" => params["product_type"],
          "principal_amount" => params["amount"]
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{add_user: _add_user}} ->
          json(conn, %{data: "Loan Application Submitted"})

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          json(conn, %{error: reason})
      end
    end
  end

  def reject_loan(conn, params) do
    loan_details = Loans.find_by(id: params["id"])
    new_params =
      Map.merge(params, %{
        "loan_status" => "REJECTED",
        "status" => "REJECTED"
      })

    Ecto.Multi.new()
    |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, new_params))
    |> Ecto.Multi.run(:user_logs, fn _, %{loan_details: loan_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Rejected loan with Loan Number: #{loan_details.id}Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{loan_details: _loan_details}} ->
        conn
        |> put_flash(:info, "Rejected loan successfully")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end
  end

  defp handle_payment_date(loan_details) do
    if loan_details.repayment_frequency == "Daily" do
      tenor = loan_details.tenor
      todays_date = Timex.today()
      Timex.shift(todays_date, days: tenor)
    else
      if loan_details.repayment_frequency == "Monthly" do
        tenor = loan_details.tenor
        todays_date = Timex.today()
        Timex.shift(todays_date, months: tenor)
      else
        ""
      end
    end
  end

  def approve_loan(conn, params) do
    loan_details = Loanmanagementsystem.Loan.get_loan_by_id!(params["id"])
    payment_date = handle_payment_date(loan_details)

    new_params =
      Map.merge(params, %{
        "loan_status" => "APPROVED",
        "status" => "APPROVED",
        "approvedon_date" => Timex.today(),
        "closedon_date" => payment_date
      })

    Ecto.Multi.new()
    |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, new_params))
    |> Ecto.Multi.run(:user_logs, fn _, %{loan_details: loan_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "The loan with S/N: #{loan_details.id} has been Approved Successfully, awaiting disbursement... ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{loan_details: loan_details}} ->
        json(conn, %{
          data:
            "The Loan with S/N: #{loan_details.id} has been Approved successfully, awaiting disbursement..."
        })

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
    end
  end

  @current "tbl_loans"
  def client_statement_item_lookup(conn, params) do
    # user_id = conn.assigns.user.id
    {draw, start, length, search_params} = searchs_loan_statement_options(params)
    lookup = confirms_loan_statement_report_type(conn.request_path)
    results = lookup.(search_params, start, length)
    totals_entries = totals_entries(results)

    results = %{
      draw: draw,
      recordsTotal: totals_entries,
      recordsFiltered: totals_entries,
      data: entriess(results)
    }

    json(conn, results)
  end

  defp confirms_loan_statement_report_type("/Credit/Management/client/statement"),
    do: &get_all_complete_loan_statement/3

  def searchs_loan_statement_options(params) do
    length = calculates_page_size(params["length"])
    page = calculates_page_num(params["start"], length)
    draw = String.to_integer(params["draw"])
    params = Map.put(params, "isearch", params["search"]["value"])

    new_params =
      Enum.reduce(~w(columns order search length draw start _csrf_token), params, fn key, acc ->
        Map.delete(acc, key)
      end)

    {draw, page, length, new_params}
  end

  def totals_entries(%{total_entries: total_entries}), do: total_entries
  def totals_entries(_), do: 0

  def entriess(%{entries: entries}), do: entries
  def entriess(_), do: []

  def calculates_page_num(nil, _), do: 1

  def calculates_page_num(start, length) do
    start = String.to_integer(start)
    round(start / length + 1)
  end

  def calculates_page_size(nil), do: 10
  def calculates_page_size(length), do: String.to_integer(length)

  def export_loan_statement_pdf(conn, params) do
    process_report_loan_statement(conn, @current, params)
  end

  defp process_report_loan_statement(conn, source, params) do
    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=LOAN_STATEMENT#{Timex.today()}.csv"
      )
      |> put_resp_content_type("text/csv")

    params
    |> Map.delete("_csrf_token")
    |> reports_generators_loan_statement(source)
    |> Repo.all()
    |> LoanSavingsSystem.Workers.LoanStatement.generate()
    |> process_loan_statement(conn)
  end

  defp process_loan_statement(content, conn) do
    datetime =
      Timex.now() |> DateTime.truncate(:second) |> DateTime.to_naive() |> Timex.shift(hours: 2)

    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=LOAN_STATEMENT As at #{datetime}.pdf"
      )
      |> put_resp_content_type("text/pdf")

    send_resp(conn, 200, content)
  end

  def reports_generators_loan_statement(search_params, source) do
    get_all_complete_loan_statement_pdf(source, Map.put(search_params, "isearch", ""))
  end

  def get_all_complete_loan_statement_pdf(_source, search_params) do
    loan_id = String.to_integer(search_params["id"])

    Loans
    |> join(:left, [a], u in "tbl_user_bio_data", on: a.customer_id == u.userId)
    |> join(:left, [a, u], p in "tbl_products", on: a.product_id == p.id)
    |> join(:left, [a, u, p], t in "tbl_loan_transaction", on: a.id == t.loan_id)
    |> where([a, u, p, t], t.loan_id == ^loan_id and a.customer_id == u.userId)
    |> order_by(desc: :inserted_at)
    |> loan_statement_report_select_on_generating_pdf()
  end

  def get_all_complete_loan_statement(_search_params, page, size) do
    LoanTransaction
    |> join(:left, [a], u in "tbl_user_bio_data", on: a.customer_id == u.userId)
    |> where([a, u], a.customer_id == u.userId)
    # |> loan_statement_report_filter(search_params)
    |> order_by([a, u], a.transaction_date)
    |> loan_statement_report_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  # CSV Report
  # def get_all_complete_loan_statement(_source, search_params) do
  #   Loans
  #   |> join(:left, [a], u in "tbl_user_bio_data", on: a.customer_id == u.userId)
  #   |> join(:left, [a, u], p in "tbl_products", on: a.product_id == p.id)
  #   |> where([a, u, p], a.customer_id == u.userId)
  #     # |> loan_statement_report_filter(search_params)
  #     |> order_by(desc: :inserted_at)
  #     |> loan_statement_report_select()
  # end

  defp loan_statement_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> account_listing_date_filter(search_params)
    |> account_listing_counter_filter(search_params)
    |> account_listing_customer_no(search_params)
    |> account_listing_email(search_params)
  end

  defp loan_statement_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    account_listing_isearch_filter(query, search_term)
  end

  defp account_listing_date_filter(query, %{"start_date" => start_date, "end_date" => end_date})
       when start_date == "" or is_nil(start_date) or end_date == "" or is_nil(end_date),
       do: query

  defp account_listing_date_filter(query, %{"start_date" => start_date, "end_date" => end_date}) do
    query
    |> where(
      [a],
      fragment("CAST(? AS DATE) >= ?", a.inserted_at, ^start_date) and
        fragment("CAST(? AS DATE) <= ?", a.inserted_at, ^end_date)
    )
  end

  defp account_listing_counter_filter(query, %{"fund_name" => fund_name})
       when fund_name == "" or is_nil(fund_name),
       do: query

  defp account_listing_counter_filter(query, %{"fund_name" => fund_name}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.fund_name, ^"%#{fund_name}%"))
  end

  # ------------------------------------------
  defp account_listing_customer_no(query, %{"customer_no" => customer_no})
       when customer_no == "" or is_nil(customer_no),
       do: query

  defp account_listing_customer_no(query, %{"customer_no" => customer_no}) do
    where(query, [a, u], fragment("lower(?) LIKE lower(?)", u.customer_no, ^"%#{customer_no}%"))
  end

  # ----------------------------------------------
  defp account_listing_email(query, %{"email" => email})
       when email == "" or is_nil(email),
       do: query

  defp account_listing_email(query, %{"email" => email}) do
    where(query, [a, u], fragment("lower(?) LIKE lower(?)", u.email, ^"%#{email}%"))
  end

  defp account_listing_isearch_filter(query, search_term) do
    query
    |> where(
      [a, u, r],
      fragment("lower(?) LIKE lower(?)", a.ac_no, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.ac_name, ^search_term) or
        fragment("lower(?) LIKE lower(?)", u.linked_account_category, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.unit_price, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.fund_name, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.currency, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.available_bal, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.current_units, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.market_value, ^search_term)
    )
  end

  defp loan_statement_report_select(query) do
    query
    |> select([a, u], %{
      id: a.id,
      first_name: u.firstName,
      last_name: u.lastName,
      phone: u.mobileNumber,
      email_address: u.emailAddress,
      amount: a.amount,
      transaction_date: a.transaction_date,
      narration: a.narration,
      dr_amount:
        fragment(
          "select case when  drcr_ind = ? then sum(amount) else '0' end from tbl_loan_transaction where drcr_ind = 'D'  and  transaction_date = ? and id = ? group by drcr_ind,  transaction_date",
          a.drcr_ind,
          a.transaction_date,
          a.id
        ),
      cr_amount:
        fragment(
          "select case when  drcr_ind = ? then sum(amount) else '0' end from tbl_loan_transaction where drcr_ind = 'C'  and  transaction_date = ? and id = ? group by drcr_ind,  transaction_date",
          a.drcr_ind,
          a.transaction_date,
          a.id
        ),
      balance: a.amount
    })
  end

  defp loan_statement_report_select_on_generating_pdf(query) do
    query
    |> select([a, u, p, t], %{
      sn: a.id,
      id: a.id,
      customer_id: a.customer_id,
      first_name: u.firstName,
      last_name: u.lastName,
      phone: u.mobileNumber,
      email_address: u.emailAddress,
      loan_status: a.loan_status,
      company_id: a.company_id,
      principal_amount: a.principal_amount,
      product_name: p.name,
      product_id: p.id,
      currency: p.currencyName,
      principal_amount: a.principal_amount,
      interest_outstanding_derived: a.interest_outstanding_derived,
      total_principal_repaid: a.total_principal_repaid,
      principal_outstanding_derived: a.principal_outstanding_derived,
      repayment_type: a.repayment_type,
      approvedon_date: a.approvedon_date,
      closedon_date: a.closedon_date,
      repayment_amount: a.repayment_amount,
      balance: a.balance,
      interest_amount: a.interest_amount,
      amount: t.amount,
      transaction_date: t.transaction_date,
      mno_mobile_no: t.mno_mobile_no,
      bank_account_no: t.bank_account_no,
      narration: t.narration
    })
  end

  def customer_loans_list_write_off(conn, params) do
    {draw, start, length, search_params} = search_options(params)

    results = Loanmanagementsystem.Loan.clients_loans_list_write_off(search_params, start, length)

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

  # LoanmanagementsystemWeb.LoanController.t
  def t() do
    balance = 100
    interestRate = 10 / 100
    terms = 12
    monthlyRate = interestRate / 12

    payment = balance * (monthlyRate / :math.pow(1 + monthlyRate, -terms))

    loanamount = balance
    intrestrate = interestRate * 100
    numebrofmonths = terms
    monthlyrepay = payment
    totalrepay = payment * terms

    IO.inspect(loanamount)
    IO.inspect(intrestrate)
    IO.inspect(numebrofmonths)
    IO.inspect(monthlyrepay)
    IO.inspect(totalrepay)
    # termss = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    x = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

    results =
      Enum.map(x, fn val ->
        val
      end)

    IO.inspect("----------------------------------------")
    IO.inspect(results)
  end

  # LoanmanagementsystemWeb.LoanController.calculate_maturity_repayments(100, 12, 10, 365, "COMPOUND INTEREST", "Months", "Months")
  # LoanmanagementsystemWeb.LoanController.calculate_maturity_repayments(500, 1, 0.15, 365, "FLAT", "Months", "Months")
  def calculate_maturity_repayments(
        amount,
        period,
        rate,
        annual_period,
        interestMode,
        interestType,
        periodType
      ) do
    IO.inspect("################")
    IO.inspect(amount)
    # IO.inspect period
    # IO.inspect "Rate ...#{rate}"
    # IO.inspect annual_period
    IO.inspect(interestType)
    IO.inspect(interestMode)
    IO.inspect(periodType)
    IO.inspect(annual_period)

    rate =
      case interestType do
        "Days" ->
          rate = rate * annual_period
          rate = rate / 100
          rate = rate / annual_period
          rate

        "Months" ->
          # rate = rate*12
          # rate = rate/100
          # rate = rate/annual_period
          rate

        "Year" ->
          rate = rate / 100
          IO.inspect(rate)
          rate = rate / annual_period
          IO.inspect(rate)
          rate
      end

    IO.inspect("+++++++++++++++++")
    IO.inspect(rate)

    totalRepayable = 0.00
    y = 1

    case interestMode do
      "FLAT" ->
        incurredInterest = amount * rate * period
        IO.inspect("#{amount} * #{rate} * #{period} * ")
        IO.inspect(incurredInterest)
        totalPayableAtEnd = incurredInterest + amount
        totalPayableAtEnd

      "COMPOUND INTEREST" ->
        rate__ = 1 + rate
        number_of_repayments = 3
        raisedVal = :math.pow(rate__, number_of_repayments)
        IO.inspect(raisedVal)
        a = rate * raisedVal
        b = raisedVal - 1
        c = a / b

        if number_of_repayments > 0 do
          totalPayableInMonthX = amount * (rate * raisedVal / (raisedVal - 1))
          IO.inspect("GREATER THAN SCHDULE")
          IO.inspect(totalPayableInMonthX)
        else
          IO.inspect("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
          totalPayableInMonthX = amount * (rate * raisedVal / (raisedVal - 1))
          IO.inspect(totalPayableInMonthX)
        end

        # realMonthlyRepayment = amount * (rate) * (1)
        # IO.inspect realMonthlyRepayment
    end
  end

  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:credit_mgt, :create}
      act when act in ~w(index view)a -> {:credit_mgt, :view}
      act when act in ~w(update edit)a -> {:credit_mgt, :edit}
      act when act in ~w(change_status)a -> {:credit_mgt, :change_status}
      _ -> {:credit_mgt, :unknown}
    end
  end

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")



   def calculate_amortization(conn, params) do
    customer_address_details = Loanmanagementsystem.Accounts.get_address_by_id(params["customer_id"])
    get_user_bio_by_id = Loanmanagementsystem.Accounts.get_user_bio_by_id(params["customer_id"])
    product_details = Loanmanagementsystem.Products.Product.find_by(id: params["product_id"])
    IO.inspect product_details, label: "product_details -----------------------------------"
    # house_number = customer_address_details.house_number
    # town = customer_address_details.town
    # province = customer_address_details.province

    if params["date"] != ""  do
      loan_amount = params["loan_amount"]
      interest_rate = params["interest_rate"]
      loan_term = params["loan_term"]
      loan_id = params["loan_id"]
      customer_id = params["customer_id"]
      reference_no = params["reference_no"]
      calculation_date = params["date"]

      # Calculate the amortization schedule using Elixir
      schedule = generate_schedule(loan_amount, interest_rate, loan_term, calculation_date, loan_id, customer_id, reference_no)


      get_first_month_payment = List.first(schedule)
      first_payment_month = get_first_month_payment.date
      payment_per_month = get_first_month_payment.payment


      total_payment = Enum.reduce(schedule, 0, fn map, acc ->
        acc + map.payment
      end)


      months_int = try do
        case String.contains?(String.trim(interest_rate), ".") do
          true ->  String.trim(interest_rate) |> String.to_float()
          false ->  String.trim(interest_rate) |> String.to_integer() end
      rescue _-> 0 end

      interest_r = try do
        case String.contains?(String.trim(interest_rate), ".") do
          true ->  String.trim(interest_rate) |> String.to_float()
          false ->  String.trim(interest_rate) |> String.to_integer() end
      rescue _-> 0 end
      requested_amount = try do
        case String.contains?(String.trim(loan_amount), ".") do
          true ->  String.trim(loan_amount) |> String.to_float()
          false ->  String.trim(loan_amount) |> String.to_integer() end
      rescue _-> 0 end
      term_in_months = try do
        case String.contains?(String.trim(loan_term), ".") do
          true ->  String.trim(loan_term) |> String.to_float()
          false ->  String.trim(loan_term) |> String.to_integer() end
      rescue _-> 0 end

      months_interest = months_int / 12
      monthly_interest_rate = interest_r / 1200.0 # Convert interest rate to monthly rate
      payment = requested_amount * (monthly_interest_rate / (1 - :math.pow(1 + monthly_interest_rate, -term_in_months)))
      monthly_inst = Float.round(payment, 2)
      processing_fee = if product_details.proccessing_fee == nil do 0.1 * requested_amount else product_details.proccessing_fee * requested_amount end
      insurance =  if product_details.insurance == nil do 0.03 * requested_amount else product_details.insurance * requested_amount end
      crb_fee = if product_details.crb_fee == nil do 100 else product_details.crb_fee end
      net_disbiursed =  requested_amount - processing_fee - insurance - crb_fee
      proces_fee = if product_details.proccessing_fee == nil do 0.1 else product_details.proccessing_fee  end
      insura_fee = if product_details.insurance == nil do 0.03 else product_details.insurance  end
      disbursed_processing_fee_percent = proces_fee * 100
      disbursed_insurance_percent = insura_fee * 100

      # Disbursement Schedule
      disbursement_schedule = %{
        applicant: "#{params["firstname"]} #{params["othername"]} #{params["surname"]}",
        applied_amount: params["loan_amount"],
        approved_amount: params["loan_amount"],
        processing_fee: processing_fee,
        insurance: insurance,
        interest_per_month: months_interest,
        repayment_period: params["loan_term"],
        monthly_installment: monthly_inst,
        crb_amt: crb_fee,
        net_disbiursed: net_disbiursed,
        customer_address: "house # #{customer_address_details.house_number}, town - #{customer_address_details.town}, province - #{customer_address_details.province}",
        customer_nrc: get_user_bio_by_id.meansOfIdentificationNumber,
        first_payment_month: "#{first_payment_month}",
        total_payment: total_payment,
        payment_per_month: payment_per_month,
        processing_fee_percent: disbursed_processing_fee_percent,
        insurance_percent: disbursed_insurance_percent

      }
      # Pass the schedule to the view
      render(conn, "loan_legals_documents.html",
       amortization: schedule, loan_amount: loan_amount,
       interest_rate: interest_rate, loan_term: loan_term,
       months_interest: months_interest, current_time: current_time(),
       disbursement_schedule: disbursement_schedule, loan_id: loan_id,
       bank_details: Loan.list_customers_bank_details_validation(customer_id),
       calculation_date: calculation_date,

        )
    else
      conn
      |> put_flash(:error, "kindly add the calculation date and try again.")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end
    end

    def generate_schedule(loan_amount_v, interet_rate_v, term_in_months_v, calculation_date, loan_id, customer_id, reference_no) do
      interest_rate = try do
        case String.contains?(String.trim(interet_rate_v), ".") do
          true ->  String.trim(interet_rate_v) |> String.to_float()
          false ->  String.trim(interet_rate_v) |> String.to_integer() end
      rescue _-> 0 end
      loan_amount = try do
        case String.contains?(String.trim(loan_amount_v), ".") do
          true ->  String.trim(loan_amount_v) |> String.to_float()
          false ->  String.trim(loan_amount_v) |> String.to_integer() end
      rescue _-> 0 end
      term_in_months = try do
        case String.contains?(String.trim(term_in_months_v), ".") do
          true ->  String.trim(term_in_months_v) |> String.to_float()
          false ->  String.trim(term_in_months_v) |> String.to_integer() end
      rescue _-> 0 end

    cal_date = Date.from_iso8601!(calculation_date)
    monthly_rate = interest_rate / 1200.0
    payment = loan_amount * monthly_rate / (1.0 - :math.pow(1.0 + monthly_rate, -term_in_months))
    Enum.reduce(1..term_in_months, [], fn month, acc ->
      previous_balance = if month == 1, do: loan_amount, else: hd(acc)[:ending_balance]
      interest = previous_balance * monthly_rate
      principal = payment - interest
      ending_balance = previous_balance - principal
      [ %{
          loan_id: loan_id,
          customer_id: customer_id,
          reference_no: reference_no,
          loan_amount: loan_amount,
          interest_rate: interest_rate,
          term_in_months: term_in_months,
          month: month,
          beginning_balance: previous_balance,
          payment: Float.round(payment, 2),
          interest: Float.round(interest, 2),
          principal: Float.round(principal, 2),
          ending_balance: Float.round(ending_balance, 2),
          date: Timex.end_of_month(Timex.shift(cal_date, months: month)),
          calculation_date: calculation_date
        }
        | acc ]
    end)
    |> Enum.reverse()
    end

    def render_amortization(conn, params) do
        with(
          client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
        ) do
         nrc = client_details.id_number
        client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
        client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
        nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
        client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
        loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
        collateral_details = Loan.collateral_details_validation(params["userId"], params["reference_no"])
        extracted_other_collateral_details = Loan.extracted_other_collateral_details_validation(params["userId"], params["reference_no"])
        guarantors_details = Loan.guarantors_details_validation(params["userId"], params["reference_no"])
        sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
        market_details = Loan.list_loan_market_info(params["userId"], params["reference_no"])
        render(conn, "loan_amortization.html",
          product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
          product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
          client_data: client_data,
          client_kyc: client_kyc,
          nextofkin: nextofkin,
          client_references: client_references,
          loan_details: loan_details,
          collateral_details: collateral_details,
          extracted_other_collateral_details: extracted_other_collateral_details,
          guarantors_details: guarantors_details,
          sales_recommedation: sales_recommedation,
          market_details: market_details,
        )
        else
          _ ->
          conn
          |> put_flash(:error, "Something went wrong, try again.")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
        end
     end

     def payment_requisition_form(conn, params) do
       reference_no = params["reference_no"]
       loan_details = Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"])
       customer_kyc = Loanmanagementsystem.Accounts.UserBioData.find_by(userId: loan_details.customer_id)
       contact_details = Loanmanagementsystem.Loan.Loan_customer_details.find_by(reference_no: params["reference_no"])
       fullname = "#{customer_kyc.firstName}" <> " " <> "#{customer_kyc.lastName}" <> " " <> "#{customer_kyc.otherName}"
       disbursement_schedule = Loan.list_disbursement_schedule_validation(params["userId"], params["reference_no"])
       render(conn, "payment_requisition_form.html",
       reference_no: reference_no, fullname: fullname,
       loan_details: loan_details, contact_details: contact_details,
       disbursement_schedule: disbursement_schedule)
     end

     def create_loan_payment_requisition(conn, params) do
      with(
        loan_details when loan_details  != nil <- Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"])
      ) do
      new_params = Map.merge(params, %{
        "customer_id" => loan_details.customer_id,
        "loan_id" => loan_details.id,
        "reference_no" =>  loan_details.reference_no,

      })
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:add_reference, Loan_disbursement.changeset(%Loan_disbursement{}, new_params))
      |> Ecto.Multi.run(:user_logs, fn _repo, %{add_reference: _add_reference} ->
        Ecto.Multi.new()
        |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, %{
          "loan_status" => "DISBURSEMENT_PENDING_FINANCE_MANAGER",
          "status" => "DISBURSEMENT_PENDING_FINANCE_MANAGER"
        }))
        |> Repo.transaction()

        UserLogs.changeset(%UserLogs{}, %{
          activity: "You have Successfully created a payment requisition for #{params["payable_to"]} worth #{params["amount_requested"]}",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, _} ->
          conn
          |> put_flash(:info, "You have initiated loan disbursement")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors)

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
    else
      _->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end
    end

    def cfo_payment_requisition_form(conn, params) do
      reference_no = params["reference_no"]
      loan_details = Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"])
      customer_kyc = Loanmanagementsystem.Accounts.UserBioData.find_by(userId: loan_details.customer_id)
      contact_details = Loanmanagementsystem.Loan.Loan_customer_details.find_by(reference_no: params["reference_no"])
      fullname = "#{customer_kyc.firstName}" <> " " <> "#{customer_kyc.lastName}" <> " " <> "#{customer_kyc.otherName}"
      disbursement_details = Loanmanagementsystem.Loan.Loan_disbursement.find_by(reference_no: params["reference_no"])
      render(conn, "cfo_approve_payment_requisition_form.html",
      reference_no: reference_no, fullname: fullname,
      loan_details: loan_details, contact_details: contact_details,
      disbursement_details: disbursement_details,
      )
    end

    def cfo_approve_loan_payment_requisition(conn, params) do
      with(
        loan_details when loan_details  != nil <- Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"])
      ) do
      disbursement_details = Loanmanagementsystem.Loan.Loan_disbursement.find_by(reference_no:  params["reference_no"])
      Ecto.Multi.new()
      |> Ecto.Multi.update(:disbursement_details, Loan_disbursement.changeset(disbursement_details, params))
      |> Ecto.Multi.run(:user_logs, fn _repo, %{disbursement_details: _disbursement_details} ->
        Ecto.Multi.new()
        |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, %{
          "loan_status" => "DISBURSEMENT_PENDING_CEO",
          "status" => "DISBURSEMENT_PENDING_CEO"
        }))
        |> Repo.transaction()
        UserLogs.changeset(%UserLogs{}, %{
          activity: "You have Successfully Approved a payment requisition ",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, _} ->
          conn
          |> put_flash(:info, "You have Approved loan disbursement")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors)

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
    else
      _->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end
    end

    def ceo_payment_requisition_form(conn, params) do
      reference_no = params["reference_no"]
      loan_details = Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"])
      customer_kyc = Loanmanagementsystem.Accounts.UserBioData.find_by(userId: loan_details.customer_id)
      contact_details = Loanmanagementsystem.Loan.Loan_customer_details.find_by(reference_no: params["reference_no"])
      fullname = "#{customer_kyc.firstName}" <> " " <> "#{customer_kyc.lastName}" <> " " <> "#{customer_kyc.otherName}"
      disbursement_details = Loanmanagementsystem.Loan.Loan_disbursement.find_by(reference_no: params["reference_no"])
      render(conn, "ceo_approve_payment_requisition_form.html",
      reference_no: reference_no, fullname: fullname,
      loan_details: loan_details, contact_details: contact_details,
      disbursement_details: disbursement_details,
      )
    end

    def ceo_approve_loan_payment_requisition(conn, params) do
      with(
        loan_details when loan_details  != nil <- Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"])
      ) do
      disbursement_details = Loanmanagementsystem.Loan.Loan_disbursement.find_by(reference_no:  params["reference_no"])
      Ecto.Multi.new()
      |> Ecto.Multi.update(:disbursement_details, Loan_disbursement.changeset(disbursement_details, params))
      |> Ecto.Multi.run(:user_logs, fn _repo, %{disbursement_details: _disbursement_details} ->
        Ecto.Multi.new()
        |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, %{
          "loan_status" => "DISBURSED",
          "status" => "DISBURSED",
          "disbursedon_date" => Timex.today,
        }))
        |> Repo.transaction()
        txn_ref = transaction_ref()
        gl_params = prepare_disbursement_gl_cr_params(params, txn_ref)
        customer_params =  prepare_disbursement_customer_dr_params(params, txn_ref, loan_details)
        Journal_entries.changeset(%Journal_entries{}, gl_params)
        |> Repo.insert()
        Journal_entries.changeset(%Journal_entries{}, customer_params)
        |> Repo.insert()
        UserLogs.changeset(%UserLogs{}, %{
          activity: "You have Successfully Approved a payment requisition ",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, _} ->
          conn
          |> put_flash(:info, "You have Approved loan disbursement")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors)

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
    else
      _->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end
    end

    def transaction_ref() do
      day_year = Date.day_of_year(Date.utc_today()) |> to_string
      date = to_string(Timex.format!(Timex.today(), "%Y", :strftime))
      random_int = to_string(Enum.random(1111..9999))
      randoms = to_string(Enum.random(11..99))
      date <> day_year <> random_int <> randoms
    end

    defp prepare_disbursement_gl_cr_params(params, txn_ref) do
      gl_description =
      try do
        Loanmanagementsystem.Chart_of_accounts.Chart_of_account.find_by(
          ac_gl_no: String.trim(params["gl_account"])
        ).ac_gl_descption
      rescue
        _ -> "No Account Name"
      end
    gl_category =
      try do
        Loanmanagementsystem.Chart_of_accounts.Chart_of_account.find_by(
          ac_gl_no: String.trim(params["gl_account"])
        ).gl_category
      rescue
        _ -> "No GL Category"
      end
      %{
        module: "DISBURSEMENT",
        batch_no: "",
        batch_id: "",
        event: "LD",
        trn_ref_no: txn_ref,
        account_no: params["gl_account"],
        account_name: gl_description,
        currency: "ZMW",
        drcr_ind: "C",
        fcy_amount: 0,
        lcy_amount: params["amount_paid"],
        financial_cycle: "FY#{Timex.today().year}",
        period_code: String.upcase(Timex.format!(Timex.today(), "%b", :strftime)),
        product: params["loan_type"],
        trn_dt: params["date_paid"],
        value_dt: to_string(Timex.today()),
        auth_status: "AUTHORISED",
        batch_status: "ACTIVE",
        process_status: "APPROVED",
        account_category: to_string(gl_category),
        narration: "DISBURSEMENT",
        interest: 0.00,
        principle: params["amount_paid"],
        running_balance: 0.00
      }
    end

    defp prepare_disbursement_customer_dr_params(params, txn_ref, loan_details) do
      %{
        module: "DISBURSEMENT",
        batch_no: "",
        batch_id: "",
        event: "LD",
        trn_ref_no: txn_ref,
        account_no: params["customer_id"],
        account_name: params["payable_to"],
        currency: "ZMW",
        drcr_ind: "D",
        fcy_amount: 0,
        lcy_amount: params["amount_paid"],
        financial_cycle: "FY#{Timex.today().year}",
        period_code: String.upcase(Timex.format!(Timex.today(), "%b", :strftime)),
        product: params["loan_type"],
        trn_dt: params["date_paid"],
        value_dt: to_string(Timex.today()),
        auth_status: "AUTHORISED",
        batch_status: "ACTIVE",
        process_status: "APPROVED",
        account_category: "Assets",
        narration: "DISBURSEMENT",
        interest: 0.00,
        principle: params["amount_paid"],
        running_balance: 0.00,
        customer_id: params["customer_id"],
        loan_id: loan_details.id,
      }
    end

    def add_client_documents(conn, params) do
      with(
        loan_details when loan_details  != nil <- Loanmanagementsystem.Loan.Loans.find_by(id: params["loan_id"])
      ) do
      new_params = %{
        activity: "You have Successfully uploaded documents",
        user_id: conn.assigns.user.id
      }
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:add_client_documents, UserLogs.changeset(%UserLogs{}, new_params))
      |> Ecto.Multi.run(:user_logs, fn _repo, %{add_client_documents: _add_client_documents} ->
        file_category = if params["file_category"] == "SALARYBACKED" do "EMPLOYMENT_VERIFICATION" else "LOAN_DOCUMENTS" end
        nrc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(userId: loan_details.customer_id).meansOfIdentificationNumber rescue _-> "" end
        Loanmanagementsystem.Services.LoanDocumentsUploads.client_upload(%{"process_documents" => params, "conn" => conn, "nrc" => nrc, "loan_id" => loan_details.id, "file_category" => file_category })
        {:ok, "Success"}
      end)
      |> Repo.transaction()
      |> case do
        {:ok, _} ->
          conn
          |> put_flash(:info, "You have Successfully Uploaded")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors)

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
    else
      _->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end
    end


    def add_client_crb_documents(conn, params) do
      with(
        loan_details when loan_details  != nil <- Loanmanagementsystem.Loan.Loans.find_by(id: params["loan_id"])
      ) do
      new_params = %{
        activity: "You have Successfully uploaded CRB Report document for #{params["firstname"]} #{params["surname"]} with ID #{params["id_number"]}",
        user_id: conn.assigns.user.id
      }
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:add_client_documents, UserLogs.changeset(%UserLogs{}, new_params))
      |> Ecto.Multi.run(:user_logs, fn _repo, %{add_client_documents: _add_client_documents} ->
        nrc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(userId: loan_details.customer_id).meansOfIdentificationNumber rescue _-> "" end
        Loanmanagementsystem.Services.LoanDocumentsUploads.client_upload(%{"process_documents" => params, "conn" => conn, "nrc" => nrc, "loan_id" => loan_details.id, "file_category" => "CRB_REPORT"})
        {:ok, "Success"}
      end)
      |> Repo.transaction()
      |> case do
        {:ok, _} ->
          conn
          |> put_flash(:info, "You have Successfully Uploaded")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors)

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
    else
      _->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end
  end

    def writeoff_loan(conn, params) do
      loan_details = Loans.find_by(id: params["id"])
      firstname = try do Loanmanagementsystem.Loan.Loan_customer_details.find_by(reference_no: loan_details.reference_no).firstname || "" rescue _-> "" end
      surname = try do Loanmanagementsystem.Loan.Loan_customer_details.find_by(reference_no: loan_details.reference_no).surname || "" rescue _-> "" end
      othername = try do Loanmanagementsystem.Loan.Loan_customer_details.find_by(reference_no: loan_details.reference_no).othername || "" rescue _-> "" end
      company_name = try do Loanmanagementsystem.Loan.Loan_customer_details.find_by(reference_no: loan_details.reference_no).company_name || "" rescue _-> "" end
      customer_name = if company_name == "" do firstname<>" "<>surname<>" "<>othername else company_name end
      new_param =  %{
        "loan_status" => "WRITTEN_OFF",
        "status" => "WRITTEN_OFF",
      }
      Ecto.Multi.new()
      |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, new_param))
      |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_details: _loan_details} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "You have Successfully written off Loan for #{params["firstname"]} #{params["surname"]} #{params["othername"]} with email: #{params["email"]} Worth #{params["requested_amount"]}",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
          Writtenoff_loans.changeset(%Writtenoff_loans{}, %{
          amount_writtenoff: params["amount_writtenoff"],
          client_name: customer_name,
          date_of_writtenoff: Timex.today(),
          savings_account: "",
          writtenoff_by: conn.assigns.user.id,
          customer_id: loan_details.customer_id,
          loan_id: loan_details.id,
          reference_no: loan_details.reference_no,
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, _} ->
          conn
          |> put_flash(:info, "You have Successfully Written off the loan")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors)

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
    end

    def loan_bulkupload(conn, _params), do: render(conn, "loan_bulkupload.html")

    @headers ~w/ client_name	mobile_number	product_name	requested_amount	loan_period	application_date	reject_reason	loan_purpose	loan_officer /a

    def handle_loan_bulkupload(conn, params) do
      user = conn.assigns.user
      {key, msg, _invalid} = handle_file_upload(user, params)

      if key == :info do
        conn
        |> put_flash(key, msg)
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      else
        conn
        |> put_flash(key, msg)
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end
    end

    defp handle_file_upload(user, params) do
      with {:ok, filename, destin_path, _rows} <- is_valide_file(params) do
        user
        |> process_bulk_upload(filename, destin_path)
        |> case do
          {:ok, {invalid, _valid}} ->
            {:info, "Loans Uploaded Successful ", invalid}

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

    def process_bulk_upload(user, filename, path) do
      {:ok, items} = extract_xlsx(path)
      prepare_bulk_params(user, filename, items)
      |> Repo.transaction(timeout: :infinity)
      |> case do
        {:ok, multi_records} ->
          {invalid, valid} =
            multi_records
            |> Map.values()
            |> Enum.reduce({0, 0}, fn item, {invalid, valid} ->
              case item do
                %{uploafile_name: _src} -> {invalid, valid + 1}
                %{col_index: _index} -> {invalid + 1, valid}
                _ -> {invalid, valid}
              end
            end)

          {:ok, {invalid, valid}}

        {:error, _, changeset, _} ->
          reason = traverse_errors(changeset.errors) |> Enum.join("\r\n")
          {:error, reason}

        {:error, reason} ->
            {:error, reason}
      end
    end

    defp prepare_bulk_params(user, filename, items) do
        Ecto.Multi.new()
        |> Ecto.Multi.run(:upload_entries, fn _repo, _changes_so_far ->
          user
           |> prepare_loan_bulk_params(filename, items)
           |> prepare_customer_details_bulk_params(user, filename, items)
           |> prepare_nextofkin_bulk_params(user, filename, items)
           |> prepare_references_bulk_params(user, filename, items)
           |> prepare_disbursement_bulk_params(user, filename, items)
           |> prepare_amortization_bulk_params(user, filename, items)
           |> prepare_logs_bulk_params(user, filename, items)
           |> case do
              nil ->
                {:ok, "UPLOAD COMPLETE"}
              error ->
                error
            end
        end)
    end

    defp execute_multi(multi) do
      multi
      |> Repo.transaction()
      |> case do
        {:ok, _result} ->
          nil
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          IO.inspect(failed_value)
          {:error, failed_value}
      end
    end

    defp execute_multi_amortisation(multi) do
      multi
      |> Repo.transaction()
      |> case do
        {:ok, _result} ->
          nil
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          IO.inspect(failed_value)
          {:error, failed_value}
      end
    end

    defp prepare_loan_bulk_params(user, _filename, items) do
      items
      |> Stream.with_index(1)
      |> Enum.map(fn {item, index} ->
        customer_id = try do UserBioData.find_by(mobileNumber: item.mobile_number).userId rescue _-> "" end
        reference_no = generate_reference_no_bulkupload(customer_id)
        loan_params = prepare_loan_params(item, user, reference_no, customer_id)
        changeset_loan = Loans.changeset(%Loans{}, loan_params)
        Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_loan)
      end)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> execute_multi()
    end

    defp prepare_nextofkin_bulk_params(nextofkin_resp, _user, _, _) when not is_nil(nextofkin_resp), do: nextofkin_resp
    defp prepare_nextofkin_bulk_params(_nextofkin_resp, user, _filename, items) do
      items
      |> Stream.with_index(1)
      |> Enum.map(fn {item, index} ->
        maintenance_params = prepare_nextofkin_params(item, user)
        maintenance_employee = Nextofkin.changeset(%Nextofkin{}, maintenance_params)
        Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), maintenance_employee)

      end)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> execute_multi()
    end

    defp prepare_customer_details_bulk_params(cust_details_resp, _user, _, _) when not is_nil(cust_details_resp), do: cust_details_resp
    defp prepare_customer_details_bulk_params(_cust_details_resp, user, _filename, items) do
      items
      |> Stream.with_index(1)
      |> Enum.map(fn {item, index} ->
        customer_params = prepare_customer_details_params(item, user)
        customer = Loan_customer_details.changeset(%Loan_customer_details{}, customer_params)
        Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), customer)

      end)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> execute_multi()
    end

    defp prepare_references_bulk_params(reference_resp, _user, _, _) when not is_nil(reference_resp), do: reference_resp
    defp prepare_references_bulk_params(_reference_resp, user, _filename, items) do
      items
      |> Stream.with_index(1)
      |> Enum.map(fn {item, index} ->
        reference_params = prepare_reference_details_params(item, user)
        reference = Loan_applicant_reference.changeset(%Loan_applicant_reference{}, reference_params)
        Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), reference)

      end)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> execute_multi()
    end

    defp prepare_disbursement_bulk_params(reference_resp, _user, _, _) when not is_nil(reference_resp), do: reference_resp
    defp prepare_disbursement_bulk_params(_reference_resp, user, _filename, items) do
      items
      |> Stream.with_index(1)
      |> Enum.map(fn {item, index} ->
        disbursement_params = prepare_disbursement_details_params(item, user)
        disbursement = Loan_disbursement_schedule.changeset(%Loan_disbursement_schedule{}, disbursement_params)
        Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), disbursement)

      end)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> execute_multi()
    end

    defp prepare_amortization_bulk_params(amorti_resp, _user, _, _) when not is_nil(amorti_resp), do: amorti_resp
    defp prepare_amortization_bulk_params(_amorti_resp, _user, _filename, items) do
      items
      |> Stream.with_index(1)
      |> Enum.map(fn {item, _index} ->
        customer_id =  try do User.find_by(username: item.mobile_number).id rescue _-> "" end
        ref_no =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).reference_no rescue _-> "" end
        loan_id =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).id rescue _-> "" end
        calculation_date =  item.application_date
        interest_rate = try do Loanmanagementsystem.Products.Product.find_by(name: item.product_name).interest rescue _-> "" end
        anualised_rate =  to_string(interest_rate * 12)
        amortization_schedule =  generate_schedule(item.requested_amount, anualised_rate, item.loan_period, calculation_date, loan_id, customer_id, ref_no)
        amortization_schedule
        |> Enum.map(fn amortization ->
          amortization_params =
          %{
                loan_id: loan_id,
                customer_id: customer_id,
                reference_no: ref_no,
                loan_amount: amortization.loan_amount,
                interest_rate: amortization.interest_rate,
                term_in_months: amortization.term_in_months,
                month: amortization.month,
                beginning_balance: amortization.beginning_balance,
                payment: amortization.payment,
                interest: amortization.interest,
                principal: amortization.principal,
                ending_balance: amortization.ending_balance,
                date: amortization.date,
                calculation_date: amortization.calculation_date,
            }
          amortised = Loan_amortization_schedule.changeset(%Loan_amortization_schedule{}, amortization_params)
          Ecto.Multi.insert(Ecto.Multi.new(), Ecto.UUID.generate(), amortised)
        end)
        |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
        |> execute_multi_amortisation()
      end)
      |> List.flatten()
      |>Enum.uniq
      |> hd
    end

    defp prepare_logs_bulk_params(logs_resp, _user, _, _) when not is_nil(logs_resp), do: logs_resp
    defp prepare_logs_bulk_params(_logs_resp, user, _filename, items) do
      items
      |> Stream.with_index(1)
      |> Enum.map(fn {item, index} ->
        user_logs_params = prepare_user_logs_params(item, user)
        changeset_userlogs = UserLogs.changeset(%UserLogs{}, user_logs_params)
        Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_userlogs)
      end)
      |> List.flatten()
      |> Enum.reject(& !&1)
      |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
      |> execute_multi()
    end

    defp prepare_loan_params(item, _user, reference_no, customer_id) do
       product_id = try do Loanmanagementsystem.Products.Product.find_by(name: item.product_name).id rescue _-> "" end
       interest_rate = try do Loanmanagementsystem.Products.Product.find_by(name: item.product_name).interest rescue _-> "" end
       cro_id = try do UserBioData.find_by(firstName: item.loan_officer).userId rescue _-> "" end

      loan_amount = try do
      case String.contains?(String.trim(item.requested_amount), ".") do
          true ->  String.trim(item.requested_amount) |> String.to_float()
          false ->  String.trim(item.requested_amount) |> String.to_integer() end
      rescue _-> 0 end
      term_in_months = try do
      case String.contains?(String.trim(item.loan_period), ".") do
          true ->  String.trim(item.loan_period) |> String.to_float()
          false ->  String.trim(item.loan_period) |> String.to_integer() end
      rescue _-> 0 end
      IO.inspect item, label: "item -----------------------------------------"
      IO.inspect customer_id, label: "customer_id ------- #{item.mobile_number}----------------------------------"
      IO.inspect interest_rate, label: "interest_rate -----------------------------------------"
      monthly_interest_rate = interest_rate / 100.0 # Convert interest rate to monthly rate
      payment = loan_amount * (monthly_interest_rate / (1 - :math.pow(1 + monthly_interest_rate, -term_in_months)))
      monthly_inst = to_string(Float.round(payment, 2))

      %{
        customer_id: customer_id,
        reference_no: reference_no,
        product_id: product_id,
        loan_status: "DISBURSED",
        loan_type: item.product_name,
        principal_amount_proposed: item.requested_amount,
        status: "DISBURSED",
        reason: item.reject_reason,
        requested_amount: item.requested_amount,
        loan_duration_month: item.loan_period,
        monthly_installment:  monthly_inst,
        loan_purpose: item.loan_purpose,
        application_date: item.application_date,
        disbursedon_date: item.application_date,
        cro_id: cro_id,
      }
    end

    defp prepare_customer_details_params(item, _user) do
      customer_id =  try do User.find_by(username: item.mobile_number).id rescue _-> "" end
      ref_no =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).reference_no rescue _-> "" end
      customer_kyc = try do UserBioData.find_by(userId: customer_id) rescue _-> "" end
      customer_address = try do Address_Details.find_by(userId: customer_id) rescue _-> "" end
      if customer_kyc != "" || customer_address != "" do
      %{
        customer_id: customer_id,
        reference_no: ref_no,
        firstname: customer_kyc.firstName,
        surname: customer_kyc.lastName,
        othername: customer_kyc.otherName,
        id_type: customer_kyc.meansOfIdentificationType,
        id_number: customer_kyc.meansOfIdentificationNumber,
        gender: customer_kyc.gender,
        marital_status: customer_kyc.marital_status,
        cell_number: customer_kyc.mobileNumber,
        email: customer_kyc.emailAddress,
        dob: to_string(customer_kyc.dateOfBirth),
        residential_address: customer_address.house_number,
        landmark: customer_address.land_mark,
        town: customer_address.town,
        province: customer_address.province,
        crb_consent: "YES",
      }
    else
      %{
        customer_id: customer_id,
        reference_no: ref_no
      }
    end
    end

    defp prepare_nextofkin_params(item, _user) do
      customer_id =  try do User.find_by(username: item.mobile_number).id rescue _-> "" end
      ref_no =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).reference_no rescue _-> "" end
      nextofkin_params = try do Nextofkin.find_by(customer_id: customer_id) rescue _-> "" end
      if nextofkin_params != "" do
      %{
        applicant_nrc: nextofkin_params.idNumber,
        kin_ID_number: nextofkin_params.kin_ID_number,
        kin_first_name: nextofkin_params.kin_first_name,
        kin_gender: nextofkin_params.kin_gender,
        kin_last_name: nextofkin_params.kin_last_name,
        kin_mobile_number: nextofkin_params.kin_mobile_number,
        kin_other_name: nextofkin_params.kin_other_name,
        kin_personal_email: nextofkin_params.kin_personal_email,
        kin_relationship: nextofkin_params.kin_relationship,
        kin_status: "ACTIVE",
        userID: customer_id,
        reference_no: ref_no
      }
    else
      %{
        kin_status: "ACTIVE",
        userID: customer_id,
        reference_no: ref_no
      }
    end
    end

    defp prepare_reference_details_params(item, _user) do
      customer_id =  try do User.find_by(username: item.mobile_number).id rescue _-> "" end
      ref_no =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).reference_no rescue _-> "" end
      reference_details = try do Loan_applicant_reference.find_by(userId: customer_id) rescue _-> "" end
      if reference_details != "" do
      %{
        customer_id: customer_id,
        reference_no: ref_no,
        name: reference_details.name,
        contact_no: reference_details.contact_no,
      }
    else
      %{
        customer_id: customer_id,
        reference_no: ref_no
      }
    end
    end


    defp prepare_disbursement_details_params(item, _user) do
      customer_id =  try do User.find_by(username: item.mobile_number).id rescue _-> "" end
      ref_no =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).reference_no rescue _-> "" end
      loan_id =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).id rescue _-> "" end
      # customer_kyc = try do UserBioData.find_by(userId: customer_id) rescue _-> "" end
      product = try do Loanmanagementsystem.Products.Product.find_by(name: item.product_name) rescue _-> "" end
      interest_rate = try do Loanmanagementsystem.Products.Product.find_by(name: item.product_name).interest rescue _-> "" end
      # customer_address = try do Address_Details.find_by(userId: customer_id) rescue _-> "" end
      loan_amount = try do
      case String.contains?(String.trim(item.requested_amount), ".") do
          true ->  String.trim(item.requested_amount) |> String.to_float()
          false ->  String.trim(item.requested_amount) |> String.to_integer() end
      rescue _-> 0 end
      term_in_months = try do
      case String.contains?(String.trim(item.loan_period), ".") do
          true ->  String.trim(item.loan_period) |> String.to_float()
          false ->  String.trim(item.loan_period) |> String.to_integer() end
      rescue _-> 0 end
      months_interest = interest_rate
      monthly_interest_rate = interest_rate / 100.0 # Convert interest rate to monthly rate
      payment = loan_amount * (monthly_interest_rate / (1 - :math.pow(1 + monthly_interest_rate, -term_in_months)))
      monthly_inst = Float.round(payment, 2)
      processing_fee = if product.proccessing_fee == nil do 0.1 * loan_amount else product.proccessing_fee * loan_amount end
      insurance =  if product.insurance == nil do 0.03 * loan_amount else product.insurance * loan_amount end
      crb_fee = if product.crb_fee == nil do 100 else product.crb_fee end
      net_disbiursed =  loan_amount - processing_fee - insurance - crb_fee
      proces_fee = if product.proccessing_fee == nil do 0.1 else product.proccessing_fee  end
      insura_fee = if product.insurance == nil do 0.03 else product.insurance  end
      disbursed_processing_fee_percent = proces_fee * 100
      disbursed_insurance_percent = insura_fee * 100
      total_amt =  monthly_inst *  term_in_months
      total_payment = Float.round(total_amt, 2)
      disbursed_date = Date.from_iso8601!(item.application_date)
       # Disbursement Schedule
       %{
        applicant_name: item.client_name,
        applied_amount: item.requested_amount,
        approved_amount: item.requested_amount,
        processing_fee: processing_fee,
        insurance: insurance,
        interet_per_month: months_interest,
        repayment_period: item.loan_period,
        monthly_installment: monthly_inst,
        crb_amt: crb_fee,
        crb: crb_fee,
        motor_insurance: 0,
        month_installment: monthly_inst,
        net_disbiursed: net_disbiursed,
        total_payment: total_payment,
        payment_per_month: monthly_inst,
        processing_fee_percent: disbursed_processing_fee_percent,
        insurance_percent: disbursed_insurance_percent,
        customer_id: customer_id,
        reference_no: ref_no,
        date: disbursed_date,
        loan_id: loan_id,

      }
    end

    defp prepare_user_logs_params(item, user) do
      %{
        activity: "You have Successfully uploaded a loan for a customer with mobile number #{item.mobile_number}",
        user_id: user.id
      }
    end

    # ---------------------- file persistence --------------------------------------
    def is_valide_file(%{"uploafile_name" => params}) do
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

          _ ->
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

          case row_count do
            rows when rows in 1..100_000 ->
              {:ok, upload.filename, path, row_count}

            _ ->
              {:error, "File records should be between 1 to 100,000"}
          end

        {:error, reason} ->
          {:error, reason}
      end
    end

    def persist(%Plug.Upload{filename: filename, path: path}) do
      destin_path = "C:/clientonboarding/file" |> default_dir()
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
            |> Enum.reject(&Enum.all?(&1, fn item -> is_nil(item) end))
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

    # ------------------------------------ Instant Loan Automation -----------------
    def handle_legal_document_posting(params, user) do
      Ecto.Multi.new()
      |> Ecto.Multi.run(:upload_entries, fn _repo, _changes_so_far ->
        user
         |> prepare_disbursement_params(params)
         |> prepare_amortization_params(user, params)
         |> prepare_logs_params(user, params)
         |> case do
            nil ->
              {:ok, "UPLOAD COMPLETE"}
            error ->
              error
          end
      end)
      |> Repo.transaction()
  end

  defp prepare_disbursement_params(user, params) do
      disbursement_params = handle_disbursement_details_params(params, user)
      disbursement = Loan_disbursement_schedule.changeset(%Loan_disbursement_schedule{}, disbursement_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Ecto.UUID.generate(), disbursement)
      |> execute_multi()
  end

    defp handle_disbursement_details_params(params, _user) do
      customer_id = try do UserBioData.find_by(mobileNumber: params["cell_number"]).userId  rescue _-> "" end
      ref_no =  try do Loans.find_by(customer_id: customer_id, requested_amount: params["requested_amount"]).reference_no rescue _-> "" end
      loan_id =  try do Loans.find_by(customer_id: customer_id, requested_amount: params["requested_amount"]).id rescue _-> "" end
      customer_kyc = try do UserBioData.find_by(userId: customer_id) rescue _-> "" end
      product = try do Loanmanagementsystem.Products.Product.find_by(productType: params["loan_type"]) rescue _-> "" end
      interest_rate = try do Loanmanagementsystem.Products.Product.find_by(productType: params["loan_type"]).interest rescue _-> "" end
      customer_address = try do Address_Details.find_by(userId: customer_id) rescue _-> "" end
      loan_amount = try do
      case String.contains?(String.trim(params["requested_amount"]), ".") do
          true ->  String.trim(params["requested_amount"]) |> String.to_float()
          false ->  String.trim(params["requested_amount"]) |> String.to_integer() end
      rescue _-> 0 end
      term_in_months = try do
      case String.contains?(String.trim(params["loan_duration_month"]), ".") do
          true ->  String.trim(params["loan_duration_month"]) |> String.to_float()
          false ->  String.trim(params["loan_duration_month"]) |> String.to_integer() end
      rescue _-> 0 end
      months_interest = interest_rate / 12
      monthly_interest_rate = interest_rate / 100.0 # Convert interest rate to monthly rate
      payment = loan_amount * (monthly_interest_rate / (1 - :math.pow(1 + monthly_interest_rate, -term_in_months)))
      monthly_inst = Float.round(payment, 2)
      processing_fee = if product.proccessing_fee == nil do 0.1 * loan_amount else product.proccessing_fee * loan_amount end
      insurance =  if product.insurance == nil do 0.03 * loan_amount else product.insurance * loan_amount end
      crb_fee = if product.crb_fee == nil do 100 else product.crb_fee end
      net_disbiursed =  loan_amount - processing_fee - insurance - crb_fee
      proces_fee = if product.proccessing_fee == nil do 0.1 else product.proccessing_fee  end
      insura_fee = if product.insurance == nil do 0.03 else product.insurance  end
      disbursed_processing_fee_percent = proces_fee * 100
      disbursed_insurance_percent = insura_fee * 100
      total_amt =  monthly_inst *  term_in_months
      total_payment = Float.round(total_amt, 2)
      disbursed_date = Timex.today()
       # Disbursement Schedule
       %{
        applicant_name: "#{customer_kyc.firstName} #{customer_kyc.otherName} #{customer_kyc.lastName}",
        applied_amount: params["requested_amount"],
        approved_amount: params["requested_amount"],
        processing_fee: processing_fee,
        insurance: insurance,
        interet_per_month: months_interest,
        repayment_period: to_string(term_in_months),
        monthly_installment: monthly_inst,
        crb_amt: crb_fee,
        crb: crb_fee,
        motor_insurance: 0,
        month_installment: monthly_inst,
        net_disbiursed: net_disbiursed,
        customer_address: "house # #{customer_address.house_number}, town - #{customer_address.town}, province - #{customer_address.province}",
        customer_nrc: customer_kyc.meansOfIdentificationNumber,
        first_payment_month: "",
        total_payment: total_payment,
        payment_per_month: monthly_inst,
        processing_fee_percent: disbursed_processing_fee_percent,
        insurance_percent: disbursed_insurance_percent,
        customer_id: customer_id,
        reference_no: ref_no,
        date: disbursed_date,
        loan_id: loan_id,

      }
    end

    defp prepare_amortization_params(amorti_resp, _user, _) when not is_nil(amorti_resp), do: amorti_resp
    defp prepare_amortization_params(_amorti_resp, _user, params) do
        customer_id = try do UserBioData.find_by(mobileNumber: params["cell_number"]).userId  rescue _-> "" end
        ref_no =  try do Loans.find_by(customer_id: customer_id, requested_amount: params["requested_amount"]).reference_no rescue _-> "" end
        loan_id =  try do Loans.find_by(customer_id: customer_id, requested_amount: params["requested_amount"]).id rescue _-> "" end
        calculation_date =  to_string(Timex.today)
        interest_rate = try do Loanmanagementsystem.Products.Product.find_by(productType: params["loan_type"]).interest rescue _-> "" end
        anualised_rate =  to_string(interest_rate * 12)
        amortization_schedule =  generate_schedule(params["requested_amount"], anualised_rate, params["loan_duration_month"], calculation_date, loan_id, customer_id, ref_no)
        amortization_schedule
        |> Enum.map(fn amortization ->
          amortization_params =
          %{
                loan_id: loan_id,
                customer_id: customer_id,
                reference_no: ref_no,
                loan_amount: amortization.loan_amount,
                interest_rate: amortization.interest_rate,
                term_in_months: amortization.term_in_months,
                month: amortization.month,
                beginning_balance: amortization.beginning_balance,
                payment: amortization.payment,
                interest: amortization.interest,
                principal: amortization.principal,
                ending_balance: amortization.ending_balance,
                date: amortization.date,
                calculation_date: amortization.calculation_date,
            }
          amortised = Loan_amortization_schedule.changeset(%Loan_amortization_schedule{}, amortization_params)
          Ecto.Multi.insert(Ecto.Multi.new(), Ecto.UUID.generate(), amortised)

        end)
        |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
        |> execute_multi_amortisation()
    end


    defp prepare_logs_params(logs_resp, _user, _) when not is_nil(logs_resp), do: logs_resp
    defp prepare_logs_params(_logs_resp, user, params) do
        user_logs_params = handle_user_logs_params(params, user)
        changeset_userlogs = UserLogs.changeset(%UserLogs{}, user_logs_params)
        Ecto.Multi.insert(Ecto.Multi.new(), Ecto.UUID.generate(), changeset_userlogs)
      |> execute_multi()
    end

    defp handle_user_logs_params(params, user) do
      %{
        activity: "Instant Loan Amortization and Disbursement Automation was successfully for a customer with  mobile Number #{params["cell_number"]}",
        user_id: user
      }
    end


    def mark_has_repaid_loan(conn, params) do
      if params["payoff_amount"] != "" do
      payoff_amount = Decimal.round(Decimal.new(params["payoff_amount"]))
      total_repaid = Decimal.round(Decimal.new(params["total_repaid"]))
      if total_repaid >= payoff_amount do
      loan_details = Loanmanagementsystem.Loan.Loans.find_by(id:  params["id"])
      user_details = Loanmanagementsystem.Accounts.UserBioData.find_by(userId: loan_details.customer_id)
      new_params = %{
        "loan_status" => "REPAID"
      }
      Ecto.Multi.new()
      |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, new_params))
      |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_details: _loan_details} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "You have Successfully Marked this loan has Repaid for customer: #{user_details.firstName} #{user_details.lastName} and Loan Number: #{loan_details.id} ",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, _} ->
          conn
          |> put_flash(:info, "You have Marked this loan has repaid")
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors)

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      conn
      |> put_flash(:error, "The loan has not been paid in full, Try again later.")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end

  else
    conn
    |> put_flash(:error, "The loan has not been paid in full, Try again later.")
    |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end


    end


    # def compount_interest(principal, interest_rate, time, compounding_frequency) do
    #   interest_rate_decimal = interest_rate / 100 / 12
    #   compounded_periods = compounding_frequency * time
    #   amount = principal * :math.pow(1 + interest_rate_decimal / compounding_frequency, compounded_periods)
    #   IO.puts("The future value of the investment is #{amount}")
    # end







end
