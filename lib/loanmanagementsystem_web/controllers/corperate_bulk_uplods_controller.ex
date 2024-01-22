defmodule LoanmanagementsystemWeb.CorperateBulkUploadsController do
 use LoanmanagementsystemWeb, :controller
 import Ecto.Query, warn: false
 alias Loanmanagementsystem.Logs.UserLogs
 alias Loanmanagementsystem.Repo
 alias Loanmanagementsystem.Loan.Loans
 alias Loanmanagementsystem.Accounts.UserBioData
#  alias Loanmanagementsystem.Accounts.User
#  alias Loanmanagementsystem.Accounts.UserRole
 alias Loanmanagementsystem.Loan.Loan_customer_details
 alias Loanmanagementsystem.Accounts.Nextofkin
 alias Loanmanagementsystem.Loan.Loan_applicant_reference
 alias Loanmanagementsystem.Loan.Loan_amortization_schedule
alias Loanmanagementsystem.Accounts.Address_Details
alias Loanmanagementsystem.Loan.Bulk_loan_init_figures
alias Loanmanagementsystem.Transactions.Loan_transactions
alias Loanmanagementsystem.Loan.Order_finance_loan_invoice

#  plug LoanmanagementsystemWeb.Plugs.Authenticate,
#  [module_callback: &LoanmanagementsystemWeb.LoanController.authorize_role/1]
#  when action not in [
#      :loan_bulkupload,

# ] LoanmanagementsystemWeb.CorperateBulkUploadsController.generate_reference_no_bulkupload(3)

use PipeTo.Override




 @headers ~w/company_name company_registration_number product_name requested_amount repaid_amount total_interest outstanding_balance arrangement_fee finance_cost total_expected_repayment days_under_due days_over_due loan_period loan_status application_date disbursedon_date reject_reason product_type loan_purpose loan_officer loan_officer_phone_number funder_phone_number offtaker_company_registration_number repayment_type interest_percentage finance_percentage arrangement_percentage order_number invoice_number order_value invoice_value/a

 @headers_list ["company_name", "company_registration_number", "product_name",
                "requested_amount", "repaid_amount", "total_interest", "outstanding_balance",
                "arrangement_fee", "finance_cost", "total_expected_repayment",
                "days_under_due", "days_over_due", "loan_period", "loan_status",
                "application_date", "disbursedon_date", "reject_reason", "product_type",
                "loan_purpose", "loan_officer", "loan_officer_phone_number",
                "funder_phone_number", "offtaker_company_registration_number",
                "repayment_type", "interest_percentage", "finance_percentage",
                "arrangement_percentage", "order_number", "invoice_number", "order_value",
                "invoice_value"]

# @headers ~w/ client_name	mobile_number product_name	requested_amount loan_period	loan_status	application_date disbursedon_date reject_reason	loan_purpose loan_officer  /a

def handle_loan_bulkupload(conn, params) do
  user = conn.assigns.user
  {key, msg, _invalid} = handle_file_upload(user, params, conn)

  if key == :info do
    conn
    |> put_flash(key, msg)
    |> redirect(to: Routes.credit_management_path(conn, :loan_appraisal))
  else
    conn
    |> put_flash(:error, msg)
    |> redirect(to: Routes.loan_path(conn, :corperate_loan_bulkupload))
  end
end

defp handle_file_upload(user, params, conn) do
  with {:ok, filename, destin_path, _rows} <- is_valide_file(params) do
    user
    |> process_bulk_upload(filename, destin_path, conn)
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

def process_bulk_upload(user, filename, path, conn) do
  {:ok, items} = extract_xlsx(path)
  # IO.inspect(items.application_date, label: "-----------------------------------")
  prepare_bulk_params(user, filename, items, conn)
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

defp prepare_bulk_params(user, filename, items, conn) do

    Ecto.Multi.new()
    |> Ecto.Multi.run(:upload_entries, fn _repo, _changes_so_far ->
      user
       |> prepare_loan_bulk_params(filename, items, conn)
       |> prepare_customer_details_bulk_params(user, filename, items)
       |> prepare_nextofkin_bulk_params(user, filename, items)
       |> prepare_references_bulk_params(user, filename, items)
      #  |> prepare_disbursement_bulk_params(user, filename, items)
       |> prepare_amortization_bulk_params(user, filename, items)
       |> prepare_bulk_loan_init_params(user, filename, items)
       |> push_invoice_or_order_number(user, filename, items)


       |> prepare_bulk_loan_txn_table_params(user, filename, items)
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

alias Loanmanagementsystem.Companies.Company

defp prepare_loan_bulk_params(user, _filename, items, conn) do
  items
  |> Stream.with_index(1)
  |> Enum.map(fn {item, index} ->

    user_bio_id= try do Company.find_by(registrationNumber: item.company_registration_number).user_bio_id rescue _-> "" end
    customer_kyc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id) rescue _-> "" end
    customer_id = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id).userId rescue _-> "" end

    # reference_no = generate_reference_no_bulkupload(customer_id)
    loan_params = prepare_loan_params(item, user, customer_id, conn)
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

