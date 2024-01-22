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
  alias Loanmanagementsystem.Loan.Loan_invoice
  # alias Loanmanagementsystem.Emails.Email
  alias Loanmanagementsystem.Loan.Loan_recommendation_and_assessment
  alias Loanmanagementsystem.Emails.Email
  alias Loanmanagementsystem.Loan.Loan_amortization_schedule
  alias Loanmanagementsystem.Loan.LoanRepayment
  alias Loanmanagementsystem.Accounts.Role
  alias Loanmanagementsystem.Loan.Order_finance_loan_invoice
  alias Loanmanagementsystem.Transactions.Loan_transactions
  # alias Loanmanagementsystem.Loan.Loan_application_documents
  # LoanmanagementsystemWeb.LoanController.generate_schedule("50000", "9", "90", Timex.today) do

    # LoanmanagementsystemWeb.LoanController.generate_reference_no(14)

  plug LoanmanagementsystemWeb.Plugs.Authenticate,
          [module_callback: &LoanmanagementsystemWeb.LoanController.authorize_role/1]
          when action not in [
            :admin_disbursed_loan,
            :admin_write_off_loan,
            :approve_loan,
            :approve_credit_invoice_discounting,
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
            :loan_bulkupload,
            :corperate_loan_bulkupload,
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
            :send_company_otp,
            :company_otp_validation,
            :validate_company_otp,
            :invoice_discounting_approval,
            :view_invoice_discounting,
            :display_pdf,
            :approve_credit_invoice_discounting_application,
            :account_invoice_discounting_view,
            :approve_accounts_invoice_discounting,
            :admin_order_finance_application,
            :approve_operations_invoice_discounting_application,
            :admin_approve_credit_analyst_ordering_finance_miz,
            :admin_credit_analyst_approval_with_documents,
            :admin_approve_operations_ordering_finance,
            :admin_approve_operations_sme_loan,
            :admin_operations_and_credit_manager_approval_with_documents,
            :mgt_view_invoice_discounting,
            :mgt_approve_invoice_discounting_application,
            :approve_employee_consumer_loan_by_credit_analyst,
            :approve_employee_consumer_loan_by_accountant,
            :approve_employee_consumer_loan_by_operation_officer,
            :approve_employee_consumer_loan_by_management,
            :admin_mgt_ordering_financing_loan_approval_miz,
            :admin_management_approval_without_documents,
            :admin_management_approval_without_documents_sme,
            :admin_loan_officer_approval_with_documents,
            :admin_approve_loan_officer_ordering_finance_miz,
            :admin_assessment_credit_analyst_ordering_finance_miz,
            :admin_credit_analyst_assesment_with_document_upload_miz,
            :admin_mgt_ordering_financing_loan_reject_miz,
            :admin_management_reject_without_documents,
            :admin_loan_officer_ordering_financing_loan_reject_miz,
            :admin_loan_officer_reject_without_documents,
            :admin_approve_accountant_ordering_finance_miz,
            :admin_accountant_assesment_with_document_upload_miz,
            :sme_loan_item_lookup,
            :sme_loan_application_datatable,
            :admin_sme_loan_application_by_loan_officer,
            :admin_approve_accountant_sme_loan_miz,
            :admin_accountant_assesment_with_document_upload_miz_sme_loan,
            :sme_loan_assement_by_credit_analyst,
            :admin_credit_analyst_sme_loan_review_with_documents,
            :admin_management_review_approve_sme_loan,
            :admin_operations_and_credit_manager_approval_without_documents_sme_loan,
            :admin_mgt_review_sme_loan_approval,
            :admin_management_reject_without_documents_sme_loan,
            :admin_approve_accountant_invoice_discounting,
            :admin_accountant_assesment_for_invoice_discounting,
            :consumer_loan_item_lookup,
            :consumer_loans_datatable,
            :view_for_all_documents_for_loans,
            :admin_order_finance_view,
            :admin_sme_loan_view,
            :resend_otp,
            :resend_company_otp,
            :go_to_repayment_page,
            :credit_analyst_go_to_repayment_page,
            :all_product_loan_repayment,
            :credit_analyst_update_all_product_loan_repayment,
            :mgt_go_to_repayment_page,
            :view_loan_invoice_discounting,
            :consumer_upload_guarantor_facility_form_loan_by_credit_analyst,
            :consumer_from_mgt_to_credit_analyst,
            :admin_review_credit_analyst_ordering_finance_miz,
            :admin_review_credit_analyst_ordering_finance_upload_miz,
            :admin_credit_analyst_review_sme_loan_approval,
            :admin_review_credit_analyst_sme_loan_upload_miz,
            :view_for_collateral_documents_for_loans

    ]

  use PipeTo.Override


  ################################################################################### INVOICE DISCOUNTING #######################################################################################
    def invoice_discounting_application_datatable(conn, _params) do
      render(conn, "invoice_discounting_application.html")
    end


    def go_to_repayment_page(conn, params) do
      loan = Loans.find_by(reference_no: params["reference_no"])
      if loan != nil do
            filtered_loan = [loan] |> Enum.reject(&(&1.repayment_type == "FULL REPAYMENT"))


                if filtered_loan == [] do
                  conn
                    |> put_flash(:error, "No pending repayment loan was found with that Reference Number")
                    |> redirect(to: Routes.credit_management_path(conn, :admin_repayments))

                else
                  loan_details = Loanmanagementsystem.Operations.get_a_loan_by_reference_no(params["reference_no"]) |> IO.inspect(label: "xxxxxxxxxxxxxxxxxxxxxxx")
                  company_details = Loanmanagementsystem.Operations.get_company_details_by_reference_no(params["reference_no"]) |> IO.inspect(label: "xxxxxxxxxxxxxxxxxxxxxxx")
                  individual_details = Loanmanagementsystem.Operations.get_client_company_detials(params["reference_no"]) |> IO.inspect(label: "xxxxxxxxxxxxxxxxxxxxxxx")
                  render(conn, "go_to_repayment_page.html", loan_details: loan_details, company_details: company_details, individual_details: individual_details)
                end
      else
            conn
            |> put_flash(:error, "No pending repayment loan was found with that Reference Number")
            |> redirect(to: Routes.credit_management_path(conn, :admin_repayments))
      end
    end

    def all_product_loan_repayment(conn, params) do
        IO.inspect("@@@@@@@@@@@@@@@@@@@@ check payment @@@@@@@@@@@@@@@@@@@@@@@@@")
        calculated_balance_1 = params["balance"]

        calculated_balance = try do
          cleaned_balance =
            calculated_balance_1
            |> String.trim()
            |> String.replace(",", "")
            |> String.replace(".", ".")

          case String.contains?(cleaned_balance, ".") do
            true -> String.to_float(cleaned_balance)
            false -> String.to_integer(cleaned_balance)
          end
        rescue
          _ -> 0
        end

        repayment_amount_1 = params["repayment_amount"]
        repayment_amount = try do
          case String.contains?(String.trim(repayment_amount_1), ".") do
            true ->  String.trim(repayment_amount_1) |> String.to_float()
            false ->  String.trim(repayment_amount_1) |> String.to_integer() end
        rescue _-> 0 end

        # loan_repay_type = Loans.find_by(reference_no: params["reference_no"]).repayment_type
        loan_repay_type =  params["repayment_status"]

        if loan_repay_type == "PARTIAL REPAYMENT" or  repayment_amount <= calculated_balance do
          LoanmanagementsystemWeb.LoanController.with_patial_all_product_loan_repayment(conn, params)
          else

          params = Map.merge(params, %{"for_repayment" => true})
          #  Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["A-2023125.338.112.1457.1701788579"]).total_repaid
          total_repaid = if is_nil(Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"]).total_repaid) do 0 else Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"]).total_repaid end

          loan_by_refe = Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"])

          repayment_amount_1 = params["repayment_amount"]
          repayment_amount = try do
            case String.contains?(String.trim(repayment_amount_1), ".") do
              true ->  String.trim(repayment_amount_1) |> String.to_float()
              false ->  String.trim(repayment_amount_1) |> String.to_integer() end
          rescue _-> 0 end

          calculated_balance_1 = params["balance"]

          calculated_balance = try do
            cleaned_balance =
              calculated_balance_1
              |> String.trim()
              |> String.replace(",", "")
              |> String.replace(".", ".")

            case String.contains?(cleaned_balance, ".") do
              true -> String.to_float(cleaned_balance)
              false -> String.to_integer(cleaned_balance)
            end
          rescue
            _ -> 0
          end


          # balance = Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"]).balance
          # interest_amount = Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"]).interest_amount
          final_total_repaid = if is_nil(total_repaid) do repayment_amount + 0 else repayment_amount + total_repaid end

          IO.inspect(final_total_repaid, label: "----------------------------------------")

          new_balance = (calculated_balance - final_total_repaid)


          IO.inspect(new_balance, label: "wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww")

          Ecto.Multi.new()
          |> Ecto.Multi.insert(:repayment, LoanRepayment.changeset(%LoanRepayment{}, %{
            amountRepaid: calculated_balance,
            dateOfRepayment: "#{Date.utc_today}",
            modeOfRepayment: params["repayment_method"],
            recipientUserRoleId: conn.assigns.user.role_id,

            registeredByUserId: conn.assigns.user.id,
            repayment: params["repayment_status"],
            company_id: params["company_id"],
            loan_product: params["loan_type"],
            repayment_type: params["repayment_status"],
            repayment_method: params["repayment_method"],
            bank_name: params["bank_name"],
            expiry_date: params["expiry_date"],
            cvc: params["cvc"],
            bank_account_no: params["bank_account_number"],
            account_name: params["accountName"],
            mno_mobile_no: params["mobile_number"],
            reference_no: params["reference_no"],
            status: params["repayment_status"],
            loan_id: params["loan_id"],
          }))
          |> Ecto.Multi.run(:loan_update, fn _repo, %{repayment: _repayment}->
            loan_params = %{
              total_repaid: final_total_repaid,
              principal_repaid_derived: final_total_repaid,
              number_of_repayments: Integer.floor_div(loan_by_refe.tenor, 30),
              total_expected_repayment_derived: loan_by_refe.repayment_amount,
              total_repayment_derived: final_total_repaid,
              bank_name: params["bank_name"],
              bank_account_no: params["bank_account_number"],
              account_name: params["accountName"],
              receipient_number: params["mobile_number"],
              reference_no: params["reference_no"],
              repayment_type: params["repayment_status"],
              repayment_amount: loan_by_refe.repayment_amount,
              cvv: params["cvc"],
              repayment_frequency: "Month",
              proposed_repayment_date: Date.utc_today,
              loan_status: "PENDING_CREDIT_ANALYST_REPAYMENT",
              status: "DISBURSED",
              balance: new_balance,
              calculated_balance: new_balance
            }

            IO.inspect(loan_params, label: "TTTTTTTT")
            case Repo.update(Loans.changeset(loan_by_refe,loan_params)) do
              {:ok, message}-> {:ok, message}
              {:error, reason}-> {:error, reason}
            end

          end)

          |> Ecto.Multi.run(:user_logs, fn _repo , %{repayment: _repayment, loan_transactions: _loan_transactions}->
            IO.inspect("TTTTTTTT")
            user_logs = %{
              activity: "Accountant has Repaid the loan Successfully",
              user_id: conn.assigns.user.id
            }
            case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
              {:ok, message} -> {:ok, message}
              {:error, reason}-> {:error, reason}
            end
          end)

          |> Ecto.Multi.run(:loan_txn, fn _repo , %{repayment: _repayment, user_logs: _user_logs}->
            loan_txn_params = %{
              loan_id: params["loan_id"],
              customer_id: params["customer_id"],
              principal_amount: loan_by_refe.principal_amount,
              repayment_type: params["repayment_status"],
              days_accrued: loan_by_refe.accrued_no_days,
              total_interest_accrued: loan_by_refe.daily_accrued_interest,
              total_finance_cost_accrued: loan_by_refe.daily_accrued_finance_cost,
              product_id: loan_by_refe.product_id,
              txn_amount: repayment_amount,
              repaid_amount: repayment_amount,
              transaction_date: Timex.today(),
              momo_mobile_no: params["mobile_number"],
              created_by_id: conn.assigns.user.id,
              outstanding_balance: new_balance,
              is_repayment: true

            }
            case Repo.insert(Loan_transactions.changeset(%Loan_transactions{}, loan_txn_params)) do
              {:ok, message} -> {:ok, message}
              {:error, reason}-> {:error, reason}
            end
          end)

          |> Ecto.Multi.run(:document, fn _repo, %{repayment: _repayment, user_logs: _user_logs, loan_txn: _loan_txn} ->
            Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: params["loan_id"]}, params)
          end)
          |>Repo.transaction()
          |>case do
            {:ok, _ } ->
              conn
              |> put_flash(:info, "You have Successfully Repaid a Loan")
              |> redirect(to: Routes.credit_management_path(conn, :admin_repayments))
            {:error, _failed_operations, failed_value,  _changes_so_far} ->
              reason = traverse_errors(failed_value.errors) |> List.first()
              conn
              |>put_flash(:error, reason)
              |>redirect(to: Routes.credit_management_path(conn, :admin_repayments))
          end
      end
    end

    def with_patial_all_product_loan_repayment(conn, params) do

      params = Map.merge(params, %{"for_repayment" => true})

      total_repaid = if is_nil(Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"]).total_repaid) do 0 else Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"]).total_repaid end

      loan_by_refe = Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"])

      repayment_amount_1 = params["repayment_amount"]
      repayment_amount = try do
        case String.contains?(String.trim(repayment_amount_1), ".") do
          true ->  String.trim(repayment_amount_1) |> String.to_float()
          false ->  String.trim(repayment_amount_1) |> String.to_integer() end
      rescue _-> 0 end

      calculated_balance_1 = params["balance"]

      calculated_balance = try do
        cleaned_balance =
          calculated_balance_1
          |> String.trim()
          |> String.replace(",", "")
          |> String.replace(".", ".")

        case String.contains?(cleaned_balance, ".") do
          true -> String.to_float(cleaned_balance)
          false -> String.to_integer(cleaned_balance)
        end
      rescue
        _ -> 0
      end


      # balance = Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"]).balance
      # interest_amount = Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"]).interest_amount
      final_total_repaid = if is_nil(total_repaid) do repayment_amount + 0 else repayment_amount + total_repaid end

      new_balance = (calculated_balance - repayment_amount)

      Ecto.Multi.new()
      |> Ecto.Multi.insert(:repayment, LoanRepayment.changeset(%LoanRepayment{}, %{
        amountRepaid: calculated_balance,
        dateOfRepayment: "#{Date.utc_today}",
        modeOfRepayment: params["repayment_method"],
        recipientUserRoleId: conn.assigns.user.role_id,

        registeredByUserId: conn.assigns.user.id,
        repayment: params["repayment_status"],
        company_id: params["company_id"],
        loan_product: params["loan_type"],
        repayment_type: params["repayment_status"],
        repayment_method: params["repayment_method"],
        bank_name: params["bank_name"],
        expiry_date: params["expiry_date"],
        cvc: params["cvc"],
        bank_account_no: params["bank_account_number"],
        account_name: params["accountName"],
        mno_mobile_no: params["mobile_number"],
        reference_no: params["reference_no"],
        status: params["repayment_status"],
        loan_id: params["loan_id"],

      }))

      |> Ecto.Multi.run(:loan_update, fn _repo, %{}->
        loan_params = %{
          principal_repaid_derived: final_total_repaid,
          number_of_repayments: Integer.floor_div(loan_by_refe.tenor, 30),
          total_expected_repayment_derived: loan_by_refe.repayment_amount,
          # interest_repaid_derived: params[""],
          # penalty_charges_repaid_derived: params[""],
          total_repayment_derived: final_total_repaid,
          # total_principal_repaid: params[""],
          # total_interest_repaid: params[""],
          # total_charges_repaid: params[""],
          # total_penalties_repaid: params[""],
          total_repaid: final_total_repaid,
          bank_name: params["bank_name"],
          bank_account_no: params["bank_account_number"],
          account_name: params["accountName"],
          receipient_number: params["mobile_number"],
          reference_no: params["reference_no"],
          repayment_type: params["repayment_status"],
          repayment_amount: loan_by_refe.repayment_amount,
          cvv: params["cvc"],
          repayment_frequency: "Month",
          proposed_repayment_date: Date.utc_today,
          loan_status: "PENDING_CREDIT_ANALYST_REPAYMENT",
          status: "DISBURSED",
          balance: new_balance,
          calculated_balance: new_balance

        }

        case Repo.update(Loans.changeset(loan_by_refe,loan_params)) do
          {:ok, message}-> {:ok, message}
          {:error, reason}-> {:error, reason}
        end

      end)

      |>Ecto.Multi.run(:user_logs, fn _repo , %{repayment: _repayment}->
        user_logs = %{
          activity: "Accountant has Repaid the loan Successfully",
          user_id: conn.assigns.user.id
        }
        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)

      |> Ecto.Multi.run(:loan_txn, fn _repo , %{repayment: _repayment, user_logs: _user_logs}->
        loan_txn_params = %{
          loan_id: params["loan_id"],
          customer_id: params["customer_id"],
          principal_amount: loan_by_refe.principal_amount,
          repayment_type: params["repayment_status"],
          days_accrued: loan_by_refe.accrued_no_days,
          total_interest_accrued: loan_by_refe.daily_accrued_interest,
          total_finance_cost_accrued: loan_by_refe.daily_accrued_finance_cost,
          product_id: loan_by_refe.product_id,
          txn_amount: repayment_amount,
          repaid_amount: repayment_amount,
          transaction_date: Timex.today(),
          momo_mobile_no: params["mobile_number"],
          created_by_id: conn.assigns.user.id,
          outstanding_balance: new_balance,
          is_repayment: true


        }
        case Repo.insert(Loan_transactions.changeset(%Loan_transactions{}, loan_txn_params)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)

      |> Ecto.Multi.run(:document, fn _repo, %{repayment: _repayment, user_logs: _user_logs} ->
        Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: params["loan_id"]}, params)
      end)
      |>Repo.transaction()
      |>case do
        {:ok, _ } ->
          conn
          |>put_flash(:info, "You have Successfully Repaid a Loan")
          |>redirect(to: Routes.credit_management_path(conn, :admin_repayments))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.credit_management_path(conn, :admin_repayments))
      end
    end

    def view_for_all_documents_for_loans(conn, params) do
      documents = Loanmanagementsystem.Operations.get_loan_client_docs(params["userId"], params["loan_id"])
      render(conn, "view_for_all_documents_for_loans.html", documents: documents)
    end

    def admin_order_finance_view(conn, %{"loan_id" => loan_id}) do

      loanDocs = Loanmanagementsystem.Operations.get_docs_order_finance(loan_id)
      loan_details = Loanmanagementsystem.Operations.ordering_finance_details(loan_id)
      offtaker = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)

      render(conn, "admin_order_finance_view.html", loan_details: loan_details, loanDocs: loanDocs, offtaker: offtaker)
    end


    def admin_sme_loan_view(conn, %{"loan_id" => loan_id}) do

      loanDocs = Loanmanagementsystem.Operations.get_docs_order_finance(loan_id)
      loan_details = Loanmanagementsystem.Operations.ordering_finance_details(loan_id)
      offtaker = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)

      render(conn, "admin_sme_loan_view.html", loan_details: loan_details, loanDocs: loanDocs, offtaker: offtaker)
    end

    def create_invoice_discounting_application(conn, params) do
      product_details = Loanmanagementsystem.Products.Product.find_by(id: params["product_id"])
      if params["has_mou"] == "NO" do

        LoanmanagementsystemWeb.LoanController.push_no_mou_create_invoice_discounting_application(conn, params)

        else

        role_id = try do Role.find_by(role_group: "Credit Analyst").id rescue _-> "" end

        user_details = try do User.where(role_id: role_id)  rescue _-> "" end

        invoice_percentage = String.to_integer(params["invoice_percentage"])

        calculated_invoice_percentage = invoice_percentage / 100

        invoice_value = params["invoiceValue"]

        invoice_value_to_convert = try do
          case String.contains?(String.trim(invoice_value), ".") do
            true ->  String.trim(invoice_value) |> String.to_float()
            false ->  String.trim(invoice_value) |> String.to_integer() end
          rescue _-> 0 end

        calculated_invoiceValue = invoice_value_to_convert * calculated_invoice_percentage

        requested_amount = params["requested_amount"]

        requested_amount_to_convert = try do
          case String.contains?(String.trim(requested_amount), ".") do
            true ->  String.trim(requested_amount) |> String.to_float()
            false ->  String.trim(requested_amount) |> String.to_integer() end
          rescue _-> 0 end


        if calculated_invoiceValue >= requested_amount_to_convert do

          # tenor_log_2 = params["repayment"]
          # loan_calculations = calculate_interest_and_repaymnent_amt(params)


          # loan_calculations = calculate_interest_and_repaymnent_amt(params)

          # otp = to_string(Enum.random(1111..9999))

          # get_funder_id = Loanmanagementsystem.Loan.get_loan_funder_details(params["loan_funder"])

          # get_loan_funder = Loanmanagementsystem.Loan.get_loan_funder!(get_funder_id.id)


          # total_funder_balance = get_loan_funder.totalAmountFunded - (Decimal.new(params["amount"]) |> Decimal.to_integer)

          # reference_no = generate_momo_random_string(10)


            if params["customer_id"] != "" || params["customer_id"] != nil do

              offtaker = String.split(params["offtakerID"], "|||")

              # company_id = try do Loanmanagementsystem.Accounts.User.find_by(company_id: params["customer_id"]).id rescue _-> nil end

              # email_address = try do Loanmanagementsystem.Companies.Company.find_by(id: Enum.at(offtaker, 0)).contactEmail rescue _-> nil end

              contact_number = try do Loanmanagementsystem.Companies.Company.find_by(id: Enum.at(offtaker, 0)).companyPhone rescue _-> nil end

              get_bio_id = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).user_bio_id rescue _-> nil end

              get_bio_data = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: get_bio_id) rescue _-> nil end

              company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

              company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

              company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end



                new_params =
                  Map.merge(params, %{
                    "principal_amount_proposed" => params["requested_amount"],
                    "loan_status" => "PENDING_CREDIT_ANALYST",
                    "status" => "PENDING_CREDIT_ANALYST",
                    "currency_code" => "ZMW",
                    "loan_type" => "INVOICE DISCOUNTING",
                    "loan_limit" => calculated_invoiceValue,
                    "tenor" => params["tenor_log"],
                    "number_of_repayments" => params["repayment"],
                    "principal_amount" => params["requested_amount"],
                    "has_mou" => params["has_mou"],
                    "customer_id" => params["customer_id"],
                    "company_id" => params["company_id"],
                    # "repayment_amount" => loan_calculations.repayement_amt,
                    # "interest_amount" => loan_calculations.interest_amt,
                    # "balance" => loan_calculations.repayement_amt,
                    "repayment_amount" => params["totalPayment"],
                    "application_date" => Date.utc_today(),
                    "interest_amount" => params["total_interest"],
                    "balance" => 0.0,
                    "funderID" => params["loan_funder"],
                    "loan_duration_month" => params["repayment"],
                    "reference_no" => generate_reference_no(params["customer_id"]),
                    "offtakerID" => Enum.at(offtaker, 0),
                    "loan_officer_id" => conn.assigns.user.id,
                    "init_interest_per" => product_details.interest,
                    "init_arrangement_fee_per" => product_details.arrangement_fee,
                    "init_finance_cost_per" => product_details.finance_cost,


                  })

                  link = "http://89.58.48.159:5050/"

                  text = "You have recieved a pending loan that needs to be approved for it to proceed to the next step. Please log in to the system and aprove the loan. To Login use the link #{link}"

                  params = Map.put(params, "mobile", contact_number)
                  params = Map.put(params, "msg", text)
                  params = Map.put(params, "status", "READY")
                  params = Map.put(params, "type", "SMS")
                  params = Map.put(params, "msg_count", "1")

                Ecto.Multi.new()
                |> Ecto.Multi.insert(:add_loan, Loans.changeset(%Loans{}, new_params))
                # |> Ecto.Multi.insert(:invoice_loan, Sms.changeset(%Sms{}, params))
                |> Ecto.Multi.run(:loan_txn, fn _repo , %{add_loan: add_loan}->
                    loan_txn_params = %{
                      loan_id:  add_loan.id,
                      customer_id: add_loan.customer_id,
                      principal_amount: params["requested_amount"],
                      is_disbursement: true,
                      days_accrued: 0,
                      total_interest_accrued: 0,
                      total_finance_cost_accrued: 0,
                      product_id: params["product_id"],
                      txn_amount: params["requested_amount"],
                      repaid_amount: 0,
                      transaction_date: Timex.today(),
                      created_by_id: conn.assigns.user.id,
                      outstanding_balance: 0,

                  }
                  case Repo.insert(Loan_transactions.changeset(%Loan_transactions{}, loan_txn_params)) do
                    {:ok, message} -> {:ok, message}
                    {:error, reason}-> {:error, reason}
                  end
                end)

                |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: add_loan, loan_txn: _loan_txn} ->
                  UserLogs.changeset(%UserLogs{}, %{
                    activity: "Loan Application Successfully Submitted for user with user id #{add_loan.customer_id}",
                    user_id: conn.assigns.user.id
                  })
                  |> Repo.insert()
                end)

                # |> Ecto.Multi.run(:update_funders_account, fn _repo, %{add_loan: _add_loan} ->
                #   Loanmanagementsystem.Loan.Loan_funder.changeset(get_loan_funder, %{
                #     totalbalance: total_funder_balance,
                #   })
                #   |> Repo.update()
                # end)


                |> Ecto.Multi.run(:loan_customer_details, fn _repo, %{add_loan: add_loan} ->
                  Loan_customer_details.changeset(%Loan_customer_details{}, %{
                      "cell_number" => get_bio_data.mobileNumber,
                      "customer_id" => add_loan.id,
                      "dob" => get_bio_data.dateOfBirth,
                      "email" => get_bio_data.emailAddress,
                      "firstname" => get_bio_data.firstName,
                      "surname" => get_bio_data.lastName,
                      "id_type" => get_bio_data.meansOfIdentificationType,
                      "gender" => get_bio_data.gender,
                      "id_number" => get_bio_data.meansOfIdentificationNumber,
                      "othername" => get_bio_data.otherName,
                      "reference_no" => add_loan.reference_no
                  })
                  |> Repo.insert()
                end)
                |> Ecto.Multi.run(:document, fn _repo, %{add_loan: add_loan, user_logs: _user_logs} ->
                  Loanmanagementsystem.Services.InvoiceDiscountingLoanUploads.invoice_loan_upload(%{"conn" => conn, "customer_id" => params["customer_id"], "loan_id" => add_loan.id}, params)
                end)

                |> Repo.transaction()
                |> case do
                  {:ok, %{add_loan: add_loan, user_logs: _user_logs, document: _document}} ->
                    reference_number = add_loan.reference_no
                    requested_amount = add_loan.principal_amount_proposed
                    user_details
                    |> Enum.map(fn user ->
                      try do UserBioData.where(userId: user.id) rescue _-> "" end
                      |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
                      end)
                    end)

                    params["vendorName"]
                    |> Enum.with_index()
                    |> Enum.each(fn {_x, index} ->
                      loan_invoice = %{
                        invoiceValue: params["invoiceValue"],
                        paymentTerms: Enum.at(params["paymentTerms"], index),
                        dateOfIssue: Enum.at(params["dateOfIssue"], index),
                        invoiceNo: Enum.at(params["invoiceNo"], index),
                        customer_id: add_loan.customer_id,
                        loanID: add_loan.id,
                        reference_no: add_loan.reference_no,
                        vendorName: Enum.at(offtaker, 1),
                        status: "ACTIVE",
                      }

                      Loan_invoice.changeset(%Loan_invoice{}, loan_invoice)
                      |> Repo.insert()
                    end)
                    # Loanmanagementsystem.Workers.Sms.send()
                    conn
                    |> put_flash(:info, "Loan application has successfully been sent to the credit analyst")
                    # |> redirect(to: Routes.loan_path(conn, :calculate_amortization))
                    # |> redirect(to: Routes.loan_path(conn, :calculate_amortization,  loan_amount: add_loan.principal_amount, interest_rate: 9, loan_term: "#{tenor_log_2}"))
                      |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
                  {:error, _failed_operation, failed_value, _changes_so_far} ->
                    reason = traverse_errors(failed_value.errors) |> List.first()

                    conn
                    |> put_flash(:error, reason)
                    |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
                end
              else
                conn
                |> put_flash(:error, "Sorry, We could not process your loan application at the moment. Please try again")
                |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
            end

          else
            conn
            |> put_flash(:error, "You only qualify for #{invoice_percentage}% of your invoice value, Please check and try again.")
            |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
        end
      end
    end

    @spec push_no_mou_create_invoice_discounting_application(
            Plug.Conn.t(),
            nil | maybe_improper_list | map
          ) :: Plug.Conn.t()
    def push_no_mou_create_invoice_discounting_application(conn, params) do
      product_details = Loanmanagementsystem.Products.Product.find_by(id: params["product_id"])

      role_id = try do Role.find_by(role_group: "Credit Analyst").id rescue _-> "" end

      user_details = try do User.where(role_id: role_id) rescue _-> "" end

      invoice_percentage = String.to_integer(params["invoice_percentage"])

        calculated_invoice_percentage = invoice_percentage / 100

        invoice_value = params["invoiceValue"]

        invoice_value_to_convert = try do
          case String.contains?(String.trim(invoice_value), ".") do
            true ->  String.trim(invoice_value) |> String.to_float()
            false ->  String.trim(invoice_value) |> String.to_integer() end
          rescue _-> 0 end

        calculated_invoiceValue = invoice_value_to_convert * calculated_invoice_percentage

        requested_amount = params["requested_amount"]

        requested_amount_to_convert = try do
          case String.contains?(String.trim(requested_amount), ".") do
            true ->  String.trim(requested_amount) |> String.to_float()
            false ->  String.trim(requested_amount) |> String.to_integer() end
          rescue _-> 0 end

      if calculated_invoiceValue >= requested_amount_to_convert do

      # reference_no = generate_momo_random_string(10)


      if params["customer_id"] != "" || params["customer_id"] != nil do

        offtaker = String.split(params["offtakerID"], "|||")

        # company_id = try do Loanmanagementsystem.Accounts.User.find_by(company_id: params["customer_id"]).id rescue _-> nil end

        # email_address = try do Loanmanagementsystem.Companies.Company.find_by(id: Enum.at(offtaker, 0)).contactEmail rescue _-> nil end

        contact_number = try do Loanmanagementsystem.Companies.Company.find_by(id: Enum.at(offtaker, 0)).companyPhone rescue _-> nil end

        get_bio_id = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).user_bio_id rescue _-> nil end

        get_bio_data = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: get_bio_id) rescue _-> nil end

        company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

        company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

        company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end




          new_params =
            Map.merge(params, %{
              "principal_amount_proposed" => params["requested_amount"],
              "loan_status" => "PENDING_CREDIT_ANALYST",
              "status" => "PENDING_CREDIT_ANALYST",
              "currency_code" => "ZMW",
              "loan_type" => "INVOICE DISCOUNTING",
              "loan_limit" => calculated_invoiceValue,
              "tenor" => params["tenor_log"],
              "principal_amount" => params["requested_amount"],
              "has_mou" => params["has_mou"],
              "company_id" => params["company_id"],
              "customer_id" => params["customer_id"],
              # "repayment_amount" => loan_calculations.repayement_amt,
              # "interest_amount" => loan_calculations.interest_amt,
              # "balance" => loan_calculations.repayement_amt,
              "repayment_amount" => params["totalPayment"],
              "application_date" => Date.utc_today(),
              "interest_amount" => params["total_interest"],
              "balance" => 0.0,
              "funderID" => params["loan_funder"],
              "loan_duration_month" => params["tenor_log"],
              "number_of_repayments" => params["tenor_log"],
              "reference_no" => generate_reference_no(params["customer_id"]),
              "offtakerID" => Enum.at(offtaker, 0),
              "loan_officer_id" => conn.assigns.user.id,
              "init_interest_per" => product_details.interest,
              "init_arrangement_fee_per" => product_details.arrangement_fee,
              "init_finance_cost_per" => product_details.finance_cost,

            })

            link = "http://89.58.48.159:5050/"

            text = "You have recieved a pending loan that needs to be approved for it to proceed to the next step. Please log in to the system and aprove the loan. To Login use the link #{link}"

            params = Map.put(params, "mobile", contact_number)
            params = Map.put(params, "msg", text)
            params = Map.put(params, "status", "READY")
            params = Map.put(params, "type", "SMS")
            params = Map.put(params, "msg_count", "1")

          Ecto.Multi.new()
          |> Ecto.Multi.insert(:add_loan, Loans.changeset(%Loans{}, new_params))
          # |> Ecto.Multi.insert(:invoice_loan, Sms.changeset(%Sms{}, params))
          |> Ecto.Multi.run(:loan_txn, fn _repo , %{add_loan: add_loan}->
                loan_txn_params = %{
                  loan_id:  add_loan.id,
                  customer_id: add_loan.customer_id,
                  principal_amount: params["requested_amount"],
                  is_disbursement: true,
                  days_accrued: 0,
                  total_interest_accrued: 0,
                  total_finance_cost_accrued: 0,
                  product_id: params["product_id"],
                  txn_amount: params["requested_amount"],
                  repaid_amount: 0,
                  transaction_date: Timex.today(),
                  created_by_id: conn.assigns.user.id,
                  outstanding_balance: 0,

              }
              case Repo.insert(Loan_transactions.changeset(%Loan_transactions{}, loan_txn_params)) do
                {:ok, message} -> {:ok, message}
                {:error, reason}-> {:error, reason}
              end
            end)

          |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: add_loan, loan_txn: _loan_txn} ->
            UserLogs.changeset(%UserLogs{}, %{
              activity: "Loan Application Successfully Submitted with customer is #{add_loan.customer_id}",
              user_id: conn.assigns.user.id
            })
            |> Repo.insert()
          end)

          # |> Ecto.Multi.run(:update_funders_account, fn _repo, %{add_loan: _add_loan} ->
          #   Loanmanagementsystem.Loan.Loan_funder.changeset(get_loan_funder, %{
          #     totalbalance: total_funder_balance,
          #   })
          #   |> Repo.update()
          # end)

          # |> Ecto.Multi.run(:loan_invoice, fn _repo, %{add_loan: add_loan} ->
          #   Loan_invoice.changeset(%Loan_invoice{}, %{
          #     "invoiceValue" => params["invoiceValue"],
          #     "paymentTerms" => params["paymentTerms"],
          #     "customer_id" => add_loan.id,
          #     "dateOfIssue" => params["dateOfIssue"],
          #     "invoiceNo" => params["invoiceNo"],
          #     "loanID" => add_loan.id,
          #     "reference_no" => add_loan.reference_no,
          #     "status" => "ACTIVE",
          #     "vendorName" => Enum.at(offtaker, 1)
          #   })
          #   |> Repo.insert()
          # end)


          |> Ecto.Multi.run(:loan_customer_details, fn _repo, %{add_loan: add_loan} ->
            Loan_customer_details.changeset(%Loan_customer_details{}, %{
                "cell_number" => get_bio_data.mobileNumber,
                "customer_id" => add_loan.id,
                "dob" => get_bio_data.dateOfBirth,
                "email" => get_bio_data.emailAddress,
                "firstname" => get_bio_data.firstName,
                "surname" => get_bio_data.lastName,
                "id_type" => get_bio_data.meansOfIdentificationType,
                "gender" => get_bio_data.gender,
                "id_number" => get_bio_data.meansOfIdentificationNumber,
                "othername" => get_bio_data.otherName,
                "reference_no" => add_loan.reference_no
            })
            |> Repo.insert()
          end)
          |> Ecto.Multi.run(:document, fn _repo, %{add_loan: add_loan, user_logs: _user_logs} ->
            Loanmanagementsystem.Services.InvoiceDiscountingLoanUploads.invoice_loan_upload(%{"conn" => conn, "customer_id" => params["customer_id"], "loan_id" => add_loan.id}, params)
          end)
          |> Repo.transaction()
          |> case do
            {:ok, %{add_loan: add_loan, user_logs: _user_logs, document: _document}} ->
              reference_number = add_loan.reference_no
              requested_amount = add_loan.principal_amount_proposed
              user_details
              |> Enum.map(fn user ->
                try do UserBioData.where(userId: user.id) rescue _-> "" end
                |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
                end)
              end)
              params["vendorName"]
                |> Enum.with_index()
                |> Enum.each(fn {_x, index} ->
                  loan_invoice = %{
                    invoiceValue: params["invoiceValue"],
                    paymentTerms: Enum.at(params["paymentTerms"], index),
                    dateOfIssue: Enum.at(params["dateOfIssue"], index),
                    invoiceNo: Enum.at(params["invoiceNo"], index),
                    customer_id: add_loan.customer_id,
                    loanID: add_loan.id,
                    reference_no: add_loan.reference_no,
                    vendorName: Enum.at(offtaker, 1),
                    status: "ACTIVE",
                  }

                  Loan_invoice.changeset(%Loan_invoice{}, loan_invoice)
                  |> Repo.insert()
                end)
              # Loanmanagementsystem.Workers.Sms.send()
                LoanmanagementsystemWeb.LoanController.post_amortazation(params["requested_amount"], params["calculated_interest"], params["repayment"], Timex.today, add_loan.id, params["customer_id"], add_loan.reference_no)
              conn
              |> put_flash(:info, "Loan application has successfully been sent to the credit analyst")
              # |> redirect(to: Routes.loan_path(conn, :calculate_amortization))
              # |> redirect(to: Routes.loan_path(conn, :calculate_amortization,  loan_amount: add_loan.principal_amount, interest_rate: 9, loan_term: "#{tenor_log_2}"))
                |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
            {:error, _failed_operation, failed_value, _changes_so_far} ->
              reason = traverse_errors(failed_value.errors) |> List.first()

              conn
              |> put_flash(:error, reason)
              |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
          end
        else
          conn
          |> put_flash(:error, "Sorry, We could not process your loan application at the moment. Please try again")
          |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
        end

      else
        conn
        |> put_flash(:error, "You only qualify for #{invoice_percentage}% of your invoice value, Please check and try again.")
        |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
      end
    end

    def push_create_invoice_discounting_application(conn, params) do

      loan_calculations = calculate_interest_and_repaymnent_amt(params)

      # reference_no = generate_momo_random_string(10)

      # get_funder_id = Loanmanagementsystem.Loan.get_loan_funder_details(params["loan_funder"])

      # get_loan_funder = Loanmanagementsystem.Loan.get_loan_funder!(get_funder_id.id)


      # total_funder_balance = get_loan_funder.totalAmountFunded - (Decimal.new(params["amount"]) |> Decimal.to_integer)


      if params["customer_id"] != "" || params["customer_id"] != nil do

        offtaker = String.split(params["offtakerID"], "|||")

        # email_address = try do Loanmanagementsystem.Companies.Company.find_by(id: Enum.at(offtaker, 0)).contactEmail rescue _-> nil end

        # contact_number = try do Loanmanagementsystem.Companies.Company.find_by(id: Enum.at(offtaker, 0)).companyPhone rescue _-> nil end



          new_params =
            Map.merge(params, %{
              "principal_amount_proposed" => params["amount"],
              "loan_status" => "PENDING_CREDIT_ANALYST",
              "status" => "PENDING_CREDIT_ANALYST",
              "currency_code" => "ZMW",
              "loan_type" => "INVOICE DISCOUNTING",
              "tenor" => loan_calculations.tenor,
              "principal_amount" => params["amount"],
              "has_mou" => params["has_mou"],
              "repayment_amount" => loan_calculations.repayement_amt,
              "interest_amount" => loan_calculations.interest_amt,
              "balance" => 0.0,
              "funderID" => params["loan_funder"],
              "loan_duration_month" => params["tenor_log"],
              "number_of_repayments" => params["tenor_log"],
              "reference_no" => generate_reference_no(params["customer_id"]),
              "offtakerID" => Enum.at(offtaker, 0)
            })

            # link = "http://89.58.48.159:5050/"

            # text = "You have recieved a pending loan that needs to be approved for it to proceed to the next step. Please log in to the system and aprove the loan. To Login use the link #{link}"

            # params = Map.put(params, "mobile", contact_number)
            # params = Map.put(params, "msg", text)
            # params = Map.put(params, "status", "READY")
            # params = Map.put(params, "type", "SMS")
            # params = Map.put(params, "msg_count", "1")

          Ecto.Multi.new()
          |> Ecto.Multi.insert(:add_loan, Loans.changeset(%Loans{}, new_params))
          # |> Ecto.Multi.insert(:invoice_loan, Sms.changeset(%Sms{}, params))
          |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
            UserLogs.changeset(%UserLogs{}, %{
              activity: "Loan Application Successfully Submitted",
              user_id: conn.assigns.user.id
            })
            |> Repo.insert()
          end)

          # |> Ecto.Multi.run(:update_funders_account, fn _repo, %{add_loan: _add_loan} ->
          #   Loanmanagementsystem.Loan.Loan_funder.changeset(get_loan_funder, %{
          #     totalbalance: total_funder_balance,
          #   })
          #   |> Repo.update()
          # end)

          |> Ecto.Multi.run(:loan_invoice, fn _repo, %{add_loan: add_loan} ->
            Loan_invoice.changeset(%Loan_invoice{}, %{
              "invoiceValue" => params["invoiceValue"],
              "paymentTerms" => params["paymentTerms"],
              "customer_id" => add_loan.id,
              "dateOfIssue" => params["dateOfIssue"],
              "invoiceNo" => params["invoiceNo"],
              "loanID" => add_loan.id,
              "status" => "ACTIVE",
              "reference_no" => add_loan.reference_no,
              "vendorName" => Enum.at(offtaker, 1)
            })
            |> Repo.insert()
          end)


          |> Ecto.Multi.run(:loan_customer_details, fn _repo, %{add_loan: add_loan, loan_invoice: _loan_invoice} ->
            Loan_customer_details.changeset(%Loan_customer_details{}, %{
                "cell_number" => params["cell_number"],
                "customer_id" => add_loan.id,
                "dob" => params["dob"],
                "email" => params["email"],
                "firstname" => params["firstname"],
                "gender" => params["gender"],
                "id_number" => params["id_number"],
                "othername" => params["othername"],
                "reference_no" => add_loan.reference_no,
            })
            |> Repo.insert()
          end)
          |> Ecto.Multi.run(:document, fn _repo, %{add_loan: add_loan, user_logs: _user_logs} ->
            Loanmanagementsystem.Services.InvoiceDiscountingLoanUploads.invoice_loan_upload(%{"conn" => conn, "customer_id" => params["customer_id"], "loan_id" => add_loan.id}, params)
          end)
          |> Repo.transaction()
          |> case do
            {:ok, %{add_loan: _add_loan, user_logs: _user_logs, loan_invoice: _loan_invoice, document: _document}} ->
              # Email.confirm_approval(email_address)
              # Loanmanagementsystem.Workers.Sms.send()
              conn
              |> put_flash(:info, "Loan application has successfully been sent to the credit analyst")
              |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))

            {:error, _failed_operation, failed_value, _changes_so_far} ->
              reason = traverse_errors(failed_value.errors) |> List.first()

              conn
              |> put_flash(:error, reason)
              |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
          end
        else
          conn
          |> put_flash(:error, "Sorry, We could not process your loan application at the moment. Please try again")
          |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
        end
    end

    def approve_credit_invoice_discounting(conn, %{"loan_id" => loan_id}) do

      loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(loan_id)

      loan_details = Loanmanagementsystem.Loan.invoice_details_list(loan_id)

      loan_invoice_details = Loanmanagementsystem.Loan.loan_invoice_details(loan_id)

      credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)

      funder_details = Loanmanagementsystem.Loan.get_funder_details()

      render(conn, "approve_credit_invoice_discounting.html", loan_details: loan_details, loanDocs: loanDocs, credit_loan_details: credit_loan_details, funder_details: funder_details, loan_invoice_details: loan_invoice_details)
    end


    def approve_accounts_invoice_discounting(conn, %{"loan_id" => loan_id}) do

      loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(loan_id)

      loan_details = Loanmanagementsystem.Loan.invoice_details_list(loan_id)

      credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)

      loan_invoice_details = Loanmanagementsystem.Loan.loan_invoice_details(loan_id)

      render(conn, "approve_accounts_invoice_discounting.html", loan_details: loan_details, loanDocs: loanDocs, credit_loan_details: credit_loan_details, loan_invoice_details: loan_invoice_details)
    end


    def admin_approve_credit_analyst_ordering_finance_miz(conn, %{"loan_id" => loan_id}) do

      loanDocs = Loanmanagementsystem.Operations.get_credit_invoice_docs(loan_id)

      loan_details = Loanmanagementsystem.Operations.ordering_finance_details(loan_id)

      credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)

      offtaker_details = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)

      render(conn, "admin_approve_credit_analyst_ordering_finance_miz.html", loan_details: loan_details, loanDocs: loanDocs, credit_loan_details: credit_loan_details, offtaker_details: offtaker_details)
    end

    def admin_approve_accountant_ordering_finance_miz(conn, %{"loan_id" => loan_id}) do

      loanDocs = Loanmanagementsystem.Operations.get_credit_invoice_docs(loan_id)

      loan_details = Loanmanagementsystem.Operations.ordering_finance_details(loan_id)

      credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)

      offtaker_details = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)

      render(conn, "admin_approve_accountant_ordering_finance_miz.html", loan_details: loan_details, loanDocs: loanDocs, credit_loan_details: credit_loan_details, offtaker_details: offtaker_details)
    end


    def admin_approve_accountant_invoice_discounting(conn, %{"loan_id" => loan_id}) do

      loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(loan_id)

      loan_details = Loanmanagementsystem.Loan.invoice_details_list(loan_id)

      credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)

      offtaker_details = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)

      render(conn, "admin_approve_accountant_invoice_discounting.html", loan_details: loan_details, loanDocs: loanDocs, credit_loan_details: credit_loan_details, offtaker_details: offtaker_details)
    end

    def admin_approve_accountant_sme_loan_miz(conn, %{"loan_id" => loan_id}) do

      loanDocs = Loanmanagementsystem.Operations.get_credit_invoice_docs(loan_id)

      loan_details = Loanmanagementsystem.Operations.ordering_finance_details(loan_id)

      credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)

      offtaker_details = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)

      render(conn, "admin_approve_accountant_sme_loan_miz.html", loan_details: loan_details, loanDocs: loanDocs, credit_loan_details: credit_loan_details, offtaker_details: offtaker_details)
    end


    def admin_review_credit_analyst_ordering_finance_miz(conn, %{"loan_id" => loan_id}) do

      loanDocs = Loanmanagementsystem.Operations.get_credit_invoice_docs(loan_id)

      loan_details = Loanmanagementsystem.Operations.ordering_finance_details(loan_id)

      credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)

      offtaker_details = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)

      render(conn, "admin_review_credit_analyst_ordering_finance_miz.html", loan_details: loan_details, loanDocs: loanDocs, credit_loan_details: credit_loan_details, offtaker_details: offtaker_details)
    end
    def admin_assessment_credit_analyst_ordering_finance_miz(conn, %{"loan_id" => loan_id}) do

      loanDocs = Loanmanagementsystem.Operations.get_credit_invoice_docs(loan_id)

      loan_details = Loanmanagementsystem.Operations.ordering_finance_details(loan_id)

      credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)

      offtaker_details = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)


      render(conn, "admin_assessment_credit_analyst_ordering_finance_miz.html", loan_details: loan_details, loanDocs: loanDocs, credit_loan_details: credit_loan_details, offtaker_details: offtaker_details)
    end


    def admin_approve_loan_officer_ordering_finance_miz(conn, %{"loan_id" => loan_id}) do

      loanDocs = Loanmanagementsystem.Operations.get_credit_invoice_docs(loan_id)

      loan_details = Loanmanagementsystem.Operations.ordering_finance_details(loan_id)

      credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)

      offtaker_details = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)

      render(conn, "admin_approve_loan_officer_ordering_finance_miz.html", loan_details: loan_details, loanDocs: loanDocs, credit_loan_details: credit_loan_details, offtaker_details: offtaker_details)
    end

    def admin_approve_operations_ordering_finance(conn, %{"loan_id" => loan_id}) do

      loanDocs = Loanmanagementsystem.Operations.get_credit_invoice_docs(loan_id)

      loan_details = Loanmanagementsystem.Operations.ordering_finance_details(loan_id)

      offtaker_details = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)

      render(conn, "admin_approve_operations_ordering_finance.html", loan_details: loan_details, loanDocs: loanDocs, offtaker_details: offtaker_details)
    end


    def admin_approve_operations_sme_loan(conn, %{"loan_id" => loan_id}) do

      # IO.inspect(loan_id, label: "loan_id here")

      loanDocs = Loanmanagementsystem.Operations.get_credit_invoice_docs(loan_id)

      loan_details = Loanmanagementsystem.Operations.ordering_finance_details(loan_id)

      credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)

      offtaker_details = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)

      render(conn, "admin_approve_operations_sme_loan.html", loan_details: loan_details, loanDocs: loanDocs, credit_loan_details: credit_loan_details, offtaker_details: offtaker_details)
    end

    def approve_credit_invoice_discounting_application(conn, params) do

      # reference_no = generate_momo_random_string(10)


      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["id"])

      if (loans.loan_status == "PENDING_CREDIT_ANALYST" and loans.status == "PENDING_CREDIT_ANALYST_FROM_FUNDER") do

        LoanmanagementsystemWeb.LoanController.approve_funder_credit_invoice_discounting_application(conn, params)

        else

          if (loans.loan_status == "APPROVED" and loans.status == "APPROVED_FROM_CEO") do

            LoanmanagementsystemWeb.LoanController.approve_credit_from_ceo_invoice_discounting_application(conn, params)

            else

            funder = String.split(params["funderID"], "|||")

          if params["has_mou"] == "YES" and Enum.at(funder, 1) == "EXTERNAL FUNDER" do

            LoanmanagementsystemWeb.LoanController.approve_funder_invoice_discounting_application(conn, params)

            else

            if params["has_mou"] == "NO" and Enum.at(funder, 1) == "EXTERNAL FUNDER" do

              LoanmanagementsystemWeb.LoanController.approve_funder_invoice_discounting_application(conn, params)

              else

              if params["has_mou"] == "YES" and Enum.at(funder, 1) == "INTERNAL FUNDER" do

                LoanmanagementsystemWeb.LoanController.push_to_approve_credit_invoice_discounting_application(conn, params)

                else

                  role_id = try do Role.find_by(role_group: "Credit Manager").id rescue _-> "" end

                  user_details = try do User.where(role_id: role_id)  rescue _-> "" end

                  company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

                  company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

                  company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

                Ecto.Multi.new()
                |> Ecto.Multi.update(
                  :add_loan,
                  Loans.changeset(loans, %{

                    loan_status: "PENDING_OPERATIONS_MANAGER",
                    status: "PENDING_OPERATIONS_MANAGER_REVIEW",
                    funderID: Enum.at(funder, 0)

                  })
                )

                |> Ecto.Multi.run(:recomendation, fn _repo, %{add_loan: _add_loan} ->
                  Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
                    comments: params["comment"],
                    customer_id: params["customer_id"],
                    date: "#{Date.utc_today()}",
                    date_received: Date.to_string(loans.application_date),
                    name: params["feedback_name"],
                    position: "CREDIT ANALYST",
                    recommended: params["feedback"],
                    time_received: "#{Timex.now()}",
                    user_type: "CREDIT",
                    loan_id: loans.id,
                    reference_no: generate_reference_no(params["customer_id"]),
                  })
                  |> Repo.insert()
                end)

                |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
                  UserLogs.changeset(%UserLogs{}, %{
                    activity: "Loan application has successfully been sent to the operations manager",
                    user_id: conn.assigns.user.id
                  })
                  |> Repo.insert()
                end)
                |> Ecto.Multi.run(:document, fn _repo, %{add_loan: add_loan, user_logs: _user_logs} ->
                  Loanmanagementsystem.Services.InvoiceDiscountingLoanUploads.invoice_loan_upload(%{"conn" => conn, "customer_id" => params["customer_id"], "loan_id" => add_loan.id}, params)
                end)
                |> Repo.transaction()
                |> case do
                  {:ok, %{add_loan: add_loan, user_logs: _user_logs, document: _document}} ->
                    reference_number = add_loan.reference_no
                    requested_amount = add_loan.principal_amount_proposed
                    user_details
                    |> Enum.map(fn user ->
                      try do UserBioData.where(userId: user.id) rescue _-> "" end
                      |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
                      end)
                    end)
                    conn
                    |> put_flash(:info, "Loan application has successfully been sent to the operations manager")
                    |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))

                  {:error, _failed_operation, failed_value, _changes_so_far} ->
                    reason = traverse_errors(failed_value.errors) |> List.first()

                    conn
                    |> put_flash(:error, reason)
                    |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
                end
              end
            end
          end
        end
      end
    end


    def approve_credit_from_ceo_invoice_discounting_application(conn, params) do

      # reference_no = generate_momo_random_string(10)

      role_id = try do Role.find_by(role_group: "Accountant").id rescue _-> "" end

      user_details = try do User.where(role_id: role_id)  rescue _-> "" end

      company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

      company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

      company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end


      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["id"])

        Ecto.Multi.new()
        |> Ecto.Multi.update(
          :add_loan,
          Loans.changeset(loans, %{

            loan_status: "PENDING_ACCOUNTANT",
            status: "APPROVED",

          })
        )

        |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Loan application has successfully been sent to the account",
            user_id: conn.assigns.user.id
          })
          |> Repo.insert()
        end)
        |> Ecto.Multi.run(:document, fn _repo, %{add_loan: add_loan, user_logs: _user_logs} ->
          Loanmanagementsystem.Services.InvoiceDiscountingLoanUploads.invoice_loan_upload(%{"conn" => conn, "customer_id" => params["customer_id"], "loan_id" => add_loan.id}, params)
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{add_loan: add_loan, user_logs: _user_logs, document: _document}} ->
            reference_number = add_loan.reference_no
            requested_amount = add_loan.principal_amount_proposed
            user_details
            |> Enum.map(fn user ->
              try do UserBioData.where(userId: user.id) rescue _-> "" end
              |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
              end)
            end)
            conn
            |> put_flash(:info, "Loan application has successfully been sent to the account for disbursement")
            |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
        end
    end

    def approve_funder_invoice_discounting_application(conn, params) do

      # reference_no = generate_momo_random_string(10)

      funder = String.split(params["funderID"], "|||")

        user_bio_email = try do UserBioData.find_by(userId: Enum.at(funder, 0)).emailAddress  rescue _-> "" end

        company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

        company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

        company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["id"])

        Ecto.Multi.new()
        |> Ecto.Multi.update(
          :add_loan,
          Loans.changeset(loans, %{

            loan_status: "PENDING_FUNDER_APPROVAL",
            status: "PENDING_FUNDER_APPROVAL",
            funderID: Enum.at(funder, 0)


          })
        )

        |> Ecto.Multi.run(:recomendation, fn _repo, %{add_loan: _add_loan} ->
          Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
            comments: params["comment"],
            customer_id: params["customer_id"],
            date: "#{Date.utc_today()}",
            date_received: Date.to_string(loans.application_date),
            name: params["feedback_name"],
            position: "CREDIT ANALYST",
            recommended: params["feedback"],
            time_received: "#{Timex.now()}",
            user_type: "CREDIT",
            loan_id: loans.id,
            reference_no: generate_reference_no(params["customer_id"]),
          })
          |> Repo.insert()
        end)

        |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Loan Application Successfully Approved By Credit Analyst",
            user_id: conn.assigns.user.id
          })
          |> Repo.insert()
        end)
        |> Ecto.Multi.run(:document, fn _repo, %{add_loan: add_loan, user_logs: _user_logs} ->
          Loanmanagementsystem.Services.InvoiceDiscountingLoanUploads.invoice_loan_upload(%{"conn" => conn, "customer_id" => params["customer_id"], "loan_id" => add_loan.id}, params)
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{add_loan: add_loan, user_logs: _user_logs}} ->
            reference_number = add_loan.reference_no
            requested_amount = add_loan.principal_amount_proposed
            Email.notify_next_approver(user_bio_email, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
            conn
            |> put_flash(:info, "Loan application has successfully been sent to the funder")
            |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
        end
    end

    def push_to_approve_credit_invoice_discounting_application(conn, params) do

      role_id = try do Role.find_by(role_group: "Credit Manager").id rescue _-> "" end

      user_details = try do User.where(role_id: role_id)  rescue _-> "" end

      company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

      company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

      company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

      funder = String.split(params["funderID"], "|||")

      # reference_no = generate_momo_random_string(10)

      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["id"])

      Ecto.Multi.new()
      |> Ecto.Multi.update(
        :add_loan,
        Loans.changeset(loans, %{

          loan_status: "PENDING_OPERATIONS_MANAGER",
          status: "PENDING_OPERATIONS_MANAGER_REVIEW",
          funderID: Enum.at(funder, 0)

        })
      )

      |> Ecto.Multi.run(:recomendation, fn _repo, %{add_loan: _add_loan} ->
        Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
          comments: params["comment"],
          customer_id: params["customer_id"],
          date: "#{Date.utc_today()}",
          date_received: Date.to_string(loans.application_date),
          name: params["feedback_name"],
          position: "CREDIT ANALYST",
          recommended: params["feedback"],
          time_received: "#{Timex.now()}",
          user_type: "CREDIT",
          loan_id: loans.id,
          reference_no: generate_reference_no(params["customer_id"]),
        })
        |> Repo.insert()
      end)
      |> Ecto.Multi.run(:document, fn _repo, %{add_loan: add_loan} ->
        Loanmanagementsystem.Services.InvoiceDiscountingLoanUploads.invoice_loan_upload(%{"conn" => conn, "customer_id" => params["customer_id"], "loan_id" => add_loan.id}, params)
      end)
      |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Loan application has successfully been sent to the operations manager",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{add_loan: add_loan, user_logs: _user_logs}} ->
          reference_number = add_loan.reference_no
          requested_amount = add_loan.principal_amount_proposed
          user_details
          |> Enum.map(fn user ->
            try do UserBioData.where(userId: user.id) rescue _-> "" end
            |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
            end)
          end)
          conn
          |> put_flash(:info, "Loan application has successfully been sent to the operations manager")
          |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
        end
    end

    def approve_funder_credit_invoice_discounting_application(conn, params) do

      funder = String.split(params["funderID"], "|||")

      # reference_no = generate_momo_random_string(10)

      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["id"])

        Ecto.Multi.new()
        |> Ecto.Multi.update(
          :add_loan,
          Loans.changeset(loans, %{

            loan_status: "PENDING_ACCOUNTANT",
            status: "PENDING_ACCOUNTANT_FROM_CREDIT",
            funderID: Enum.at(funder, 0)

          })
        )

        |> Ecto.Multi.run(:recomendation, fn _repo, %{add_loan: _add_loan} ->
          Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
            comments: params["comment"],
            customer_id: params["customer_id"],
            date: "#{Date.utc_today()}",
            date_received: Date.to_string(loans.application_date),
            name: params["feedback_name"],
            position: "CREDIT ANALYST",
            recommended: params["feedback"],
            time_received: "#{Timex.now()}",
            user_type: "CREDIT",
            loan_id: loans.id,
            reference_no: generate_reference_no(params["customer_id"]),
          })
          |> Repo.insert()
        end)

        |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Loan Application Successfully Approved By Credit Analyst",
            user_id: conn.assigns.user.id
          })
          |> Repo.insert()
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{add_loan: _add_loan, user_logs: _user_logs}} ->
            conn
            |> put_flash(:info, "Loan application has successfully been sent to the accountant")
            |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
        end
    end

    def approve_operations_invoice_discounting_application(conn, params) do

      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["id"])

      # reference_no = generate_momo_random_string(10)

      if (loans.has_mou == "YES") do

        LoanmanagementsystemWeb.LoanController.approve_operations_invoice_discounting_application_with_mou(conn, params)

      else

      role_id = try do Role.find_by(role_group: "Management").id rescue _-> "" end

      IO.inspect(role_id, label: "----------------------ID----------------------")

      user_details = try do User.where(role_id: role_id)  rescue _-> "" end

      IO.inspect(user_details, label: "----------------------ID----------------------")

      company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

      company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

      company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

        Ecto.Multi.new()
        |> Ecto.Multi.update(
          :add_loan,
          Loans.changeset(loans, %{

            loan_status: "PENDING_MANAGEMENT",
            status: "PENDING_MANAGEMENT_FROM_OPERATIONS"

          })
        )

        |> Ecto.Multi.run(:recomendation, fn _repo, %{add_loan: _add_loan} ->
          Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
            comments: params["comment"],
            customer_id: params["customer_id"],
            date: "#{Date.utc_today()}",
            date_received: Date.to_string(loans.application_date),
            name: params["feedback_name"],
            position: "CREDIT ANALYST",
            recommended: params["feedback"],
            time_received: "#{Timex.now()}",
            user_type: "CREDIT",
            loan_id: loans.id,
            reference_no: generate_reference_no(params["customer_id"]),
          })
          |> Repo.insert()
        end)

        |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Loan application has successfully been sent to management",
            user_id: conn.assigns.user.id
          })
          |> Repo.insert()
        end)

        # |> Ecto.Multi.run(:document, fn _repo, %{add_loan: add_loan, user_logs: _user_logs} ->
        #   Loanmanagementsystem.Services.InvoiceDiscountingLoanUploads.invoice_loan_upload(%{"conn" => conn, "customer_id" => params["customer_id"], "loan_id" => add_loan.id}, params)
        # end)
        |> Repo.transaction()
        |> case do
          {:ok, %{add_loan: add_loan, user_logs: _user_logs}} ->
            reference_number = add_loan.reference_no
            requested_amount = add_loan.principal_amount_proposed
            user_details
            |> Enum.map(fn user ->
              try do UserBioData.where(userId: user.id) rescue _-> "" end
              |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
              end)
            end)
            conn
            |> put_flash(:info, "Loan Application Submitted Successfully By Operations Manager")
            |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
        end
      end
    end

    def approve_operations_invoice_discounting_application_with_mou(conn, params) do

      role_id = try do Role.find_by(role_group: "Management").id rescue _-> "" end

      user_details = try do User.where(role_id: role_id)  rescue _-> "" end

      company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

      company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

      company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["id"])

        Ecto.Multi.new()
        |> Ecto.Multi.update(
          :add_loan,
          Loans.changeset(loans, %{

            loan_status: "PENDING_MANAGEMENT",
            status: "PENDING_MANAGEMENT_FROM_OPERATIONS"

          })
        )

        |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Loan Application Successfully Approved By Operations Manager",
            user_id: conn.assigns.user.id
          })
          |> Repo.insert()
        end)
        |> Repo.transaction()
        |> case do
          {:ok, %{add_loan: add_loan, user_logs: _user_logs}} ->
            reference_number = add_loan.reference_no
            requested_amount = add_loan.principal_amount_proposed
            user_details
            |> Enum.map(fn user ->
              try do UserBioData.where(userId: user.id) rescue _-> "" end
              |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
              end)
            end)
            conn
            |> put_flash(:info, "Loan application has successfully been sent to management")
            |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))

          {:error, _failed_operation, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()

            conn
            |> put_flash(:error, reason)
            |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
        end
    end

    def invoice_discounting_approval(conn, %{"loan_id" => loan_id}) do

      loan_details = Loanmanagementsystem.Loan.invoice_details_list(loan_id)

      render(conn, "invoice_discounting_credit_approval.html", loan_details: loan_details)

    end


    def admin_credit_analyst_approval_with_documents(conn, params) do

      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])


      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{
          "loan_status" => "PENDING_LOAN_OFFICER",
          "status"=> "PENDING_LOAN_OFFICER_PROOF_OF_COLLATERAL",
          "funderID"=> params["loan_funder_ID"]
        })

      ))
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status}->
        user_logs = %{
          activity: "Credit Analyst has Viewed the purchase order Successful",
          user_id: conn.assigns.user.id
        }

        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |> Ecto.Multi.run(:document, fn _repo, %{update_loan_status: update_loan_status, user_logs: _user_logs} ->
        Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan_status.id}, params)
      end)
      |>Repo.transaction()
      |>case do
        {:ok, %{update_loan_status: _update_loan_status}} ->
          conn
          |>put_flash(:info, "You have Successfully Viewed the purchase order and requested for collateral and proof of payment upload")
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
      end
    end


    def admin_credit_analyst_assesment_with_document_upload_miz(conn, params) do

      role_id = try do Role.find_by(role_group: "Credit Manager").id rescue _-> "" end

      user_details = try do User.where(role_id: role_id)  rescue _-> "" end

      company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

      company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

      company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])

      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{
          "loan_status" => "PENDING_OPERATIONS_MANAGER",
          "status"=> "OPERATIONS AND CREDIT MANAGER APPROVAL",
          "funderID"=> params["loan_funder_ID"]
        })
      ))
      |>Ecto.Multi.run(:loan_assessment, fn _repo, %{update_loan_status: update_loan_status}->
        loan_assessment = %{
          comments: params["comments_feedback"],
          customer_id: params["customer_id"],
          date: "#{Date.utc_today()}",
          date_received: "#{update_loan_status.application_date}",
          name: params["feedback_name"],
          position: "CREDIT ANALYST",
          recommended: params["comments_feedback"],
          time_received: "#{Timex.now()}",
          user_type: "CREDIT ANALYST",
          loan_id: update_loan_status.id
        }
        case Repo.insert(Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, loan_assessment)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status, loan_assessment: _loan_assessment}->
        user_logs = %{
          activity: "Credit Analyst has Viewed and Assessed all the documents Successfully",
          user_id: conn.assigns.user.id
        }
        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |> Ecto.Multi.run(:document, fn _repo, %{update_loan_status: update_loan_status, user_logs: _user_logs} ->
        Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan_status.id}, params)
      end)
      |>Repo.transaction()
      |>case do
        {:ok, %{update_loan_status: update_loan_status} } ->
          reference_number = update_loan_status.reference_no
          requested_amount = update_loan_status.principal_amount
          user_details
          |> Enum.map(fn user ->
            try do UserBioData.where(userId: user.id) rescue _-> "" end
            |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
            end)
          end)
          conn
          |>put_flash(:info, "You have Successfully Submitted the Document and Assessment, And has been pushed to the Credit Manager")
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
      end
    end

    def admin_accountant_assesment_with_document_upload_miz(conn, params) do
      IO.inspect(params, label: "----------------------------------------------------miz")
      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])

      requested_amount = String.to_integer(params["amount_loan"])
      disbursed_amount = String.to_integer(params["disbursement_amount"])

      if (disbursed_amount <= requested_amount) do

        Ecto.Multi.new()
        |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
          Map.merge(params, %{
            "loan_status" => "DISBURSED",
            "status"=> "DISBURSED",
            "disbursedon_date"=> Date.utc_today(),
            "disbursedon_user_id" => conn.assigns.user.id,
            "principal_disbursed_derived" => loans.principal_amount,
            "disbursement_method"=> params["disbursement_method"]
          })
        ))
        |>Ecto.Multi.run(:loan_assessment, fn _repo, %{update_loan_status: update_loan_status}->
          loan_assessment = %{
            comments: params["comment"],
            customer_id: params["customer_id"],
            date: "#{Date.utc_today()}",
            date_received: "#{update_loan_status.application_date}",
            name: params["feedback_name"],
            position: "ACCOUNTANT",
            recommended: params["feedback"],
            time_received: "#{Timex.now()}",
            user_type: "ACCOUNTANT",
            loan_id: update_loan_status.id,
            reference_no: generate_reference_no(params["customer_id"])
          }
          case Repo.insert(Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, loan_assessment)) do
            {:ok, message} -> {:ok, message}
            {:error, reason}-> {:error, reason}
          end
        end)
        |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status, loan_assessment: _loan_assessment}->
          user_logs = %{
            activity: "Accountant has disbursed the loan Successfully",
            user_id: conn.assigns.user.id
          }
          case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
            {:ok, message} -> {:ok, message}
            {:error, reason}-> {:error, reason}
          end
        end)
        |> Ecto.Multi.run(:document, fn _repo, %{update_loan_status: update_loan_status, user_logs: _user_logs} ->
          Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan_status.id}, params)
        end)
        |>Repo.transaction()
        |>case do
          {:ok, _ } ->
            conn
            |>put_flash(:info, "You have Successfully Disbursed this Loan")
            |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
          {:error, _failed_operations, failed_value,  _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()
            conn
            |>put_flash(:error, reason)
            |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
        end
        else
          conn
          |>put_flash(:error, "Disbursed amount can not be more than the requested amount, please check and try again.")
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
      end
    end


    def admin_accountant_assesment_for_invoice_discounting(conn, params) do
      IO.inspect(params, label: "----------------------------------------------------miz")
      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])

      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{
          "loan_status" => "DISBURSED",
          "status"=> "DISBURSED",
          "disbursedon_date"=> Date.utc_today(),
          "disbursedon_user_id" => conn.assigns.user.id,
          # "principal_disbursed_derived" => loans.principal_amount,
          "disbursement_method"=> params["disbursement_method"],
          "principal_disbursed_derived" => params["disbursement_amount"],
          "disbursement_status"=> params["disbursement_status"]
        })
      ))
      |>Ecto.Multi.run(:loan_assessment, fn _repo, %{update_loan_status: update_loan_status}->
        loan_assessment = %{
          comments: params["review"],
          customer_id: params["customer_id"],
          date: "#{Date.utc_today()}",
          date_received: "#{update_loan_status.application_date}",
          name: params["feedback_name"],
          position: "ACCOUNTANT",
          recommended: params["review"],
          time_received: "#{Timex.now()}",
          user_type: "ACCOUNTANT",
          loan_id: update_loan_status.id
        }
        case Repo.insert(Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, loan_assessment)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status, loan_assessment: _loan_assessment}->
        user_logs = %{
          activity: "Accountant has disbursed the loan Successfully",
          user_id: conn.assigns.user.id
        }
        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |> Ecto.Multi.run(:document, fn _repo, %{update_loan_status: update_loan_status, user_logs: _user_logs} ->
        Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan_status.id}, params)
      end)
      |>Repo.transaction()
      |>case do
        {:ok, _ } ->
          conn
          |>put_flash(:info, "You have Successfully Disbursed this Loan")
          |>redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
      end
    end


    def admin_accountant_assesment_with_document_upload_miz_sme_loan(conn, params) do
      IO.inspect(params, label: "----------------------------------------------------miz")
      reguested_amount = String.to_integer(params["amount_loan"])
      disbursed_amount = String.to_integer(params["disbursement_amount"])

      IO.inspect(disbursed_amount, label: "---------------------------DISBURSED-------------------------")
      IO.inspect(reguested_amount, label: "---------------------------REQUESTED-------------------------miz")

      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])

      if (reguested_amount >= disbursed_amount) do

        Ecto.Multi.new()
        |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
          Map.merge(params, %{
            "loan_status" => "DISBURSED",
            "status"=> "DISBURSED",
            "disbursedon_date"=> Date.utc_today(),
            "disbursedon_userid" => conn.assigns.user.id,
            "principal_disbursed_derived" => loans.principal_amount,
            "disbursement_method"=> params["disbursement_method"]
          })
        ))
        |>Ecto.Multi.run(:loan_assessment, fn _repo, %{update_loan_status: update_loan_status}->
          loan_assessment = %{
            comments: params["comment"],
            customer_id: params["customer_id"],
            date: "#{Date.utc_today()}",
            date_received: "#{update_loan_status.application_date}",
            name: params["feedback_name"],
            position: "ACCOUNTANT",
            recommended: params["feedback"],
            time_received: "#{Timex.now()}",
            user_type: "ACCOUNTANT",
            loan_id: update_loan_status.id
          }
          case Repo.insert(Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, loan_assessment)) do
            {:ok, message} -> {:ok, message}
            {:error, reason}-> {:error, reason}
          end
        end)
        |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status, loan_assessment: _loan_assessment}->
          user_logs = %{
            activity: "Accountant has disbursed the loan Successfully",
            user_id: conn.assigns.user.id
          }
          case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
            {:ok, message} -> {:ok, message}
            {:error, reason}-> {:error, reason}
          end
        end)
        |> Ecto.Multi.run(:document, fn _repo, %{update_loan_status: update_loan_status, user_logs: _user_logs} ->
          Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan_status.id}, params)
        end)
        |>Repo.transaction()
        |>case do
          {:ok, _ } ->
            conn
            |>put_flash(:info, "You have Successfully Disbursed the Loan")
            |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
          {:error, _failed_operations, failed_value,  _changes_so_far} ->
            reason = traverse_errors(failed_value.errors) |> List.first()
            conn
            |>put_flash(:error, reason)
            |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
        end
      else
        conn
            |>put_flash(:error, "Disbursed amount can not be more than the requested amount, please check and try again.")
            |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
    end
  end


    # def admin_credit_analyst_approval_with_documents(conn, params) do
    #   loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])


    #   Ecto.Multi.new()
    #   |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
    #     Map.merge(params, %{
    #       "loan_status" => "PENDING_LOAN_OFFICER",
    #       "status"=> "PENDING_LOAN_OFFICER_PROOF_OF_COLLATERAL"
    #     })

    #   ))
    #   |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status}->
    #     user_logs = %{
    #       activity: "Credit Analyst has Viewed the purchase order Successful",
    #       user_id: conn.assigns.user.id
    #     }

    #     case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
    #       {:ok, message} -> {:ok, message}
    #       {:error, reason}-> {:error, reason}
    #     end
    #   end)
    #   # |> Ecto.Multi.run(:document, fn _repo, %{update_loan_status: _update_loan_status, user_logs: _user_logs} ->
    #   #   Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{"process_documents" => params, "conn" => conn, "customer_id" => params["customer_id"], "loan_id" => params["loan_id"], "fileName" => params["fileName"]})
    #   # end)
    #   |>Repo.transaction()
    #   |>case do
    #     {:ok, _ } ->
    #       conn
    #       |>put_flash(:info, "You have Successfully Viewed the purchase order and requested for collateral and proof of payment upload")
    #       |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
    #     {:error, _failed_operations, failed_value,  _changes_so_far} ->
    #       reason = traverse_errors(failed_value.errors) |> List.first()
    #       conn
    #       |>put_flash(:error, reason)
    #       |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
    #   end
    # end





    def admin_loan_officer_approval_with_documents(conn, params) do
      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])


      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{
          "loan_status" => "PENDING_CREDIT_ANALYST",
          "status"=> "PENDING_CREDIT_ANALYST_ASSESSMENT"
        })

      ))
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status}->
        user_logs = %{
          activity: "Loan Officer with id: #{conn.assigns.user.id} has Successfully Upload required documents",
          user_id: conn.assigns.user.id
        }

        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |> Ecto.Multi.run(:document, fn _repo, %{update_loan_status: update_loan_status, user_logs: _user_logs} ->
        Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan_status.id}, params)
      end)
      |>Repo.transaction()
      |>case do
        {:ok, _ } ->
          conn
          |>put_flash(:info, "You have Successfully Uploaded required documents")
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
      end
    end



    def admin_operations_and_credit_manager_approval_with_documents(conn, params) do

      role_id = try do Role.find_by(role_group: "Management").id rescue _-> "" end

      user_details = try do User.where(role_id: role_id)  rescue _-> "" end

      company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

      company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

      company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])

      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{
          "loan_status" => "PENDING_MANAGEMENT",
          "status"=> "APPROVED",
          "approvedon_date"=> Date.utc_today(),
          "approvedon_userid"=> conn.assigns.user.id
        })
      ))
      |>Ecto.Multi.run(:loan_assessment, fn _repo, %{update_loan_status: update_loan_status}->
        loan_assessment = %{
          comments: params["feedback"],
          customer_id: params["customer_id"],
          date: "#{Date.utc_today()}",
          date_received: "#{update_loan_status.application_date}",
          name: params["feedback_name"],
          position: "CREDIT MANAGER",
          recommended: params["feedback"],
          time_received: "#{Timex.now()}",
          user_type: "CREDIT MANAGER",
          loan_id: update_loan_status.id
        }
        case Repo.insert(Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, loan_assessment)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status, loan_assessment: _loan_assessment}->
        user_logs = %{
          activity: "Operations and Credit Manager Approval and Review done Successfully",
          user_id: conn.assigns.user.id
        }

        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      # |> Ecto.Multi.run(:document, fn _repo, %{update_loan_status: _update_loan_status, user_logs: _user_logs} ->
      #   Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{"process_documents" => params, "conn" => conn, "customer_id" => params["customer_id"], "loan_id" => params["loan_id"], "fileName" => params["fileName"]})
      # end)
      |>Repo.transaction()
      |>case do
        {:ok, %{update_loan_status: update_loan_statu}} ->
          reference_number = update_loan_statu.reference_no
          requested_amount = update_loan_statu.principal_amount
          user_details
          |> Enum.map(fn user ->
            try do UserBioData.where(userId: user.id) rescue _-> "" end
            |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
            end)
          end)
          conn
          |>put_flash(:info, "You have Successfully Approved the Loan and Reviewed Uploaded documents")
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
      end
    end



    def admin_operations_and_credit_manager_approval_without_documents_sme_loan(conn, params) do
      role_id = try do Role.find_by(role_group: "Management").id rescue _-> "" end

      user_details = try do User.where(role_id: role_id)  rescue _-> "" end

      company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

      company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

      company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end
      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])
      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{
          "loan_status" => "PENDING_MANAGEMENT",
          "status"=> "APPROVED",
          "approvedon_date"=> Date.utc_today(),
          "approvedon_userid"=> conn.assigns.user.id
        })
      ))
      |>Ecto.Multi.run(:loan_assessment, fn _repo, %{update_loan_status: update_loan_status}->
        loan_assessment = %{
          comments: params["feedback"],
          customer_id: params["customer_id"],
          date: "#{Date.utc_today()}",
          date_received: "#{update_loan_status.application_date}",
          name: params["feedback_name"],
          position: "CREDIT MANAGER",
          recommended: params["feedback"],
          time_received: "#{Timex.now()}",
          user_type: "CREDIT MANAGER",
          loan_id: update_loan_status.id
        }
        case Repo.insert(Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, loan_assessment)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status, loan_assessment: _loan_assessment}->
        user_logs = %{
          activity: "Credit Manager 1st Approval and Review done Successfully, Loan has been Pushed to Management For @nd Approval",
          user_id: conn.assigns.user.id
        }

        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      # |> Ecto.Multi.run(:document, fn _repo, %{update_loan_status: _update_loan_status, user_logs: _user_logs} ->
      #   Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{"process_documents" => params, "conn" => conn, "customer_id" => params["customer_id"], "loan_id" => params["loan_id"], "fileName" => params["fileName"]})
      # end)
      |>Repo.transaction()
      |>case do
        {:ok, %{update_loan_status: update_loan_status}} ->
          reference_number = update_loan_status.reference_no
          requested_amount = update_loan_status.principal_amount
          user_details
          |> Enum.map(fn user ->
            try do UserBioData.where(userId: user.id) rescue _-> "" end
            |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
            end)
          end)
          conn
          |>put_flash(:info, "You have Successfully Approved the Loan and Reviewed Uploaded documents, Loan Has Moved Management")
          |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
      end
    end

    def admin_sme_loan_application_by_loan_officer(conn, params) do
      product_details = Loanmanagementsystem.Products.Product.find_by(id: params["product_id"])

      role_id = try do Role.find_by(role_group: "Credit Analyst").id rescue _-> "" end

      user_details = try do User.where(role_id: role_id)  rescue _-> "" end

      company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

      company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

      company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

      # params
      # |>IO.inspect(label: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")

      Ecto.Multi.new()
      |> Ecto.Multi.insert(:loan_application, Loans.changeset(%Loans{}, %{
        product_id: params["product_id"],
        customer_id: params["customer_id"],
        interest_method: params["interest_method"],
        loan_type: params["loan_type"],
        principal_amount: params["requested_amount"],
        loan_status: "PENDING_CREDIT_ANALYST",
        status: "PENDING_CREDIT_ANALYST_ASSESSMENT",
        company_id: params["company_id"],
        bank_name: params["bank_name"],
        bank_account_no: params["bank_account_no"],
        # interest_amount: params["interest_amount"],
        interest_amount: params["total_interest"],
        tenor: params["tenor_log"],
        requested_amount: params["requested_amount"],
        loan_duration_month: params["tenor_log"],
        monthly_installment: params["monthly_installment"],
        application_date: Date.utc_today,
        offtakerID: params["offtaker_id"],
        has_mou: params["has_mou"],
        total_repayment_derived: params["totalPayment"],
        repayment_amount: params["totalPayment"],
        # balance: params["totalPayment"],
        balance: 0.0,
        arrangement_fee: params["loan_arrangement_fee"],
        finance_cost: params["finance_cost"],
        reference_no: generate_reference_no(params["customer_id"]),
        loan_limit: params["loan_limit"],
        loan_officer_id: conn.assigns.user.id,
        init_interest_per: product_details.interest,
        init_arrangement_fee_per: product_details.arrangement_fee,
        init_finance_cost_per: product_details.finance_cost,

      }))


      |> Ecto.Multi.run(:loan_txn, fn _repo , %{loan_application: loan_application}->
          loan_txn_params = %{
            loan_id:  loan_application.id,
            customer_id: loan_application.customer_id,
            principal_amount: params["requested_amount"],
            is_disbursement: true,
            days_accrued: 0,
            total_interest_accrued: 0,
            total_finance_cost_accrued: 0,
            product_id: params["product_id"],
            txn_amount: params["requested_amount"],
            repaid_amount: 0,
            transaction_date: Timex.today(),
            created_by_id: conn.assigns.user.id,
            outstanding_balance: 0,

          }
          case Repo.insert(Loan_transactions.changeset(%Loan_transactions{}, loan_txn_params)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
          end
      end)

      |>Ecto.Multi.run(:user_logs, fn _repo , %{loan_application: loan_application, loan_txn: _loan_txn}->
        user_logs = %{
          activity: "Loan #{loan_application.loan_type} Initiation has Successfully Been Done ",
          user_id: conn.assigns.user.id
        }
        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |> Ecto.Multi.run(:document, fn _repo, %{loan_application: loan_application, user_logs: _user_logs} ->
        Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: loan_application.id}, params)
      end)
      |>Repo.transaction()
      |>case do
        {:ok, %{loan_application: loan_application}} ->
            LoanmanagementsystemWeb.LoanController.post_amortazation(params["requested_amount"], params["calculated_interest"], params["repayment"], Timex.today, loan_application.id, params["customer_id"], loan_application.reference_no)

            reference_number = loan_application.reference_no
            requested_amount = loan_application.principal_amount
            user_details
            |> Enum.map(fn user ->
              try do UserBioData.where(userId: user.id) rescue _-> "" end
              |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
              end)
            end)
          conn
          |>put_flash(:info, "You have Successfully Initiated a Loan Application, And has been Moved to the Credit Analyst")
          |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
      end
    end

    def admin_management_approval_without_documents(conn, params) do

      role_id = try do Role.find_by(role_group: "Credit Analyst").id rescue _-> "" end

      user_details = try do User.where(role_id: role_id)  rescue _-> "" end

      company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

      company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

      company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])

      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{
          "loan_status" => "PENDING_CREDIT_ANALYST",
          # "loan_status" => "PENDING_ACCOUNTANT_DISBURSEMENT",
          # "status"=> "APPROVED",
          "status"=> "PENDING_CREDIT_ANALYST_UPLOAD",
          "loan_limit" => params["loan_limit"],
          "approvedon_date" => params["approvedon_date"],
          "approvedon_userid" => conn.assigns.user.id,
          # "loan_funder" => params["loan_funder"]
        })
      ))
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status}->
        user_logs = %{
          activity: "Management Approval done Successfully",
          user_id: conn.assigns.user.id
        }

        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |>Repo.transaction()
      |>case do
        {:ok, %{update_loan_status: update_loan_status} } ->
          reference_number = update_loan_status.reference_no
          requested_amount = update_loan_status.principal_amount
          user_details
          |> Enum.map(fn user ->
            try do UserBioData.where(userId: user.id) rescue _-> "" end
            |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
            end)
          end)
          conn
          |>put_flash(:info, "You have Successfully Approved the Loan, And the loan has been pushed Back to the Credit Analyst")
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
      end
    end


    def admin_management_approval_without_documents_sme(conn, params) do

      role_id = try do Role.find_by(role_group: "Credit Analyst").id rescue _-> "" end

      user_details = try do User.where(role_id: role_id)  rescue _-> "" end

      company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

      company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

      company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end
      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])
      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{
          "loan_status" => "PENDING_CREDIT_ANALYST",
          # "loan_status" => "PENDING_ACCOUNTANT_DISBURSEMENT",
          # "status"=> "APPROVED",
          "status"=> "PENDING_CREDIT_ANALYST_UPLOAD",
          "loan_limit" => params["loan_limit"],
          "approvedon_date" => params["approvedon_date"],
          "approvedon_userid" => conn.assigns.user.id,
          # "loan_funder" => params["loan_funder"]
        })
      ))
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status}->
        user_logs = %{
          activity: "Management Approval done Successfully",
          user_id: conn.assigns.user.id
        }

        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |>Repo.transaction()
      |>case do
        {:ok, %{update_loan_status: update_loan_status}} ->
          reference_number = update_loan_status.reference_no
          requested_amount = update_loan_status.principal_amount
          user_details
          |> Enum.map(fn user ->
            try do UserBioData.where(userId: user.id) rescue _-> "" end
            |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
            end)
          end)
          conn
          |>put_flash(:info, "You have Successfully Approved the Loan, And the loan has been pushed Back to the Credit Analyst")
          |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
      end
    end


    def admin_review_credit_analyst_sme_upload_miz(conn, params) do
      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])
      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{

          "loan_status" => "PENDING_ACCOUNTANT_DISBURSEMENT",
          "status"=> "APPROVED",

          "loan_limit" => params["loan_limit"],
          "approvedon_date" => params["approvedon_date"],
          "approvedon_userid" => conn.assigns.user.id,
        })
      ))
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status}->
        user_logs = %{
          activity: "Credit Analyst Approval done Successfully",
          user_id: conn.assigns.user.id
        }

        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |> Ecto.Multi.run(:document, fn _repo, %{update_loan_status: update_loan_status, user_logs: _user_logs} ->
        Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan_status.id}, params)
      end)
      |>Repo.transaction()
      |>case do
        {:ok, _ } ->
          conn
          |>put_flash(:info, "You have Successfully Uplaod Requird Documents, And the loan has been pushed to the Accountant")
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
      end
    end

    def admin_review_credit_analyst_ordering_finance_upload_miz(conn, params) do

      role_id = try do Role.find_by(role_group: "Accountant").id rescue _-> "" end

      user_details = try do User.where(role_id: role_id)  rescue _-> "" end

      company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

      company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

      company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])

      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{

          "loan_status" => "PENDING_ACCOUNTANT_DISBURSEMENT",
          "status"=> "APPROVED",

          "loan_limit" => params["loan_limit"],
          "approvedon_date" => params["approvedon_date"],
          "approvedon_userid" => conn.assigns.user.id,
        })
      ))
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status}->
        user_logs = %{
          activity: "Credit Analyst Approval done Successfully",
          user_id: conn.assigns.user.id
        }

        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |> Ecto.Multi.run(:document, fn _repo, %{update_loan_status: update_loan_status, user_logs: _user_logs} ->
        Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan_status.id}, params)
      end)
      |>Repo.transaction()
      |>case do
        {:ok, %{update_loan_status: update_loan_status}} ->
          reference_number = update_loan_status.reference_no
          requested_amount = update_loan_status.principal_amount
          user_details
          |> Enum.map(fn user ->
            try do UserBioData.where(userId: user.id) rescue _-> "" end
            |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
            end)
          end)
          conn
          |>put_flash(:info, "You have Successfully Uplaod Requird Documents, And the loan has been pushed to the Accountant")
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
      end
    end



    def admin_review_credit_analyst_sme_loan_upload_miz(conn, params) do

      role_id = try do Role.find_by(role_group: "Accountant").id rescue _-> "" end

      user_details = try do User.where(role_id: role_id)  rescue _-> "" end

      company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

      company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

      company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])
      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{

          "loan_status" => "PENDING_ACCOUNTANT_DISBURSEMENT",
          "status"=> "APPROVED",

          "loan_limit" => params["loan_limit"],
          "approvedon_date" => params["approvedon_date"],
          "approvedon_userid" => conn.assigns.user.id,
        })
      ))
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status}->
        user_logs = %{
          activity: "Credit Analyst Approval done Successfully",
          user_id: conn.assigns.user.id
        }

        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |> Ecto.Multi.run(:document, fn _repo, %{update_loan_status: update_loan_status, user_logs: _user_logs} ->
        Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan_status.id}, params)
      end)
      |>Repo.transaction()
      |>case do
        {:ok, %{update_loan_status: update_loan_status}} ->
          reference_number = update_loan_status.reference_no
          requested_amount = update_loan_status.principal_amount
          user_details
          |> Enum.map(fn user ->
            try do UserBioData.where(userId: user.id) rescue _-> "" end
            |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
            end)
          end)
          conn
          |>put_flash(:info, "You have Successfully Uplaod Requird Documents, And the loan has been pushed to the Accountant")
          |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
      end
    end

    def admin_management_reject_without_documents(conn, params) do
      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])
      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{
          "loan_status" => "PENDING_LOAN_OFFICER",
          "status"=> "REJECTED",
          "rejectedon_date" => params["rejectedon_date"],
          "rejectedon_userid" => conn.assigns.user.id,
        })
      ))
      |>Ecto.Multi.run(:loan_assessment, fn _repo, %{update_loan_status: update_loan_status}->
        loan_assessment = %{
          comments: params["feedback"],
          customer_id: params["customer_id"],
          date: "#{Date.utc_today()}",
          date_received: "#{update_loan_status.application_date}",
          name: params["feedback_name"],
          position: "MANAGEMENT",
          recommended: params["feedback"],
          time_received: "#{Timex.now()}",
          user_type: "MANAGEMENT",
          loan_id: update_loan_status.id
        }
        case Repo.insert(Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, loan_assessment)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status, loan_assessment: _loan_assessment}->
        user_logs = %{
          activity: "Management Rejcted done Successfully",
          user_id: conn.assigns.user.id
        }

        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |>Repo.transaction()
      |>case do
        {:ok, _ } ->
          conn
          |>put_flash(:info, "You have Successfully Rejcted the Loan")
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
      end
    end



    def admin_management_reject_without_documents_sme_loan(conn, params) do
      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])
      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{
          "loan_status" => "PENDING_LOAN_OFFICER",
          "status"=> "REJECTED",
          "rejectedon_date" => params["rejectedon_date"],
          "rejectedon_userid" => conn.assigns.user.id,
        })
      ))
      |>Ecto.Multi.run(:loan_assessment, fn _repo, %{update_loan_status: update_loan_status}->
        loan_assessment = %{
          comments: params["feedback"],
          customer_id: params["customer_id"],
          date: "#{Date.utc_today()}",
          date_received: "#{update_loan_status.application_date}",
          name: params["feedback_name"],
          position: "MANAGEMENT",
          recommended: params["feedback"],
          time_received: "#{Timex.now()}",
          user_type: "MANAGEMENT",
          loan_id: update_loan_status.id
        }
        case Repo.insert(Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, loan_assessment)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status, loan_assessment: _loan_assessment}->
        user_logs = %{
          activity: "Management Rejcted done Successfully",
          user_id: conn.assigns.user.id
        }

        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |>Repo.transaction()
      |>case do
        {:ok, _ } ->
          conn
          |>put_flash(:info, "You have Successfully Rejcted the Loan")
          |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
      end
    end


    def admin_loan_officer_reject_without_documents(conn, params) do
      loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])
      Ecto.Multi.new()
      |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
        Map.merge(params, %{
          "loan_status" => "REJECTED",
          "status"=> "REJECTED",
        })
      ))
      |>Ecto.Multi.run(:loan_assessment, fn _repo, %{update_loan_status: update_loan_status}->
        loan_assessment = %{
          comments: params["feedback"],
          customer_id: params["customer_id"],
          date: "#{Date.utc_today()}",
          date_received: "#{update_loan_status.application_date}",
          name: params["feedback_name"],
          position: "SALES",
          recommended: params["feedback"],
          time_received: "#{Timex.now()}",
          user_type: "SALES",
          loan_id: update_loan_status.id
        }
        case Repo.insert(Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, loan_assessment)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status, loan_assessment: _loan_assessment}->
        user_logs = %{
          activity: "Loan Officer Confirmation of Rejected Loan Successfully",
          user_id: conn.assigns.user.id
        }

        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |>Repo.transaction()
      |>case do
        {:ok, _ } ->
          conn
          |>put_flash(:info, "You have Successfully Confirmed The Rejcted Loan")
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
      end
    end

    def account_invoice_discounting_view(conn, %{"loan_id" => loan_id}) do

      loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(loan_id)

      loan_details = Loanmanagementsystem.Loan.invoice_details_list(loan_id)

      render(conn, "account_invoice_discounting_view.html", loan_details: loan_details, loanDocs: loanDocs)

    end

    def view_invoice_discounting(conn, %{"loan_id" => loan_id}) do

      loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(loan_id)
      loan_details = Loanmanagementsystem.Loan.invoice_details_list(loan_id)
      loan_invoice_details = Loanmanagementsystem.Loan.loan_invoice_details(loan_id)

      render(conn, "invoice_discounting_view.html", loan_details: loan_details, loanDocs: loanDocs, loan_invoice_details: loan_invoice_details)
    end


    def mgt_view_invoice_discounting(conn, %{"loan_id" => loan_id}) do
      current_user = conn.assigns.user.id
      get_user_details = Loanmanagementsystem.Accounts.get_current_user_by_bio_data(current_user)
      loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(loan_id)
      loan_details = Loanmanagementsystem.Loan.invoice_details_list(loan_id)
      loan_invoice_details = Loanmanagementsystem.Loan.loan_invoice_details(loan_id)

      render(conn, "mgt_invoice_discounting_view.html", get_user_details: get_user_details, loan_details: loan_details, loanDocs: loanDocs, loan_invoice_details: loan_invoice_details)
    end

    def display_pdf(conn, %{"path" => path}), do: send_file( put_resp_header(conn, "content-type", "application/pdf"), 200, path)
    ############################################################################################# END #######################################################################################

    def admin_mgt_ordering_financing_loan_approval_miz(conn, %{"loan_id" => loan_id}) do
      current_user = conn.assigns.user.id

      IO.inspect(current_user, label: "----------------------------------current_user")
      get_user_details = Loanmanagementsystem.Operations.get_current_user_by_bio_data(current_user)
      loanDocs = Loanmanagementsystem.Operations.get_credit_invoice_docs(loan_id)
      loan_details = Loanmanagementsystem.Operations.ordering_finance_details(loan_id)
      credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)
      offtaker_details = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)

      render(conn, "admin_mgt_ordering_financing_loan_approval_miz.html", get_user_details: get_user_details, loan_details: loan_details, loanDocs: loanDocs, offtaker_details: offtaker_details, credit_loan_details: credit_loan_details)
    end



    def admin_mgt_ordering_financing_loan_reject_miz(conn, %{"loan_id" => loan_id}) do
      current_user = conn.assigns.user.id

      IO.inspect(current_user, label: "----------------------------------current_user")
      get_user_details = Loanmanagementsystem.Operations.get_current_user_by_bio_data(current_user)
      loanDocs = Loanmanagementsystem.Operations.get_credit_invoice_docs(loan_id)
      loan_details = Loanmanagementsystem.Operations.ordering_finance_details(loan_id)
      credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)
      offtaker_details = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)

      render(conn, "admin_mgt_ordering_financing_loan_reject_miz.html", get_user_details: get_user_details, loan_details: loan_details, loanDocs: loanDocs, offtaker_details: offtaker_details, credit_loan_details: credit_loan_details)
    end


    def admin_mgt_sme_loan_reject_miz(conn, %{"loan_id" => loan_id}) do
      current_user = conn.assigns.user.id

      IO.inspect(current_user, label: "----------------------------------current_user")
      get_user_details = Loanmanagementsystem.Operations.get_current_user_by_bio_data(current_user)
      loanDocs = Loanmanagementsystem.Operations.get_credit_invoice_docs(loan_id)
      loan_details = Loanmanagementsystem.Operations.ordering_finance_details(loan_id)
      credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)
      offtaker_details = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)

      render(conn, "admin_mgt_sme_loan_reject_miz.html", get_user_details: get_user_details, loan_details: loan_details, loanDocs: loanDocs, offtaker_details: offtaker_details, credit_loan_details: credit_loan_details)
    end


    def admin_loan_officer_ordering_financing_loan_reject_miz(conn, %{"loan_id" => loan_id}) do
      current_user = conn.assigns.user.id

      IO.inspect(current_user, label: "----------------------------------current_user")
      get_user_details = Loanmanagementsystem.Operations.get_current_user_by_bio_data(current_user)
      loanDocs = Loanmanagementsystem.Operations.get_credit_invoice_docs(loan_id)
      loan_details = Loanmanagementsystem.Operations.ordering_finance_details(loan_id)
      credit_loan_details = Loanmanagementsystem.Loan.invoice_credit_details_list(loan_id)
      offtaker_details = Loanmanagementsystem.Operations.ordering_finance_get_offtaker(loan_id)

      render(conn, "admin_loan_officer_ordering_financing_loan_reject_miz.html", get_user_details: get_user_details, loan_details: loan_details, loanDocs: loanDocs, offtaker_details: offtaker_details, credit_loan_details: credit_loan_details)
    end


    def admin_order_finance_application(conn, params) do
      product_details = Loanmanagementsystem.Products.Product.find_by(id: params["product_id"])

      IO.inspect(params, label: "--------------------------------params")
      bank_detail = String.split(params["bank_detail"], "|||")
      offtaker_details = String.split(params["offtaker_details"], "|||")

      role_id = try do Role.find_by(role_group: "Credit Analyst").id rescue _-> "" end

      user_details = try do User.where(role_id: role_id)  rescue _-> "" end

      company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

      company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

      company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

      params =
        Map.merge(params, %{
          "bank_account_no" => Enum.at(bank_detail, 1),
          "bank_name" => Enum.at(bank_detail, 0),
        })

        params =
        Map.merge(params, %{
          "offtaker_name" => Enum.at(offtaker_details, 1),
          "offtaker_id" => Enum.at(offtaker_details, 0),
        })

          # year = Date.utc_today|> Date.to_string |> String.split("-") |> Enum.at(0)
          # month = Date.utc_today|> Date.to_string |> String.split("-") |> Enum.at(1)
          # day = Date.utc_today|> Date.to_string |> String.split("-") |> Enum.at(2)

          # reference_date = "#{year}#{month}#{day}"
      Ecto.Multi.new()
      |>Ecto.Multi.insert(:loan_application, Loans.changeset(%Loans{}, %{
        product_id: params["product_id"],
        customer_id: params["customer_id"],
        interest_method: params["interest_method"],
        loan_type: params["loan_type"],
        principal_amount: params["requested_amount"],
        loan_status: "PENDING_CREDIT_ANALYST",
        status: "PENDING_CREDIT_ANALYST_ASSESSMENT",
        company_id: params["company_id"],
        bank_name: params["bank_name"],
        bank_account_no: params["bank_account_no"],
        # interest_amount: params["interest_amount"],
        interest_amount: params["total_interest"],
        tenor: params["tenor_log"],
        requested_amount: params["requested_amount"],
        loan_duration_month: params["tenor_log"],
        monthly_installment: params["monthly_installment"],
        application_date: Date.utc_today,
        offtakerID: params["offtaker_id"],
        has_mou: params["has_mou"],
        total_repayment_derived: params["totalPayment"],
        repayment_amount: params["totalPayment"],
        # balance: params["totalPayment"],
        balance: 0.0,
        arrangement_fee: params["loan_arrangement_fee"],
        finance_cost: params["finance_cost"],
        reference_no: generate_reference_no(params["customer_id"]),
        loan_limit: params["loan_limit"],
        loan_officer_id: conn.assigns.user.id,
        init_interest_per: product_details.interest,
        init_arrangement_fee_per: product_details.arrangement_fee,
        init_finance_cost_per: product_details.finance_cost,

      }))
      |> Ecto.Multi.run(:order_invoice, fn _repo, %{loan_application: loan_application} ->
        Order_finance_loan_invoice.changeset(%Order_finance_loan_invoice{}, %{
          item_description: params["item_description"],
          order_number: params["order_number"],
          order_date: params["order_date"],
          expected_due_date: params["expected_due_date"],
          order_value: params["order_value"],
          tenor: params["tenor"],
          status: "ACTIVE",
          loan_id: loan_application.id,
          customer_id: loan_application.customer_id
        })
        |> Repo.insert()
      end)

      |> Ecto.Multi.run(:loan_txn, fn _repo , %{loan_application: loan_application}->
          loan_txn_params = %{
            loan_id:  loan_application.id,
            customer_id: loan_application.customer_id,
            principal_amount: params["requested_amount"],
            is_disbursement: true,
            days_accrued: 0,
            total_interest_accrued: 0,
            total_finance_cost_accrued: 0,
            product_id: params["product_id"],
            txn_amount: params["requested_amount"],
            repaid_amount: 0,
            transaction_date: Timex.today(),
            created_by_id: conn.assigns.user.id,
            outstanding_balance: 0,

        }
        case Repo.insert(Loan_transactions.changeset(%Loan_transactions{}, loan_txn_params)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)

      |>Ecto.Multi.run(:user_logs, fn _repo , %{loan_application: loan_application}->
        user_logs = %{
          activity: "Loan #{loan_application.loan_type} Initiation has Successfully Been Done ",
          user_id: conn.assigns.user.id
        }
        case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |> Ecto.Multi.run(:documents, fn _repo, %{loan_application: loan_application, user_logs: _user_logs} ->
        Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: loan_application.id}, params)
      end)

      |>Repo.transaction()
      |>case do
        {:ok, %{loan_application: loan_application}} ->
            LoanmanagementsystemWeb.LoanController.post_amortazation(params["requested_amount"], params["calculated_interest"], params["repayment"], Timex.today, loan_application.id, params["customer_id"], loan_application.reference_no)

            reference_number = loan_application.reference_no
            requested_amount = params["requested_amount"]
            user_details
            |> Enum.map(fn user ->
              try do UserBioData.where(userId: user.id) rescue _-> "" end
              |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
              end)
            end)
          conn
          |>put_flash(:info, "You have Successfully Initiated a Loan Application, and it has been pushed to the Credit Analysts")
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
        {:error, _failed_operations, failed_value,  _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |>put_flash(:error, reason)
          |>redirect(to: Routes.loan_path(conn, :order_finance_application_datatable))
      end
    end

  def loans(conn, _params), do: render(conn, "loans.html")
  def pending_loans(conn, _params), do: render(conn, "pending_loans.html")
  def tracking_loans(conn, _params), do: render(conn, "tracking_loans.html")
  def disbursed_loans(conn, _params), do: render(conn, "disbursed_loans.html")
  def outstanding_loans(conn, _params), do: render(conn, "outstanding_loans.html")
  def return_off_loans(conn, _params), do: render(conn, "return_off_loans.html")

  def quick_advance_application_datatable(conn, _params),
    do: render(conn, "quick_advance_application.html")

  def consumer_loans_datatable(conn, _params),
    do: render(conn, "consumer_loans_list.html")


  def quick_loan_application_datatable(conn, _params),
    do: render(conn, "quick_loan_application.html")

  @spec float_advance_application_datatable(Plug.Conn.t(), any) :: Plug.Conn.t()
  def float_advance_application_datatable(conn, _params),
    do: render(conn, "float_advance_application.html")

  def order_finance_application_datatable(conn, _params),
    do: render(conn, "order_finance_loans_table.html")


    def sme_loan_application_datatable(conn, _params),
    do: render(conn, "sme_loan_application_datatable.html")

  def trade_advance_application_datatable(conn, _params),
    do: render(conn, "trade_advance_application.html")

  def current_time do
    {_erl_date, erl_time} = :calendar.local_time()
    {:ok, time} = Time.from_erl(erl_time)
    Calendar.strftime(time, "%c", preferred_datetime: "%H:%M:%S")
  end

  def universal_loan_application_capturing(conn, params) do

    banks = Loanmanagementsystem.Maintenance.list_tbl_banks()

    params
    |>IO.inspect(label: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx after OTP Success ")



   product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
    if product_type == "CONSUMER LOAN" do
      nrc = params["nrc"]
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      customers_address = try do Loanmanagementsystem.Accounts.get_client_address_details(client_data.userId) ||
      %{
        accomodation_status: "",
        area: "",
        house_number: "",
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
      customers_income = Loanmanagementsystem.Employment.list_income_details(client_data.userId)
      customers_employment = Loanmanagementsystem.Employment.list_employement(client_data.userId)
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
          banks: banks,
          customers_address: customers_address,
          nextofkin: nextofkin,
          customers_income: customers_income,
          customers_employment: customers_employment,
          reference_details: Loan.list_customer_reference_details(client_data.userId),
          market_info: Loan.list_business_market_info_validation_instant_loan(client_data.userId)

      )
   else
    if product_type == "SME LOAN" do
      registrationNumber = params["registrationNumber"]
      # client_data =

      render(conn, "sme_loan_application.html",
      banks: banks,
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        frequencies: Loanmanagementsystem.Products.Product_rates.find_by(product_id: params["product_id"]),
        client_data: Loanmanagementsystem.Companies.get_company_by_regNo(registrationNumber),
        loan_funders: Loanmanagementsystem.Loan.get_loan_funder_details()
      )
    else
      if product_type == "INVOICE DISCOUNTING" do
        registrationNumber = params["registrationNumber"]
        client_data = Loanmanagementsystem.Companies.get_company_by_regNo(registrationNumber)
        loan_funders = Loanmanagementsystem.Loan.get_loan_funder_details()

        render(conn, "invoice_discounting_capturing.html",
          offtaker_details: Loanmanagementsystem.Companies.offtaker_details_list,
          product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
          product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
          frequencies: Loanmanagementsystem.Products.Product_rates.find_by(product_id: params["product_id"]), client_data: client_data,
          loan_funders: loan_funders
        )
        else
          if product_type == "ORDER FINANCE" do
            registrationNumber = params["registrationNumber"]
            client_data = Loanmanagementsystem.Companies.get_company_by_regNo(registrationNumber)
            offtaker_details= Loanmanagementsystem.Companies.offtaker_details_list()
            loan_funders = Loanmanagementsystem.Loan.get_loan_funder_details()
            render(conn, "order_finance_application.html",
              product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
              product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
              frequencies: Loanmanagementsystem.Products.Product_rates.find_by(product_id: params["product_id"]),
              client_data: client_data,
              offtaker_details: offtaker_details,
              loan_funders: loan_funders
            )
          else
              conn
              |> put_flash(:error, "Something went wrong, try again.")
              |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end
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

  def edit_loan_application(conn, %{"loan_id" => loan_id}) do

    loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(loan_id)

    loan_details = Loanmanagementsystem.Loan.invoice_details_list(loan_id)

    render(conn, "edit_loan_application.html",loanDocs: loanDocs, loan_details: loan_details)
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

  # def order_finance_item_lookup(conn, params) do
  #   {draw, start, length, search_params} = search_options(params)
  #   results = Loanmanagementsystem.Loan.order_finance_list(search_params, start, length)
  #   total_entries = total_entries(results)
  #   entries = entries(results)

  #   results = %{
  #     draw: draw,
  #     recordsTotal: total_entries,
  #     recordsFiltered: total_entries,
  #     data: entries
  #   }

  #   json(conn, results)
  # end

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



  def order_finance_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.credit_analyst_pending_loans_approval_list(search_params, start, length)
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


  def sme_loan_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Operations.sme_loans__list(search_params, start, length)
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
    with(false <- params["product_id"] == "" || params["product_rate_tenor"] == "") do
      repayment_frequency =
        Loanmanagementsystem.Products.Product_rates.find_by(
          product_id: params["product_id"],
          tenor: params["product_rate_tenor"]
        ).repayment

      rate =
        Loanmanagementsystem.Products.Product_rates.find_by(
          product_id: params["product_id"],
          tenor: params["product_rate_tenor"]
        ).interest_rates

      processing_fee =
        Loanmanagementsystem.Products.Product_rates.find_by(
          product_id: params["product_id"],
          tenor: params["product_rate_tenor"]
        ).processing_fee

      currency =
        Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).currencyName

      principle_amt =
        try do
          String.to_integer(params["requested_amount"])
        rescue
          _ -> String.to_float(params["requested_amount"])
        end

      tenor =
        try do
          String.to_integer(params["product_rate_tenor"])
        rescue
          _ -> String.to_float(params["product_rate_tenor"])
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

    # IO.inspect(params["fileName"], label: "&&&&& check fileName &&&&&")

    product_details = Loanmanagementsystem.Products.Product.find_by(id: params["product_id"])

    role_id = try do Role.find_by(role_group: "Credit Analyst").id rescue _-> "" end

    user_details = try do User.where(role_id: role_id)  rescue _-> "" end

    IO.inspect(user_details, label: "-------------------------ROLE ID---------------------")

    last_name = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).lastName rescue _-> nil end

    first_name = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).firstName rescue _-> nil end

    client_name = "#{last_name} - #{first_name}"

    client_contact = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).mobileNumber rescue _-> nil end

    client_id_number = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).meansOfIdentificationNumber rescue _-> nil end



    # role_id = try do Role.find_by(role_group: "Credit Analyst").id rescue _-> "" end

    # user_details = try do User.where(role_id: role_id)  rescue _-> "" end

    # company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

    # company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

    # company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

    customer_id = params["customer_id"]

        # loan_type
        case params["loan_type"] do
          "CONSUMER LOAN" ->

                  new_params =
                    Map.merge(params, %{
                      "principal_amount_proposed" => params["requested_amount"],
                      "principal_amount" => params["requested_amount"],
                      "interest_amount" => params["total_interest"],
                      "arrangement_fee" => params["arrangement_fee"],
                      "finance_cost" => params["finance_cost"],
                      "repayment_amount" => params["totalPayment"],
                      "requested_amount" => params["requested_amount"],
                      "monthly_installment" => params["monthly_installment"],
                      "balance" => 0.0,
                      "company_id" => params["company_id"],
                      "tenor" => params["tenor_log"],
                      "number_of_repayments" => params["repayment"],
                      "loan_status" => "PENDING_CREDIT_ANALYST",
                      "status" => "PENDING_CREDIT_ANALYST",
                      "reference_no" =>  generate_reference_no(params["customer_id"]),
                      "loan_officer_id" => conn.assigns.user.id,
                      "init_interest_per" => product_details.interest,
                      "init_arrangement_fee_per" => product_details.arrangement_fee,
                      "init_finance_cost_per" => product_details.finance_cost,

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
                  #----------------------------------- Reference
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
                      IO.inspect(Enum.at(params["id_number_collateral"], x), label: "Test")

                      collateral_params =
                      %{
                        customer_id: params["customer_id"],
                        reference_no: new_params["reference_no"],
                        serialNo: Enum.at(params["id_number_collateral"], x),
                        asset_value: Enum.at(params["asset_value"], x),
                        color:  Enum.at(params["color"], x),
                        id_number: params["id_number"],
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
                      name_of_witness: params["name_of_witness"],
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


                |> Ecto.Multi.run(:loan_txn, fn _repo , %{add_loan: add_loan}->
                  loan_txn_params = %{
                    loan_id:  add_loan.id,
                    customer_id: add_loan.customer_id,
                    principal_amount: params["requested_amount"],
                    is_disbursement: true,
                    days_accrued: 0,
                    total_interest_accrued: 0,
                    total_finance_cost_accrued: 0,
                    product_id: params["product_id"],
                    txn_amount: params["requested_amount"],
                    repaid_amount: 0,
                    transaction_date: Timex.today(),
                    created_by_id: conn.assigns.user.id,
                    outstanding_balance: 0,

                  }
                  case Repo.insert(Loan_transactions.changeset(%Loan_transactions{}, loan_txn_params)) do
                  {:ok, message} -> {:ok, message}
                  {:error, reason}-> {:error, reason}
                  end
                end)



                  # |> Ecto.Multi.run(:client_document, fn _repo, %{add_loan: add_loan, user_logs: _user_logs} ->
                  #   IO.inspect(add_loan.id, label: "CHeck Loan ID here")
                  #   Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{"process_documents" => params, "conn" => conn, "customer_id" => params["customer_id"], "loan_id" => add_loan.id, "fileName" => params["fileName"]})

                  # end)

                  |> Repo.transaction()
                  |> case do
                    {:ok, %{add_loan: add_loan, user_logs: _user_logs, loan_txn: _loan_txn}} ->
                      reference_number = add_loan.reference_no
                      requested_amount = add_loan.principal_amount_proposed
                      user_details
                      |> Enum.map(fn user ->
                        try do UserBioData.where(userId: user.id) rescue _-> "" end
                        |> Enum.map(fn userbio -> Email.email_notify_next_approver_consumer(userbio.emailAddress, client_name, reference_number, requested_amount, client_id_number, client_contact)
                        end)
                      end)
                      Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: customer_id, loan_id: add_loan.id}, params)
                      # post_amortazation(loan_amount_v, interet_rate_v, term_in_months_v, calculation_date, loan_id, customer_id, reference_no)
                      LoanmanagementsystemWeb.LoanController.post_amortazation(params["requested_amount"], params["calculated_interest"], params["repayment"], Timex.today, add_loan.id, params["customer_id"], add_loan.reference_no)
                      conn
                      |> put_flash(:info, "Loan Application Successfully sent to Credit Analyst")
                      |> redirect(to: Routes.loan_path(conn, :consumer_loans_datatable))

                    {:error, _failed_operation, failed_value, _changes_so_far} ->
                      reason = traverse_errors(failed_value.errors) |> List.first()
                      conn
                      |> put_flash(:error, reason)
                      |> redirect(to: Routes.loan_path(conn, :consumer_loans_datatable))
                  end

          _ ->

              new_params =
                Map.merge(params, %{
                  "principal_amount_proposed" => params["requested_amount"],
                  "principal_amount" => params["requested_amount"],
                  "interest_amount" => params["total_interest"],
                  "repayment_amount" => params["totalPayment"],
                  "requested_amount" => params["requested_amount"],
                  "monthly_installment" => params["monthly_installment"],
                  "balance" => 0.0,
                  "tenor" => params["repayment"],
                  "loan_status" => "PENDING_CREDIT_ANALYST",
                  "status" => "PENDING_CREDIT_ANALYST",
                  "reference_no" =>  generate_reference_no(params["customer_id"]),
                  "loan_officer_id" => conn.assigns.user.id

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
                  IO.inspect(Enum.at(params["id_number_collateral"], x), label: "Test")

                  collateral_params =
                  %{
                    customer_id: params["customer_id"],
                    reference_no: new_params["reference_no"],
                    serialNo: Enum.at(params["id_number_collateral"], x),
                    asset_value: Enum.at(params["asset_value"], x),
                    color:  Enum.at(params["color"], x),
                    id_number: params["id_number"],
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
                  name_of_witness: params["name_of_witness"],
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
                {:ok, %{add_loan: add_loan, user_logs: _user_logs, colleteral_document: _colleteral_document}} ->
                  reference_number = add_loan.reference_no
                  requested_amount = add_loan.principal_amount_proposed
                  user_details
                  |> Enum.map(fn user ->
                    try do UserBioData.where(userId: user.id) rescue _-> "" end
                    |> Enum.map(fn userbio -> Email.email_notify_next_approver_consumer(userbio.emailAddress, client_name, reference_number, requested_amount, client_id_number, client_contact)
                    end)
                  end)


                  conn
                  |> put_flash(:info, "Loan Application Submitted")
                  |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

                {:error, _failed_operation, failed_value, _changes_so_far} ->
                  reason = traverse_errors(failed_value.errors) |> List.first()
                  conn
                  |> put_flash(:error, reason)
                  |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
              end

        end

  end


  def view_universal_loan_application(conn, params) do
    product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
    if product_type == "CONSUMER LOAN" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id: params["userId"], reference_no: params["reference_no"])
      ) do
      nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
      guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
      market_info = Loan.list_business_market_info(params["userId"], params["reference_no"])
      sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
      customers_income = Loanmanagementsystem.Employment.list_income_details(params["userId"])
      customers_employment = Loanmanagementsystem.Employment.list_employement(params["userId"])
      render(conn, "view_instant_loan_application.html",
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        customers_income: customers_income,
        customers_employment: customers_employment,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details,
        market_info: market_info,
        sales_recommedation: sales_recommedation
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
        collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
        extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
        guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
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
          guarantors_details: guarantors_details
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
          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
          guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
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
            employment_details: employment_details
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
    if product_type == "CONSUMER LOAN" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
      guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
      sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
      market_details = Loan.list_loan_market_info(params["userId"], params["reference_no"])
      render(conn, "edit_universal_loan_application.html",
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
        market_details: market_details
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
        collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
        extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
        guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
        render(conn, "edit_universal_loan_application.html",
          product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
          product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
          client_data: client_data,
          client_kyc: client_kyc,
          nextofkin: nextofkin,
          client_references: client_references,
          loan_details: loan_details,
          collateral_details: collateral_details,
          extracted_other_collateral_details: extracted_other_collateral_details,
          guarantors_details: guarantors_details
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
          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
          guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
          render(conn, "edit_salary_loan_application.html",
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
            employment_details: employment_details
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
    if product_type == "CONSUMER LOAN" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
      guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
      sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
      market_details = Loan.list_loan_market_info(params["userId"], params["reference_no"])
      render(conn, "edit_rejected_instant_loan_application.html",
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
        market_details: market_details
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
        collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
        extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
        guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
        render(conn, "edit_rejected_universal_loan_application.html",
          product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
          product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
          client_data: client_data,
          client_kyc: client_kyc,
          nextofkin: nextofkin,
          client_references: client_references,
          loan_details: loan_details,
          collateral_details: collateral_details,
          extracted_other_collateral_details: extracted_other_collateral_details,
          guarantors_details: guarantors_details
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
          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
          guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
          render(conn, "edit_rejected_salary_loan_application.html",
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
            employment_details: employment_details
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

      # -------------------------------------------Base 64 image Encoder
      applicant_signature = image_data_applicant_signature(params)
      applicant_signature_encode_img = if applicant_signature != false do parse_image(applicant_signature.path) else "" end
      witness_signature = image_data_witness_signature(params)
      witness_signature_encode_img = if witness_signature != false  do parse_image(witness_signature.path) else "" end
      cro_staff_signature = image_data_cro_staff_signature(params)
      cro_staff_signature_encode_img = if  cro_staff_signature != false do parse_image(cro_staff_signature.path) else "" end
      gaurantor_signature = image_data_gaurantor_signature(params)
      gaurantor_signature_encode_img = if gaurantor_signature != false do parse_image(gaurantor_signature.path) else "" end
      guarantor_witness_signature = image_data_guarantor_witness_signature(params)
      guarantor_witness_signature_encode_img = if guarantor_witness_signature != false do parse_image(guarantor_witness_signature.path) else "" end

      update_loan_collateral = Loan_applicant_collateral.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
      collateral_params = %{
            applicant_signature: if applicant_signature_encode_img == "" do  update_loan_collateral.applicant_signature else applicant_signature_encode_img end,
            name_of_witness:  params["name_of_witness"],
            witness_signature: if witness_signature_encode_img == "" do  update_loan_collateral.witness_signature else witness_signature_encode_img end,
            cro_staff_name:  params["cro_staff_name"],
            cro_staff_signature: if cro_staff_signature_encode_img == "" do  update_loan_collateral.cro_staff_signature else cro_staff_signature_encode_img end,
          }

        Ecto.Multi.new()
        |> Ecto.Multi.update(:update_loan_collateral, Loan_applicant_collateral.changeset(update_loan_collateral, collateral_params))
        |> Repo.transaction()
      # ----------------------------------- Guarantor
      update_loan_guarantor = Loan_applicant_guarantor.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no)
       applicant_guarantor_params = %{
          cost_of_sales: params["cost_of_sales"],
          occupation: params["occupation"],
          email: params["guarantor_email"],
          employer: params["employer"],
          gaurantor_sign_date: params["gaurantor_sign_date"],
          gaurantor_signature: if gaurantor_signature_encode_img == "" do  update_loan_guarantor.gaurantor_signature else gaurantor_signature_encode_img end,
          guarantor_name: params["guarantor_name"],
          guarantor_phone_no: params["guarantor_phone_no"],
          loan_applicant_name: params["loan_applicant_name"],
          name_of_cro_staff: params["gaurantor_cro_staff"],
          name_of_witness: params["name_of_witness"],
          guarantor_witness_signature: if guarantor_witness_signature_encode_img == "" do  update_loan_guarantor.guarantor_witness_signature else guarantor_witness_signature_encode_img end,
          witness_sign_date: params["witness_sign_date"],
          net_profit_loss: params["net_profit_loss"],
          nrc: params["guarantor_nrc"],
          other_expenses: params["other_expenses"],
          other_income_bills: params["other_income_bills"],
          relationship: params["guarantor_relationship"],
          salary_loan: params["salary_loan"],
          sale_business_rentals: params["sale_business_rentals"],
          staff_sign_date: params["staff_sign_date"],
          staff_signature: if cro_staff_signature_encode_img == "" do  update_loan_guarantor.staff_signature else cro_staff_signature_encode_img end,
          total_income_expense: params["total_income_expense"],
      }

      Ecto.Multi.new()
      |> Ecto.Multi.update(:update_loan_guarantor, Loan_applicant_guarantor.changeset(update_loan_guarantor, applicant_guarantor_params))
      |> Repo.transaction()
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


def update_salarybacked_loan_application(conn, params) do
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
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_employment_details, Loan_employment_info.changeset(update_employment_details, employment_details))
    |> Repo.transaction()
    #  -------------------------------------- CRO
    cro_recommendation = %{
      recommended: params["recommended_feedback"],
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      signature: params["signature_feedback"],
      position: params["position_feedback"],
      date: params["date_feedback"],
      time_received: params["time_received_feedback"],
      time_out: params["time_out_feedback"],
      date_received: params["date_received_feedback"],
    }
    update_cro_recommendation = Loan_recommendation_and_assessment.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no, user_type: "SALES")
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_cro_recommendation, Loan_recommendation_and_assessment.changeset(update_cro_recommendation, cro_recommendation))
    |> Repo.transaction()
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
    cro_recommendation = %{
      recommended: params["recommended_feedback"],
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      signature: params["signature_feedback"],
      position: params["position_feedback"],
      date: params["date_feedback"],
      time_received: params["time_received_feedback"],
      time_out: params["time_out_feedback"],
      date_received: params["date_received_feedback"],
    }
    update_cro_recommendation = Loan_recommendation_and_assessment.find_by(customer_id: update_loan.customer_id, reference_no: update_loan.reference_no, user_type: "SALES")
    Ecto.Multi.new()
    |> Ecto.Multi.update(:update_cro_recommendation, Loan_recommendation_and_assessment.changeset(update_cro_recommendation, cro_recommendation))
    |> Repo.transaction()
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
    Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
      customer_id: params["customer_id"],
      reference_no: new_params["reference_no"],
      recommended: params["recommended_feedback"],
      user_type: "SALES",
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      signature: params["signature_feedback"],
      position: params["position_feedback"],
      date: params["date_feedback"],
      time_received: params["time_received_feedback"],
      time_out: params["time_out_feedback"],
      date_received: params["date_received_feedback"],
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
      conn
      |> put_flash(:info, "Loan Application Submitted")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors) |> List.first()
      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
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
    # -------------------------------------- Recommendation
    Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
      customer_id: params["customer_id"],
      reference_no: new_params["reference_no"],
      recommended: params["recommended_feedback"],
      user_type: "SALES",
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      signature: params["signature_feedback"],
      position: params["position_feedback"],
      date: params["date_feedback"],
      time_received: params["time_received_feedback"],
      time_out: params["time_out_feedback"],
      date_received: params["date_received_feedback"],
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
      conn
      |> put_flash(:info, "Loan Application Submitted")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors) |> List.first()
      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  end
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

def create_loan_reference(conn, params) do
  with(
    loan_details when loan_details  != nil <- Loanmanagementsystem.Loan.Loans.find_by(id: params["id"])
  ) do
  new_params = Map.merge(params, %{
    "customer_id" => loan_details.customer_id,
    "reference_no" =>  loan_details.reference_no,
  })
  Ecto.Multi.new()
  |> Ecto.Multi.insert(:add_reference, Loan_applicant_reference.changeset(%Loan_applicant_reference{}, new_params))
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

def operations_loan_approval(conn, params) do
  loan_details = Loans.find_by(id: params["loan_id"])
  new_param =  %{
    "loan_status" => "PENDING_MANAGEMENT",
    "status" => "PENDING_MANAGEMENT",
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
      user_type: "OPERATIONS",
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      signature: params["signature_feedback"],
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


def view_before_approving_loan_application_operations(conn, params) do
  IO.inspect(params, label: " hello ba mukabene")
  product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
  # IO.inspect(params, label: "Hello ba Teddy")
  current_user = conn.assigns.user.id

    if product_type == "CONSUMER LOAN" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"]),
        client_type when client_type != nil <- Loanmanagementsystem.Accounts.UserRole.find_by(userId:  params["userId"]).roleType
        ) do
                  case client_type do
                    "EMPLOYEE" ->

                          client_address_details = Loanmanagementsystem.Accounts.Address_Details.find_by(userId:  params["userId"])

                          nrc = client_details.id_number
                          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
                          get_user_details = Loanmanagementsystem.Accounts.get_current_user_by_bio_data(current_user)
                          loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(params["loan_id"])
                          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
                          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
                          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
                          loan_details = Loan.list_customer_loan_details(params["loan_id"], params["reference_no"])
                          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
                          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
                          guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
                          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
                          market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
                          render(conn, "operation_consumer_loan_employee_approval.html",
                            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
                            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
                            client_data: client_data,
                            client_kyc: client_kyc,
                            get_user_details: get_user_details,
                            loanDocs: loanDocs,
                            nextofkin: nextofkin,
                            client_address_details: client_address_details,
                            client_references: client_references,
                            loan_details: loan_details,
                            collateral_details: collateral_details,
                            extracted_other_collateral_details: extracted_other_collateral_details,
                            guarantors_details: guarantors_details,
                            sales_recommedation: sales_recommedation,
                            market_info: market_info
                          )

                      _ ->

                          client_address_details = Loanmanagementsystem.Accounts.Address_Details.find_by(userId:  params["userId"])

                          nrc = client_details.id_number
                          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
                          get_user_details = Loanmanagementsystem.Accounts.get_current_user_by_bio_data(current_user)
                          loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(params["loan_id"])
                          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
                          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
                          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
                          loan_details = Loan.list_customer_loan_details(params["loan_id"], params["reference_no"])
                          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
                          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
                          guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
                          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
                          market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
                          render(conn, "operation_consumer_loan_employee_approval.html",
                            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
                            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
                            client_data: client_data,
                            client_kyc: client_kyc,
                            get_user_details: get_user_details,
                            loanDocs: loanDocs,
                            nextofkin: nextofkin,
                            client_address_details: client_address_details,
                            client_references: client_references,
                            loan_details: loan_details,
                            collateral_details: collateral_details,
                            extracted_other_collateral_details: extracted_other_collateral_details,
                            guarantors_details: guarantors_details,
                            sales_recommedation: sales_recommedation,
                            market_info: market_info,
                          )
                  end
              else
                _ ->
                conn
                |> put_flash(:error, "Something went wrong, try again. CONSUMER LOAN")
                |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
              end

    else
      if product_type == "ORDER FINANCE" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
      nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
      guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
      sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
      render(conn, "operations_approve_universal_loan_application.html",
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
      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again. ORDER FINANCE")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

      else
        if product_type == "SME LOAN" do
          with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
            nrc = client_details.id_number
            client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
            client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
            nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
            client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
            loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
            collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
            extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
            guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
            sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
          render(conn, "operations_salary_loan_application.html",
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
          )
          else
            _ ->
            conn
            |> put_flash(:error, "Something went wrong, try again. SME LOAN")
            |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
          end

        else
          if product_type == "INVOICE DISCOUNTING" do
            IO.inspect(params["loan_id"], label: "Hello ba Teddy")
            IO.inspect(params["reference_no"], label: "Hello ba Teddy")

            with(client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["loan_id"], reference_no: params["reference_no"])) do
             nrc = client_details.id_number

            client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
            loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(params["loan_id"])
            client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
            nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
            client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
            loan_details = Loan.list_customer_loan_details(params["loan_id"], params["reference_no"])
            collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
            extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
            guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
            sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
            employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
            render(conn, "operations_salary_loan_application.html",
              product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
              product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
              client_data: client_data,
              client_kyc: client_kyc,
              nextofkin: nextofkin,
              loanDocs: loanDocs,
              client_references: client_references,
              loan_details: loan_details,
              collateral_details: collateral_details,
              extracted_other_collateral_details: extracted_other_collateral_details,
              guarantors_details: guarantors_details,
              sales_recommedation: sales_recommedation,
              employment_details: employment_details
            )
            else
              _ ->
              conn
              |> put_flash(:error, "Something went wrong, try again. INVOICE DISCOUNTING")
              |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
            end


          end
        end


      end
    end
end


def view_before_approving_loan_application(conn, params) do
  IO.inspect(params, label: "Hello Muhammad")
  current_user = conn.assigns.user.id
  product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
    if product_type == "CONSUMER LOAN" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"]),
        client_type when client_type != nil <- Loanmanagementsystem.Accounts.UserRole.find_by(userId:  params["userId"]).roleType

      ) do

      case client_type do
        "EMPLOYEE" ->

                client_address_details = Loanmanagementsystem.Accounts.Address_Details.find_by(userId:  params["userId"])

                IO.inspect(params["reference_no"], label: "!!!!!!!!!!!!!! CHeck my reference_no !!!!!!!!!!!!!!")
                # collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
                # extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
                nrc = client_details.id_number
                client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
                IO.inspect(client_data, label: "Check client_data")
                funder_details = Loanmanagementsystem.Loan.get_funder_details()
                get_user_details = Loanmanagementsystem.Accounts.get_current_user_by_bio_data(current_user)
                loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(params["loan_id"])
                client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
                nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
                client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
                loan_details = Loan.list_customer_loan_details(params["loan_id"], params["reference_no"])
                guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
                sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
                market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
                render(conn, "credit_analyst_instant_loan_employee_approval.html",
                  product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
                  product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
                  client_data: client_data,
                  client_kyc: client_kyc,
                  nextofkin: nextofkin,
                  client_references: client_references,
                  loan_details: loan_details,
                  loanDocs: loanDocs,
                  funder_details: funder_details,
                  get_user_details: get_user_details,
                  # collateral_details: collateral_details,
                  # extracted_other_collateral_details: extracted_other_collateral_details,
                  guarantors_details: guarantors_details,
                  sales_recommedation: sales_recommedation,
                  market_info: market_info,
                  client_address_details: client_address_details
                )
        _ ->

                      nrc = client_details.id_number
                      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
                      IO.inspect(client_data, label: "Check client_data")

                      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
                      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
                      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
                      loan_details = Loan.list_customer_loan_details(params["loan_id"], params["reference_no"])
                      loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(params["loan_id"])
                      collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])

                      extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
                      guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
                      IO.inspect(guarantors_details, label: "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ CHeck my collateral_details @@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                      sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
                      market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
                      render(conn, "credit_analyst_instant_loan_application.html",
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
                        loanDocs: loanDocs
                      )
        end

      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "ORDER FINANCE" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
      nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
      guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
      render(conn, "approve_universal_loan_application.html",
        product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
        product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
        client_data: client_data,
        client_kyc: client_kyc,
        nextofkin: nextofkin,
        client_references: client_references,
        loan_details: loan_details,
        collateral_details: collateral_details,
        extracted_other_collateral_details: extracted_other_collateral_details,
        guarantors_details: guarantors_details
      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

      else
        if product_type == "SME LOAN" do
          with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
          guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
          render(conn, "credit_analyst_salary_loan_application.html",
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


        if product_type == "INVOICE DISCOUNTING" do
          with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
          guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
          render(conn, "credit_analyst_salary_loan_application.html",
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
  if product_type == "CONSUMER LOAN" do
    with(
      client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
    ) do
     nrc = client_details.id_number
    client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
    client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
    nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
    client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
    loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
    collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
    extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
    sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
    market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
    credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
    render(conn, "credit_manager_instant_loan_application.html",
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
    )
    else
      _ ->
      conn
      |> put_flash(:error, "Something went wrong, try again.")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end


  else
    if product_type == "ORDER FINANCE" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
      guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
      credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
      render(conn, "credit_manager_loan_application_approval.html",
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

      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "SME LOAN" do
        with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
          guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
          credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
          render(conn, "credit_manager_salary_loan_application.html",
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

      if product_type == "INVOICE DISCOUNTING" do
        with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
          guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
          credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
          render(conn, "credit_manager_salary_loan_application.html",
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
  if product_type == "CONSUMER LOAN" do
    with(
      client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
    ) do
     nrc = client_details.id_number
    client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
    client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
    nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
    client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
    loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
    collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
    extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
    sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
    market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
    credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
    credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
    render(conn, "accounts_asistant_instant_loan_application.html",
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
    )
    else
      _ ->
      conn
      |> put_flash(:error, "Something went wrong, try again.")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end


  else
    if product_type == "ORDER FINANCE" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
      guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
      credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
      credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
      render(conn, "accounts_asistant_loan_application_approval.html",
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

      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "SME LOAN" do
        with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
          guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
          credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
          credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
          render(conn, "accounts_asistant_salary_loan_application.html",
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
      if product_type == "INVOICE DISCOUNTING" do
        with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
          guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
          credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
          credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
          render(conn, "accounts_asistant_salary_loan_application.html",
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
  if product_type == "CONSUMER LOAN" do
    with(
      client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"]),
      client_type when client_type != nil <- Loanmanagementsystem.Accounts.UserRole.find_by(userId:  params["userId"]).roleType
      ) do
        case client_type do
          "EMPLOYEE" ->
                          client_address_details = Loanmanagementsystem.Accounts.Address_Details.find_by(userId:  params["userId"])
                              nrc = client_details.id_number
                              client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
                              client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
                              nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
                              client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
                              loan_details = Loan.list_customer_loan_details(params["loan_id"], params["reference_no"])
                              loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(params["loan_id"])
                              collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
                              extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
                              sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
                              market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
                              credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
                              credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
                              accounts_assistant_recommedation = Loan.list_accounts_assistant_recommendation(params["userId"], params["reference_no"])
                              render(conn, "accountant_consumer_loan_employee_approval.html",
                            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
                            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
                            client_data: client_data,
                            client_kyc: client_kyc,
                            nextofkin: nextofkin,
                            loanDocs: loanDocs,
                            client_references: client_references,
                            loan_details: loan_details,
                            collateral_details: collateral_details,
                            extracted_other_collateral_details: extracted_other_collateral_details,
                            sales_recommedation: sales_recommedation,
                            market_info: market_info,
                            credit_analyst_recommedation: credit_analyst_recommedation,
                            credit_manager_recommedation: credit_manager_recommedation,
                            accounts_assistant_recommedation: accounts_assistant_recommedation,
                            client_address_details: client_address_details
                          )

                      _ ->

                          client_address_details = Loanmanagementsystem.Accounts.Address_Details.find_by(userId:  params["userId"])
                          nrc = client_details.id_number
                          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
                          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
                          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
                          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
                          loan_details = Loan.list_customer_loan_details(params["loan_id"], params["reference_no"])
                          loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(params["loan_id"])
                          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
                          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
                          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
                          market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
                          credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
                          credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
                          accounts_assistant_recommedation = Loan.list_accounts_assistant_recommendation(params["userId"], params["reference_no"])
                          render(conn, "accountant_consumer_loan_employee_approval.html",
                            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
                            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
                            client_data: client_data,
                            client_kyc: client_kyc,
                            nextofkin: nextofkin,
                            loanDocs: loanDocs,
                            client_references: client_references,
                            loan_details: loan_details,
                            collateral_details: collateral_details,
                            extracted_other_collateral_details: extracted_other_collateral_details,
                            sales_recommedation: sales_recommedation,
                            market_info: market_info,
                            credit_analyst_recommedation: credit_analyst_recommedation,
                            credit_manager_recommedation: credit_manager_recommedation,
                            accounts_assistant_recommedation: accounts_assistant_recommedation,
                            client_address_details: client_address_details
                          )
        end
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

  else
    if product_type == "ORDER FINANCE" do
      with(
    client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
      nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
      guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
      credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
      credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
      accounts_assistant_recommedation = Loan.list_accounts_assistant_recommendation(params["userId"], params["reference_no"])
      render(conn, "finance_manager_loan_application_approval.html",
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

      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "SME LOAN" do
        with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
          guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
          credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
          credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
          accounts_assistant_recommedation = Loan.list_accounts_assistant_recommendation(params["userId"], params["reference_no"])
          render(conn, "finance_manager_salary_loan_application.html",
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
      if product_type == "INVOICE DISCOUNTING" do
        with(
            client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
          ) do
           nrc = client_details.id_number
          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
          loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
          guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
          employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
          credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
          credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
          accounts_assistant_recommedation = Loan.list_accounts_assistant_recommendation(params["userId"], params["reference_no"])
          render(conn, "finance_manager_salary_loan_application.html",
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
  current_user = conn.assigns.user.id
  product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
  if product_type == "CONSUMER LOAN" do
    with(
      client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"]),
      client_type when client_type != nil <- Loanmanagementsystem.Accounts.UserRole.find_by(userId:  params["userId"]).roleType
      ) do
            case client_type do
              "EMPLOYEE" ->

                          nrc = client_details.id_number
                          positions = Loanmanagementsystem.Operations.get_current_user_by_bio_data(current_user)
                          current_user_role_id= Loanmanagementsystem.Accounts.User.find_by(id: current_user).role_id
                          current_user_role = Loanmanagementsystem.Accounts.Role.find_by(id: current_user_role_id).role_group
                          client_address_details = Loanmanagementsystem.Accounts.Address_Details.find_by(userId:  params["userId"])
                          get_user_details = Loanmanagementsystem.Accounts.get_current_user_by_bio_data(current_user)
                          loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(params["loan_id"])
                          client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
                          client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
                          nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
                          client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
                          loan_details = Loan.list_customer_loan_details(params["loan_id"], params["reference_no"])
                          collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
                          extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
                          sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
                          market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
                          credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
                          credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
                          accounts_assistant_recommedation = Loan.list_accounts_assistant_recommendation(params["userId"], params["reference_no"])
                          finance_manager_recommedation = Loan.list_finance_manager_recommendation(params["userId"], params["reference_no"])
                          render(conn, "management_consumer_loan_employee_approval.html",
                            product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
                            product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
                            client_data: client_data,
                            client_kyc: client_kyc,
                            client_address_details: client_address_details,
                            get_user_details: get_user_details,
                            loanDocs: loanDocs,
                            nextofkin: nextofkin,
                            current_user_role: current_user_role,
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
                            positions: positions
                          )

                    _ ->

                            nrc = client_details.id_number
                            positions = Loanmanagementsystem.Operations.get_current_user_by_bio_data(current_user)
                            current_user_role_id= Loanmanagementsystem.Accounts.User.find_by(id: current_user).role_id
                            current_user_role = Loanmanagementsystem.Accounts.Role.find_by(id: current_user_role_id).role_group
                            client_address_details = Loanmanagementsystem.Accounts.Address_Details.find_by(userId:  params["userId"])
                            get_user_details = Loanmanagementsystem.Accounts.get_current_user_by_bio_data(current_user)
                            loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(params["loan_id"])
                            client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
                            client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
                            nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
                            client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
                            loan_details = Loan.list_customer_loan_details(params["loan_id"], params["reference_no"])
                            collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
                            extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
                            sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
                            market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
                            credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
                            credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
                            accounts_assistant_recommedation = Loan.list_accounts_assistant_recommendation(params["userId"], params["reference_no"])
                            finance_manager_recommedation = Loan.list_finance_manager_recommendation(params["userId"], params["reference_no"])
                              render(conn, "management_consumer_loan_employee_approval.html",
                                product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
                                product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
                                client_data: client_data,
                                client_kyc: client_kyc,
                                client_address_details: client_address_details,
                                get_user_details: get_user_details,
                                loanDocs: loanDocs,
                                nextofkin: nextofkin,
                                current_user_role: current_user_role,
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
                                positions: positions
                              )


            end
    else
      _ ->
      conn
      |> put_flash(:error, "Something went wrong, try again.")
      |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
    end

  else
    if product_type == "ORDER FINANCE" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
      ) do
       nrc = client_details.id_number
      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
      loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
      collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
      guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
      credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
      credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
      accounts_assistant_recommedation = Loan.list_accounts_assistant_recommendation(params["userId"], params["reference_no"])
      finance_manager_recommedation = Loan.list_finance_manager_recommendation(params["userId"], params["reference_no"])
      render(conn, "executive_committe_loan_application_approval.html",
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

      )
      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else
      if product_type == "SME LOAN" do
        with(
          client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
        ) do
         nrc = client_details.id_number
        client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
        client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
        nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
        client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
        loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
        collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
        extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
        guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
        sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
        employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
        credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
        credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
        accounts_assistant_recommedation = Loan.list_accounts_assistant_recommendation(params["userId"], params["reference_no"])
        finance_manager_recommedation = Loan.list_finance_manager_recommendation(params["userId"], params["reference_no"])
        render(conn, "executive_committe_salary_loan_application.html",
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
      if product_type == "INVOICE DISCOUNTING" do
        with(
          client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"])
        ) do
         nrc = client_details.id_number
        client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
        client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
        nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
        client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
        loan_details = Loan.list_customer_loan_details(params["userId"], params["reference_no"])
        collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
        extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
        guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
        sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
        employment_details = Loan.list_employment_info(params["userId"], params["reference_no"])
        credit_analyst_recommedation = Loan.list_credit_analyst_recommendation(params["userId"], params["reference_no"])
        credit_manager_recommedation = Loan.list_credit_manager_recommendation(params["userId"], params["reference_no"])
        accounts_assistant_recommedation = Loan.list_accounts_assistant_recommendation(params["userId"], params["reference_no"])
        finance_manager_recommedation = Loan.list_finance_manager_recommendation(params["userId"], params["reference_no"])
        render(conn, "executive_committe_salary_loan_application.html",
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


def credit_analyst_loan_approval(conn, params) do
  loan_details = Loans.find_by(id: params["loan_id"])
  new_param =  %{
    "loan_status" => "PENDING_ACCOUNTANT",
    "status" => "PENDING_ACCOUNTANT",
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
      user_type: "CREDIT_ANALYST",
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      signature: params["signature_feedback"],
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

def credit_manager_loan_approval(conn, params) do
  loan_details = Loans.find_by(id: params["loan_id"])
  new_param =  %{
    "loan_status" => "PENDING_ACCOUNTS_ASSISTANT",
    "status" => "PENDING_ACCOUNTS_ASSISTANT",
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
      signature: params["signature_feedback"],
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
      user_type: "ACCOUNTS",
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      signature: params["signature_feedback"],
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
    "loan_status" => "PENDING_OPERATIONS_MANAGER",
    "status" => "PENDING_OPERATIONS_MANAGER",
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
      user_type: "ACCOUNTANT",
      on_hold: params["on_hold_feedback"],
      file_sent_to_sale: params["file_sent_to_sale_feedback"],
      comments: params["comments_feedback"],
      name: params["name_feedback"],
      signature: params["signature_feedback"],
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
  new_param =  %{
    "loan_status" => "APPROVED",
    "status" => "APPROVED",
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
          "balance" => 0.0
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
    product_details = Loanmanagementsystem.Products.get_products()
    render(conn, "select_quick_advance.html", product_details: product_details)
  end

  def get_otp(conn, %{"product_id" => product_id}) do

    get_product_type = Loanmanagementsystem.Products.Product.find_by(id:  product_id)

    case get_product_type.productType do

      "CONSUMER LOAN" ->
      render(conn, "get_otp.html", product_id: product_id)

      "INVOICE DISCOUNTING" ->
      render(conn, "get_company_otp.html", product_id: product_id)

      "ORDER FINANCE" ->
      render(conn, "get_company_otp.html", product_id: product_id)

      "SME LOAN" ->
      render(conn, "get_company_otp.html", product_id: product_id)

    end

  end

  def otp_validation(conn, %{"client_line" => client_line, "product_id" => product_id, "nrc" => nrc}) do
    render(conn, "otp_validation.html", client_line: client_line, product_id: product_id, nrc: nrc)
  end

  def send_otp(conn, params) do
    IO.inspect(params, label: "Hello TEST ************************")

    nrc =  to_string(params["nrc"])
    product_id = params["product_id"]

    check_customer = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
    IO.inspect check_customer, label: "check_customer---------------------"

    # if Enum.count(check_customer) > 0 do
      if check_customer != nil do

      client_line = check_customer.mobileNumber
      generate_otp = to_string(Enum.random(1111..9999))
      text = "To verify your loan initiation, please provide the OTP - #{generate_otp}"
      params = Map.put(params, "mobile", client_line)
      params = Map.put(params, "msg", text)
      params = Map.put(params, "status", "READY")
      params = Map.put(params, "type", "SMS")
      params = Map.put(params, "msg_count", "1")

      my_client_role = Loanmanagementsystem.Accounts.get_user_role!(check_customer.role_id)

      Loanmanagementsystem.Accounts.update_user_role(my_client_role, %{otp: generate_otp})
      # Loanmanagementsystem.Accounts.update_user_role(my_client_role, %{otp: "1234"})


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
              # Loanmanagementsystem.Workers.Sms.send()
              conn
              |> put_flash(:info, "OTP has been sent to your Mobile Number")
              |> redirect(to: Routes.loan_path(conn, :otp_validation, client_line: "#{client_line}", product_id: "#{product_id}", nrc: "#{nrc}"))

          {:error, _failed_operation, _failed_value, _changes_so_far} ->

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

  def company_otp_validation(conn, %{"client_line" => client_line, "product_id" => product_id, "registrationNumber" => registrationNumber} = _params) do

    render(conn, "company_otp_validation.html", client_line: client_line, product_id: product_id, registrationNumber: registrationNumber)
  end

  def send_company_otp(conn, params) do
    IO.inspect(params, label: "Company Application ************************")

    registrationNumber = params["registrationNumber"]
    product_id = params["product_id"]

    check_customer = Loanmanagementsystem.Companies.get_company_by_regNo(registrationNumber)
    IO.inspect check_customer, label: "check_customer---------------------"

    # if Enum.count(check_customer) > 0 doLoanmanagementsystem.Companies.get_company_by_regNo("10029388433")
      if check_customer != nil do

      client_line = check_customer.companyPhone
      generate_otp = to_string(Enum.random(1111..9999))
      text = "To verify your loan initiation, please provide the OTP - #{generate_otp}"
      params = Map.put(params, "mobile", client_line)
      params = Map.put(params, "msg", text)
      params = Map.put(params, "status", "READY")
      params = Map.put(params, "type", "SMS")
      params = Map.put(params, "msg_count", "1")

      my_client_role = Loanmanagementsystem.Accounts.get_user_role!(check_customer.role_id)

      Loanmanagementsystem.Accounts.update_user_role(my_client_role, %{otp: generate_otp})
      # Loanmanagementsystem.Accounts.update_user_role(my_client_role, %{otp: "1234"})


      Ecto.Multi.new()
        |> Ecto.Multi.insert(:loan_otp, Sms.changeset(%Sms{}, params))
        |> Ecto.Multi.run(:user_logs, fn _repo, %{loan_otp: _loan_otp} ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Company loan inititation OTP Successfully sent to company phone number (#{client_line})",
            user_id: conn.assigns.user.id
          })
          |> Repo.insert()
        end)
          |> Repo.transaction()
          |> case do
            {:ok, %{loan_otp: _loan_otp, user_logs: _user_logs}} ->
              # Loanmanagementsystem.Workers.Sms.send()
              conn
              |> put_flash(:info, "OTP has been sent to company phone Number")
              |> redirect(to: Routes.loan_path(conn, :company_otp_validation, client_line: "#{client_line}", product_id: "#{product_id}", registrationNumber: "#{registrationNumber}"))

          {:error, _failed_operation, _failed_value, _changes_so_far} ->

        end
    else
      conn
        |> put_flash(:error, "The company Registration number you entered is not registered, Please Check the Registration number and try again.")
        |> redirect(to: Routes.loan_path(conn, :get_otp, product_id: "#{product_id}"))

    end
  end

  # def validate_company_otp(conn, params) do

  #   params
  #   |> IO.inspect(label: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-------------------- after confirmation")

  #   registrationNumber = params["registrationNumber"]
  #   product_id = params["product_id"]

  #   # generate_otp = to_string(Enum.random(1111..9999))

  #   otp1 = params["otp1"]
  #   otp2 = params["otp2"]
  #   otp3 = params["otp3"]
  #   otp4 = params["otp4"]
  #   user_otp = "#{otp1}#{otp2}#{otp3}#{otp4}"

  #   client_role = Loanmanagementsystem.Companies.get_company_by_regNo(registrationNumber)

  #   client_line = client_role.mobileNumber
  #   my_client_role = Loanmanagementsystem.Accounts.get_user_role!(client_role.role_id)

  #   company_rep = Loanmanagementsystem.Accounts.UserRole.find_by(userId: client_role.user_bio_id)

  #   loan_otp = company_rep.otp

  #   if loan_otp == user_otp && user_otp != nil do


  #         Ecto.Multi.new()
  #         |> Ecto.Multi.update(
  #           :otp_validate,
  #           UserRole.changeset(
  #             my_client_role,
  #             Map.merge(params, %{"otp" => ""})
  #           )
  #         )
  #         |> Ecto.Multi.run(:user_logs, fn _, %{otp_validate: _otp_validate} ->
  #           UserLogs.changeset(%UserLogs{}, %{
  #             activity: "OTP Validated Successfully ",
  #             user_id: conn.assigns.user.id
  #           })
  #           |> Repo.insert()
  #         end)
  #         |> Repo.transaction()
  #         |> case do
  #           {:ok, %{otp_validate: _otp_validate, user_logs: _user_logs}} ->
  #             conn
  #             |> put_flash(:info, "OTP Validated Successfully Proceed With Your Loan Application")
  #             |> redirect(to: Routes.loan_path(conn, :universal_loan_application_capturing, client_line: "#{client_line}", product_id: "#{product_id}", registrationNumber: "#{registrationNumber}"))

  #           {:error, _failed_operation, failed_value, _changes_so_far} ->
  #             reason = traverse_errors(failed_value.errors) |> List.first()

  #             conn
  #             |> put_flash(:error, reason)
  #             |> redirect(to: Routes.loan_path(conn, :company_otp_validation))
  #         end
  #   else

  #   conn
  #     |> put_flash(:error, "OTP does not match")
  #     |> redirect(to: Routes.loan_path(conn, :company_otp_validation, client_line: "#{client_line}", product_id: "#{product_id}", registrationNumber: "#{registrationNumber}"))


  #   end
  # end

  def validate_company_otp(conn, params) do

    params
    |> IO.inspect(label: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-------------------- after confirmation")

    registrationNumber = params["registrationNumber"]
    product_id = params["product_id"]

    # generate_otp = to_string(Enum.random(1111..9999))



    otp1 = params["otp1"]
    otp2 = params["otp2"]
    otp3 = params["otp3"]
    otp4 = params["otp4"]
    user_otp = "#{otp1}#{otp2}#{otp3}#{otp4}"

    client_role = Loanmanagementsystem.Companies.get_company_by_regNo(registrationNumber)

    client_line = client_role.mobileNumber





    user_role_data = Loanmanagementsystem.Accounts.UserRole.find_by(userId: client_role.userId)

    my_user_role_data = Loanmanagementsystem.Accounts.get_user_role!(user_role_data.id)

    company_rep = Loanmanagementsystem.Accounts.UserRole.find_by(userId: client_role.userId)

    loan_otp = company_rep.otp

    if loan_otp == user_otp && user_otp != nil do


          Ecto.Multi.new()
          |> Ecto.Multi.update(
            :otp_validate,
            UserRole.changeset(
              my_user_role_data,
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
              |> redirect(to: Routes.loan_path(conn, :universal_loan_application_capturing, client_line: "#{client_line}", product_id: "#{product_id}", registrationNumber: "#{registrationNumber}"))

            {:error, _failed_operation, failed_value, _changes_so_far} ->
              reason = traverse_errors(failed_value.errors) |> List.first()

              conn
              |> put_flash(:error, reason)
              |> redirect(to: Routes.loan_path(conn, :company_otp_validation))
          end
    else

    conn
      |> put_flash(:error, "OTP does not match")
      |> redirect(to: Routes.loan_path(conn, :company_otp_validation, client_line: "#{client_line}", product_id: "#{product_id}", registrationNumber: "#{registrationNumber}"))


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
          "balance" => 0.0
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
          "balance" => 0.0
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
          "balance" => 0.0
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
    loan_details = Loanmanagementsystem.Loan.get_loan_by_id!(params["id"])

    new_params =
      Map.merge(params, %{
        "loan_status" => "REJECTED",
        "status" => "REJECTED",
        "reason" => params["reason"]
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



  # defp account_listing_date_filter(query, %{"start_date" => start_date, "end_date" => end_date})
  #      when start_date == "" or is_nil(start_date) or end_date == "" or is_nil(end_date),
  #      do: query


  # defp account_listing_counter_filter(query, %{"fund_name" => fund_name})
  #      when fund_name == "" or is_nil(fund_name),
  #      do: query



  # ------------------------------------------
  # defp account_listing_customer_no(query, %{"customer_no" => customer_no})
  #      when customer_no == "" or is_nil(customer_no),
  #      do: query


  # ----------------------------------------------
  # defp account_listing_email(query, %{"email" => email})
  #      when email == "" or is_nil(email),
  #      do: query



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





  #  def calculate_amortization(conn, params) do
    def calculate_amortization(conn, %{"loan_amount" => loan_amount, "interest_rate" => interest_rate, "loan_term" => loan_term}) do
    # IO.inspect(loan_amount, label: "CHeck my params at calculate_amortization")
    # loan_amount = params["loan_amount"]
    interest_rate = interest_rate
    # loan_term = params["repayment"]
    start_date = Timex.today

    # IO.inspect loan_amount, label: "loan_amount ********************************"
    # IO.inspect interest_rate, label: "interest_rate ********************************"
    # IO.inspect loan_term, label: "loan_term ********************************"

    # Calculate the amortization schedule using Elixir
    schedule = generate_schedule(loan_amount, interest_rate, loan_term, start_date)
    # product_details =  Loanmanagementsystem.Products.product_details_list(params["product_id"])

    IO.inspect schedule, label: "schedule ********************************"

    # Pass the schedule to the view
    render(conn, "amortization.html", amortization: schedule)
  #   conn
  #   |> put_flash(:Info, "Below is the amortization table.")
  #   |> redirect(to: Routes.loan_path(conn, :render_amortization, product_details: product_details, userId: params["userId"], reference_no: params["reference_no"]))
  end

  def generate_schedule(loan_amount_v, interet_rate_v, term_in_months_v, _start_date) do
    IO.inspect(loan_amount_v, label: "CHeck my params at loan_amount_v")
    IO.inspect(interet_rate_v, label: "CHeck my params at interet_rate_v")
    IO.inspect(term_in_months_v, label: "CHeck my params at term_in_months_v")

    # interest_rate = try do
    #   case String.contains?(String.trim(interet_rate_v), ".") do
    #     true ->  String.trim(interet_rate_v) |> String.to_float()
    #     false ->  String.trim(interet_rate_v) |> String.to_integer() end
    # rescue _-> 0 end
    interest_rate = interet_rate_v |> String.to_integer()
    loan_amount = loan_amount_v |> String.to_integer()
    # loan_amount = try do
    #   case String.contains?(String.trim(loan_amount_v), ".") do
    #     true ->  String.trim(loan_amount_v) |> String.to_float()
    #     false ->  String.trim(loan_amount_v) |> String.to_integer() end
    # rescue _-> 0 end
    # term_in_months = try do
    #   case String.contains?(String.trim(term_in_months_v), ".") do
    #     true ->  String.trim(term_in_months_v) |> String.to_float()
    #     false ->  String.trim(term_in_months_v) |> String.to_integer() end
    # rescue _-> 0 end

    term_in_months = term_in_months_v |> String.to_integer()
    term_in_months = round(term_in_months/30)


  monthly_rate = interest_rate / 100.0
  IO.inspect(monthly_rate, label: "CHeck my params at monthly_rate")
  payment = loan_amount * monthly_rate / (1.0 - :math.pow(1.0 + monthly_rate, -term_in_months))
  Enum.reduce(1..term_in_months, [], fn month, acc ->
    previous_balance = if month == 1, do: loan_amount, else: hd(acc)[:ending_balance]
    interest = previous_balance * monthly_rate
    principal = payment - interest
    ending_balance = previous_balance - principal
    [ %{
        loan_amount: loan_amount,
        interest_rate: interest_rate,
        term_in_months: term_in_months,
        month: month,
        beginning_balance: previous_balance,
        payment: Float.round(payment, 3),
        interest: Float.round(interest, 3),
        principal_paid: Float.round(principal, 3),
        ending_balance: Float.round(ending_balance, 3),

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
      collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
      extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
      guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
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


   def mgt_approve_invoice_discounting_application(conn, params) do

    role_id = try do Role.find_by(role_group: "Credit Analyst").id rescue _-> "" end

    user_details = try do User.where(role_id: role_id)  rescue _-> "" end

    company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

    company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

    company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

    reference_no = generate_momo_random_string(10)

    loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["id"])

    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :add_loan,
      Loans.changeset(loans, %{
        loan_status: "APPROVED",
        status: "APPROVED_FROM_CEO",
        approvedon_userid: conn.assigns.user.id,
        approvedon_date: "#{Date.utc_today()}"
      })
    )
    |>Ecto.Multi.run(:loan_assessment, fn _repo, %{add_loan: add_loan}->
      loan_assessment = %{
        comments: params["comment"],
        customer_id: params["customer_id"],
        date: "#{Date.utc_today()}",
        date_received: "#{add_loan.application_date}",
        name: params["feedback_name"],
        position: "MANAGEMENT",
        recommended: params["feedback"],
        time_received: "#{Timex.now()}",
        user_type: "MANAGEMENT",
        loan_id: add_loan.id,
        reference_no: reference_no
      }
      case Repo.insert(Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, loan_assessment)) do
        {:ok, message} -> {:ok, message}
        {:error, reason}-> {:error, reason}
      end
    end)
    |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity: "Loan Application Successfully Approved By Management",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{add_loan: add_loan, user_logs: _user_logs}} ->
        reference_number = add_loan.reference_no
        requested_amount = add_loan.principal_amount_proposed
        user_details
        |> Enum.map(fn user ->
          try do UserBioData.where(userId: user.id) rescue _-> "" end
          |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
          end)
        end)
        conn
        |> put_flash(:info, "Loan application successfully sent to the credit analyst to attach documents")
        |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
    end
  end

  def push_to_mgt_approve_invoice_discounting_application(conn, params) do
    IO.inspect(params, label: "CHeck params")
    IO.inspect(params["loan_id"], label: "CHeck params")

    reference_no = generate_momo_random_string(10)

    loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["id"])

      Ecto.Multi.new()
      |> Ecto.Multi.update(
        :add_loan,
        Loans.changeset(loans, %{
          loan_status: "APPROVED",
          status: "APPROVED_FROM_CEO",
          approvedon_userid: conn.assigns.user.id,
          approvedon_date: "#{Date.utc_today()}"
        })
      )
      |>Ecto.Multi.run(:loan_assessment, fn _repo, %{add_loan: add_loan}->
        loan_assessment = %{
          comments: params["comment"],
          customer_id: params["customer_id"],
          date: "#{Date.utc_today()}",
          date_received: "#{add_loan.application_date}",
          name: params["feedback_name"],
          position: "MANAGEMENT",
          recommended: params["feedback"],
          time_received: "#{Timex.now()}",
          user_type: "MANAGEMENT",
          loan_id: add_loan.id,
          reference_no: reference_no
        }
        case Repo.insert(Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, loan_assessment)) do
          {:ok, message} -> {:ok, message}
          {:error, reason}-> {:error, reason}
        end
      end)
      |> Ecto.Multi.run(:user_logs, fn _repo, %{add_loan: _add_loan} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Loan Application Successfully Approved By Management",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()
      end)
      |> Repo.transaction()
      |> case do
        {:ok, _} ->

          conn
          |> put_flash(:info, "Loan application successfully sent to the credit analyst to attach documents")
          |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :invoice_discounting_application_datatable))
      end
  end


  def approve_employee_consumer_loan_by_credit_analyst(conn, params) do

    role_id = try do Role.find_by(role_group: "Credit Manager").id rescue _-> "" end

    user_details = try do User.where(role_id: role_id)  rescue _-> "" end

    last_name = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).lastName rescue _-> nil end

    first_name = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).firstName rescue _-> nil end

    client_name = "#{last_name} - #{first_name}"

    client_contact = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).mobileNumber rescue _-> nil end

    client_id_number = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).meansOfIdentificationNumber rescue _-> nil end

    loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])
    # current_user_id = conn.assigns.user.id

      Ecto.Multi.new()
      |> Ecto.Multi.update(
        :update_loan,
        Loans.changeset(loans, %{
          loan_status: "PENDING_OPERATIONS_MANAGER",
          status: "PENDING_OPERATIONS_MANAGER",
          funderID: params["funder_id"]

        })
      )
      |> Ecto.Multi.run(:loan_recommandation, fn _repo, %{update_loan: _update_loan} ->
        Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
          comments: params["loan_recommandation"],
          customer_id: loans.customer_id,
          loan_id: loans.id,
          name: params["name_feedback"],
          position: params["position_feedback"],
          reference_no: loans.reference_no,

        })
        |> Repo.insert()

      end)

      |> Ecto.Multi.run(:user_logs, fn _repo, %{update_loan: _update_loan, loan_recommandation: _loan_recommandation} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Loan Application Successfully Approved By Credit Analyst",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()

      end)

      # |> Ecto.Multi.run(:document, fn _repo, %{update_loan: update_loan, user_logs: _user_logs} ->
      #   Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{"process_documents" => params, "conn" => conn, "customer_id" => params["customer_id"], "loan_id" => update_loan.id, "fileName" => params["fileName"]})
      # end)
      |> Repo.transaction()
      |> case do
        {:ok, %{update_loan: update_loan, user_logs: _user_logs}} ->
          reference_number = update_loan.reference_no
          requested_amount = update_loan.principal_amount_proposed
          user_details
          |> Enum.map(fn user ->
            try do UserBioData.where(userId: user.id) rescue _-> "" end
            |> Enum.map(fn userbio -> Email.email_notify_next_approver_consumer(userbio.emailAddress, client_name, reference_number, requested_amount, client_id_number, client_contact)
            end)
          end)
          Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan.id}, params)
          conn
          |> put_flash(:info, "Loan Application Successfully sent to Credit Manager")
          |> redirect(to: Routes.loan_path(conn, :consumer_loans_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :consumer_loans_datatable))
      end
  end


  @spec approve_employee_consumer_loan_by_accountant(
          Plug.Conn.t(),
          nil | maybe_improper_list | map
        ) :: Plug.Conn.t()
  def approve_employee_consumer_loan_by_accountant(conn, params) do

    loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])
    loan_details = Loanmanagementsystem.Loan.get_loans!(params["loan_id"])
    maturity_date = Date.add(Timex.today(), loan_details.tenor)

      Ecto.Multi.new()
      |> Ecto.Multi.update(
        :update_loan,
        Loans.changeset(loans, %{
          "status" => "DISBURSED",
          "closedon_date" => maturity_date,
          "loan_status" => "DISBURSED",
          "disbursedon_date" => Date.utc_today()

        })
      )
      |> Ecto.Multi.run(:user_logs, fn _repo, %{update_loan: _update_loan} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Loan Application Successfully Approved By Accountant",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()

      end)

      # |> Ecto.Multi.run(:document, fn _repo, %{update_loan: update_loan, user_logs: _user_logs} ->
      #   Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{"process_documents" => params, "conn" => conn, "customer_id" => params["customer_id"], "loan_id" => update_loan.id, "fileName" => params["fileName"]})
      # end)
      |> Repo.transaction()
      |> case do
        {:ok, %{update_loan: update_loan, user_logs: _user_logs}} ->
          Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan.id}, params)
          conn
          |> put_flash(:info, "Disbursed Loan Successfully")
          |> redirect(to: Routes.loan_path(conn, :consumer_loans_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :consumer_loans_datatable))
      end
  end


  def approve_employee_consumer_loan_by_operation_officer(conn, params) do

    role_id = try do Role.find_by(role_group: "Management").id rescue _-> "" end

    user_details = try do User.where(role_id: role_id)  rescue _-> "" end

    last_name = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).lastName rescue _-> nil end

    first_name = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).firstName rescue _-> nil end

    client_name = "#{last_name} - #{first_name}"

    client_contact = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).mobileNumber rescue _-> nil end

    client_id_number = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).meansOfIdentificationNumber rescue _-> nil end

    loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])

      Ecto.Multi.new()
      |> Ecto.Multi.update(
        :update_loan,
        Loans.changeset(loans, %{
          loan_status: "PENDING_MANAGEMENT",
          status: "PENDING_MANAGEMENT"
        })
      )

      |> Ecto.Multi.run(:loan_recommandation, fn _repo, %{update_loan: _update_loan} ->
        Loan_recommendation_and_assessment.changeset(%Loan_recommendation_and_assessment{}, %{
          comments: params["loan_recommandation"],
          customer_id: loans.customer_id,
          loan_id: loans.id,
          name: params["name_feedback"],
          position: params["position_feedback"],
          reference_no: loans.reference_no,
          user_type: "Operations"

        })
        |> Repo.insert()

      end)

      |> Ecto.Multi.run(:user_logs, fn _repo, %{update_loan: _update_loan} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Loan Application Successfully Approved By Operations Officer",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()

      end)

      # |> Ecto.Multi.run(:document, fn _repo, %{update_loan: update_loan, user_logs: _user_logs} ->
      #   Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{"process_documents" => params, "conn" => conn, "customer_id" => params["customer_id"], "loan_id" => update_loan.id, "fileName" => params["fileName"]})
      # end)
      |> Repo.transaction()
      |> case do
        {:ok, %{update_loan: update_loan, user_logs: _user_logs}} ->
          # Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan.id}, params)
          conn
          # reference_number = update_loan.reference_no
          # requested_amount = update_loan.principal_amount_proposed
          # user_details
          # |> Enum.map(fn user ->
          #   try do UserBioData.where(userId: user.id) rescue _-> "" end
          #   |> Enum.map(fn userbio -> Email.email_notify_next_approver_consumer(userbio.emailAddress, client_name, reference_number, requested_amount, client_id_number, client_contact)
          #   end)
          # end)
          |> put_flash(:info, "Loan Application Successfully sent to Management")
          |> redirect(to: Routes.loan_path(conn, :consumer_loans_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :consumer_loans_datatable))
      end
  end

  def approve_employee_consumer_loan_by_management(conn, params) do

    loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])
    Ecto.Multi.new()
      |> Ecto.Multi.update(
        :update_loan,
        Loans.changeset(loans, %{
          loan_status: "FROM_MGT_TO_CREDIT_ANALYST",
          status: "PENDING_CREDIT_ANALYST",
          approvedon_date: params["approvedon_date"],
          approvedon_userid: conn.assigns.user.id,
          approved_principal: params["approved_principal"],
          interest_amount: params["total_interest"],
          total_expected_repayment_derived: params["totalPayment"],
          total_repayment_derived: params["totalPayment"],

        })
      )
      |> Ecto.Multi.run(:user_logs, fn _repo, %{update_loan: _update_loan} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Loan Application Successfully Approved By Managament",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()

      end)

      # |> Ecto.Multi.run(:document, fn _repo, %{update_loan: update_loan, user_logs: _user_logs} ->
      #   Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{"process_documents" => params, "conn" => conn, "customer_id" => params["customer_id"], "loan_id" => update_loan.id, "fileName" => params["fileName"]})
      # end)
      |> Repo.transaction()
      |> case do
        {:ok, %{update_loan: _update_loan, user_logs: _user_logs}} ->
          # Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan.id}, params)
          conn
          |> put_flash(:info, "Loan Application Approved Successfully")
          |> redirect(to: Routes.loan_path(conn, :consumer_loans_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :consumer_loans_datatable))
      end
  end

  def consumer_loans_application_datatable(conn, _params),
  do: render(conn, "consumer_loans_datatable.html")



  def sme_loan_assement_by_credit_analyst(conn, %{"loan_id" => loan_id}) do

    loanDocs = Loanmanagementsystem.Loan.get_sme_loan_docs(loan_id)

    loan_details = Loanmanagementsystem.Loan.get_sme_loan_details(loan_id)

    credit_loan_details = Loanmanagementsystem.Loan.get_sme_loan_credit_details_list(loan_id)

    offtaker_details = Loanmanagementsystem.Loan.get_offtaker_sme_loan(loan_id)

    render(conn, "admin_approve_credit_analyst_sme.html", loan_details: loan_details, loanDocs: loanDocs, credit_loan_details: credit_loan_details, offtaker_details: offtaker_details)
  end


  def admin_credit_analyst_sme_loan_review_with_documents(conn, params) do

    role_id = try do Role.find_by(role_group: "Credit Manager").id rescue _-> "" end

    user_details = try do User.where(role_id: role_id)  rescue _-> "" end

    company_name_email = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyName rescue _-> nil end

    company_contact = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).companyPhone rescue _-> nil end

    company_tax_number = try do Loanmanagementsystem.Companies.Company.find_by(registrationNumber: params["registrationNumber"]).registrationNumber rescue _-> nil end

    loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])


    Ecto.Multi.new()
    |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
      Map.merge(params, %{
        "loan_status" => "PENDING_OPERATIONS_MANAGER",
        "status"=> "OPERATIONS AND CREDIT MANAGER APPROVAL",
        "funderID"=> params["loan_funder_ID"]
      })

    ))
    |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status}->
      user_logs = %{
        activity: "Credit Analyst has Viewed the dosuments and Upload required documents Successfully",
        user_id: conn.assigns.user.id
      }

      case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
        {:ok, message} -> {:ok, message}
        {:error, reason}-> {:error, reason}
      end
    end)
    |> Ecto.Multi.run(:document, fn _repo, %{update_loan_status: update_loan_status, user_logs: _user_logs} ->
      Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan_status.id}, params)
    end)
    |>Repo.transaction()
    |>case do
      {:ok, %{update_loan_status: update_loan_status} } ->
        reference_number = update_loan_status.reference_no
        requested_amount = update_loan_status.principal_amount
        user_details
        |> Enum.map(fn user ->
          try do UserBioData.where(userId: user.id) rescue _-> "" end
          |> Enum.map(fn userbio -> Email.notify_next_approver(userbio.emailAddress, company_name_email, reference_number, requested_amount, company_tax_number, company_contact)
          end)
        end)
        conn
        |>put_flash(:info, "You have Successfully Viewed and submitted The loan to the Credit Manager")
        |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
      {:error, _failed_operations, failed_value,  _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn
        |>put_flash(:error, reason)
        |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
    end
  end

  def admin_mgt_review_sme_loan_approval(conn, %{"loan_id" => loan_id}) do
    current_user = conn.assigns.user.id

    IO.inspect(current_user, label: "----------------------------------current_user")
    get_user_details = Loanmanagementsystem.Operations.get_current_user_by_bio_data(current_user)
    loanDocs = Loanmanagementsystem.Loan.get_sme_loan_docs(loan_id)
    loan_details = Loanmanagementsystem.Loan.get_sme_loan_details(loan_id)
    credit_loan_details = Loanmanagementsystem.Loan.get_sme_loan_credit_details_list(loan_id)
    offtaker_details = Loanmanagementsystem.Loan.get_offtaker_sme_loan(loan_id)

    render(conn, "admin_mgt_sme_loan_review_approval.html", get_user_details: get_user_details, loan_details: loan_details, loanDocs: loanDocs, offtaker_details: offtaker_details, credit_loan_details: credit_loan_details)
  end

  def admin_credit_analyst_review_sme_loan_approval(conn, %{"loan_id" => loan_id}) do
    current_user = conn.assigns.user.id

    IO.inspect(current_user, label: "----------------------------------current_user")
    get_user_details = Loanmanagementsystem.Operations.get_current_user_by_bio_data(current_user)
    loanDocs = Loanmanagementsystem.Loan.get_sme_loan_docs(loan_id)
    loan_details = Loanmanagementsystem.Loan.get_sme_loan_details(loan_id)
    credit_loan_details = Loanmanagementsystem.Loan.get_sme_loan_credit_details_list(loan_id)
    offtaker_details = Loanmanagementsystem.Loan.get_offtaker_sme_loan(loan_id)

    render(conn, "admin_credit_analyst_review_sme_loan_approval.html", get_user_details: get_user_details, loan_details: loan_details, loanDocs: loanDocs, offtaker_details: offtaker_details, credit_loan_details: credit_loan_details)
  end

  def admin_management_review_approve_sme_loan(conn, params) do
    loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])
    Ecto.Multi.new()
    |>Ecto.Multi.update(:update_loan_status, Loans.changeset(loans,
      Map.merge(params, %{
        "loan_status" => "APPROVED",
        "status"=> "APPROVED",
        # "loan_limit" => params["loan_limit"],
        "approvedon_date" => params["approvedon_date"],
        "approvedon_userid" => conn.assigns.user.id,
        "loan_funder" => params["loan_funder"]
      })
    ))
    |>Ecto.Multi.run(:user_logs, fn _repo , %{update_loan_status: _update_loan_status}->
      user_logs = %{
        activity: "Management Approval done Successfully",
        user_id: conn.assigns.user.id
      }

      case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
        {:ok, message} -> {:ok, message}
        {:error, reason}-> {:error, reason}
      end
    end)
    |>Repo.transaction()
    |>case do
      {:ok, _ } ->
        conn
        |>put_flash(:info, "You have Successfully Approved the Loan")
        |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
      {:error, _failed_operations, failed_value,  _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn
        |>put_flash(:error, reason)
        |>redirect(to: Routes.loan_path(conn, :sme_loan_application_datatable))
    end
  end

  def generate_momo_random_string(length) do
    :crypto.strong_rand_bytes(length)
    |> Base.encode64
    |> binary_part(0, length)
  end

#  |> Enum.reject(&(&1.status != "ACTIVE"))
  def consumer_loan_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.consumer_loan_application_listing(search_params, start, length)
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

  def resend_otp(conn, %{"client_line" => client_line, "nrc" => nrc, "product_id" => product_id} = params) do

    IO.inspect(client_line)
    IO.inspect(nrc)
    IO.inspect(product_id)
    resend_fxn = LoanmanagementsystemWeb.LoanController.send_otp(conn, params)
    IO.inspect(resend_fxn)
  end

  def resend_company_otp(conn, %{"client_line" => client_line, "registrationNumber" => registrationNumber, "product_id" => product_id} = params) do

    resend_fxn = LoanmanagementsystemWeb.LoanController.send_company_otp(conn, params)

    IO.inspect(resend_fxn)

  end

  # LoanmanagementsystemWeb.LoanController.generate_schedule_2("50000", "9", "3", Timex.today, "3", "4", "1234")

  def generate_schedule_2(loan_amount_v, interet_rate_v, term_in_months_v, calculation_date, loan_id, customer_id, reference_no) do
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

      # term_in_months = round(term_in_months/30)

    cal_date = (calculation_date)
    IO.inspect(interest_rate, label: "check interest_rate")

    monthly_rate = interest_rate / 100
    IO.inspect(monthly_rate, label: "check monthly_rate")

    payment = loan_amount * monthly_rate / (1.0 - :math.pow(1.0 + monthly_rate, -term_in_months))
    Enum.reduce(1..term_in_months, [], fn month, acc ->
      previous_balance = if month == 1, do: loan_amount, else: hd(acc)[:ending_balance]
      interest = previous_balance * monthly_rate
      principal = payment - interest
      ending_balance = previous_balance - principal
      total_interest = interest * term_in_months

      [ %{
          loan_id: loan_id,
          customer_id: customer_id,
          reference_no: reference_no,
          loan_amount: loan_amount,
          interest_rate: interest_rate,
          term_in_months: term_in_months,
          month: month,
          beginning_balance: previous_balance,
          payment: Float.round(payment, 3),
          interest: Float.round(interest, 3),
          principal: Float.round(principal, 3),
          ending_balance: Float.round(ending_balance, 3),
          date: Timex.end_of_month(Timex.shift(cal_date, months: month)),
          calculation_date: calculation_date,
          total_interest: Float.round(total_interest, 2),
        }
        | acc ]

    end)
    |> Enum.reverse()

  end


# LoanmanagementsystemWeb.LoanController.post_amortazation("50000", "9", "3", Timex.today, "6", "3", "1234")
  def post_amortazation(loan_amount_v, interet_rate_v, term_in_months_v, _calculation_date, loan_id, customer_id, reference_no) do
    calculation_date = Timex.today
    amortization = LoanmanagementsystemWeb.LoanController.generate_schedule_2(loan_amount_v, interet_rate_v, term_in_months_v, calculation_date, loan_id, customer_id, reference_no)

    # total_principal = amortization |> Enum.map(&(&1.principal)) |> Enum.reduce(0, &+/2)
    # total_interest = amortization |> Enum.map(&(&1.interest)) |> Enum.reduce(0, &+/2)
    total_interest = amortization |> Enum.map(&(&1.interest)) |> Enum.reduce(0, &+/2)

    IO.inspect(total_interest, label:  "check total_principal Here")

    cal_date = Date.from_iso8601!(Date.to_string(calculation_date))
    amortization
    |> Enum.map(fn amortization ->
      amortization_params =
      %{
            loan_id: amortization.loan_id,
            customer_id: amortization.customer_id,
            reference_no: amortization.reference_no,
            loan_amount: amortization.loan_amount,
            interest_rate: amortization.interest_rate,
            term_in_months: amortization.term_in_months,
            month: amortization.month,
            beginning_balance: amortization.beginning_balance,
            payment: amortization.payment,
            interest: amortization.interest,
            principal: amortization.principal,
            ending_balance: amortization.ending_balance,
            date: Timex.end_of_month(Timex.shift(cal_date, months: amortization.month)),
            calculation_date: amortization.calculation_date,
        }
      Loan_amortization_schedule.changeset(%Loan_amortization_schedule{}, amortization_params)
      |> Repo.insert()
    end)
  end


  def credit_analyst_go_to_repayment_page(conn, %{"reference_no" => reference_no, "loan_id" => loan_id, "repayment_type" => repayment_type}) do
    loanDocs = Loanmanagementsystem.Operations.get_docs_order_finance(loan_id) |> Enum.reject(&(&1.for_repayment != true))
    repayment_type = repayment_type
    loan_details = Loanmanagementsystem.Operations.get_a_loan_by_reference_no(reference_no) |> IO.inspect(label: "xxxxxxxxxxxxxxxxxxxxxxx")
    company_details = Loanmanagementsystem.Operations.get_company_details_by_reference_no(reference_no) |> IO.inspect(label: "xxxxxxxxxxxxxxxxxxxxxxx")
    individual_details = Loanmanagementsystem.Operations.get_client_company_detials(reference_no) |> IO.inspect(label: "xxxxxxxxxxxxxxxxxxxxxxx")
    render(conn, "credit_analyst_go_to_repayment_page.html", repayment_type: repayment_type, loanDocs: loanDocs, loan_details: loan_details, company_details: company_details, individual_details: individual_details)
  end




  def credit_analyst_update_all_product_loan_repayment(conn, params) do
    IO.inspect(params, label: "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
    # total_repaid = Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"]).total_repaid
    loan_by_refe = Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"])
    params = Map.merge(params, %{"for_repayment" => true})
    repayment_type = params["repayment_type"]


    repayment_amount_1 = params["repayment_amount"]
    repayment_amount = try do
      case String.contains?(String.trim(repayment_amount_1), ".") do
        true ->  String.trim(repayment_amount_1) |> String.to_float()
        false ->  String.trim(repayment_amount_1) |> String.to_integer() end
    rescue _-> 0 end
    IO.inspect(repayment_amount, label: "oooooooooooooooooooooooooooooooooooooooo")


    # balance = Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"]).balance
    # interest_amount = Loanmanagementsystem.Loan.Loans.find_by(reference_no: params["reference_no"]).interest_amount
    # final_total_repaid = if is_nil(total_repaid) do repayment_amount + 0 else repayment_amount + total_repaid end
    # new_balance = (balance - final_total_repaid)

    loan_balance =

     Ecto.Multi.new()


    |> Ecto.Multi.run(:loan_update, fn _repo, %{}->
      loan_params = %{
        loan_status:  if repayment_type == "PARTIAL REPAYMENT" do "DISBURSED" else  "REPAID" end,
        status: if repayment_type == "PARTIAL REPAYMENT" do "DISBURSED" else  "REPAID" end,


      }

      case Repo.update(Loans.changeset(loan_by_refe, loan_params)) do
        {:ok, message}-> {:ok, message}
        {:error, reason}-> {:error, reason}
      end

    end)


    |>Ecto.Multi.run(:user_logs, fn _repo , %{loan_update: _loan_update}->
      user_logs = %{
        activity: "Accountant has Repaid the loan Successfully",
        user_id: conn.assigns.user.id
      }
      case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs)) do
        {:ok, message} -> {:ok, message}
        {:error, reason}-> {:error, reason}
      end
    end)
    |> Ecto.Multi.run(:document, fn _repo, %{loan_update: _loan_update, user_logs: _user_logs} ->
      Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: params["loan_id"]}, params)
    end)
    |>Repo.transaction()
    |>case do
      {:ok, _ } ->
        conn
        |>put_flash(:info, "You have Successfully Repaid a Loan")
        |>redirect(to: Routes.credit_management_path(conn, :admin_repayments))
      {:error, _failed_operations, failed_value,  _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn
        |>put_flash(:error, reason)
        |>redirect(to: Routes.credit_management_path(conn, :admin_repayments))
    end
  end


  def mgt_loan_repayment_items(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Loanmanagementsystem.Loan.mgt_loan_repayment_listing(search_params, start, length)
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

  def mgt_go_to_repayment_page(conn, %{"reference_no" => reference_no, "loan_id" => loan_id, "repayment_type" => repayment_type}) do
    loanDocs = Loanmanagementsystem.Operations.get_docs_order_finance(loan_id) |> Enum.reject(&(&1.for_repayment != true))
    repayment_type = repayment_type
    loan_details = Loanmanagementsystem.Operations.get_a_loan_by_reference_no(reference_no) |> IO.inspect(label: "xxxxxxxxxxxxxxxxxxxxxxx")
    company_details = Loanmanagementsystem.Operations.get_company_details_by_reference_no(reference_no) |> IO.inspect(label: "xxxxxxxxxxxxxxxxxxxxxxx")
    individual_details = Loanmanagementsystem.Operations.get_client_company_detials(reference_no) |> IO.inspect(label: "xxxxxxxxxxxxxxxxxxxxxxx")
    render(conn, "management_go_to_repayment_page.html", repayment_type: repayment_type, loanDocs: loanDocs, loan_details: loan_details, company_details: company_details, individual_details: individual_details)
  end


  def loan_bulkupload(conn, _params), do: render(conn, "loan_bulkupload.html")

  def corperate_loan_bulkupload(conn, _params), do: render(conn, "corporate_loan_bulkupload.html")


  def consumer_upload_guarantor_facility_form_loan_by_credit_analyst(conn, params) do

    role_id = try do Role.find_by(role_group: "Accountant").id rescue _-> "" end

    user_details = try do User.where(role_id: role_id)  rescue _-> "" end

    last_name = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).lastName rescue _-> nil end

    first_name = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).firstName rescue _-> nil end

    client_name = "#{last_name} - #{first_name}"

    client_contact = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).mobileNumber rescue _-> nil end

    client_id_number = try do Loanmanagementsystem.Accounts.UserBioData.find_by(meansOfIdentificationNumber: params["id_number"]).meansOfIdentificationNumber rescue _-> nil end

    loans = Loanmanagementsystem.Loan.get_loan_by_id!(params["loan_id"])
    Ecto.Multi.new()
      |> Ecto.Multi.update(
        :update_loan,
        Loans.changeset(loans, %{
          loan_status: "PENDING_ACCOUNTANT",
          status: "APPROVED",
          # approvedon_date: params["approvedon_date"],
          # approvedon_userid: conn.assigns.user.id,
          # approved_principal: params["approved_principal"],
          # interest_amount: params["total_interest"],
          # total_expected_repayment_derived: params["totalPayment"],
          # total_repayment_derived: params["totalPayment"],

        })
      )
      |> Ecto.Multi.run(:user_logs, fn _repo, %{update_loan: _update_loan} ->
        UserLogs.changeset(%UserLogs{}, %{
          activity: "Loan Application Agrement and Guarantor form Successfully uploaded",
          user_id: conn.assigns.user.id
        })
        |> Repo.insert()

      end)

      # |> Ecto.Multi.run(:document, fn _repo, %{update_loan: update_loan, user_logs: _user_logs} ->
      #   Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{"process_documents" => params, "conn" => conn, "customer_id" => params["customer_id"], "loan_id" => update_loan.id, "fileName" => params["fileName"]})
      # end)
      |> Repo.transaction()
      |> case do
        {:ok, %{update_loan: update_loan, user_logs: _user_logs}} ->
          reference_number = update_loan.reference_no
          requested_amount = update_loan.principal_amount_proposed
          user_details
          |> Enum.map(fn user ->
            try do UserBioData.where(userId: user.id) rescue _-> "" end
            |> Enum.map(fn userbio -> Email.email_notify_next_approver_consumer(userbio.emailAddress, client_name, reference_number, requested_amount, client_id_number, client_contact)
            end)
          end)
          # Loanmanagementsystem.Services.InvoiceUploads.invoice_loan_upload(%{conn: conn, customer_id: params["customer_id"], loan_id: update_loan.id}, params)
          conn
          |> put_flash(:info, "Loan Successfully sent to Accountant")
          |> redirect(to: Routes.loan_path(conn, :consumer_loans_datatable))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()

          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.loan_path(conn, :consumer_loans_datatable))
      end
  end




