defmodule Loanmanagementsystem.Services.EmployerUploads do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Companies.{Documents, Company}
  alias Loanmanagementsystem.Logs.UserLogs

  def employer_upload(%{"process_documents" => files, "conn" => conn, "user_id" => user_id, "company_id" => company_id, "tax_number" => tax_number}) do
    IO.inspect(files, label: "~~~~~~~~~~~~~")

    generate_path()
    |> case do
      {:ok, path} ->
        handle_documents(%{conn: conn, path: path, files: files, user_id: user_id, company_id: company_id, tax_number: tax_number})

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp generate_path() do
    new = new_route()

    path =
      Application.app_dir(:loanmanagementsystem, "priv/static")
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

    "/employer_uploads/#{date_path.year}/#{date_path.month}/#{day}/"
  end

  def handle_documents(%{conn: conn, path: path, files: files, user_id: user_id, company_id: company_id, tax_number: tax_number}) do
    IO.inspect(files, label: "~~~~~~~~~000")

    random_string = Ecto.UUID.generate()
    documents =
      Enum.map(files["file"], fn file_item ->

        file = "#{random_string}_#{file_item.filename}"
        docname = "#{file_item.filename}"
        type = file_item.content_type
        dest = "#{path}/#{file}"

        File.cp!(file_item.path, dest)

        %{
          docName: docname,
          userID: user_id,
          companyID: company_id,
          taxNo: tax_number,
          path: dest,
          docType: type,
          status: "ACTIVE",
          inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
          updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
        }
      end)

    {:ok, documents}
    |> handle_uploaded_files(conn)
  end

  def handle_uploaded_files(request, conn) do
    case request do
      {:ok, documents} ->
        Ecto.Multi.new()
        |> Ecto.Multi.insert_all(:documents, Documents, documents)
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
