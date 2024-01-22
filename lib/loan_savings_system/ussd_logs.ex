defmodule LoanSavingsSystem.UssdLogs do
  @moduledoc """
  The UssdLogs context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.UssdLogs.UssdLog

  @doc """
  Returns the list of tbl_ussd_logs.

  ## Examples

      iex> list_tbl_ussd_logs()
      [%UssdLog{}, ...]

  """
  def list_tbl_ussd_logs do
    Repo.all(UssdLog)
  end

  @doc """
  Gets a single ussd_log.

  Raises `Ecto.NoResultsError` if the Ussd log does not exist.

  ## Examples

      iex> get_ussd_log!(123)
      %UssdLog{}

      iex> get_ussd_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ussd_log!(id), do: Repo.get!(UssdLog, id)

  @doc """
  Creates a ussd_log.

  ## Examples

      iex> create_ussd_log(%{field: value})
      {:ok, %UssdLog{}}

      iex> create_ussd_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ussd_log(attrs \\ %{}) do
    %UssdLog{}
    |> UssdLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ussd_log.

  ## Examples

      iex> update_ussd_log(ussd_log, %{field: new_value})
      {:ok, %UssdLog{}}

      iex> update_ussd_log(ussd_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ussd_log(%UssdLog{} = ussd_log, attrs) do
    ussd_log
    |> UssdLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ussd_log.

  ## Examples

      iex> delete_ussd_log(ussd_log)
      {:ok, %UssdLog{}}

      iex> delete_ussd_log(ussd_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ussd_log(%UssdLog{} = ussd_log) do
    Repo.delete(ussd_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ussd_log changes.

  ## Examples

      iex> change_ussd_log(ussd_log)
      %Ecto.Changeset{source: %UssdLog{}}

  """
  def change_ussd_log(%UssdLog{} = ussd_log) do
    UssdLog.changeset(ussd_log, %{})
  end
end
