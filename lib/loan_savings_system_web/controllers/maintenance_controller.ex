defmodule LoanSavingsSystemWeb.MaintenanceController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystem.Repo
  alias LoanSavingsSystem.Logs.UserLogs
  alias LoanSavingsSystem.Charges
  alias LoanSavingsSystem.Charges.AccountCharge
  alias LoanSavingsSystem.Companies
  alias LoanSavingsSystem.Companies.Branch
  alias LoanSavingsSystem.SystemSetting
  alias LoanSavingsSystem.SystemSetting.Country
  alias LoanSavingsSystem.SystemSetting.Currency
  alias LoanSavingsSystem.SystemDirectories
  alias LoanSavingsSystem.Charges.Charge
  alias LoanSavingsSystem.Documents.{DocumentPath, DocumentType}
  alias LoanSavingsSystem.Accounts
  alias LoanSavingsSystem.Accounts.SecurityQuestions
  alias LoanSavingsSystem.Notification
  alias LoanSavingsSystem.Notification.SmsNotificationConfiguration

    require Logger
        # alias LoanSavingsSystem.Accounts
        # alias MfzUssd.{Auth, Logs}

        alias LoanSavingsSystem.Repo
        require Record
        import Ecto.Query, only: [from: 2]

  @headers ~w/ name /a

  plug(
    LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
      when action not in [:new_password, :change_password]
    )

  def branch(conn, _params) do
    branches = Companies.list_tbl_branch()
    render(conn, "branch.html", branches: branches)
  end

  def add_branch(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:branches, Branch.changeset(%Branch{}, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{branches: branches} ->
      activity = "Created new Branch with ID \"#{branches.id}\""

      user_log = %{
            user_id: conn.assigns.user.id,
            activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{branches: _branches, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Branch Created successfully.")
        |> redirect(to: Routes.maintenance_path(conn, :branch))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :branch))
    end
    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occurred, reason unknown. try again")
    #     |> redirect(to: Routes.branch_path(conn, :index))
  end


    def document(conn, params) do
        query = from cl in LoanSavingsSystem.Documents.DocumentType, select: cl
            documents = Repo.all(query);
        render(conn, "document.html", documents: documents)
    end


    def add_document(conn, params) do
         current_user = get_session(conn, :current_user);
         Logger.info "Current User...#{current_user}"
         new_param = %{};
         new_param = Map.merge(new_param, %{"name" => params["name"] })
         new_param = Map.merge(new_param, %{"createdByUserId" => current_user })
         new_param = Map.merge(new_param, %{"documentFormats" => Enum.join(params["docTypes"], ", ") })
         new_param = Map.merge(new_param, %{"description" => (params["description"]) })
         Logger.info Jason.encode!(new_param);
         Ecto.Multi.new()
             |> Ecto.Multi.insert(:DocumentType, DocumentType.changeset(%DocumentType{}, new_param))
             |> Ecto.Multi.run(:user_log, fn _repo, %{DocumentType: DocumentType} ->
                activity = "Created new document type with code \"{DocumentType.id}\""

           user_log = %{
                 user_id: conn.assigns.user.id,
                 activity: activity
           }
           UserLogs.changeset(%UserLogs{}, user_log)
           |> Repo.insert()
         end)
         |> Repo.transaction()
           |> case do
             {:ok, %{DocumentType: _DocumentType, user_log: _user_log}} ->
               conn
               |> put_flash(:info, "Document  type Created successfully.")
               |> redirect(to: Routes.maintenance_path(conn, :document))

             {:error, _failed_operation, failed_value, _changes_so_far} ->
               reason = traverse_errors(failed_value.errors) |> List.first()

               conn
               |> put_flash(:error, reason)
               |> redirect(to: Routes.maintenance_path(conn, :document))
         end

    end




  def update_branch(conn, params) do
    branches = Companies.get_branch!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:branches, Branch.changeset(branches, params))
    |> Ecto.Multi.run(:user_log, fn (_, %{branches: branches}) ->
        activity = "Updated Branch with ID \"#{branches.id}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{branches: _branches, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Branch updated successfully")
        |> redirect(to: Routes.maintenance_path(conn, :branch))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.maintenance_path(conn, :branch))
    end
  end

  def notifications(conn, _params) do
    notifications = Notification.list_tbl_sms_notification_configuration()

    query = from cl in LoanSavingsSystem.Notification.SmsNotificationConfiguration, select: cl
		smsnotifications = Repo.all(query);

		existingConfig = []
		existingConfig = for x <- 0..(Enum.count(smsnotifications)-1) do
			Logger.info ">>>>>>>>>>>>"
			fcc = Enum.at(smsnotifications, x);
			IO.inspect fcc;
			existingConfig = existingConfig ++ ("#{fcc.actionType}_#{fcc.intervaltype}#{fcc.interval}#{fcc.days}#{fcc.numberOfSms}#{fcc.message}")
			existingConfig
		end

		IO.inspect existingConfig;

    render(conn, "notifications.html", notifications: notifications, existingConfig: existingConfig)
  end

  def add_notification_config(conn, params) do
    activity = "Created new notification with ID"
    params = Map.put(params, "user_id", conn.assigns.user.id)
    params = Map.put(params, "activity", activity)
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:user_log, UserLogs.changeset(%UserLogs{}, params))
    # |> Ecto.Multi.run(:notifications, fn _repo, %{user_log: _user_log} ->
    #   for x <- 0..(Enum.count(params["days"])-1) do
    #     IO.inspect ">>>>>>++++++++++++++++++>>>>>>"
    #     notifications =
    #     %{
    #         actionType: Enum.at(params["actionType"], x),
    #         days: Enum.at(params["days"], x),
    #         interval: Enum.at(params["interval"], x),
    #         intervaltype: Enum.at(params["intervaltype"], x),
    #         message: Enum.at(params["message"], x),
    #         numberOfSms: Enum.at(params["numberOfSms"], x),
    #     }
    #     SmsNotificationConfiguration.changeset(%SmsNotificationConfiguration{}, notifications)
    #     |> Repo.insert()
    #   end
    # end)
    |> Repo.transaction()
    |> case do
      {:ok, %{user_log: _user_log}} ->

        for x <- 0..(Enum.count(params["days"])-1) do
          IO.inspect ">>>>>>++++++++++++++++++>>>>>>"
          notifications =
          %{
              actionType: Enum.at(params["actionType"], x),
              days: Enum.at(params["days"], x),
              interval: Enum.at(params["interval"], x),
              intervaltype: Enum.at(params["intervaltype"], x),
              message: Enum.at(params["message"], x),
              numberOfSms: Enum.at(params["numberOfSms"], x),
          }
          SmsNotificationConfiguration.changeset(%SmsNotificationConfiguration{}, notifications)
          |> Repo.insert()
        end

        conn
        |> put_flash(:info, "Notifications Created successfully.")
        |> redirect(to: Routes.maintenance_path(conn, :notifications))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :notifications))
    end
  end
























  def questions(conn, _params) do
    questions = Accounts.list_tbl_security_questions()
    render(conn, "questions.html", questions: questions)
  end

  def add_questions(conn, params) do
    params = Map.put(params, "status", "ACTIVE")
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:questions, SecurityQuestions.changeset(%SecurityQuestions{}, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{questions: questions} ->
      activity = "Created new Question with ID \"#{questions.id}\""

      user_log = %{
            user_id: conn.assigns.user.id,
            activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{questions: _questions, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Questions Created successfully.")
        |> redirect(to: Routes.maintenance_path(conn, :questions))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :questions))
    end
    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occurred, reason unknown. try again")
    #     |> redirect(to: Routes.branch_path(conn, :index))
end




def update_questions(conn, params) do
  questions = Accounts.get_security_questions!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:questions, SecurityQuestions.changeset(questions, params))
    |> Ecto.Multi.run(:user_log, fn (_, %{questions: questions}) ->
      activity = "Updated Question with ID \"#{questions.id}\""

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
    {:ok, %{questions: _questions, user_log: _user_log}} ->
      conn
      |> put_flash(:info, "Question updated successfully")
      |> redirect(to: Routes.maintenance_path(conn, :questions))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :questions))
    end
