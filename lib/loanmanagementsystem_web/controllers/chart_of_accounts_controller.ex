defmodule LoanmanagementsystemWeb.ChartOfAccountsController do
  use LoanmanagementsystemWeb, :controller
  alias Loanmanagementsystem.Chart_of_accounts
  alias Loanmanagementsystem.Chart_of_accounts.Chart_of_account
  alias LoanmanagementsystemWeb.UserController
  alias Loanmanagementsystem.{Repo, Logs.UserLogs}
  alias Loanmanagementsystem.Chart_of_accounts.Gl_balance
  alias Loanmanagementsystem.Chart_of_accounts.Accounts_mgt


  @headers ~w/ ac_gl_no ac_gl_descption gl_category leaf_or_node node_gl /a




  plug LoanmanagementsystemWeb.Plugs.Authenticate,
       [module_callback: &LoanmanagementsystemWeb.ChartOfAccountsController.authorize_role/1]
       when action not in [
			:authorise_general_ledger_account,
			:calculate_page_num,
			:calculate_page_size,
			:chart_of_accounts,
			:chart_of_accounts_item_lookup,
			:create_general_ledger_account,
			:csv,
			:default_dir,
			:edit_general_ledger_account,
			:entries,
			:extract_xlsx,
			:handle_chart_of_account_bulk_upload,
			:is_valide_file,
			:persist,
			:process_bulk_upload,
			:process_csv,
			:search_options,
			:total_entries,
			:traverse_errors,

            ]

  use PipeTo.Override



  def chart_of_accounts(conn, _params), do: render(conn, "chart_of_accounts.html")

  def chart_of_accounts_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = Chart_of_accounts.list_tbl_chart_of_accounts_gl(search_params, start, length)
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

  def create_general_ledger_account(conn, params) do
    param =
      Map.merge(params, %{
        "ac_open_date" => to_string(Timex.today()),
        "ac_or_gl" =>
          if params["gl_type"] == "Internal" do
            "GL"
          else
            "Cust"
          end,
        "ac_status" => "INACTIVE",
        "auth_status" => "PENDING_APPROVAL"
      })
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :chart_of_account,
      Chart_of_account.changeset(%Chart_of_account{}, param)
    )
    |> Ecto.Multi.run(:user_logs, fn _repo, %{chart_of_account: chart_of_account} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "Created a General Ledger Account Successfully with Gl  NO: \"#{chart_of_account.ac_gl_no}\" and Description: \"#{chart_of_account.ac_gl_descption}\" .",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{chart_of_account: _chart_of_account, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Created a General Ledger Account Successfully.")
        |> redirect(to: Routes.chart_of_accounts_path(conn, :chart_of_accounts))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = UserController.traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.chart_of_accounts_path(conn, :chart_of_accounts))
    end
  end

  def edit_general_ledger_account(conn, params) do
    general_ledger_ac_details = Chart_of_accounts.get_chart_of_account!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :general_ledger_ac_details,
      Chart_of_account.changeset(general_ledger_ac_details, params)
    )
    |> Ecto.Multi.run(:user_logs, fn _repo,
       %{general_ledger_ac_details: general_ledger_ac_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "Edited  a General Ledger Account Successfully with Gl  NO: \"#{general_ledger_ac_details.ac_gl_no}\" and Description: \"#{general_ledger_ac_details.ac_gl_descption}\" .",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{general_ledger_ac_details: _general_ledger_ac_details, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Edited a General Ledger Account Successfully.")
        |> redirect(to: Routes.chart_of_accounts_path(conn, :chart_of_accounts))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = UserController.traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.chart_of_accounts_path(conn, :chart_of_accounts))
    end
  end

  def authorise_general_ledger_account(conn, params) do
    general_ledger_ac_details = Chart_of_accounts.get_chart_of_account!(params["id"])
    param =
      Map.merge(params, %{
        "ac_status" => "ACTIVE",
        "auth_status" => "AUTHORISED",
        "fcy_bal" => 0.0,
        "lcy_bal" => 0.0
      })
    Ecto.Multi.new()
    |> Ecto.Multi.update(
      :general_ledger_ac_details,
      Chart_of_account.changeset(general_ledger_ac_details, param)
    )
    |> Ecto.Multi.run(:user_logs, fn _repo,
      %{general_ledger_ac_details: general_ledger_ac_details} ->
      UserLogs.changeset(%UserLogs{}, %{
        activity:
          "Authorised a General Ledger Account Successfully with Gl  NO: \"#{general_ledger_ac_details.ac_gl_no}\" and Description: \"#{general_ledger_ac_details.ac_gl_descption}\" .",
        user_id: conn.assigns.user.id
      })
      |> Repo.insert()
      if params["leaf_or_node"] == "DETAIL" do
        Accounts_mgt.changeset(%Accounts_mgt{}, %{
          account_no: params["ac_gl_no"],
          account_name: params["ac_gl_descption"],
          type: "GL",
          status: "ACTIVE"
        })
        |> Repo.insert()
      end
      Gl_balance.changeset(%Gl_balance{}, %{
        account_gl_number: params["ac_gl_no"],
        account_gl_name: params["ac_gl_descption"],
        currency: params["ac_gl_ccy"],
        fin_period: String.upcase(Timex.format!(Timex.today, "%b", :strftime)),
        fin_year: "FY#{Timex.today.year}",
        gl_category: params["gl_category"],
        gl_date: Timex.today,
        gl_type: params["gl_type"],
        node: params["node_gl"],
        dr_balance: 0,
        cr_balance: 0
      })
      |> Repo.insert()

    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{general_ledger_ac_details: _general_ledger_ac_details, user_logs: _user_logs}} ->
        conn
        |> put_flash(:info, "Authorised a General Ledger Account Successfully.")
        |> redirect(to: Routes.chart_of_accounts_path(conn, :chart_of_accounts))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = UserController.traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.chart_of_accounts_path(conn, :chart_of_accounts))
    end
  end

  @headers ~w/ gl_Number gl_Type gl_Descption gl_Category gl_Classification node_GL /a
  def handle_chart_of_account_bulk_upload(conn, params) do
    user = conn.assigns.user
    {key, msg, _invalid} = handle_file_upload(user, params)

    if key == :info do
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.chart_of_accounts_path(conn, :chart_of_accounts))
    else
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.chart_of_accounts_path(conn, :chart_of_accounts))
    end
  end

  defp handle_file_upload(user, params) do
    with {:ok, filename, destin_path, _rows} <- is_valide_file(params) do
      user
      |> process_bulk_upload(filename, destin_path)
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

  def process_bulk_upload(user, filename, path) do
    {:ok, items} = extract_xlsx(path)

    prepare_bulk_params(user, filename, items)
    |> Repo.transaction(timeout: 290_000)
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
    end
  end

  defp prepare_bulk_params(user, filename, items) do
    items
    |> Stream.with_index(2)
    |> Stream.map(fn {item, index} ->
      other_details = %{
        ac_gl_no: item.gl_Number,
        gl_type: item.gl_Type,
        ac_gl_descption: item.gl_Descption,
        leaf_or_node: item.gl_Classification,
        gl_ategory: item.gl_Category,
        node_gl: item.node_GL,
        auth_status: "AUTHORISED",
        uploafile_name: filename,
        ac_open_date: to_string(Timex.today()),
      }

      changeset = Chart_of_account.changeset(%Chart_of_account{}, Map.merge(item, other_details))
      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset)
    end)
    |> Enum.reject(fn
      %{operations: [{_, {:run, _}}]} -> false
      %{operations: [{_, {_, changeset, _}}]} -> changeset.valid? == false
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
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
    destin_path = "C:/Chartofaccount/file" |> default_dir()
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

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
  end

  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:chart_of_accounts, :create}
      act when act in ~w(index view)a -> {:chart_of_accounts, :view}
      act when act in ~w(update edit)a -> {:chart_of_accounts, :edit}
      act when act in ~w(change_status)a -> {:chart_of_accounts, :change_status}
      _ -> {:chart_of_accounts, :unknown}
    end
  end

end
