defmodule Loanmanagementsystem.Services.MerchantUploads do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  # alias Loanmanagementsystem.Companies.Documents
  alias Loanmanagementsystem.Merchants.Merchants_document
  alias Loanmanagementsystem.Logs.UserLogs

  def merchant_upload(%{"process_documents" => files, "conn" => conn, "company_id" => company_id, "individualId" => individualId, "tax" => tax}) do
    IO.inspect(files, label: "~~~~~~~~~~~~~")

    generate_path()
    |> case do
      {:ok, path} ->
        handle_documents(%{conn: conn, path: path, files: files, company_id: company_id, individualId: individualId, tax: tax})

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp generate_path() do
    new = new_route()

    path =
      # Application.app_dir(:loanmanagementsystem, "priv/static")
      File.cwd!<>"/priv/static"
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

    "/merchant_uploads/#{date_path.year}/#{date_path.month}/#{day}/"
  end

  def handle_documents(%{conn: conn, path: path, files: files, company_id: company_id, individualId: individualId, tax: tax}) do
    IO.inspect(files, label: "~~~~~~~~~000")
    random_string = Ecto.UUID.generate()
    documents =
    Enum.map(files["file"], fn file_item ->
      file = "#{random_string}_#{file_item.filename}"
      base64file = Base.encode64(file_item.filename)
      docname = "#{file_item.filename}"
      type = file_item.content_type
      # dest = String.replace("#{path}/#{file}", " ", "")
      dest = "#{path}/#{file}"

      File.cp!(file_item.path, dest)

      %{
        docName: docname,
        userID: individualId,
        file: base64file,
        companyID: company_id,
        path: dest,
        docType: type,
        taxNo: tax,
        # clientID: nrc,
        # createdBy: createdBy,
        status: "ACTIVE",
        inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second),
        updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second)
      }
      end)

    {:ok, documents}
    |> handle_uploaded_files(conn, individualId)
  end

  def handle_uploaded_files(request, _conn, individualId) do
    IO.inspect(individualId, label: "--------------------------ID-----------------------")
    case request do
      {:ok, documents} ->
        Ecto.Multi.new()
        |> Ecto.Multi.insert_all(:documents, Merchants_document, documents)
        |> Ecto.Multi.insert(:user_logs, fn _response ->
          UserLogs.changeset(%UserLogs{}, %{
            activity: "Document Uploaded Successfully",
            user_id: individualId
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