end

def question_disable(conn, params) do
  questions = Accounts.get_security_questions!(params["id"])
  Ecto.Multi.new()
  |> Ecto.Multi.update(:question, SecurityQuestions.changeset(questions, %{status: "DISABLED"}))
  |> Ecto.Multi.run(:user_log, fn (_, %{question: _question}) ->
      activity = "Question Disabled with ID \"#{questions.id}\""

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, %{question: _question, user_log: _user_log}} ->
      conn |> json(%{message: "Question Disabled successfully", status: 0})
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn |> json(%{message: reason, status: 1})
  end
end

def question_activate(conn, params) do
  questions = Accounts.get_security_questions!(params["id"])
  Ecto.Multi.new()
  |> Ecto.Multi.update(:question, SecurityQuestions.changeset(questions, %{status: "ACTIVE"}))
  |> Ecto.Multi.run(:user_log, fn (_, %{question: _question}) ->
      activity = "Question Activated with ID \"#{questions.id}\""

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, %{question: _question, user_log: _user_log}} ->
      conn |> json(%{message: "Question Activated successfully", status: 0})
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn |> json(%{message: reason, status: 1})
  end
end

































  def currency(conn, _params) do
    currencies = SystemSetting.currency_name()
    countries = SystemSetting.list_tbl_country()
    render(conn, "currency.html", currencies: currencies, countries: countries)
  end

  def add_currency(conn, params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:currencies, Currency.changeset(%Currency{}, params))
    |> Ecto.Multi.run(:user_log, fn _repo, %{currencies: currencies} ->
      activity = "Created new Currency with code \"#{currencies.id}\""

      user_log = %{
            user_id: conn.assigns.user.id,
            activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{currencies: _currencies, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Currency Created successfully.")
        |> redirect(to: Routes.maintenance_path(conn, :currency))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()

        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :currency))
    end
    # rescue
    #   _ ->
    #     conn
    #     |> put_flash(:error, "An error occurred, reason unknown. try again")
    #     |> redirect(to: Routes.branch_path(conn, :index))
  end

  def update_currency(conn, params) do
    currencies = SystemSetting.get_currency!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:currencies, Currency.changeset(currencies, params))
    |> Ecto.Multi.run(:user_log, fn (_, %{currencies: currencies}) ->
        activity = "Updated Currency with code \"#{currencies.id}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{currencies: _currencies, user_log: _user_log}} ->
        conn
        |> put_flash(:info, "Currency updated successfully")
        |> redirect(to: Routes.maintenance_path(conn, :currency))

        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn
          |> put_flash(:error, reason)
          |> redirect(to: Routes.maintenance_path(conn, :currency))
    end
  end

  def approve_currency(conn, params) do
    currencies = SystemSetting.get_currency!(params["id"])
    Ecto.Multi.new()
    |> Ecto.Multi.update(:currencies, Currency.changeset(currencies, %{status: "ACTIVE" }))
    |> Ecto.Multi.run(:user_log, fn (_, %{currencies: _currencies}) ->
        activity = "Currency approved with code \"#{currencies.id}\""

        user_logs = %{
          user_id: conn.assigns.user.id,
          activity: activity
        }

        UserLogs.changeset(%UserLogs{}, user_logs)
        |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{currencies: _currencies, user_log: _user_log}} ->
        conn |> json(%{message: "Currency approved successfully", status: 0})
        {:error, _failed_operation, failed_value, _changes_so_far} ->
          reason = traverse_errors(failed_value.errors) |> List.first()
          conn |> json(%{message: reason, status: 1})
    end
  end

















  def country(conn, _params) do
    countries = SystemSetting.list_tbl_country()
    render(conn, "countries.html", countries: countries)
  end

  def handle_bulk_upload(conn, params) do
    user = conn.assigns.user

    {key, msg, _invalid} = handle_file_upload(user, params)

    if key == :info do
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.maintenance_path(conn, :country))

    else
      conn
      |> put_flash(key, msg)
      |> redirect(to: Routes.maintenance_path(conn, :country))
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
    # try do
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
                %{country_file_name: _src} -> {invalid, valid + 1}
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

  defp prepare_bulk_params(user, filename, items) do

    items
    |> Stream.with_index(2)
    |> Stream.map(fn {item, index} ->
      changeset =
        %Country{country_file_name: filename}
        |> Country.changeset(Map.put(item, :user_id, user.id))

      Ecto.Multi.insert(Ecto.Multi.new(), Integer.to_string(index), changeset)

    end)

    # |> filter_upload_errors(filename)
    |> Enum.reject(fn
      %{operations: [{_, {:run, _}}]} -> false
      %{operations: [{_, {_, changeset, _}}]} -> changeset.valid? == false
    end)
    |> Enum.reduce(Ecto.Multi.new(), &Ecto.Multi.append/2)
  end

  # ---------------------- file persistence --------------------------------------
  def is_valide_file(%{"country_file_name" => params}) do
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





























