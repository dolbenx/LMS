defmodule LoanSavingsSystem.Registration do

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo
  alias LoanSavingsSystem.Accounts.{User, UserRole}
  alias LoanSavingsSystem.Client.{UserBioData, NextOfKin}
  alias LoanSavingsSystem.Notifications.{Emails, Sms}
  alias LoanSavingsSystem.Companies.{Company, Documents}
  alias LoanSavingsSystem.Workers.Resource
  alias LoanSavingsSystem.Notification
  alias LoanSavingsSystem.Documents.DocumentPath
  alias LoanSavingsSystem.Logs.UserLogs




  #   LoanSavingsSystem.Registration.test1()
  def test1(dox) do
    # dox =
    # [
    #   %Plug.Upload{
    #     content_type: "application/pdf",
    #     filename: "LIFE.pdf",
    #     path: "C:\\Users\\musen\\AppData\\Local\\Temp/plug-1642/multipart-1642164024-287490772389163-1"
    #   },
    #   %Plug.Upload{
    #     content_type: "application/pdf",
    #     filename: "WATER.pdf",
    #     path: "C:\\Users\\musen\\AppData\\Local\\Temp/plug-1642/multipart-1642164024-287490772389163-1"
    #   }
    # ]
    num = length(dox) - 1
    docx =  Enum.map(0..num, fn x ->

      case File.cp(Enum.at(dox, x).path, "C:/Users/musen/OneDrive/Documents/test/#{Enum.at(dox, x).filename}") do
        :ok ->
          %{path: Enum.at(dox, x).path, name: Enum.at(dox, x).filename, status: "PENDING", inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second), updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second) }
        _ERROR -> []
      end
    end)

    # name = ["Incorporation", "Certificate"]

    # num = length(name) - 1
    IO.inspect " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    IO.inspect docx
    IO.inspect " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    # Enum.map(0..num, fn x -> %{doc_name: Enum.at(dox, x).filename, type: Enum.at(name, x),  path: Enum.at(dox, x).path} end) |> IO.inspect
    # IO.inspect " >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
  end


  def results(doc) do

  end

  def register(_conn, params) do
    params = Map.put(params, "permissions", "super_admin~deactivator~approver~creator") |> Map.put("otp", Integer.to_string(Enum.random(1_000..9_999)) ) |> Map.put("status", "PENDING")
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:company, company_params(Map.put(params, "status", "PENDING") ))
    |> Ecto.Multi.run(:user_log_company, fn _repo, %{company: company} ->
      case Repo.insert(UserLogs.changeset(%UserLogs{}, %{user_id: company.id, activity: "#{company.companyName} #{company.companyName} has been registered as an Company client"} )) do
        {:ok, user_logs} -> {:ok, user_logs}
        {:error, msg} -> {:error, msg}
      end
    end)
    |> Ecto.Multi.run(:user, fn _repo, %{company: company} ->
        password = Resource.random_string(3)
        case Repo.insert(User.changeset(%User{}, %{"createdByUserId" => company.id, "username" => params["emailAddress"], "auto_password" => "Y", "status" => "PENDING", "password" => password} ) ) do
          {:ok, user} ->
            Repo.insert(Emails.changeset(%Emails{}, prepare_emails(params, user, password) ))
            Repo.insert(Sms.changeset(%Sms{}, prepare_sms(params, user, password)  ))
            {:ok, user}
          {:error, changeset} -> {:error, changeset}
        end
    end)
    |> Ecto.Multi.run(:role, fn _repo, %{company: company, user: user} ->
      case Repo.insert(UserRole.changeset(%UserRole{}, %{userId: user.id, roleType: params["typ"], companyId: company.id, status: "ACTIVE"} ) ) do
        {:ok, role} -> {:ok, role}
          {:ok, role}
        {:error, changeset} -> {:error, changeset}
      end
    end)
    |> Ecto.Multi.run(:document, fn _repo, %{role: role, company: company, user: user} ->
      case insert_documents(params, company, user, params["document"], params["docname"], "Company", company.companyName) do
        {:ok, doc} -> {:ok, doc}
          {:ok, role}
        {:error, changeset} -> {:error, changeset}
      end
    end)
    |> Ecto.Multi.run(:boi_data, fn _repo, %{user: user} ->
    case Repo.insert(UserBioData.changeset(%UserBioData{},  Map.merge(Map.take(params, ["physical_address", "firstName", "lastName", "otherName", "dateOfBirth", "meansOfIdentificationType", "meansOfIdentificationNumber", "mobileNumber", "emailAddress"]), %{"userId" => user.id}) )) do
        {:ok, boi_data} -> {:ok, boi_data}
        {:error, changeset} -> {:error, changeset}
      end
    end)
    # |> Ecto.Multi.run(:platform_notification, fn _repo, %{company: company, user: user} ->
    #   case Notification.on_platform_notification(on_platform_notification(user, company, "/Registered/Company/Profiles")) do
    #       {:ok, notify} -> {:ok, notify}
    #       {:error, changeset} -> {:error, changeset}
    #     end
    # end)
    |> Ecto.Multi.run(:user_log, fn _repo, %{user: user, boi_data: boi_data, company: company} ->
      case Repo.insert(UserLogs.changeset(%UserLogs{}, %{user_id: user.id, activity: "#{boi_data.firstName} #{boi_data.lastName} has been registered as a user under #{company.companyName}"} )) do
        {:ok, user_logs} -> {:ok, user_logs}
        {:error, msg} -> {:error, msg}
      end
    end)
    |> Repo.transaction()
    |> case do
      {:ok, _} -> {:ok, "SME HAS BEEN CREATED SUCCESSFULLY"}
      {:error, _} -> {:error, "FAILED TO CREATE SME"}
    end
  end

  def company_params(params) do
    case params["typ"] do
      "SME" ->
        Company.changeset(%Company{}, Map.take(params, ["companyName", "contactPhone", "registrationNumber", "taxNo", "contactEmail"]) |> Map.put("isSme", true))
      "EMPLOYER" ->
        Company.changeset(%Company{}, Map.take(params, ["companyName", "contactPhone", "registrationNumber", "taxNo", "contactEmail"]) |> Map.put("isEmployer", true))
    end
  end


  def insert_documents(params, company, user, dox, names, type, belongs_to) do
    IO.inspect dox
    IO.inspect names
    IO.inspect belongs_to

    num = length(dox) - 1
    case Repo.one(from m in DocumentPath, where: m.applicable_on == ^"Registration" and m.belongs_to == ^type and m.status == ^"ACTIVE") do
      path ->
        case Repo.one(from m in DocumentPath, where: m.applicable_on == ^"#{company.companyName}_Registration" and m.belongs_to == ^company.companyName and m.created_by == ^company.id and m.path_name == ^company.companyName)  do
          nil ->
            case Repo.insert(DocumentPath.changeset(%DocumentPath{}, %{applicable_on: "#{company.companyName}_Registration", belongs_to: company.companyName, created_by: company.id, path: "#{path.path}/#{company.companyName}", path_name: company.companyName, status: "ACTIVE"})) do
              {:ok, resp} ->
                case File.mkdir_p!(resp.path) do
                  :ok ->
                    document = if length(names) == 0 do
                      []
                    else
                      # docx =  Enum.map(dox, fn doc ->
                      #   case File.cp(doc.path, "#{resp.path}/#{company.id}-#{doc.filename}") do
                      #     :ok ->
                      #       %{status: "PENDING", userID: user.id, companyID: company.id,taxNo: company.taxNo, path: "#{resp.path}/#{company.id}-#{doc.filename}",
                      #         inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second), updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second) }
                      #     _ERROR -> []
                      #   end
                      # end)


                      document =  Enum.map(0..num, fn x ->
                        case File.cp(Enum.at(dox, x).path, "#{resp.path}/#{company.id}-#{Enum.at(dox, x).filename}") do
                          :ok ->
                            %{docName: "TPIN", status: "PENDING", userID: user.id, companyID: company.id,taxNo: company.taxNo, path: "#{resp.path}/#{company.id}-#{Enum.at(dox, x).filename}",
                            inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second), updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second) }
                            %{path: Enum.at(dox, x).path, name: Enum.at(dox, x).filename, status: "PENDING", inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second), updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second) }
                          _ERROR -> []
                        end
                      end)

                      # num  = 0..length(names) -1
                      # for i <- num, do: Map.put(Enum.at(Enum.map([List.pop_at(docx, i)], fn {a, _y} -> a end), 0), :docName, Enum.at( Enum.map([List.pop_at(names, i)], fn {a, _y} -> a end), 0)  ) |> IO.inspect
                  end
                    docx =  Enum.map(dox, fn doc ->
                      case File.cp(doc.path, "#{resp.path}/#{company.id}-#{doc.filename}") do
                        :ok ->
                          %{status: "PENDING", userID: user.id, companyID: company.id,taxNo: company.taxNo, docType: "#{resp.path}/#{company.id}-#{doc.filename}",
                            inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second), updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second) }
                        _ERROR -> []
                      end
                    end)

                    document = if length(names) == 0 do
                      []
                    else
                      num  = 0..length(names) -1
                      for i <- num, do: Map.put(Enum.at(Enum.map([List.pop_at(docx, i)], fn {a, y} -> a end), 0), :docName, Enum.at( Enum.map([List.pop_at(names, i)], fn {a, y} -> a end), 0)  ) |> IO.inspect
                    end
                    case  Repo.insert_all(Documents, document) do
                      {num, nil} -> {:ok, num}
                      _ -> {:error, "Failed to insert documents"}
                    end
                  _anything_else -> {:error, "failed to create path for #{company.companyName}"}
                end
              {:error, _msg} -> {:error, "failed to create path for #{company.companyName}"}
            end
          found ->
            document = if length(names) == 0 do
                []
              else
                # docx =  Enum.map(dox, fn doc ->
                #   case File.cp(doc.path, "#{found.path}/#{company.id}-#{doc.filename}") do
                #     :ok ->
                #       %{userID: user.id, companyID: company.id,taxNo: company.taxNo, path: "#{found.path}/#{company.id}-#{doc.filename}",
                #         inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second), updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second) }
                #     _ERROR -> []
                #   end
                # end)
                # num  = 0..length(names) -1
                # for i <- num, do: Map.put(Enum.at(Enum.map([List.pop_at(docx, i)], fn {a, _y} -> a end), 0), :docName, Enum.at( Enum.map([List.pop_at(names, i)], fn {a, _y} -> a end), 0)  ) |> IO.inspect

                document =  Enum.map(0..num, fn x ->
                  case File.cp(Enum.at(dox, x).path, "#{found.path}/#{company.id}-#{Enum.at(dox, x).filename}") do
                    :ok ->
                      %{docName: Enum.at(names, 0).filename, status: "PENDING", userID: user.id, companyID: company.id,taxNo: company.taxNo, path: "#{found.path}/#{company.id}-#{Enum.at(dox, x).filename}",
                      inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second), updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second) }
                      %{path: Enum.at(dox, x).path, name: Enum.at(dox, x).filename, status: "PENDING", inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second), updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second) }
                    _ERROR -> []
                  end
                end)
              end
            docx =  Enum.map(dox, fn doc ->
              case File.cp(doc.path, "#{found.path}/#{company.id}-#{doc.filename}") do
                :ok ->
                  %{userID: user.id, companyID: company.id,taxNo: company.taxNo, docType: "#{found.path}/#{company.id}-#{doc.filename}",
                    inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second), updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second) }
                _ERROR -> []
              end
            end)
            document = for i <- 0..length(names) - 1, do: Map.put(Enum.at(Enum.map([List.pop_at(docx, i)], fn {a, _y} -> a end), 0), :docName, Enum.at( Enum.map([List.pop_at(names, i)], fn {a, _y} -> a end), 0)  ) |> IO.inspect

            case  Repo.insert_all(Documents, document) do
              {num, nil} ->
                {:ok, num}
              _ -> {:error, "Failed to insert documents"}
            end
        end
      nil -> {:error, "Company registration document path not found"}
    end
  end


  def on_platform_notification(user, company, url) do
    %{
      message: "profile registration",
      creator_id: company.id,
      belongs_to: "BACK_OFFICE",
      type: "REGISTRATION",
      creator_user_id: user.id,
      status: false,
      recipient_id: nil,
      url: url
    }
  end

  def prepare_emails(params, user, password) do
    params = Resource.to_atomic_map(params)
    %{
      email: params.email_address,
      msg: "Dear #{params.first_name} #{params.last_name}, your account has been created username: #{user.username} password: #{password}, otp: #{params["otp"]}",
      msg_count: "0",
      status: "READY",
      type: "SME",
      date_sent: NaiveDateTime.utc_now
    }
  end

  def prepare_sms(params, user, password) do
    params = Resource.to_atomic_map(params)
    %{
      mobile: params.mobile_number,
      msg: "Dear #{params.first_name} #{params.last_name}, your account has been created username: #{user.username} password: #{password}, otp: #{params["opt"]}",
      msg_count: "0",
      status: "READY",
      type: "SME",
      date_sent: NaiveDateTime.utc_now
    }
  end

    def register_individual(_conn, params) do
      password = Resource.random_string(3)
      Ecto.Multi.new()
      |> Ecto.Multi.insert(:individual, User.changeset(%User{}, %{username: params["emailAddress"], password: password, status: "PENDING", auto_password: "Y"} ) )
      |> Ecto.Multi.run(:boi_data, fn _repo, %{individual: individual} ->
        case Repo.insert(UserBioData.changeset(%UserBioData{}, Map.put(Map.take(params, ["physical_address", "firstName", "lastName", "otherName", "dateOfBirth", "meansOfIdentificationType", "meansOfIdentificationNumber", "mobileNumber", "emailAddress"]), "userId", individual.id ))) do
          {:ok, boi} ->
              Repo.insert(Emails.changeset(%Emails{}, prepare_emails(params, individual, password) ))
              Repo.insert(Sms.changeset(%Sms{}, prepare_sms(params, individual, password)  ))
              {:ok, boi}
          {:error, msg} -> {:error, msg}
        end
      end)
      |> Ecto.Multi.run(:next_of_kin, fn _repo, %{individual: individual} ->
        kin = insert_next_of_kin(params, individual)
        case Repo.insert(NextOfKin.changeset(%NextOfKin{}, kin)) do
          {:ok, resp} ->
            Repo.insert(Emails.changeset(%Emails{},  prepare_next_of_kin_emails(kin, params)   ))
            Repo.insert(Sms.changeset(%Sms{}, prepare_next_of_kin_sms(kin, params)))
            {:ok, resp}
          {:error, msg} -> {:error, msg}
        end
      end)
      |> Ecto.Multi.run(:user_log_next_of_king, fn _repo, %{next_of_kin: next_of_kin, boi_data: boi_data} ->
        case Repo.insert(UserLogs.changeset(%UserLogs{}, %{user_id: next_of_kin.id, activity: "#{next_of_kin.firstName} #{next_of_kin.lastName} has been registered as next of kin by #{boi_data.firstName} #{boi_data.lastName}"} )) do
          {:ok, user_logs} -> {:ok, user_logs}
          {:error, msg} -> {:error, msg}
        end
      end)
      |> Ecto.Multi.run(:document, fn _repo, %{individual: individual, boi_data: boi_data} ->
        case insert_documents(params, %{taxNo: nil, id: individual.id, companyName: "#{boi_data.firstName}_#{boi_data.lastName}"}, individual, params["document"], params["docname"], "Individual", "#{boi_data.firstName}_#{boi_data.lastName}") do
          {:ok, resp} ->  {:ok, resp}
          {:error, msg} -> {:error, msg}
        end
      end)
      |> Ecto.Multi.run(:role, fn _repo, %{company: company, user: user} ->
        case Repo.insert(UserRole.changeset(%UserRole{}, %{otp: params["otp"], userId: user.id, roleType: "INDIVIDUAL", companyId: company.id, status: "ACTIVE"} ) ) do
          {:ok, role} -> {:ok, role}
            {:ok, role}
          {:error, changeset} -> {:error, changeset}
        end
      end)
      |> Ecto.Multi.run(:platform_notification, fn _repo, %{individual: individual} ->
      case Notification.on_platform_notification( on_platform_notification(individual, individual, "/Registered/Individual/Profiles") ) do
          {:ok, notify} -> {:ok, notify}
          {:error, changeset} -> {:error, changeset}
        end
      end)
      |> Ecto.Multi.run(:user_log, fn _repo, %{individual: individual, boi_data: boi_data} ->
        case Repo.insert(UserLogs.changeset(%UserLogs{}, %{user_id: individual.id, activity: "#{boi_data.firstName} #{boi_data.lastName} has registered as an individual client"} )) do
          {:ok, user_logs} -> {:ok, user_logs}
          {:error, msg} -> {:error, msg}
        end
      end)
      |> Repo.transaction()
      |> case do
        {:ok, %{individual: _individual}} -> {:ok, "SME HAS BEEN CREATED SUCCESSFULLY"}
        {:error, _} -> {:error, "FAILED TO CREATE SME"}
      end
    end

    def insert_next_of_kin(params, user) do
      %{
        firstName: params["nokfirstName"],
        lastName: params["noklastName"],
        otherName: params["nokotherName"],
        otp: "#{Resource.otp}",
        email: params["nokemail"],
        phoneNumber: params["nokphoneNumber"],
        userId: user.id,
        addressLine1: params["nokphysical_address"],
      }
    end

    def prepare_next_of_kin_emails(kin, user) do
      %{
        email: kin.email,
        msg: "Dear #{kin.firstName} #{kin.lastName} you have been added as a next by #{user["firstName"]} #{user["lastName"]} of kin your otp is #{kin.otp}",
        msg_count: "0",
        status: "READY",
        type: "SME",
        date_sent: NaiveDateTime.utc_now
      }
    end

    def prepare_next_of_kin_sms(kin, user) do
      %{
        mobile: kin.phoneNumber,
        msg: "Dear #{kin.firstName} #{kin.lastName} you have been added as a next by #{user["firstName"]} #{user["lastName"]} of kin your otp is #{kin.otp}",
        msg_count: "0",
        status: "READY",
        type: "SME",
        date_sent: NaiveDateTime.utc_now
      }
    end

end
