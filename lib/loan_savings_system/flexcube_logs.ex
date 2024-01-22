defmodule LoanSavingsSystem.FlexcubeLogs do
  @moduledoc """
  The FlexcubeLogs context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.FlexcubeLogs.FlexcubeLog

  @doc """
  Returns the list of flexcubeconfigs.

  ## Examples

      iex> list_flexcubeconfigs()
      [%FlexcubeLog{}, ...]

  """
  def list_flexcubeconfigs do
    Repo.all(FlexcubeLog)
  end

  @doc """
  Gets a single flexcube_log.

  Raises `Ecto.NoResultsError` if the Flexcube log does not exist.

  ## Examples

      iex> get_flexcube_log!(123)
      %FlexcubeLog{}

      iex> get_flexcube_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_flexcube_log!(id), do: Repo.get!(FlexcubeLog, id)

  @doc """
  Creates a flexcube_log.

  ## Examples

      iex> create_flexcube_log(%{field: value})
      {:ok, %FlexcubeLog{}}

      iex> create_flexcube_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_flexcube_log(attrs \\ %{}) do
    %FlexcubeLog{}
    |> FlexcubeLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a flexcube_log.

  ## Examples

      iex> update_flexcube_log(flexcube_log, %{field: new_value})
      {:ok, %FlexcubeLog{}}

      iex> update_flexcube_log(flexcube_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_flexcube_log(%FlexcubeLog{} = flexcube_log, attrs) do
    flexcube_log
    |> FlexcubeLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a flexcube_log.

  ## Examples

      iex> delete_flexcube_log(flexcube_log)
      {:ok, %FlexcubeLog{}}

      iex> delete_flexcube_log(flexcube_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_flexcube_log(%FlexcubeLog{} = flexcube_log) do
    Repo.delete(flexcube_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking flexcube_log changes.

  ## Examples

      iex> change_flexcube_log(flexcube_log)
      %Ecto.Changeset{source: %FlexcubeLog{}}

  """
  def change_flexcube_log(%FlexcubeLog{} = flexcube_log) do
    FlexcubeLog.changeset(flexcube_log, %{})
  end

  alias LoanSavingsSystem.FlexcubeLogs.FlexcubeLog

  @doc """
  Returns the list of flexcubelogs.

  ## Examples

      iex> list_flexcubelogs()
      [%FlexcubeLog{}, ...]

  """
  def list_flexcubelogs do
    Repo.all(FlexcubeLog)
  end

  
end
