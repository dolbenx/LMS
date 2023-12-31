defmodule Loanmanagementsystem.Logs do
  @moduledoc """
  The Logs context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Accounts.User

  @doc """
  Returns the list of tbl_user_logs.
  
  ## Examples
  
      iex> list_tbl_user_logs()
      [%UserLogs{}, ...]
  
  """

  # Loanmanagementsystem.Logs.list_tbl_user_activity_logs()

  def list_tbl_user_activity_logs do
    User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> join(:left, [uA], uL in "tbl_user_logs", on: uA.id == uL.user_id)
    |> select([uA, uB, uR, uL], %{
      username: uA.username,
      id: uL.id,
      status: uA.status,
      firstName: uB.firstName,
      lastName: uB.lastName,
      otherName: uB.otherName,
      dateOfBirth: uB.dateOfBirth,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobileNumber: uB.mobileNumber,
      emailAddress: uB.emailAddress,
      roleType: uR.roleType,
      activity: uL.activity,
      inserted_at: uL.inserted_at,
      userId: uR.userId
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Logs.list_tbl_user_activity_logs(2)
  def list_tbl_user_activity_logs(cid) do
    Loanmanagementsystem.Accounts.User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> join(:left, [uA], uL in "tbl_user_logs", on: uA.id == uL.user_id)
    |> join(:left, [uA], uC in "tbl_company", on: uA.company_id == uC.id)
    |> where([uA, uB, uR, uC], uA.company_id == ^cid and uR.roleType == ^"SME")
    |> select([uA, uB, uR, uL, uC], %{
      username: uA.username,
      id: uA.id,
      status: uA.status,
      firstName: uB.firstName,
      lastName: uB.lastName,
      otherName: uB.otherName,
      dateOfBirth: uB.dateOfBirth,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobileNumber: uB.mobileNumber,
      emailAddress: uB.emailAddress,
      roleType: uR.roleType,
      activity: uL.activity,
      inserted_at: uL.inserted_at,
      userId: uR.userId,
      company_id: uA.company_id
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Logs.sme_user_management(2)
  def sme_user_management(cid) do
    Loanmanagementsystem.Accounts.User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> where([uA, uB, uR, uC], uR.roleType == "SME" and uA.company_id == ^cid)
    |> select([uA, uB, uR], %{
      username: uA.username,
      id: uA.id,
      status: uA.status,
      username: uA.username,
      firstName: uB.firstName,
      lastName: uB.lastName,
      otherName: uB.otherName,
      dateOfBirth: uB.dateOfBirth,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobileNumber: uB.mobileNumber,
      emailAddress: uB.emailAddress,
      roleType: uR.roleType,
      userId: uR.userId
    })
    |> Repo.all()
  end

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
  
      iex> update_user_logs(user_logs,
      %{
        field: new_value})
      {:ok, %UserLogs{}}
  
      iex> update_user_logs(user_logs,
      %{
        field: bad_value})
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
      %Ecto.Changeset{source: %UserLogs{}}
  
  """
  def change_user_logs(%UserLogs{} = user_logs) do
    UserLogs.changeset(user_logs, %{})
  end
end
