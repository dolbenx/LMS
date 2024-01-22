defmodule LoanSavingsSystem.Client do
  @moduledoc """
  The Client context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.Client.Clients

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

  alias LoanSavingsSystem.Client.UserBioData

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
    |> where([uB, uR, uA], uA.accountType == "LOANS" and uR.roleType == "INDIVIDUAL" and uB.userId == ^userId)
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
      map(a, [:userId, :userId, :firstName, :lastName, :otherName, :dateOfBirth, :meansOfIdentificationType, :meansOfIdentificationNumber, :title, :gender, :gender, :mobileNumber, :emailAddress])
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

  """
  def get_user_bio_data!(id), do: Repo.get!(UserBioData, id)

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

  alias LoanSavingsSystem.Client.Address

  @doc """
  Returns the list of tbl_addresses.

  ## Examples

      iex> list_tbl_addresses()
      [%Address{}, ...]

  """
  def list_tbl_addresses do
    Repo.all(Address)
  end


 def get_address_details(userId) do
  Address
  |> join(:left, [uB], uR in "tbl_users", on: uB.userId == uR.id)
  |> where([uB, uR], uR.id == ^userId)
  |> select([uB, uR], %{
    id: uB.id,
    userId: uB.userId,
    status: uR.status,
    addressLine1: uB.addressLine1,
    addressLine2: uB.addressLine2,
    city: uB.city,
    districtId: uB.districtId,
    districtName: uB.districtName,
    provinceId: uB.provinceId,
    countryId: uB.countryId,
    countryName: uB.countryName,
    isCurrent: uB.isCurrent
  })
  |> Repo.all()
 end

  @doc """
  Gets a single address.

  Raises `Ecto.NoResultsError` if the Address does not exist.

  ## Examples

      iex> get_address!(123)
      %Address{}

      iex> get_address!(456)
      ** (Ecto.NoResultsError)

  """
  def get_address!(id), do: Repo.get!(Address, id)

  @doc """
  Creates a address.

  ## Examples

      iex> create_address(%{field: value})
      {:ok, %Address{}}

      iex> create_address(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_address(attrs \\ %{}) do
    %Address{}
    |> Address.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a address.

  ## Examples

      iex> update_address(address, %{field: new_value})
      {:ok, %Address{}}

      iex> update_address(address, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_address(%Address{} = address, attrs) do
    address
    |> Address.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a address.

  ## Examples

      iex> delete_address(address)
      {:ok, %Address{}}

      iex> delete_address(address)
      {:error, %Ecto.Changeset{}}

  """
  def delete_address(%Address{} = address) do
    Repo.delete(address)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking address changes.

  ## Examples

      iex> change_address(address)
      %Ecto.Changeset{source: %Address{}}

  """
  def change_address(%Address{} = address) do
    Address.changeset(address, %{})
  end

  alias LoanSavingsSystem.Client.NextOfKin

  @doc """
  Returns the list of tbl_next_of_kin.

  ## Examples

      iex> list_tbl_next_of_kin()
      [%NextOfKin{}, ...]

  """
  def list_tbl_next_of_kin do
    Repo.all(NextOfKin)
  end

  @doc """
  Gets a single next_of_kin.

  Raises `Ecto.NoResultsError` if the Next of kin does not exist.

  ## Examples

      iex> get_next_of_kin!(123)
      %NextOfKin{}

      iex> get_next_of_kin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_next_of_kin!(id), do: Repo.get!(NextOfKin, id)

  @doc """
  Creates a next_of_kin.

  ## Examples

      iex> create_next_of_kin(%{field: value})
      {:ok, %NextOfKin{}}

      iex> create_next_of_kin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_next_of_kin(attrs \\ %{}) do
    %NextOfKin{}
    |> NextOfKin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a next_of_kin.

  ## Examples

      iex> update_next_of_kin(next_of_kin, %{field: new_value})
      {:ok, %NextOfKin{}}

      iex> update_next_of_kin(next_of_kin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_next_of_kin(%NextOfKin{} = next_of_kin, attrs) do
    next_of_kin
    |> NextOfKin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a next_of_kin.

  ## Examples

      iex> delete_next_of_kin(next_of_kin)
      {:ok, %NextOfKin{}}

      iex> delete_next_of_kin(next_of_kin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_next_of_kin(%NextOfKin{} = next_of_kin) do
    Repo.delete(next_of_kin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking next_of_kin changes.

  ## Examples

      iex> change_next_of_kin(next_of_kin)
      %Ecto.Changeset{source: %NextOfKin{}}

  """
  def change_next_of_kin(%NextOfKin{} = next_of_kin) do
    NextOfKin.changeset(next_of_kin, %{})
  end

  alias LoanSavingsSystem.Client.Banks

  @doc """
  Returns the list of tbl_banks.

  ## Examples

      iex> list_tbl_banks()
      [%Banks{}, ...]

  """
  def list_tbl_banks do
    Repo.all(Banks)
  end

  @doc """
  Gets a single banks.

  Raises `Ecto.NoResultsError` if the Banks does not exist.

  ## Examples

      iex> get_banks!(123)
      %Banks{}

      iex> get_banks!(456)
      ** (Ecto.NoResultsError)

  """
  def get_banks!(id), do: Repo.get!(Banks, id)

  @doc """
  Creates a banks.

  ## Examples

      iex> create_banks(%{field: value})
      {:ok, %Banks{}}

      iex> create_banks(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_banks(attrs \\ %{}) do
    %Banks{}
    |> Banks.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a banks.

  ## Examples

      iex> update_banks(banks, %{field: new_value})
      {:ok, %Banks{}}

      iex> update_banks(banks, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_banks(%Banks{} = banks, attrs) do
    banks
    |> Banks.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a banks.

  ## Examples

      iex> delete_banks(banks)
      {:ok, %Banks{}}

      iex> delete_banks(banks)
      {:error, %Ecto.Changeset{}}

  """
  def delete_banks(%Banks{} = banks) do
    Repo.delete(banks)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking banks changes.

  ## Examples

      iex> change_banks(banks)
      %Ecto.Changeset{source: %Banks{}}

  """
  def change_banks(%Banks{} = banks) do
    Banks.changeset(banks, %{})
  end
end