# defp prepare_disbursement_bulk_params(reference_resp, _user, _, _) when not is_nil(reference_resp), do: reference_resp
# defp prepare_disbursement_bulk_params(_reference_resp, user, _filename, items) do
#   items
#   |> Stream.with_index(1)
#   |> Enum.map(fn {item, index} ->
#     disbursement_params = prepare_disbursement_details_params(item, user)
#     disbursement = Loan_disbursement_schedule.changeset(%Loan_disbursement_schedule{}, disbursement_params)
#     Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), disbursement)

#   end)
#   |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
#   |> execute_multi()
# end

defp prepare_amortization_bulk_params(amorti_resp, _user, _, _) when not is_nil(amorti_resp), do: amorti_resp
defp prepare_amortization_bulk_params(_amorti_resp, _user, _filename, items) do
  items
  |> Stream.with_index(1)
  |> Enum.map(fn {item, _index} ->
    product_name = check_product(item.product_name)
    user_bio_id = try do Company.find_by(registrationNumber: item.company_registration_number).user_bio_id rescue _-> "" end
    customer_kyc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id) rescue _-> "" end
    customer_id = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id).userId rescue _-> "" end
    ref_no =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).reference_no rescue _-> "" end
    # loan_id =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).id rescue _-> "" end
      loan_id = LoanmanagementsystemWeb.CorperateBulkUploadsController.get_loan_id(customer_id, item.requested_amount, item.application_date, item.disbursedon_date)
    # calculation_date =  if String.contains?(item.application_date, "-") do Date.from_iso8601!(String.replace(item.application_date, ~r"[ ]", "")) else Date.from_iso8601!(String.replace(convert_to_iso_date(item.application_date), ~r"[ ]", "")) end
    calculation_date =  String.replace(item.application_date, ~r"[ ]", "")

    interest_rate = try do Loanmanagementsystem.Products.Product.find_by(productType: product_name).interest rescue _-> "" end
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

  def check_product(product_name) do
    case String.contains?(product_name, "Discounting") do
      true -> "INVOICE DISCOUNTING"
      false ->
        case String.contains?(product_name, "Finance") do
          true -> "ORDER FINANCE"
          false ->
            case String.contains?(product_name, "Order") do
              true -> "ORDER FINANCE"
              false ->
                case String.contains?(product_name, "SME") do
                  true -> "SME LOAN"
                  false ->
                    "SME LOAN"
                end
            end
        end
    end
  end



  defp prepare_loan_params(item, _user, _customer_id, conn) do

    offtaker_company = item.offtaker_company_registration_number
    loan_period = if item.loan_period == "" do nil else item.loan_period end
    loan_requested_amount = if item.requested_amount == "" do nil else item.requested_amount end
    disbursedon_date = if item.disbursedon_date == "" do nil else item.disbursedon_date end
      case is_nil(loan_period) do
        false ->
            case is_nil(loan_requested_amount) do
              false ->
                    case is_nil(disbursedon_date) do
                      false ->
                          case offtaker_company do
                            nil ->
                              prepare_loan_params_withiout_offtaker(item, _user, _customer_id, conn)
                              # push_invoice_or_order_number(item, _user, reference_no, _customer_id, conn)


                            "" ->
                              prepare_loan_params_withiout_offtaker(item, _user, _customer_id, conn)
                              # push_invoice_or_order_number(item, _user, reference_no, _customer_id, conn)
                            _ ->
                              # Process the user's email here
                              prepare_loan_params_with_offtaker(item, _user, _customer_id, conn)
                              # push_invoice_or_order_number(item, _user, reference_no, _customer_id, conn)
                          end
                      true ->
                        msg = "Loan disbursement date must be provided for #{item.company_name }"
                        conn
                        |> put_flash(:error, msg)
                        |> redirect(to: Routes.loan_path(conn, :corperate_loan_bulkupload))
                    end
              true ->
                msg = "Loan requested amount must be provided for #{item.company_name}"
                conn
                |> put_flash(:error, msg)
                |> redirect(to: Routes.loan_path(conn, :corperate_loan_bulkupload))
            end
        true ->
          msg = "Loan period must be provided for #{item.company_name}"
          conn
          |> put_flash(:error, msg)
          |> redirect(to: Routes.loan_path(conn, :corperate_loan_bulkupload))
      end


  end

  defp prepare_loan_params_with_offtaker(item, _user, _customer_id, conn) do

    IO.inspect(item.company_name, label: "check company_name")
    IO.inspect(item.product_name, label: "check product_name")
    product_name = check_product(item.product_name)

    IO.inspect(product_name, label: "check product_name product_name")

    product_id = try do Loanmanagementsystem.Products.Product.find_by(productType: product_name).id rescue _-> nil end

    IO.inspect product_id, label: "product_id -----------------------------------------"
    IO.inspect(product_id, label: "product_id product_id")
    interest_rate = try do Loanmanagementsystem.Products.Product.find_by(productType: product_name).interest rescue _-> nil end
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

    IO.inspect interest_rate, label: "interest_rate -----------------------------------------"
    monthly_interest_rate = interest_rate / 100.0 # Convert interest rate to monthly rate
    payment = loan_amount * (monthly_interest_rate / (1 - :math.pow(1 + monthly_interest_rate, -term_in_months)))
    monthly_inst = to_string(Float.round(payment, 2))
    user_bio_id= try do Company.find_by(registrationNumber: item.company_registration_number).user_bio_id rescue _-> "" end
    _customer_kyc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id) rescue _-> "" end
    customer_id = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id).userId rescue _-> "" end
    loan_officer_id = try do Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: String.pad_leading(String.replace(item.loan_officer_phone_number, ~r"[a-z /]", ""), 10, "0")).userId rescue _-> nil end
    funderID = try do Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: String.pad_leading(String.replace(item.funder_phone_number, ~r"[a-z /]", ""), 10, "0")).userId rescue _-> nil end
    company_id = try do Company.find_by(registrationNumber: item.company_registration_number).id rescue _-> nil end
    offtaker_company_id = try do Company.find_by(registrationNumber: item.offtaker_company_registration_number).id rescue _-> nil end


    case is_nil(loan_officer_id) do
      false ->
        case is_nil(funderID) do
          false ->
            case is_nil(company_id)do
              false ->
                case is_nil(offtaker_company_id) do
                  false->
                    # String.pad_leading("976799179", 10, "0")
                    %{
                      customer_id: customer_id,
                      reference_no: generate_reference_no_bulkupload(customer_id),
                      product_id: product_id,
                      loan_status: String.upcase(item.loan_status),
                      loan_type: String.upcase(item.product_name),
                      principal_amount_proposed: item.requested_amount,
                      principal_amount: item.requested_amount,
                      currency_code: "ZMW",
                      interest_method: "PERCENTAGE",
                      disbursement_status: "FULL PAYMENT",
                      status: "DISBURSED",
                      reason: item.reject_reason,
                      requested_amount: item.requested_amount,
                      loan_duration_month: item.loan_period,
                      monthly_installment:  monthly_inst,
                      loan_purpose: item.loan_purpose,
                      number_of_repayments: item.loan_period,
                      tenor: (String.to_integer(item.loan_period) * 30),
                      approvedon_date:  if String.contains?(item.disbursedon_date, "-") do Date.from_iso8601!(String.replace(item.disbursedon_date, ~r"[ ]", "")) else Date.from_iso8601!(String.replace(convert_to_iso_date(item.disbursedon_date), ~r"[ ]", "")) end,
                      application_date: if String.contains?(item.application_date, "-") do Date.from_iso8601!(String.replace(item.application_date, ~r"[ ]", "")) else Date.from_iso8601!(String.replace(convert_to_iso_date(item.application_date), ~r"[ ]", "")) end,
                      disbursedon_date: if String.contains?(item.disbursedon_date, "-") do Date.from_iso8601!(String.replace(item.disbursedon_date, ~r"[ ]", "")) else Date.from_iso8601!(String.replace(convert_to_iso_date(item.disbursedon_date), ~r"[ ]", "")) end,
                      cro_id: cro_id,
                      arrangement_fee: item.arrangement_fee,
                      finance_cost: item.finance_cost,
                      total_repaid: item.repaid_amount,
                      # principal_repaid_derived: item.repaid_amount,
                      # total_repayment_derived: item.repaid_amount,
                      repayment_type: item.repayment_type,
                      balance: item.outstanding_balance,
                      interest_amount: item.total_interest,
                      loan_officer_id: loan_officer_id,
                      funderID: funderID,
                      days_under_due: if (item.days_under_due) != "" do String.to_integer(item.days_under_due) else 0 end,
                      days_over_due: if (item.days_over_due) != "" do String.to_integer(item.days_over_due) else 0 end,
                      total_expected_repayment_derived: item.total_expected_repayment,
                      principal_disbursed_derived: item.requested_amount,
                      repayment_amount: item.total_expected_repayment,
                      offtakerID: offtaker_company_id,
                      company_id: company_id,
                      init_interest_per: item.interest_percentage,
                      init_finance_cost_per: item.finance_percentage,
                      init_arrangement_fee_per: item.arrangement_percentage,

                    }
                  true ->
                    msg = "The Offtaker Registration number you entered is not registered #{item.offtaker_company_registration_number}, Please Insure Mobile Number Exists!!"
                    conn
                    |> put_flash(:error, msg)
                    |> redirect(to: Routes.loan_path(conn, :corperate_loan_bulkupload))
                end
              true ->
                msg = "The Company Registration number you entered is not registered #{item.company_registration_number}, Please Insure Mobile Number Exists!!"
                  conn
                  |> put_flash(:error, msg)
                  |> redirect(to: Routes.loan_path(conn, :corperate_loan_bulkupload))
            end
          true ->
            msg = "The funder mobile number you entered is not registered #{item.loan_officer_phone_number}, Please Insure Mobile Number Exists!!"
            conn
            |> put_flash(:error, msg)
            |> redirect(to: Routes.loan_path(conn, :corperate_loan_bulkupload))
        end
      true ->
        msg = "The loan officer mobile number you entered is not registered #{item.loan_officer_phone_number}, Please Insure Mobile Number Exists!!"
        conn
        |> put_flash(:error, msg)
        |> redirect(to: Routes.loan_path(conn, :corperate_loan_bulkupload))
    end
  end


