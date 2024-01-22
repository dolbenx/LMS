defmodule LoanmanagementsystemWeb.LoanController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Loan.Loans
  # alias Loanmanagementsystem.Loan
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.UserRole
  # alias Loanmanagementsystem.Products.Product_rates
  alias Loanmanagementsystem.Loan.LoanTransaction
  alias Loanmanagementsystem.Notifications.Sms

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

  def quick_advanced_loan_capturing(conn, params),
    do:
      render(conn, "quick_advanced_loan_capturing.html",
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details:
          Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        frequencies:
          Loanmanagementsystem.Products.Product_rates.find_by(product_id: params["product_id"]).repayment
      )

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
    results = Loanmanagementsystem.Loan.quick_advance_loan_list(search_params, start, length)
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

  def create_quick_advance_loan_application(conn, params) do
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

      |> Ecto.Multi.run(:quick_advance_document, fn _repo, %{add_loan: _add_loan } ->
        Loanmanagementsystem.Services.QuickLoanUploads.quick_loan_upload(%{

          "process_documents" => params,
          "conn" => conn

        })
      end)

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
          |> redirect(to: Routes.loan_path(conn, :quick_advance_application_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :quick_advance_application_datatable))
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
      |> Ecto.Multi.run(:add_user_bio_data, fn _repo, %{add_user: add_user, add_user_role: _add_user_role} ->
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
      |> Ecto.Multi.run(:user_logs, fn _repo, %{add_user: _add_user, add_user_role: _add_user_role, add_user_bio_data: _add_user_bio_data} ->
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
          |> redirect(to: Routes.loan_path(conn, :quick_advance_application_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :quick_advance_application_datatable))
      end
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
                                              %{add_user: add_user, add_user_role: _add_user_role} ->
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
    product_details = Loanmanagementsystem.Products.list_tbl_products() |> Enum.reject(&(&1.productType != "Quick Advance"))
    render(conn, "select_quick_advance.html", product_details: product_details)
  end

  def get_otp(conn, %{"product_id" => product_id}) do
    render(conn, "get_otp.html", product_id: product_id)
  end

  def otp_validation(conn, %{"client_line" => client_line, "product_id" => product_id}) do
    render(conn, "otp_validation.html", client_line: client_line, product_id: product_id)
  end

  def send_otp(conn, params) do
    IO.inspect(params, label: "Hello SADC")

    product_id = params["product_id"]
    client_line = params["client_line"]
    generate_otp = to_string(Enum.random(1111..9999))

    text = "To verify your loan initiation, please provide the OTP - #{generate_otp}"

    params = Map.put(params, "mobile", client_line)
    params = Map.put(params, "msg", text)
    params = Map.put(params, "status", "READY")
    params = Map.put(params, "type", "SMS")
    params = Map.put(params, "msg_count", "1")

    if Loanmanagementsystem.Accounts.UserBioData.exists?(mobileNumber: "#{client_line}") == true do

    client_role = Loanmanagementsystem.Accounts.get_client_by_line(client_line)

     my_client_role = Loanmanagementsystem.Accounts.get_user_role!(client_role.role_id)

     Loanmanagementsystem.Accounts.update_user_role(my_client_role, %{otp: generate_otp})



      Ecto.Multi.new()
      |> Ecto.Multi.insert(:loan_otp, Sms.changeset(%Sms{}, params))
      |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_otp: _loan_otp} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Add send loan OTP Successfully",
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
          |> redirect(to: Routes.loan_path(conn, :otp_validation, client_line: "#{client_line}", product_id: "#{product_id}"))

        {:error, _failed_operation, _failed_value, _changes_so_far} ->

      end

        else
          conn
          |> put_flash(:error, "The number you entered is not registered: Check the number and try again.")
          |> redirect(to: Routes.loan_path(conn, :get_otp, product_id: "#{product_id}"))

    end


  end

  def validate_otp(conn, params) do

    client_line = params["client_line"]
    product_id = params["product_id"]

    # generate_otp = to_string(Enum.random(1111..9999))

    otp1 = params["otp1"]
    otp2 = params["otp2"]
    otp3 = params["otp3"]
    otp4 = params["otp4"]
    user_otp = "#{otp1}#{otp2}#{otp3}#{otp4}"

    client_role = Loanmanagementsystem.Accounts.get_client_by_line(client_line)

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
              |> redirect(to: Routes.loan_path(conn, :quick_advanced_loan_capturing, client_line: "#{client_line}", product_id: "#{product_id}"))

            {:error, _failed_operation, failed_value, _changes_so_far} ->
              reason = traverse_errors(failed_value.errors) |> List.first()

              conn
              |> put_flash(:error, reason)
              |> redirect(to: Routes.loan_path(conn, :otp_validation))
          end
    else

    conn
      |> put_flash(:error, "OTP does not match")
      |> redirect(to: Routes.loan_path(conn, :otp_validation, client_line: "#{client_line}", product_id: "#{product_id}"))


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
                                              %{add_user: add_user, add_user_role: _add_user_role} ->
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
                                              %{add_user: add_user, add_user_role: _add_user_role} ->
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
                                              %{add_user: add_user, add_user_role: _add_user_role} ->
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
                                              %{add_user: add_user, add_user_role: _add_user_role} ->
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
                                              %{add_user: add_user, add_user_role: _add_user_role} ->
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
    loan_details = Loanmanagementsystem.Loan.get_loan_by_id!(params["id"])

    new_params =
      Map.merge(params, %{
        "loan_status" => "REJECTED",
        "status" => "REJECTED"
      })

    Ecto.Multi.new()
    |> Ecto.Multi.update(:loan_details, Loans.changeset(loan_details, new_params))
    |> Ecto.Multi.run(:user_logs, fn _, %{loan_details: loan_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Rejected loan with S/N: #{loan_details.id}Successfully ",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{loan_details: loan_details}} ->
        json(conn, %{data: "Rejected loan with S/N #{loan_details.id} successfully"})

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        json(conn, %{error: reason})
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
    user_id = conn.assigns.user.id
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

  def get_all_complete_loan_statement(search_params, page, size) do
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
    termss = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
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

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
