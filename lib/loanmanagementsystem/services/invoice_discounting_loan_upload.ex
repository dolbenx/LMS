defmodule Loanmanagementsystem.Services.InvoiceDiscountingLoanUploads do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Loan.Loan_application_documents
  alias Loanmanagementsystem.Logs.UserLogs

  def invoice_loan_upload(%{"conn" => conn, "customer_id" => customer_id, "loan_id" => loan_id}, params) do
    IO.inspect(params, label: "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")

    generate_path()
    |> case do
      {:ok, path} ->

        handle_documents_new(%{conn: conn, path: path, customer_id: customer_id, loan_id: loan_id}, params)

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

    "/invoice_discounting/#{date_path.year}/#{date_path.month}/#{day}/"
  end


  def handle_documents_new(%{conn: conn, path: path, customer_id: customer_id, loan_id: loan_id} = _p, params) do
    docx = params["file"]
    names = Map.keys(docx)
    docs = Map.values(docx)
    len = length(docs) - 1
    random_string = Ecto.UUID.generate()
    documents =
    Enum.map(0..len, fn n ->

      name = Enum.at(names, n)
      file = Enum.at(docs, n)


      file_n = "#{random_string}_#{file.filename}"
      docname = "#{file.filename}"
      type = file.content_type
      dest = "#{path}/#{file_n}"

      File.cp!(file.path, dest)

      %{
        doc_name: docname,
        loan_id: if is_integer(loan_id) do loan_id else  String.to_integer(loan_id) end,
        status: "ACTIVE",
        customer_id: String.to_integer(customer_id),
        path: dest,
        doc_type: type,
        fileName: name,
        inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second),
        updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now, :second)
      }
      end)

    {:ok, documents}
    |> handle_uploaded_files(conn)
  end

  def handle_uploaded_files(request, conn) do
    case request do
      {:ok, documents} ->
        Ecto.Multi.new()
        |> Ecto.Multi.insert_all(:documents, Loan_application_documents, documents)
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