# LoanmanagementsystemWeb.CorperateBulkUploadsController.convert_to_iso_date({2022, 07, 01})


def convert_to_iso_date(date_tuple) do
  date_struct = Date.from_erl!({elem(date_tuple, 0), elem(date_tuple, 1), elem(date_tuple, 2)})
  formatted_date = Date.to_iso8601(date_struct)
  formatted_date
end

defp prepare_customer_details_params(item, _user) do


  company_id = try do Company.find_by(registrationNumber: item.company_registration_number).id rescue _-> "" end
  user_bio_id= try do Company.find_by(registrationNumber: item.company_registration_number).user_bio_id rescue _-> "" end
  customer_kyc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id) rescue _-> "" end
  customer_id = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id).userId rescue _-> "" end


  IO.inspect(customer_id, label: "Check my customer_id")
  ref_no =  try do Loans.find_by(company_id: company_id, requested_amount: item.requested_amount).reference_no rescue _-> "" end

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
    # residential_address: customer_address.house_number,
    # # landmark: customer_address.land_mark,
    # town: customer_address.town,
    # province: customer_address.province,
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
  company_id = try do Company.find_by(registrationNumber: item.company_registration_number).id rescue _-> "" end
  user_bio_id= try do Company.find_by(registrationNumber: item.company_registration_number).user_bio_id rescue _-> "" end
  customer_kyc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id) rescue _-> "" end
  customer_id = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id).userId rescue _-> "" end
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
  company_id = try do Company.find_by(registrationNumber: item.company_registration_number).id rescue _-> "" end
  user_bio_id= try do Company.find_by(registrationNumber: item.company_registration_number).user_bio_id rescue _-> "" end
  customer_kyc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id) rescue _-> "" end
  customer_id = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id).userId rescue _-> "" end
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


