defmodule LoanmanagementsystemWeb.LoanbulkuploadController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Loan.Loan_customer_details
  # alias Loanmanagementsystem.Accounts.Nextofkin
  # alias Loanmanagementsystem.Loan.Loan_applicant_reference
  # alias Loanmanagementsystem.Loan.Loan_applicant_collateral
  # alias Loanmanagementsystem.Loan.Loan_applicant_guarantor
  alias Loanmanagementsystem.Loan.Loans
  # alias Loanmanagementsystem.Loan.Loan_recommendation_and_assessment
  # alias Loanmanagementsystem.Loan.Loan_market_info
  # alias Loanmanagementsystem.Loan.Loan_employment_info
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Products.Product

  plug LoanmanagementsystemWeb.Plugs.Authenticate,
       [module_callback: &LoanmanagementsystemWeb.ClientManagementController.authorize_role/1]
       when action not in [
        :loan_application_upload,
        :handle_loan_bulk_upload,
            ]

  use PipeTo.Override


  def loan_application_upload(conn, _params) do
    render(conn, "loan_bulkupload.html")
  end

  @headers ~w/ title	firstName	lastName	otherName	gender	marital_status	dateOfBirth	idType	idNumber	mobileNumber	emailAddress	nationality	number_of_dependants	accomodation_status	year_at_current_address	area	house_number	street_name	town	province	land_mark	companyName	company_phone	company_registration_date	contact_email	registration_number	company_bank_name	company_account_name	employement_type	employer_industry_type	employer_office_building_name	employer_officer_street_name	hr_supervisor_email	hr_supervisor_mobile_number	hr_supervisor_name	occupation	kin_ID_number	kin_first_name	kin_last_name	kin_other_name	kin_gender	kin_mobile_number	kin_personal_email	kin_relationship	accountName	accountNumber	bankName	branchName	loan_limit	with_mou	roleType  /a

  def handle_loan_bulk_upload(conn, params) do
    user = conn.assigns.user
    {key, msg, _invalid} = handle_file_upload(user, params)

    if key == :info do
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))
    else
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.client_management_path(conn, :individual_maintainence))
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
         |> prepare_loans_bulk_params(filename, items)
         |> prepare_loan_customer_details_bulk_params(user, filename, items)
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

  defp prepare_loan_customer_details_bulk_params(address_resp, _user, _, _) when not is_nil(address_resp), do: address_resp
  defp prepare_loan_customer_details_bulk_params(_address_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      customer_params = prepare_loan_customer_details_params(item, user)
      changeset_customer = Loan_customer_details.changeset(%Loan_customer_details{}, customer_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_customer)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end



  defp prepare_loans_bulk_params(user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      customer_id = try do UserBioData.find_by(mobileNumber: item.mobileNumber).userId rescue _-> 0 end
      reference_no = generate_reference_no(customer_id)
      loans_params = prepare_loans_params(item, user, reference_no, customer_id)
      changeset_loans = Loans.changeset(%Loans{}, loans_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_loans)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
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

  defp prepare_logs_bulk_params(logs_resp, _user, _, _) when not is_nil(logs_resp), do: logs_resp
  defp prepare_logs_bulk_params(_logs_resp, user, _filename, items) do
    items
    |> Stream.with_index(1)
    |> Enum.map(fn {item, index} ->
      user_logs_params = prepare_user_logs_params(item, user)
      changeset_userlogs = UserLogs.changeset(%UserLogs{}, user_logs_params)
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset_userlogs)
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
    |> execute_multi()
  end



  defp prepare_loan_customer_details_params(item, _user) do
    %{
      customer_id: item.accomodation_status,
      reference_no: item.year_at_current_address,
      firstname: item.area,
      surname: item.house_number,
      othername: item.street_name,
      id_type: item.town,
      # id_number: User.find_by(username: item.mobileNumber).id,
      gender: item.province,
      marital_status: item.land_mark,
      cell_number: item.accomodation_status,
      email: item.year_at_current_address,
      dob: item.area,
      residential_address: item.house_number,
      landmark: item.street_name,
      town: item.town,
      province: item.province,
      crb_consent: item.land_mark,
    }
  end

  defp prepare_loans_params(item, _user, reference_no, customer_id) do
    cro_id = try do UserBioData.find_by(meansOfIdentificationNumber: item.cro_id).userId rescue _-> 0 end
    product_id = try do Product.find_by(name: item.productName).id rescue _-> 0 end
    %{
      loan_type: item.loan_type,
      principal_amount: item.requested_amount,
      principal_amount_proposed: item.requested_amount,
      customer_id: customer_id,
      reference_no: reference_no,
      product_id: product_id,
      loan_status: item.loan_status,
      status: item.loan_status,
      requested_amount: item.requested_amount,
      monthly_installment: item.monthly_installment,
      proposed_repayment_date: item.proposed_repayment_date,
      loan_purpose: item.loan_purpose,
      application_date: item.application_date,
      cro_id: cro_id
    }
  end

  defp prepare_user_logs_params(item, user) do
    %{
      activity: "You have Successfully Added #{item.firstName} #{item.lastName} has a client",
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


  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")



end