def consumer_from_mgt_to_credit_analyst(conn, params) do
  IO.inspect(params, label: "Hello Muhammad")
  current_user = conn.assigns.user.id
  product_type =  try do Loanmanagementsystem.Products.Product.find_by(id: params["product_id"]).productType rescue _-> nil end
    if product_type == "CONSUMER LOAN" do
      with(
        client_details when client_details != nil <- Loanmanagementsystem.Loan.Loan_customer_details.find_by(customer_id:  params["userId"], reference_no: params["reference_no"]),
        client_type when client_type != nil <- Loanmanagementsystem.Accounts.UserRole.find_by(userId:  params["userId"]).roleType

      ) do

      case client_type do
        "EMPLOYEE" ->

                client_address_details = Loanmanagementsystem.Accounts.Address_Details.find_by(userId:  params["userId"])

                IO.inspect(params["reference_no"], label: "!!!!!!!!!!!!!! CHeck my reference_no !!!!!!!!!!!!!!")
                # collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
                # extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
                nrc = client_details.id_number
                client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
                IO.inspect(client_data, label: "Check client_data")
                funder_details = Loanmanagementsystem.Loan.get_funder_details()
                get_user_details = Loanmanagementsystem.Accounts.get_current_user_by_bio_data(current_user)
                loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(params["loan_id"])
                client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
                nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
                client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
                loan_details = Loan.list_customer_loan_details(params["loan_id"], params["reference_no"])
                guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
                sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
                market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
                render(conn, "credit_analyst_consumer_loan_approval_from_mgt.html",
                  product_details: Loanmanagementsystem.Products.product_details_list(params["product_id"]),
                  product_rate_details: Loanmanagementsystem.Products.product_rate_details_list(params["product_id"]),
                  client_data: client_data,
                  client_kyc: client_kyc,
                  nextofkin: nextofkin,
                  client_references: client_references,
                  loan_details: loan_details,
                  loanDocs: loanDocs,
                  funder_details: funder_details,
                  get_user_details: get_user_details,
                  # collateral_details: collateral_details,
                  # extracted_other_collateral_details: extracted_other_collateral_details,
                  guarantors_details: guarantors_details,
                  sales_recommedation: sales_recommedation,
                  market_info: market_info,
                  client_address_details: client_address_details
                )
        _ ->

                      nrc = client_details.id_number
                      client_data = Loanmanagementsystem.Accounts.get_client_by_nrc(nrc)
                      IO.inspect(client_data, label: "Check client_data")
                      loanDocs = Loanmanagementsystem.Loan.get_invoice_docs(params["loan_id"])
                      client_kyc = Loan.list_loan_customer_details(params["userId"], params["reference_no"])
                      nextofkin = Loan.list_loan_customer_nextofkin_details(params["userId"], params["reference_no"])
                      client_references = Loan.list_loan_customer_reference_details(params["userId"], params["reference_no"])
                      loan_details = Loan.list_customer_loan_details(params["loan_id"], params["reference_no"])
                      # IO.inspect(loan_details, label: "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ CHeck my loan_details @@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                      collateral_details = Loan.list_loan_collateral_details(params["userId"], params["reference_no"])
                      extracted_other_collateral_details = Loan.list_loan_other_collateral_details(params["userId"], params["reference_no"])
                      guarantors_details = Loan.list_loan_gaurantor_details(params["userId"], params["reference_no"])
                      sales_recommedation = Loan.list_cro_recommendation(params["userId"], params["reference_no"])
                      market_info = Loan.list_loan_market_info(params["userId"], params["reference_no"])
                      client_address_details = Loanmanagementsystem.Accounts.Address_Details.find_by(userId:  params["userId"])
                      render(conn, "credit_analyst_consumer_loan_approval_from_mgt.html",
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
                        loanDocs: loanDocs,
                        client_address_details: client_address_details
                      )
        end

      else
        _ ->
        conn
        |> put_flash(:error, "Something went wrong, try again.")
        |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
      end

    else

    end
end


def view_for_collateral_documents_for_loans(conn, params) do
  documents = Loanmanagementsystem.Operations.get_collateral_loan_client_docs(params["loan_id"], params["fileName"])
  IO.inspect(documents, label: "documents here")
  render(conn, "view_for_collateral_documents_for_loans.html", documents: documents)
end



end