# defp prepare_disbursement_details_params(item, _user) do
#   customer_id= try do Company.find_by(registrationNumber: item.company_registration_number).user_bio_id rescue _-> "" end,
#   ref_no =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).reference_no rescue _-> "" end
#   loan_id =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).id rescue _-> "" end
#   # customer_kyc = try do UserBioData.find_by(userId: customer_id) rescue _-> "" end
#   product = try do Loanmanagementsystem.Products.Product.find_by(name: item.product_name) rescue _-> "" end
#   interest_rate = try do Loanmanagementsystem.Products.Product.find_by(name: item.product_name).interest rescue _-> "" end
#   # customer_address = try do Address_Details.find_by(userId: customer_id) rescue _-> "" end
#   loan_amount = try do
#   case String.contains?(String.trim(item.requested_amount), ".") do
#       true ->  String.trim(item.requested_amount) |> String.to_float()
#       false ->  String.trim(item.requested_amount) |> String.to_integer() end
#   rescue _-> 0 end
#   term_in_months = try do
#   case String.contains?(String.trim(item.loan_period), ".") do
#       true ->  String.trim(item.loan_period) |> String.to_float()
#       false ->  String.trim(item.loan_period) |> String.to_integer() end
#   rescue _-> 0 end
#   months_interest = interest_rate / 12
#   monthly_interest_rate = interest_rate / 100.0 # Convert interest rate to monthly rate
#   payment = loan_amount * (monthly_interest_rate / (1 - :math.pow(1 + monthly_interest_rate, -term_in_months)))
#   monthly_inst = Float.round(payment, 2)
#   processing_fee = if product.proccessing_fee == nil do 0.1 * loan_amount else product.proccessing_fee * loan_amount end
#   insurance =  if product.insurance == nil do 0.03 * loan_amount else product.insurance * loan_amount end
#   crb_fee = if product.crb_fee == nil do 100 else product.crb_fee end
#   net_disbiursed =  loan_amount - processing_fee - insurance - crb_fee
#   proces_fee = if product.proccessing_fee == nil do 0.1 else product.proccessing_fee  end
#   insura_fee = if product.insurance == nil do 0.03 else product.insurance  end
#   disbursed_processing_fee_percent = proces_fee * 100
#   disbursed_insurance_percent = insura_fee * 100
#   total_amt =  monthly_inst *  term_in_months
#   total_payment = Float.round(total_amt, 2)
#   disbursed_date = Date.from_iso8601!(item.application_date)
#    # Disbursement Schedule
#    %{
#     applicant_name: item.client_name,
#     applied_amount: item.requested_amount,
#     approved_amount: item.requested_amount,
#     processing_fee: processing_fee,
#     insurance: insurance,
#     interet_per_month: months_interest,
#     repayment_period: item.loan_period,
#     monthly_installment: monthly_inst,
#     crb_amt: crb_fee,
#     crb: crb_fee,
#     motor_insurance: 0,
#     month_installment: monthly_inst,
#     net_disbiursed: net_disbiursed,
#     total_payment: total_payment,
#     payment_per_month: monthly_inst,
#     processing_fee_percent: disbursed_processing_fee_percent,
#     insurance_percent: disbursed_insurance_percent,
#     customer_id: customer_id,
#     reference_no: ref_no,
#     date: disbursed_date,
#     loan_id: loan_id,
#     total_repaid: item.repaid_amount,
#     principal_repaid_derived: item.repaid_amount,
#     total_repayment_derived: item.repaid_amount,
#     repayment_type: "PARTIAL REPAYMENT",

