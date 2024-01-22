defmodule Loanmanagementsystem.Services.IndividualUploads do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Accounts.Client_Documents
  alias Loanmanagementsystem.Logs.UserLogs

  def client_upload(%{"process_documents" => files, "conn" => conn, "individualId" => individualId, "nrc" => nrc ,"company_id"=> company_id}) do
    IO.inspect(files, label: "~~~~~~~~~~~~~")

    generate_path()
    |> case do
      {:ok, path} ->
        handle_documents(%{conn: conn, path: path, files: files, individualId: individualId, nrc: nrc, company_id: company_id})

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp generate_path() do
    new = new_route()

    path =
      File.cwd!<>"/priv/static"
      # Application.app_dir(:loanmanagementsystem, "priv/static")
      |> Path.join(new)

    IO.inspect(path)

    case File.dir?(path) do
      true ->
        case File.exists?(path) do
          false ->
            File.mkdir_p(path)
            |> IO.inspect(label: "PATH==================")
            |> case do
              :ok ->
                {:ok, path}

              {:error, :enoent} ->
                {:error, "A component of your path does not exist!"}

              {:error, :eacces} ->
                {:error, "Missing search or write permissions for the parent directories of path"}

              {:error, :enospc} ->
                {:error, "There is no space left on the device"}

              {:error, :enotdir} ->
                {:error, "A component of your path is not a directory"}

              {:error, :eexist} ->
                {:error, "There is already a file or directory named as your path"}

              {:error, reason} ->
                IO.inspect(reason, lael: "FAILED UPLOAD UTILS")
                {:error, "Error occurred during upload operations"}
            end

          true ->
            {:ok, path}
        end

      false ->
        File.mkdir_p(path)
        |> IO.inspect(label: "PATH==================")
        |> case do
          :ok ->
            {:ok, path}

          {:error, :enoent} ->
            {:error, "A component of your path does not exist!"}

          {:error, :eacces} ->
            {:error, "Missing search or write permissions for the parent directories of path"}

          {:error, :enospc} ->
            {:error, "There is no space left on the device"}

          {:error, :enotdir} ->
            {:error, "A component of your path is not a directory"}

          {:error, :eexist} ->
            {:error, "There is already a file or directory named as your path"}

          {:error, reason} ->
            IO.inspect(reason, lael: "FAILED UPLOAD UTILS")
            {:error, "Error occurred during upload operations"}
        end
    end
  end

  defp new_route() do
    # uuid = Ecto.UUID.generate()
    date_path = Date.utc_today()
    day = date_path.day

    "/individual_uploads/#{date_path.year}-#{date_path.month}-#{day}"
  end

  def handle_documents(%{conn: conn, path: path, files: files, individualId: individualId, nrc: nrc, company_id: company_id}) do
    IO.inspect(files, label: "~~~~~~~~~000")
    random_string = Ecto.UUID.generate()
    documents = if files["file"] == nil do
      [
        %{
          name: "",
          userID: 0,
          file: "",
          company_id: 0,
          path: "",
          docType: "",
          clientID: "",
          status: "",
          inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
          updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)

        }
      ]
      else
    Enum.map(files["file"], fn file_item ->
      file = "#{random_string}_#{file_item.filename}"
      docname = "#{file_item.filename}"
      # createdBy = conn.assigns.user.id
      base64file = Base.encode64(file_item.filename)
      type = file_item.content_type
      dest = String.replace("#{path}/#{file}", " ", "")
      IO.inspect(type, label: "type type type type type type type")
      File.cp!(file_item.path, dest)

              %{
                name: docname,
                userID: if is_nil(individualId) do nil else individualId end,
                file: base64file,
                company_id: if is_nil(company_id) do nil else company_id end ,
                path: dest,
                docType: type,
                clientID: nrc,
                status: "ACTIVE",
                inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second),
                updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second)
              }
              end)
            end


    {:ok, documents}
    |> handle_uploaded_files(conn)
  end

  def handle_uploaded_files(request, conn) do
    case request do
      {:ok, documents} ->
        Ecto.Multi.new()
        |> Ecto.Multi.insert_all(:documents, Client_Documents, documents)
        |> Ecto.Multi.insert(:user_logs, fn _response ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Document Uploaded Successfully",
            user_id: conn.assigns.user.id
          })
        end)
        |> Repo.transaction()
        |> case do
          {:ok, _} ->
            {:ok, "You have Successfully Uploaded a New Document"}

          {:error, _failed_operations, failed_value, _changes_so_far} ->
            reason = traverse_errors(failed_value.errors)

            {:error, reason}
        end

      {:error, reason} ->
        {:error, reason}
    end
  end

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