def charge(conn, _params) do
  charges = Charges.list_tbl_charge()
  currencies = SystemSetting.list_tbl_currency()
  render(conn, "charge.html", charges: charges, currencies: currencies)
end

def add_charge(conn, params) do
	host = conn.host
	query = from cl in LoanSavingsSystem.SystemSetting.ClientTelco, where: (cl.domain== ^host), select: cl
	clientTelco = Repo.one(query);


  IO.inspect params["currency"]
  currency_ = String.split(params["currency"], "|||");
  IO.inspect currency_
  # params = Map.merge(params, %{"currency"=> Enum.at(currency_, 1), "currencyId"=> Enum.at(currency_, 0), "clientId"=> clientTelco.clientId})
  params = Map.merge(params, %{"currency"=> Enum.at(currency_, 1), "currencyId"=> Enum.at(currency_, 0), "clientId" => 1})
  IO.inspect params
  #params["currencyId"] = Enum.at(currency_, 0);
  #params["currency"] = Enum.at(currency_, 1);
  chargeChangeSet = Charge.changeset(%Charge{}, params)
  Ecto.Multi.new()
  |> Ecto.Multi.insert(:charges, chargeChangeSet)
  |> Ecto.Multi.run(:user_log, fn _repo, %{charges: charges} ->
    activity = "Created new Charges with ID \"#{charges.id}\""

    user_log = %{
          user_id: conn.assigns.user.id,
          activity: activity
    }

    UserLogs.changeset(%UserLogs{}, user_log)
    |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, %{charges: _charges, user_log: _user_log}} ->
      conn
      |> put_flash(:info, "Charge Created successfully.")
      |> redirect(to: Routes.maintenance_path(conn, :charge))

    {:error, _failed_operation, failed_value, _changes_so_far} ->
      reason = traverse_errors(failed_value.errors) |> List.first()

      conn
      |> put_flash(:error, reason)
      |> redirect(to: Routes.maintenance_path(conn, :charge))
  end
  # rescue
  #   _ ->
  #     conn
  #     |> put_flash(:error, "An error occurred, reason unknown. try again")
  #     |> redirect(to: Routes.branch_path(conn, :index))