#   }
# end

defp prepare_user_logs_params(item, user) do
  %{
    activity: "You have Successfully uploaded a loan for a customer with mobile number #{Company.find_by(registrationNumber: item.company_registration_number).user_bio_id}",
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

                  first_row = Xlsxir.get_row(table_id, 1)
                  IO.inspect(first_row, label: "check first_row")
                  case @headers_list == first_row do
                    true ->
                          row_count = Xlsxir.get_info(table_id, :rows)
                          Xlsxir.close(table_id)
                          {:ok, upload.filename, destin_path, row_count - 1}

                        {:error, reason} ->
                          {:error, reason}
                    false ->

                      {:error, "Headers do not match. Please ensure the selected file is a corporate loans bulk file."}
                  end
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
          # |> check_date_from_list()
          # |> IO.inspect(label: "------------------------------- INPSECT")
          |> Enum.reject(&(Enum.join(Map.values(&1)) == ""))

        Xlsxir.close(id)

        {:ok, items}

      {:error, reason} ->
        {:error, reason}
    end
  end

  # def check_date_from_list(data) do

  #   IO.inspect(date, label: "+++++++++++++++++++++++++++++++++++++++++ date")


  #   formatted_data = Enum.map(data, fn %record{application_date: app_date, disbursedon_date: dis_date} ->
  #     # %record{
  #       application_date: DateConverter.convert_to_iso_date(app_date)
  #       disbursedon_date: DateConverter.convert_to_iso_date(dis_date)
  #       # ... (copy other fields as is)



  #       # application_date: {2023, 6, 12},
  #       # arrangement_fee: "0",
  #       # company_name: "Symetricks Limited",
  #       # company_registration_number: "120080073350",
  #       # days_over_due: "0",
  #       # days_under_due: "39",
  #       # disbursedon_date: {2023, 6, 12},
  #       # finance_cost: "1934.6850000000002",
  #       # funder_phone_number: "0979316651",
  #       # loan_officer: "EMMANUEL",
  #       # loan_officer_phone_number: "0979061959",
  #       # loan_period: "3",
  #       # loan_purpose: "BUSINESS",
  #       # loan_status: "DISBURSED",
  #       # offtaker_company_registration_number: "1200000044139",
  #       # outstanding_balance: "26243.433",
  #       # product_name: "Invoice Discounting",
  #       # product_type: "INVOICE DISOUNTING",
  #       # reject_reason: "",
  #       # repaid_amount: "0",
  #       # repayment_type: "PARTIAL REPAYMENT",
  #       # requested_amount: "22761",
  #       # total_expected_repayment: "26243.433",
  #       # total_interest: "1547.748"
  #     # }
  #   end)
  # end

  defp strgfy_term(term) when is_tuple(term), do: term
  defp strgfy_term(term) when not is_tuple(term), do: String.trim("#{term}")


  def generate_reference_no_bulkupload(customer_id) do
    cust_id = to_string(customer_id)
    date = Timex.today()
    year = to_string(date.year)
    month = to_string(date.month)
    day = to_string(date.day)
    start_of_year_date = Timex.beginning_of_year(date)
    current_year = date
    date_difference = to_string(Date.diff(current_year, start_of_year_date))
    generate_otp = to_string(Enum.random(1111..9999))
    "A-" <> "" <> year <> "" <> month <> "" <> day <>"" <> "." <> "" <> date_difference <> "" <> "" <> "." <> "" <> cust_id <> "" <> "." <> generate_otp <> "." <> to_string(System.system_time(:second))
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



  defp prepare_bulk_loan_init_params(logs_resp, _user, _, _) when not is_nil(logs_resp), do: logs_resp
  defp prepare_bulk_loan_init_params(_logs_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      bulk_loan_init_params = bulk_loan_initial_figures(item, user)
      changeset_loan_initial_fig = Bulk_loan_init_figures.changeset(%Bulk_loan_init_figures{}, bulk_loan_init_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_loan_initial_fig)
    end)
    |> List.flatten()
    |> Enum.reject(& !&1)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end

  defp bulk_loan_initial_figures(item, _user) do
    product_name = check_product(item.product_name)
    company_id = try do Company.find_by(registrationNumber: item.company_registration_number).id rescue _-> "" end
    user_bio_id= try do Company.find_by(registrationNumber: item.company_registration_number).user_bio_id rescue _-> "" end
    customer_kyc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id) rescue _-> "" end
    customer_id = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id).userId rescue _-> "" end

    productType = try do Loanmanagementsystem.Products.Product.find_by(productType: product_name).productType rescue _-> "" end
    # loan_id =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).id rescue _-> "" end
    # loan_id = LoanmanagementsystemWeb.BulkUploadsController.get_loan_id(customer_id, item.requested_amount)
    loan_id = LoanmanagementsystemWeb.CorperateBulkUploadsController.get_loan_id(customer_id, item.requested_amount, item.application_date, item.disbursedon_date)

        %{

          product_type: productType,
          status: "DISBURSED",
          loan_id: loan_id,
          init_principal_amount: item.requested_amount,
          init_arrangement_fee: item.arrangement_fee,
          init_finance_cost_accrued: item.finance_cost,
          init_repaid_amount: item.repaid_amount,
          balance: item.outstanding_balance,
          init_interest_accrued: item.total_interest,
          init_expected_repayment: item.total_expected_repayment,
        }
  end

  # loan_id = LoanmanagementsystemWeb.BulkUploadsController.get_loan_id(198, 300000)


    def get_loan_id(customer_id, requested_amount, application_date, disbursedon_date) do
      from(l in Loans,
        where: l.customer_id == ^customer_id and l.requested_amount == ^requested_amount and l.application_date == ^application_date and l.disbursedon_date == ^disbursedon_date,
        order_by: [desc: l.inserted_at],
        limit: 1
      )
      |> Repo.one()
      |> Map.get(:id, nil)
    end


    defp prepare_bulk_loan_txn_table_params(logs_resp, _user, _, _) when not is_nil(logs_resp), do: logs_resp
      defp prepare_bulk_loan_txn_table_params(_logs_resp, user, _filename, items) do
        items
        |> Stream.with_index(1)
        |> Enum.map(fn {item, index} ->
          bulk_loan_init_params = bulk_loan_loan_txn_table_figures(item, user)
          changeset_loan_loan_txn_table = Loan_transactions.changeset(%Loan_transactions{}, bulk_loan_init_params)
          Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_loan_loan_txn_table)
        end)
        |> List.flatten()
        |> Enum.reject(& !&1)
        |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
        |> execute_multi()
      end


      defp bulk_loan_loan_txn_table_figures(item, _user) do

        user_bio_id= try do Company.find_by(registrationNumber: item.company_registration_number).user_bio_id rescue _-> "" end
        customer_id = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id).userId rescue _-> "" end

        # loan_id =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).id rescue _-> "" end
        # loan_id = LoanmanagementsystemWeb.BulkUploadsController.get_loan_id(customer_id, item.requested_amount)
        # def get_loan_id(customer_id, requested_amount, application_date, disbursedon_date) do
        loan_id = LoanmanagementsystemWeb.CorperateBulkUploadsController.get_loan_id(customer_id, item.requested_amount, item.application_date, item.disbursedon_date)

        product_id = try do Loanmanagementsystem.Loan.Loans.find_by(id: loan_id).product_id rescue _-> "" end

            %{

              loan_id:  loan_id,
              customer_id: customer_id,
              principal_amount: item.requested_amount,
              is_disbursement: true,
              # days_accrued: item.total_expected_repayment,
              total_interest_accrued: item.total_interest,
              total_finance_cost_accrued: item.finance_cost,
              product_id: product_id,
              txn_amount: item.requested_amount,
              repaid_amount: item.repaid_amount,
              transaction_date: Timex.today(),
              outstanding_balance: item.outstanding_balance,
              init_expected_repayment: item.total_expected_repayment,
              is_bulk_upload: true,
            }
      end



      defp prepare_loan_params_withiout_offtaker(item, _user, _customer_id, conn) do

        product_name = check_product(item.product_name)

        product_id = try do Loanmanagementsystem.Products.Product.find_by(productType: product_name).id rescue _-> nil end

        IO.inspect product_id, label: "product_id -----------------------------------------"
        IO.inspect(product_id, label: "product_id product_id")
        interest_rate = try do Loanmanagementsystem.Products.Product.find_by(productType: product_name).interest rescue _-> nil end
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

        IO.inspect interest_rate, label: "interest_rate -----------------------------------------"
        monthly_interest_rate = interest_rate / 100.0 # Convert interest rate to monthly rate
        payment = loan_amount * (monthly_interest_rate / (1 - :math.pow(1 + monthly_interest_rate, -term_in_months)))
        monthly_inst = to_string(Float.round(payment, 2))
        user_bio_id= try do Company.find_by(registrationNumber: item.company_registration_number).user_bio_id rescue _-> "" end
        _customer_kyc = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id) rescue _-> "" end
        customer_id = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id).userId rescue _-> "" end
        loan_officer_id = try do Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: String.pad_leading(String.replace(item.loan_officer_phone_number, ~r"[a-z /]", ""), 10, "0")).userId rescue _-> nil end
        funderID = try do Loanmanagementsystem.Accounts.UserBioData.find_by(mobileNumber: String.pad_leading(String.replace(item.funder_phone_number, ~r"[a-z /]", ""), 10, "0")).userId rescue _-> nil end
        company_id = try do Company.find_by(registrationNumber: item.company_registration_number).id rescue _-> nil end


        case is_nil(loan_officer_id) do
          false ->
            case is_nil(funderID) do
              false ->
                case is_nil(company_id)do
                  false ->
                        %{
                          customer_id: customer_id,
                          reference_no: generate_reference_no_bulkupload(customer_id),
                          product_id: product_id,
                          loan_status: String.upcase(item.loan_status),
                          loan_type: String.upcase(item.product_name),
                          principal_amount_proposed: item.requested_amount,
                          principal_amount: item.requested_amount,
                          currency_code: "ZMW",
                          interest_method: "PERCENTAGE",
                          disbursement_status: "FULL PAYMENT",
                          status: "DISBURSED",
                          reason: item.reject_reason,
                          requested_amount: item.requested_amount,
                          loan_duration_month: item.loan_period,
                          monthly_installment:  monthly_inst,
                          loan_purpose: item.loan_purpose,
                          number_of_repayments: item.loan_period,
                          tenor: (String.to_integer(item.loan_period) * 30),
                          approvedon_date:  if String.contains?(item.disbursedon_date, "-") do Date.from_iso8601!(String.replace(item.disbursedon_date, ~r"[ ]", "")) else Date.from_iso8601!(String.replace(convert_to_iso_date(item.disbursedon_date), ~r"[ ]", "")) end,
                          application_date: if String.contains?(item.application_date, "-") do Date.from_iso8601!(String.replace(item.application_date, ~r"[ ]", "")) else Date.from_iso8601!(String.replace(convert_to_iso_date(item.application_date), ~r"[ ]", "")) end,
                          disbursedon_date: if String.contains?(item.disbursedon_date, "-") do Date.from_iso8601!(String.replace(item.disbursedon_date, ~r"[ ]", "")) else Date.from_iso8601!(String.replace(convert_to_iso_date(item.disbursedon_date), ~r"[ ]", "")) end,
                          cro_id: cro_id,
                          arrangement_fee: item.arrangement_fee,
                          finance_cost: item.finance_cost,
                          total_repaid: item.repaid_amount,
                          # principal_repaid_derived: item.repaid_amount,
                          # total_repayment_derived: item.repaid_amount,
                          repayment_type: item.repayment_type,
                          balance: item.outstanding_balance,
                          interest_amount: item.total_interest,
                          loan_officer_id: loan_officer_id,
                          funderID: funderID,
                          days_under_due: if (item.days_under_due) != "" do String.to_integer(item.days_under_due) else 0 end,
                          days_over_due: if (item.days_over_due) != "" do String.to_integer(item.days_over_due) else 0 end,
                          total_expected_repayment_derived: item.total_expected_repayment,
                          principal_disbursed_derived: item.requested_amount,
                          repayment_amount: item.total_expected_repayment,
                          # offtakerID: offtaker_company_id,
                          company_id: company_id,
                          init_interest_per: item.interest_percentage,
                          init_finance_cost_per: item.finance_percentage,
                          init_arrangement_fee_per: item.arrangement_percentage,

                        }

                  true ->
                    msg = "The Company Registration number you entered is not registered #{item.company_registration_number}, Please Insure Mobile Number Exists!!"
                      conn
                      |> put_flash(:error, msg)
                      |> redirect(to: Routes.loan_path(conn, :corperate_loan_bulkupload))
                end
              true ->
                msg = "The funder mobile number you entered is not registered #{item.loan_officer_phone_number}, Please Insure Mobile Number Exists!!"
                conn
                |> put_flash(:error, msg)
                |> redirect(to: Routes.loan_path(conn, :corperate_loan_bulkupload))
            end
          true ->
            msg = "The loan officer mobile number you entered is not registered #{item.loan_officer_phone_number}, Please Insure Mobile Number Exists!!"
            conn
            |> put_flash(:error, msg)
            |> redirect(to: Routes.loan_path(conn, :corperate_loan_bulkupload))
        end
      end









      defp push_invoice_or_order_number(logs_resp, _user, _, _) when not is_nil(logs_resp), do: logs_resp
      defp push_invoice_or_order_number(_logs_resp, user, _filename, items) do
        items
        |> Stream.with_index(1)
        |> Enum.map(fn {item, index} ->

          # bulk_loan_invoice_params = bulk_loan_invoice_number(item, user)
          # bulk_loan_order_params = bulk_loan_order_number(item, user)
          # IO.inspect(bulk_loan_invoice_or_order_params, label: "Check bulk_loan_invoice_or_order_params")
          # IO.inspect(user, label: "Check push_invoice_or_order_number user")
          # IO.inspect(item, label: "Check push_invoice_or_order_number item")
          loan_product_name = check_product(item.product_name)
          product_type = String.upcase(to_string(loan_product_name))
           IO.inspect(product_type, label: "Check push_invoice_or_order_number uproduct_type")
           case product_type do
            "INVOICE DISCOUNTING" ->
              # case bulk_loan_invoice_or_order_params
              changeset_loan_invoice_details = Loanmanagementsystem.Loan.Loan_invoice.changeset(%Loanmanagementsystem.Loan.Loan_invoice{}, bulk_loan_invoice_number(item, user))
              Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_loan_invoice_details)

            "ORDER FINANCE" ->
              changeset_loan_order_finance_details = Order_finance_loan_invoice.changeset(%Order_finance_loan_invoice{}, bulk_loan_order_number(item, user))
              Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_loan_order_finance_details)

           end


        end)

        |> List.flatten()
        |> Enum.reject(& !&1)
        |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
        |> execute_multi()
      end


      defp bulk_loan_invoice_number(item, _user) do
        product_name = check_product(item.product_name)
        product_type = String.upcase(to_string(product_name))
        user_bio_id= try do Company.find_by(registrationNumber: item.company_registration_number).user_bio_id rescue _-> "" end
        customer_id = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id).userId rescue _-> "" end

        productType = try do Loanmanagementsystem.Products.Product.find_by(productType: product_name).productType rescue _-> "" end
        # loan_id =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).id rescue _-> "" end
        # loan_id = LoanmanagementsystemWeb.BulkUploadsController.get_loan_id(customer_id, item.requested_amount)



            loan_id = LoanmanagementsystemWeb.CorperateBulkUploadsController.get_loan_id(customer_id, item.requested_amount, item.application_date, item.disbursedon_date)

            %{
              invoiceValue: item.invoice_value,
              invoiceNo: item.invoice_number,
              customer_id: customer_id,
              loanID: loan_id,
              status: "ACTIVE",
              dateOfIssue: if String.contains?(item.application_date, "-") do Date.from_iso8601!(String.replace(item.application_date, ~r"[ ]", "")) else Date.from_iso8601!(String.replace(convert_to_iso_date(item.application_date), ~r"[ ]", "")) end,
            }


      end

      defp bulk_loan_order_number(item, _user) do
        product_name = check_product(item.product_name)
        product_type = String.upcase(to_string(product_name))
        user_bio_id= try do Company.find_by(registrationNumber: item.company_registration_number).user_bio_id rescue _-> "" end
        customer_id = try do Loanmanagementsystem.Accounts.UserBioData.find_by(id: user_bio_id).userId rescue _-> "" end

        productType = try do Loanmanagementsystem.Products.Product.find_by(productType: product_name).productType rescue _-> "" end
        # loan_id =  try do Loans.find_by(customer_id: customer_id, requested_amount: item.requested_amount).id rescue _-> "" end
        # loan_id = LoanmanagementsystemWeb.BulkUploadsController.get_loan_id(customer_id, item.requested_amount)

            loan_id = LoanmanagementsystemWeb.CorperateBulkUploadsController.get_loan_id(customer_id, item.requested_amount, item.application_date, item.disbursedon_date)
            %{

              order_number: item.order_number,
              # order_value: item.order_value,
              customer_id: customer_id,
              loan_id: loan_id,
              status: "ACTIVE",
              order_date: if String.contains?(item.application_date, "-") do Date.from_iso8601!(String.replace(item.application_date, ~r"[ ]", "")) else Date.from_iso8601!(String.replace(convert_to_iso_date(item.application_date), ~r"[ ]", "")) end,

            }

      end






end
