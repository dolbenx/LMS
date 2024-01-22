defmodule Savings.EndOfDay do
  @moduledoc """
  The EndOfDay context.
  """

  import Ecto.Query, warn: false
  alias Savings.Repo

  alias Savings.EndOfDay.EndOfDayRun

  @doc """
  Returns the list of tbl_end_of_day.

  ## Examples

      iex> list_tbl_end_of_day()
      [%EndOfDayRun{}, ...]

  """
  def list_tbl_end_of_day do
    EndOfDayRun
    |> select([u], u)
    |> order_by([u], desc: u.inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single end_of_day_run.

  Raises `Ecto.NoResultsError` if the End of day run does not exist.

  ## Examples

      iex> get_end_of_day_run!(123)
      %EndOfDayRun{}

      iex> get_end_of_day_run!(456)
      ** (Ecto.NoResultsError)

  """
  def get_end_of_day_run!(id), do: Repo.get!(EndOfDayRun, id)

  @doc """
  Creates a end_of_day_run.

  ## Examples

      iex> create_end_of_day_run(%{field: value})
      {:ok, %EndOfDayRun{}}

      iex> create_end_of_day_run(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_end_of_day_run(attrs \\ %{}) do
    %EndOfDayRun{}
    |> EndOfDayRun.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a end_of_day_run.

  ## Examples

      iex> update_end_of_day_run(end_of_day_run, %{field: new_value})
      {:ok, %EndOfDayRun{}}

      iex> update_end_of_day_run(end_of_day_run, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_end_of_day_run(%EndOfDayRun{} = end_of_day_run, attrs) do
    end_of_day_run
    |> EndOfDayRun.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a end_of_day_run.

  ## Examples

      iex> delete_end_of_day_run(end_of_day_run)
      {:ok, %EndOfDayRun{}}

      iex> delete_end_of_day_run(end_of_day_run)
      {:error, %Ecto.Changeset{}}

  """
  def delete_end_of_day_run(%EndOfDayRun{} = end_of_day_run) do
    Repo.delete(end_of_day_run)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking end_of_day_run changes.

  ## Examples

      iex> change_end_of_day_run(end_of_day_run)
      %Ecto.Changeset{source: %EndOfDayRun{}}

  """
  def change_end_of_day_run(%EndOfDayRun{} = end_of_day_run) do
    EndOfDayRun.changeset(end_of_day_run, %{})
  end

  alias Savings.EndOfDay.EndOfDayEntry

  @doc """
  Returns the list of tbl_end_of_day_entries.

  ## Examples

      iex> list_tbl_end_of_day_entries()
      [%EndOfDayEntry{}, ...]

  """
  def list_tbl_end_of_day_entries do
    Repo.all(EndOfDayEntry)
  end

  @doc """
  Gets a single end_of_day_entry.

  Raises `Ecto.NoResultsError` if the End of day entry does not exist.

  ## Examples

      iex> get_end_of_day_entry!(123)
      %EndOfDayEntry{}

      iex> get_end_of_day_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_end_of_day_entry!(id), do: Repo.get!(EndOfDayEntry, id)

  @doc """
  Creates a end_of_day_entry.

  ## Examples

      iex> create_end_of_day_entry(%{field: value})
      {:ok, %EndOfDayEntry{}}

      iex> create_end_of_day_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_end_of_day_entry(attrs \\ %{}) do
    %EndOfDayEntry{}
    |> EndOfDayEntry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a end_of_day_entry.

  ## Examples

      iex> update_end_of_day_entry(end_of_day_entry, %{field: new_value})
      {:ok, %EndOfDayEntry{}}

      iex> update_end_of_day_entry(end_of_day_entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_end_of_day_entry(%EndOfDayEntry{} = end_of_day_entry, attrs) do
    end_of_day_entry
    |> EndOfDayEntry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a end_of_day_entry.

  ## Examples

      iex> delete_end_of_day_entry(end_of_day_entry)
      {:ok, %EndOfDayEntry{}}

      iex> delete_end_of_day_entry(end_of_day_entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_end_of_day_entry(%EndOfDayEntry{} = end_of_day_entry) do
    Repo.delete(end_of_day_entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking end_of_day_entry changes.

  ## Examples

      iex> change_end_of_day_entry(end_of_day_entry)
      %Ecto.Changeset{source: %EndOfDayEntry{}}

  """
  def change_end_of_day_entry(%EndOfDayEntry{} = end_of_day_entry) do
    EndOfDayEntry.changeset(end_of_day_entry, %{})
  end

  alias Savings.EndOfDay.FcubeGeneralLedger

  @doc """
  Returns the list of fcube_general_ledger.

  ## Examples

      iex> list_fcube_general_ledger()
      [%FcubeGeneralLedger{}, ...]

  """
  def list_fcube_general_ledger do
    Repo.all(FcubeGeneralLedger)
  end


  def get_tbl_fcube_general_ledger do
    FcubeGeneralLedger
    |> select([u], %{
      id: u.id,
      accountname: u.account_name,
      status: u.status,
      glaccountno: u.gl_account_no
    })
    |> Repo.all()
  end

  def get_fcube_ledger do
    FcubeGeneralLedger
    |> join(:full, [fBG], fCC in "flexcubeconfigs", on: fBG.id == fCC.flex_cube_gl_id)
    |> where([fBG, fCC], (fBG.status) == "ACTIVE")
    |> select([fBG, fCC], %{
      id: fBG.id,
      accountname: fBG.account_name,
      status: fBG.status,
      glaccountno: fBG.gl_account_no,
      action_type: fCC.action_type,
      dr_cr: fCC.dr_cr,
      flex_cube_gl_code: fCC.flex_cube_gl_code,
      flex_cube_gl_id: fCC.flex_cube_gl_id,
      flex_cube_gl_name: fCC.flex_cube_gl_name
    })
    |> Repo.all()
  end

  @doc """
  Gets a single fcube_general_ledger.

  Raises `Ecto.NoResultsError` if the Fcube general ledger does not exist.

  ## Examples

      iex> get_fcube_general_ledger!(123)
      %FcubeGeneralLedger{}

      iex> get_fcube_general_ledger!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fcube_general_ledger!(id), do: Repo.get!(FcubeGeneralLedger, id)

  @doc """
  Creates a fcube_general_ledger.

  ## Examples

      iex> create_fcube_general_ledger(%{field: value})
      {:ok, %FcubeGeneralLedger{}}

      iex> create_fcube_general_ledger(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fcube_general_ledger(attrs \\ %{}) do
    %FcubeGeneralLedger{}
    |> FcubeGeneralLedger.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fcube_general_ledger.

  ## Examples

      iex> update_fcube_general_ledger(fcube_general_ledger, %{field: new_value})
      {:ok, %FcubeGeneralLedger{}}

      iex> update_fcube_general_ledger(fcube_general_ledger, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fcube_general_ledger(%FcubeGeneralLedger{} = fcube_general_ledger, attrs) do
    fcube_general_ledger
    |> FcubeGeneralLedger.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a fcube_general_ledger.

  ## Examples

      iex> delete_fcube_general_ledger(fcube_general_ledger)
      {:ok, %FcubeGeneralLedger{}}

      iex> delete_fcube_general_ledger(fcube_general_ledger)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fcube_general_ledger(%FcubeGeneralLedger{} = fcube_general_ledger) do
    Repo.delete(fcube_general_ledger)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fcube_general_ledger changes.

  ## Examples

      iex> change_fcube_general_ledger(fcube_general_ledger)
      %Ecto.Changeset{source: %FcubeGeneralLedger{}}

  """
  def change_fcube_general_ledger(%FcubeGeneralLedger{} = fcube_general_ledger) do
    FcubeGeneralLedger.changeset(fcube_general_ledger, %{})
  end

  alias Savings.EndOfDay.FcubeReqRes

  @doc """
  Returns the list of fcube_request_responses.

  ## Examples

      iex> list_fcube_request_responses()
      [%FcubeReqRes{}, ...]

  """
  def list_fcube_request_responses do
    Repo.all(FcubeReqRes)
  end

  @doc """
  Gets a single fcube_req_res.

  Raises `Ecto.NoResultsError` if the Fcube req res does not exist.

  ## Examples

      iex> get_fcube_req_res!(123)
      %FcubeReqRes{}

      iex> get_fcube_req_res!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fcube_req_res!(id), do: Repo.get!(FcubeReqRes, id)

  @doc """
  Creates a fcube_req_res.

  ## Examples

      iex> create_fcube_req_res(%{field: value})
      {:ok, %FcubeReqRes{}}

      iex> create_fcube_req_res(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fcube_req_res(attrs \\ %{}) do
    %FcubeReqRes{}
    |> FcubeReqRes.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fcube_req_res.

  ## Examples

      iex> update_fcube_req_res(fcube_req_res, %{field: new_value})
      {:ok, %FcubeReqRes{}}

      iex> update_fcube_req_res(fcube_req_res, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fcube_req_res(%FcubeReqRes{} = fcube_req_res, attrs) do
    fcube_req_res
    |> FcubeReqRes.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a fcube_req_res.

  ## Examples

      iex> delete_fcube_req_res(fcube_req_res)
      {:ok, %FcubeReqRes{}}

      iex> delete_fcube_req_res(fcube_req_res)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fcube_req_res(%FcubeReqRes{} = fcube_req_res) do
    Repo.delete(fcube_req_res)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fcube_req_res changes.

  ## Examples

      iex> change_fcube_req_res(fcube_req_res)
      %Ecto.Changeset{source: %FcubeReqRes{}}

  """
  def change_fcube_req_res(%FcubeReqRes{} = fcube_req_res) do
    FcubeReqRes.changeset(fcube_req_res, %{})
  end

  alias Savings.EndOfDay.FlexCubeConfig

  @doc """
  Returns the list of flexcubeconfigs.

  ## Examples

      iex> list_flexcubeconfigs()
      [%FlexCubeConfig{}, ...]

  """
  def list_flexcubeconfigs do
    Repo.all(FlexCubeConfig)
  end

  @doc """
  Gets a single flex_cube_config.

  Raises `Ecto.NoResultsError` if the Flex cube config does not exist.

  ## Examples

      iex> get_flex_cube_config!(123)
      %FlexCubeConfig{}

      iex> get_flex_cube_config!(456)
      ** (Ecto.NoResultsError)

  """
  def get_flex_cube_config!(id), do: Repo.get!(FlexCubeConfig, id)

  @doc """
  Creates a flex_cube_config.

  ## Examples

      iex> create_flex_cube_config(%{field: value})
      {:ok, %FlexCubeConfig{}}

      iex> create_flex_cube_config(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_flex_cube_config(attrs \\ %{}) do
    %FlexCubeConfig{}
    |> FlexCubeConfig.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a flex_cube_config.

  ## Examples

      iex> update_flex_cube_config(flex_cube_config, %{field: new_value})
      {:ok, %FlexCubeConfig{}}

      iex> update_flex_cube_config(flex_cube_config, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_flex_cube_config(%FlexCubeConfig{} = flex_cube_config, attrs) do
    flex_cube_config
    |> FlexCubeConfig.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a flex_cube_config.

  ## Examples

      iex> delete_flex_cube_config(flex_cube_config)
      {:ok, %FlexCubeConfig{}}

      iex> delete_flex_cube_config(flex_cube_config)
      {:error, %Ecto.Changeset{}}

  """
  def delete_flex_cube_config(%FlexCubeConfig{} = flex_cube_config) do
    Repo.delete(flex_cube_config)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking flex_cube_config changes.

  ## Examples

      iex> change_flex_cube_config(flex_cube_config)
      %Ecto.Changeset{source: %FlexCubeConfig{}}

  """
  def change_flex_cube_config(%FlexCubeConfig{} = flex_cube_config) do
    FlexCubeConfig.changeset(flex_cube_config, %{})
  end

  alias Savings.EndOfDay.Calendar

  @doc """
  Returns the list of calendars.

  ## Examples

      iex> list_calendars()
      [%Calendar{}, ...]

  """

  # Savings.EndOfDay.list_calendars()
  def list_calendars do
    Repo.all(Calendar)
  end

  @doc """
  Gets a single calendar.

  Raises `Ecto.NoResultsError` if the Calendar does not exist.

  ## Examples

      iex> get_calendar!(123)
      %Calendar{}

      iex> get_calendar!(456)
      ** (Ecto.NoResultsError)

  """


  # Savings.EndOfDay.get_calendar!()

  def get_calendar!(id), do: Repo.get!(Calendar, id)

  @doc """
  Creates a calendar.

  ## Examples

      iex> create_calendar(%{field: value})
      {:ok, %Calendar{}}

      iex> create_calendar(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_calendar(attrs \\ %{}) do
    %Calendar{}
    |> Calendar.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a calendar.

  ## Examples

      iex> update_calendar(calendar, %{field: new_value})
      {:ok, %Calendar{}}

      iex> update_calendar(calendar, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_calendar(%Calendar{} = calendar, attrs) do
    calendar
    |> Calendar.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a calendar.

  ## Examples

      iex> delete_calendar(calendar)
      {:ok, %Calendar{}}

      iex> delete_calendar(calendar)
      {:error, %Ecto.Changeset{}}

  """
  def delete_calendar(%Calendar{} = calendar) do
    Repo.delete(calendar)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking calendar changes.

  ## Examples

      iex> change_calendar(calendar)
      %Ecto.Changeset{source: %Calendar{}}

  """
  def change_calendar(%Calendar{} = calendar) do
    Calendar.changeset(calendar, %{})
  end

  alias Savings.EndOfDay.Holiday

  @doc """
  Returns the list of holidays.

  ## Examples

      iex> list_holidays()
      [%Holiday{}, ...]

  """
  def list_holidays do
    Repo.all(Holiday)
  end


  # Savings.EndOfDay.get_holiday_details()

  @doc """
  Gets a single holiday.

  Raises `Ecto.NoResultsError` if the Holiday does not exist.

  ## Examples

      iex> get_holiday!(123)
      %Holiday{}

      iex> get_holiday!(456)
      ** (Ecto.NoResultsError)

  """
  def get_holiday!(id), do: Repo.get!(Holiday, id)

  @doc """
  Creates a holiday.

  ## Examples

      iex> create_holiday(%{field: value})
      {:ok, %Holiday{}}

      iex> create_holiday(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_holiday(attrs \\ %{}) do
    %Holiday{}
    |> Holiday.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a holiday.

  ## Examples

      iex> update_holiday(holiday, %{field: new_value})
      {:ok, %Holiday{}}

      iex> update_holiday(holiday, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_holiday(%Holiday{} = holiday, attrs) do
    holiday
    |> Holiday.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a holiday.

  ## Examples

      iex> delete_holiday(holiday)
      {:ok, %Holiday{}}

      iex> delete_holiday(holiday)
      {:error, %Ecto.Changeset{}}

  """
  def delete_holiday(%Holiday{} = holiday) do
    Repo.delete(holiday)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking holiday changes.

  ## Examples

      iex> change_holiday(holiday)
      %Ecto.Changeset{source: %Holiday{}}

  """
  def change_holiday(%Holiday{} = holiday) do
    Holiday.changeset(holiday, %{})
  end




	def formatFDId(id) do
		idLen = String.length("#{id}");
		fixedDepositNumber = String.pad_leading("#{id}", (6 - idLen), "0");
		fixedDepositNumber
	end
end