end

def update_charge(conn, params) do
  charges = Charges.get_account_charge!(params["id"])
  Ecto.Multi.new()
  |> Ecto.Multi.update(:charges, Charge.changeset(charges, params))
  |> Ecto.Multi.run(:user_log, fn (_, %{charges: charges}) ->
      activity = "Updated Charge with ID \"#{charges.id}\""

      user_logs = %{
        user_id: conn.assigns.user.id,
        activity: activity
      }

      UserLogs.changeset(%UserLogs{}, user_logs)
      |> Repo.insert()
  end)
  |> Repo.transaction()
  |> case do
    {:ok, %{charges: _charges, user_log: _user_log}} ->
      conn
      |> put_flash(:info, "Charge updated successfully")
      |> redirect(to: Routes.maintenance_path(conn, :charges))

      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        conn
        |> put_flash(:error, reason)
        |> redirect(to: Routes.maintenance_path(conn, :charges))
  end
end



  ################################################################################################################################################################################################################################################
  ################################################################################################################################################################################################################################################
  ################################################################################################################################################################################################################################################
  ################################################################################################################################################################################################################################################


  # ------------------------------------------------------End of Company maintianance

  def document_type(conn, _params), do: render(conn, "document_type.html", dox: Repo.all(DocumentType) )
  def loans_document_type(conn, _params), do: render(conn, "loans_document_type.html", dox: Repo.all(DocumentType) )

  def add_document_type(conn, params) do
    case Repo.insert(DocumentType.changeset(%DocumentType{}, Map.merge(params , %{"where" => "REGISTRATION", "created_by" => conn.assigns.user.id} ))) do
      {:ok, doc} -> conn |> put_flash(:info, "#{params["doc_type"]} document type  for #{params["belongs_to"]} has created successfully.")  |> redirect(to: Routes.maintenance_path(conn, :document_type))
      {:error, msg} -> conn |> put_flash(:error, "Failed to create #{params["doc_type"]} document type  for #{params["belongs_to"]}")  |> redirect(to: Routes.maintenance_path(conn, :document_type))
    end
  end
  def loans_add_document_type(conn, params) do
    case Repo.insert(DocumentType.changeset(%DocumentType{}, Map.merge(params , %{"where" => "REGISTRATION", "created_by" => conn.assigns.user.id} ))) do
      {:ok, doc} -> conn |> put_flash(:info, "#{params["doc_type"]} document type  for #{params["belongs_to"]} has created successfully.")  |> redirect(to: Routes.maintenance_path(conn, :loans_document_type))
      {:error, msg} -> conn |> put_flash(:error, "Failed to create #{params["doc_type"]} document type  for #{params["belongs_to"]}")  |> redirect(to: Routes.maintenance_path(conn, :loans_document_type))
    end
  end

  def activate_doc_type(conn, %{"id" => id}) do
    case activate(Repo.get_by(DocumentType, id: id), %{status: "ACTIVE", approved_by: conn.assigns.user.id}) do
      {:ok, _resp} -> conn |> put_flash(:info, "Successfully Activate document type.")  |> redirect(to: Routes.maintenance_path(conn, :document_type))
      {:error, _meg} -> conn |> put_flash(:error, "Failed to Activate Document type.")  |> redirect(to: Routes.maintenance_path(conn, :document_type))
    end
  end

  def activate(%DocumentType{} = document_type, changes), do: Repo.update(DocumentType.changeset(document_type, changes))

  def deactivate_doc_type(conn, %{"id" => id}) do
    case activate(Repo.get_by(DocumentType, id: id), %{status: "DISABLED"}) do
      {:ok, _resp} -> conn |> put_flash(:info, "Successfully Disabled document type.")  |> redirect(to: Routes.maintenance_path(conn, :document_type))
      {:error, _meg} -> conn |> put_flash(:error, "Failed to Disable Document type.")  |> redirect(to: Routes.maintenance_path(conn, :document_type))
    end
  end

  def deactivate(%DocumentType{} = document_type, changes), do: Repo.update(DocumentType.changeset(document_type, changes))

  #------------------------------- Document Files
  def document_files(conn, _params) do
    render(conn, "document_files.html", path: Repo.all(DocumentPath))
  end

  def loans_document_files(conn, _params) do
    render(conn, "loans_document_files.html", path: Repo.all(DocumentPath))
  end

  # def test do # LoanSavingsSystemWeb.MaintenanceController.test
  # Repo.one(from m in DocumentPath, where: m.belongs_to == ^"SME" and m.applicable_on == ^"ALL") |> IO.inspect
  #   case Repo.all(from m in DocumentPath, where: m.belongs_to == ^"SME" and m.applicable_on == ^"ALL") do
  #     [] -> IO.inspect " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  #     _ -> true
  #   end
  # end

  def maintain_file_paths(conn, params) do
    case Repo.all(from m in DocumentPath, where: m.belongs_to == ^params["belongs_to"] and m.applicable_on == ^params["applicable_on"]) do
      {:ok, resp} -> conn |> put_flash(:info, "path already exist and directs to folder resp.path_name")  |> redirect(to: Routes.maintenance_path(conn, :document_files))
      [] ->
        # env_var_path = System.get_env("Mfz")
        env_var_path = File.cwd!<>"/priv/static/documents"
        if env_var_path do
          file_name = String.trim(params["path_name"]) |> String.replace(~r"[:!@#$%^&*|,./-]", "_") |> String.replace(" ", "_")
          path = String.replace(env_var_path, "\\", "/") <> "/" <> file_name
          case File.mkdir_p!(path) do
            :ok ->
              Ecto.Multi.new()
              |> Ecto.Multi.insert(:doc_path, DocumentPath.changeset(%DocumentPath{}, Map.put(params, "path", path)   ) )
              |> Ecto.Multi.run(:user_log, fn _repo, %{doc_path: doc_path} ->
                case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs = %{user_id: conn.assigns.user.id, activity: "#{doc_path.path_name} folder has been created.}"} )) do
                  {:ok, resp} -> {:ok, resp}
                  {:error, msg} -> {:error, msg}
                end
              end)
              |> Repo.transaction
              |> case do
                {:ok, %{doc_path: doc_path, user_log: user_log}} -> conn |> put_flash(:info, "Successfully created #{params["path_name"]} folder.") |> redirect(to: Routes.maintenance_path(conn, :document_files))
                {:error, msg} -> conn |> put_flash(:error, "Failed to create folder #{params["path_name"]}")  |> redirect(to: Routes.maintenance_path(conn, :document_files))
              end
          _ -> conn |> put_flash(:error, "Failed to create folder #{params["path_name"]}")  |> redirect(to: Routes.maintenance_path(conn, :document_files))
          end
        else
          conn |> put_flash(:info, "Create a folder and Configure it in Environment Variables with name Mfz.")  |> redirect(to: Routes.maintenance_path(conn, :document_files))
        end
    end
  end


  def activate_file_path(conn, %{"id" => id}) do
    path = Repo.get_by(DocumentPath, id: id)
    Ecto.Multi.new()
    |> Ecto.Multi.update(:doc_path, DocumentPath.changeset(path, %{status: "ACTIVE"}))
    |> Ecto.Multi.run(:user_log, fn _repo, %{doc_path: doc_path} ->
      case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs = %{user_id: conn.assigns.user.id, activity: "#{path.path_name} folder has been activated.}"} )) do
        {:ok, resp} -> {:ok, resp}
        {:error, msg} -> {:error, msg}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{doc_path: doc_path, user_log: user_log}} -> conn |> put_flash(:info, "Successfully activated #{path.path_name} path.") |> redirect(to: Routes.maintenance_path(conn, :document_files))
      {:error, msg} -> conn |> put_flash(:error, "Failed to activate #{path.path_name} file path") |> redirect(to: Routes.maintenance_path(conn, :document_files))
    end
  end


  def disable_file_path(conn, %{"id" => id}) do
    path = Repo.get_by(DocumentPath, id: id)
    Ecto.Multi.new()
    |> Ecto.Multi.update(:doc_path, DocumentPath.changeset(path, %{status: "DISABLED"}))
    |> Ecto.Multi.run(:user_log, fn _repo, %{doc_path: doc_path} ->
      case Repo.insert(UserLogs.changeset(%UserLogs{}, user_logs = %{user_id: conn.assigns.user.id, activity: "#{path.path_name} folder has been deactivated.}"} )) do
        {:ok, resp} -> {:ok, resp}
        {:error, msg} -> {:error, msg}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{doc_path: doc_path, user_log: user_log}} -> conn |> put_flash(:info, "Successfully deactivated #{path.path_name} path.") |> redirect(to: Routes.maintenance_path(conn, :document_files))
      {:error, msg} -> conn |> put_flash(:error, "Failed to deactivated #{path.path_name} file path") |> redirect(to: Routes.maintenance_path(conn, :document_files))
    end
  end


  defp write_to_file(path, contents) do
    path = "C:\Users\musen\OneDrive\Documents\musenga"
    with :ok <- File.mkdir_p(Path.dirname(path)),
        :ok <- File.write(path, contents)
    do
      :ok
    end
  end

  def registered_sme(conn, _params) do
    render(conn, "registered_sme.html")
  end

  def registered_individual_profiles(conn, _params) do
    render(conn, "registered_individual_profiles.html")
  end

  def registered_company_profiles(conn, _params) do
    render(conn, "registered_company_profiles.html")
  end


  def emails(conn, _params) do
    render(conn, "emails.html")
  end

  def sms(conn, _params) do
    render(conn, "sms.html")
  end


  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}"
  end

end
