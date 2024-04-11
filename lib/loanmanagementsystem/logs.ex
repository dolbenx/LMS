defmodule Loanmanagementsystem.Logs do
  @moduledoc """
  The Logs context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Logs.UserLogs

  @doc """
  Returns the list of tbl_user_logs.

  ## Examples

      iex> list_tbl_user_logs()
      [%UserLogs{}, ...]

  """
  def list_tbl_user_logs do
    Repo.all(UserLogs)
  end

  @doc """
  Gets a single user_logs.

  Raises `Ecto.NoResultsError` if the User logs does not exist.

  ## Examples

      iex> get_user_logs!(123)
      %UserLogs{}

      iex> get_user_logs!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_logs!(id), do: Repo.get!(UserLogs, id)

  @doc """
  Creates a user_logs.

  ## Examples

      iex> create_user_logs(%{field: value})
      {:ok, %UserLogs{}}

      iex> create_user_logs(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_logs(attrs \\ %{}) do
    %UserLogs{}
    |> UserLogs.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_logs.

  ## Examples

      iex> update_user_logs(user_logs, %{field: new_value})
      {:ok, %UserLogs{}}

      iex> update_user_logs(user_logs, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_logs(%UserLogs{} = user_logs, attrs) do
    user_logs
    |> UserLogs.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_logs.

  ## Examples

      iex> delete_user_logs(user_logs)
      {:ok, %UserLogs{}}

      iex> delete_user_logs(user_logs)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_logs(%UserLogs{} = user_logs) do
    Repo.delete(user_logs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_logs changes.

  ## Examples

      iex> change_user_logs(user_logs)
      %Ecto.Changeset{data: %UserLogs{}}

  """
  def change_user_logs(%UserLogs{} = user_logs, attrs \\ %{}) do
    UserLogs.changeset(user_logs, attrs)
  end

  alias Loanmanagementsystem.Logs.SessionLogs

  @doc """
  Returns the list of tbl_session_logs.

  ## Examples

      iex> list_tbl_session_logs()
      [%SessionLogs{}, ...]

  """
  def list_tbl_session_logs do
    Repo.all(SessionLogs)
  end

  @doc """
  Gets a single session_logs.

  Raises `Ecto.NoResultsError` if the Session logs does not exist.

  ## Examples

      iex> get_session_logs!(123)
      %SessionLogs{}

      iex> get_session_logs!(456)
      ** (Ecto.NoResultsError)

  """
  def get_session_logs!(id), do: Repo.get!(SessionLogs, id)

  @doc """
  Creates a session_logs.

  ## Examples

      iex> create_session_logs(%{field: value})
      {:ok, %SessionLogs{}}

      iex> create_session_logs(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_session_logs(attrs \\ %{}) do
    %SessionLogs{}
    |> SessionLogs.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a session_logs.

  ## Examples

      iex> update_session_logs(session_logs, %{field: new_value})
      {:ok, %SessionLogs{}}

      iex> update_session_logs(session_logs, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_session_logs(%SessionLogs{} = session_logs, attrs) do
    session_logs
    |> SessionLogs.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a session_logs.

  ## Examples

      iex> delete_session_logs(session_logs)
      {:ok, %SessionLogs{}}

      iex> delete_session_logs(session_logs)
      {:error, %Ecto.Changeset{}}

  """
  def delete_session_logs(%SessionLogs{} = session_logs) do
    Repo.delete(session_logs)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking session_logs changes.

  ## Examples

      iex> change_session_logs(session_logs)
      %Ecto.Changeset{data: %SessionLogs{}}

  """
  def change_session_logs(%SessionLogs{} = session_logs, attrs \\ %{}) do
    SessionLogs.changeset(session_logs, attrs)
  end

  def system_log_session(session, description, action, attrs, service, user_id) do
    SessionLogs.changeset(
      %SessionLogs{},
      %{
        description: description,
        action: action,
        attrs: Poison.encode!(attrs),
        service: service,
        session_id: session["live_socket_id"],
        ip_address: session["remote_ip"],
        device_uuid: session["user_agent"],
        full_browser_name: session["browser_info"]["full_browser_name"],
        browser_details: session["browser_info"]["browser_details"],
        system_platform_name: session["browser_info"]["system_platform_name"],
        device_type: to_string(session["browser_info"]["device_type"]),
        known_browser: session["browser_info"]["known_browser"],
        user_id: user_id,
      }
    )
    |> Repo.insert!()
  end

  def session_logs(conn, session_id, portal, description, user_id, status \\ false) do
    SessionLogs.changeset(%SessionLogs{}, %{
      session_id: session_id,
      portal: portal,
      description: description,
      device_uuid: device_uuid(conn),
      full_browser_name: Browser.full_browser_name(conn),
      user_id: user_id,
      browser_details: Browser.full_display(conn),
      system_platform_name: Browser.full_platform_name(conn),
      device_type: to_string(Browser.device_type(conn)),
      known_browser: Browser.known?(conn),
      status: status,
      ip_address: ip_address(conn)
    })
    |> Repo.insert!()
  end

  def find_and_update_session_id_log_out(session_id, user_id, message \\ "Session Force Close Successfully") do
    SessionLogs
    |> where([a], a.session_id == ^session_id and a.user_id == ^user_id)
    |> Repo.all()
    |> Enum.with_index()
    |> Enum.reduce(Ecto.Multi.new(), fn {session, idx}, multi ->
      Ecto.Multi.update(multi, {:session, idx},
      SessionLogs.changeset(session, %{
          status: false,
          description: message,
          log_out_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)})
      )
    end)
    |> Repo.transaction()
  end


  def system_log_session_live_multi(multi, %{assigns: _assigns}, description, action, attrs, service, _user_id \\ 1) do
    data = Loans.Workers.Util.Cache.get(:assigns)
    Ecto.Multi.insert(
      multi,
      :system_logs,
      SessionLogs.changeset(
        %SessionLogs{},
        %{
          description: description,
          action: action,
          attrs: Poison.encode!(attrs),
          service: service,
          session_id: data.live_socket_identifier,
          ip_address: data.remote_ip,
          device_uuid: data.user_agent,
          full_browser_name: data.browser_info["full_browser_name"],
          browser_details: data.browser_info["browser_details"],
          system_platform_name: data.browser_info["system_platform_name"],
          device_type: to_string(data.browser_info["device_type"]),
          known_browser: data.browser_info["known_browser"],
          user_id: data.user.id,
        }
      )
    )
  end


  def log_session(%{assigns: _assigns}, description, action, attrs, service) do
    data = Loans.Workers.Util.Cache.get(:assigns)
    IO.inspect data, label: "=========== data.live_socket_identifier =============="
    changeset = SessionLogs.changeset(%SessionLogs{},
      %{
        description: description,
        action: action,
        attrs: Poison.encode!(attrs),
        service: service,
        session_id: data.live_socket_identifier,
        ip_address: data.remote_ip,
        device_uuid: data.user_agent,
        full_browser_name: data.browser_info["full_browser_name"],
        browser_details: data.browser_info["browser_details"],
        system_platform_name: data.browser_info["system_platform_name"],
        device_type: to_string(data.browser_info["device_type"]),
        known_browser: data.browser_info["known_browser"],
        user_id: data.user.id,
      }
    )
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:session_logs, changeset)
  end


  def system_log_live(%{assigns: assigns}, narration, action, attrs, service, user_id) do
    SessionLogs.changeset(
      %SessionLogs{},
      %{
        narration: narration,
        action: action,
        attrs: Poison.encode!(attrs),
        service: service,
        session_id: assigns.live_socket_identifier,
        ip_address: assigns.remote_ip,
        device_uuid: assigns.user_agent,
        full_browser_name: assigns.browser_info["full_browser_name"],
        browser_details: assigns.browser_info["browser_details"],
        system_platform_name: assigns.browser_info["system_platform_name"],
        device_type: to_string(assigns.browser_info["device_type"]),
        known_browser: assigns.browser_info["known_browser"],
        user_id: user_id,
      }
    )
    |> Repo.insert!()
  end

  def ip_address(conn, _live \\ false) do
    forwarded_for = List.first(Plug.Conn.get_req_header(conn, "x-forwarded-for"))

    if forwarded_for do
      String.split(forwarded_for, ",")
      |> Enum.map(&String.trim/1)
      |> List.first()
    else
      to_string(:inet_parse.ntoa(conn.remote_ip))
    end
  end

  def device_uuid(conn) do
    Plug.Conn.get_req_header(conn, "user-agent")
    |> List.first()
  end


end
