defmodule Savings.Client do
  @moduledoc """
  The Client context.
  """

  import Ecto.Query, warn: false
  alias Savings.Repo

  alias Savings.Client.Clients

  @doc """
  Returns the list of tbl_clients.

  ## Examples

      iex> list_tbl_clients()
      [%Clients{}, ...]

  """
  def list_tbl_clients do
    Repo.all(Clients)
  end

  @doc """
  Gets a single clients.

  Raises `Ecto.NoResultsError` if the Clients does not exist.

  ## Examples

      iex> get_clients!(123)
      %Clients{}

      iex> get_clients!(456)
      ** (Ecto.NoResultsError)

  """
  def get_clients!(id), do: Repo.get!(Clients, id)

  @doc """
  Creates a clients.

  ## Examples

      iex> create_clients(%{field: value})
      {:ok, %Clients{}}

      iex> create_clients(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_clients(attrs \\ %{}) do
    %Clients{}
    |> Clients.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a clients.

  ## Examples

      iex> update_clients(clients, %{field: new_value})
      {:ok, %Clients{}}

      iex> update_clients(clients, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_clients(%Clients{} = clients, attrs) do
    clients
    |> Clients.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a clients.

  ## Examples

      iex> delete_clients(clients)
      {:ok, %Clients{}}

      iex> delete_clients(clients)
      {:error, %Ecto.Changeset{}}

  """
  def delete_clients(%Clients{} = clients) do
    Repo.delete(clients)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking clients changes.

  ## Examples

      iex> change_clients(clients)
      %Ecto.Changeset{source: %Clients{}}

  """
  def change_clients(%Clients{} = clients) do
    Clients.changeset(clients, %{})
  end

  alias Savings.Client.UserBioData

  def get_loan_customer_individual do
    UserBioData
    |> join(:left, [uB], uR in "tbl_user_roles", on: uB.userId == uR.userId)
    |> where([uB, uR], uR.roleType == "INDIVIDUAL")
    |> select([uB, uR], %{
      id: uB.id,
      userId: uB.userId,
      status: uR.status,
      firstname: uB.firstName,
      lastname: uB.lastName,
      otherName: uB.otherName,
      dateOfBirth: uB.dateOfBirth,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobileNumber: uB.mobileNumber,
      emailAddress: uB.emailAddress,
      roleType: uR.roleType
    })
    |> Repo.all()
  end

  def get_customer_individual(userId) do
    UserBioData
    |> join(:left, [uB], uR in "tbl_user_roles", on: uB.userId == uR.userId)
    |> join(:left, [uB], uA in "tbl_account", on: uB.userId == uA.userId)
    |> where(
      [uB, uR, uA],
      uA.accountType == "LOANS" and uR.roleType == "INDIVIDUAL" and uB.userId == ^userId
    )
    |> select([uB, uR, uA], %{
      id: uA.id,
      accountType: uA.accountType,
      userId: uB.userId,
      status: uR.status,
      firstname: uB.firstName,
      lastname: uB.lastName,
      otherName: uB.otherName,
      dateOfBirth: uB.dateOfBirth,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobileNumber: uB.mobileNumber,
      emailAddress: uB.emailAddress,
      roleType: uR.roleType
    })
    |> Repo.all()
  end

  @doc """
  Returns the list of tbl_user_bio_data.

  ## Examples

      iex> list_tbl_user_bio_data()
      [%UserBioData{}, ...]

  """
  def list_tbl_user_bio_data do
    Repo.all(UserBioData)
  end

  def customer_data(userId) do
    UserBioData
    |> where([a], a.userId == ^userId)
    |> select(
      [a],
      map(a, [
        :userId,
        :userId,
        :firstName,
        :lastName,
        :otherName,
        :dateOfBirth,
        :meansOfIdentificationType,
        :meansOfIdentificationNumber,
        :title,
        :gender,
        :gender,
        :mobileNumber,
        :emailAddress
      ])
    )
    |> Repo.one()
  end

  def get_details(userId) do
    UserBioData
    |> join(:left, [uB], uR in "tbl_users", on: uB.userId == uR.id)
    |> where([uB, uR], uR.id == ^userId)
    |> select([uB, uR], %{
      id: uB.id,
      userId: uB.userId,
      clientid: uB.clientId,
      status: uR.status,
      firstname: uB.firstName,
      lastname: uB.lastName,
      otherName: uB.otherName,
      dateOfBirth: uB.dateOfBirth,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      othername: uB.otherName,
      gender: uB.gender,
      mobileNumber: uB.mobileNumber,
      emailAddress: uB.emailAddress
    })
    |> Repo.all()
  end

  @doc """
  Gets a single user_bio_data.

  Raises `Ecto.NoResultsError` if the User bio data does not exist.

  ## Examples

      iex> get_user_bio_data!(123)
      %UserBioData{}

      iex> get_user_bio_data!(456)
      ** (Ecto.NoResultsError)
  Savings.Client.get_my_user_bio_id(30)
  """
  def get_user_bio_data!(id), do: Repo.get!(UserBioData, id)

  def get_my_user_bio_id(userId) do
    UserBioData
    |> where([uB], uB.userId == ^userId)
    |> select([uB], %{
      id: uB.id
    })
    |> Repo.one()
  end

  @doc """
  Creates a user_bio_data.

  ## Examples

      iex> create_user_bio_data(%{field: value})
      {:ok, %UserBioData{}}

      iex> create_user_bio_data(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_bio_data(attrs \\ %{}) do
    %UserBioData{}
    |> UserBioData.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_bio_data.

  ## Examples

      iex> update_user_bio_data(user_bio_data, %{field: new_value})
      {:ok, %UserBioData{}}

      iex> update_user_bio_data(user_bio_data, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_bio_data(%UserBioData{} = user_bio_data, attrs) do
    user_bio_data
    |> UserBioData.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_bio_data.

  ## Examples

      iex> delete_user_bio_data(user_bio_data)
      {:ok, %UserBioData{}}

      iex> delete_user_bio_data(user_bio_data)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_bio_data(%UserBioData{} = user_bio_data) do
    Repo.delete(user_bio_data)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_bio_data changes.

  ## Examples

      iex> change_user_bio_data(user_bio_data)
      %Ecto.Changeset{source: %UserBioData{}}

  """
  def change_user_bio_data(%UserBioData{} = user_bio_data) do
    UserBioData.changeset(user_bio_data, %{})
  end
end
