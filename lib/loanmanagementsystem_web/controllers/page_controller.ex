defmodule LoanmanagementsystemWeb.PageController do
  use LoanmanagementsystemWeb, :controller

  def index(conn, _params) do

    render(conn, "index.html")
  end

  def self_register_index(conn, _params) do
    render(conn, "self_register_index.html")
  end

  def file_upload(conn, params) do
    # thisfunction merges twopaths or createsa pathfor a file
    path = get_path()
    check_path_existence(path)
    |> path_validation_results(path)
    |> get_files_from_params(params, path)
    |>case do
      :ok->
        conn
        |>put_flash(:info, "You have Successfully Uploaded (a) File(s)")
        |> redirect(to: Routes.user_path(conn, :user_dashboard))
      _ ->
        conn
        |>put_flash(:error, "You have failed to Upload (a) File(s)")
        |> redirect(to: Routes.user_path(conn, :user_dashboard))
    end
  end
  # MarkWeb.UserController.get_path
  def get_path() do
    path = "#{File.cwd!()}/priv/static/files/"
    path
  end

  # MarkWeb.UserController.check_path_existence(path)
  def check_path_existence(path) do
    case File.exists?(path) do
      true -> true
      false -> false
    end
  end

  @spec path_validation_results(boolean(), any()) :: any()
  def path_validation_results(result, path) do
    case result do
      true -> {:okay, "Path Exists"}
      false ->
        result = create_path(path)
        result
    end
  end

  def create_path(path) do
    case File.mkdir_p(path) do
      :ok -> {:ok, "Path Created Successfully"}
      {:error, reason} -> {:error, reason}
    end
  end

  def get_files_from_params(result, %{"file"=> file}, path) do
    case result do
      {:ok, _message} ->
        case upload_files(%{"file"=> file}, path) do
          :ok->
            :ok
          _ ->
            :error
        end
      {:okay, _message} ->
        case upload_files(%{"file"=> file}, path) do
          :ok->
            :ok
          _ ->
            :error
        end
      {:error, reason} ->
        :error
    end
  end

  def upload_files(file, path) do
    filename = file.filename
    final_destination = path<>filename
    case File.cp!(file.path,final_destination) do
      :ok->
        :ok
      _ ->
        :error
    end
  end
end
