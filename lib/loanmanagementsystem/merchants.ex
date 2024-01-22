defmodule Loanmanagementsystem.Merchants do
  @moduledoc """
  The Merchants context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Merchants.{Merchant, Merchants_document}

  @doc """
  Returns the list of tbl_merchant.

  ## Examples

      iex> list_tbl_merchant()
      [%Merchant{}, ...]

  """
  def list_tbl_merchant do
    Repo.all(Merchant)
  end

  @doc """
  Gets a single merchant.

  Raises `Ecto.NoResultsError` if the Merchant does not exist.

  ## Examples

      iex> get_merchant!(123)
      %Merchant{}

      iex> get_merchant!(456)
      ** (Ecto.NoResultsError)

  """

  def get_merchant!(id), do: Repo.get!(Merchant, id)


  # Loanmanagementsystem.Merchants.get_merchant_by_userId()

  def get_merchant_by_userId(user_id) do
    Merchant
    |> join(:left, [mC], mCD in "tbl_merchant_dir", on: mC.id == mCD.merchantId)
    |> where([mC], mC.user_id == ^user_id)
    |> select([mC], %{
      merchantType: mC.merchantType,
      companyName: mC.companyName,
      businessName: mC.businessName,
      businessNature: mC.businessNature,
      companyPhone: mC.companyPhone,
      registrationNumber: mC.registrationNumber,
      taxno: mC.taxno,
      contactEmail: mC.contactEmail,
      companyRegistrationDate: mC.companyRegistrationDate,
      companyAccountNumber: mC.companyAccountNumber
    })
    |> Repo.all()
  end

  @doc """
  Creates a merchant.

  ## Examples

      iex> create_merchant(%{field: value})
      {:ok, %Merchant{}}

      iex> create_merchant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_merchant(attrs \\ %{}) do
    %Merchant{}
    |> Merchant.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a merchant.

  ## Examples

      iex> update_merchant(merchant, %{field: new_value})
      {:ok, %Merchant{}}

      iex> update_merchant(merchant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_merchant(%Merchant{} = merchant, attrs) do
    merchant
    |> Merchant.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a merchant.

  ## Examples

      iex> delete_merchant(merchant)
      {:ok, %Merchant{}}

      iex> delete_merchant(merchant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_merchant(%Merchant{} = merchant) do
    Repo.delete(merchant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking merchant changes.

  ## Examples

      iex> change_merchant(merchant)
      %Ecto.Changeset{data: %Merchant{}}

  """
  def change_merchant(%Merchant{} = merchant, attrs \\ %{}) do
    Merchant.changeset(merchant, attrs)
  end

  alias Loanmanagementsystem.Merchants.Merchant_director

  @doc """
  Returns the list of tbl_merchant_dir.

  ## Examples

      iex> list_tbl_merchant_dir()
      [%Merchant_director{}, ...]

  """
  def list_tbl_merchant_dir do
    Repo.all(Merchant_director)
  end

  @doc """
  Gets a single merchant_director.

  Raises `Ecto.NoResultsError` if the Merchant director does not exist.

  ## Examples

      iex> get_merchant_director!(123)
      %Merchant_director{}

      iex> get_merchant_director!(456)
      ** (Ecto.NoResultsError)

  """
  def get_merchant_director!(id), do: Repo.get!(Merchant_director, id)

  @doc """
  Creates a merchant_director.

  ## Examples

      iex> create_merchant_director(%{field: value})
      {:ok, %Merchant_director{}}

      iex> create_merchant_director(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_merchant_director(attrs \\ %{}) do
    %Merchant_director{}
    |> Merchant_director.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a merchant_director.

  ## Examples

      iex> update_merchant_director(merchant_director, %{field: new_value})
      {:ok, %Merchant_director{}}

      iex> update_merchant_director(merchant_director, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_merchant_director(%Merchant_director{} = merchant_director, attrs) do
    merchant_director
    |> Merchant_director.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a merchant_director.

  ## Examples

      iex> delete_merchant_director(merchant_director)
      {:ok, %Merchant_director{}}

      iex> delete_merchant_director(merchant_director)
      {:error, %Ecto.Changeset{}}

  """
  def delete_merchant_director(%Merchant_director{} = merchant_director) do
    Repo.delete(merchant_director)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking merchant_director changes.

  ## Examples

      iex> change_merchant_director(merchant_director)
      %Ecto.Changeset{data: %Merchant_director{}}

  """
  def change_merchant_director(%Merchant_director{} = merchant_director, attrs \\ %{}) do
    Merchant_director.changeset(merchant_director, attrs)
  end

  alias Loanmanagementsystem.Merchants.Merchants_device

  @doc """
  Returns the list of tbl_merchant_device.

  ## Examples

      iex> list_tbl_merchant_device()
      [%Merchants_device{}, ...]

  """
  def list_tbl_merchant_device do
    Repo.all(Merchants_device)
  end

  @doc """
  Gets a single merchants_device.

  Raises `Ecto.NoResultsError` if the Merchants device does not exist.

  ## Examples

      iex> get_merchants_device!(123)
      %Merchants_device{}

      iex> get_merchants_device!(456)
      ** (Ecto.NoResultsError)

  """
  def get_merchants_device!(id), do: Repo.get!(Merchants_device, id)

  @doc """
  Creates a merchants_device.

  ## Examples

      iex> create_merchants_device(%{field: value})
      {:ok, %Merchants_device{}}

      iex> create_merchants_device(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_merchants_device(attrs \\ %{}) do
    %Merchants_device{}
    |> Merchants_device.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a merchants_device.

  ## Examples

      iex> update_merchants_device(merchants_device, %{field: new_value})
      {:ok, %Merchants_device{}}

      iex> update_merchants_device(merchants_device, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_merchants_device(%Merchants_device{} = merchants_device, attrs) do
    merchants_device
    |> Merchants_device.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a merchants_device.

  ## Examples

      iex> delete_merchants_device(merchants_device)
      {:ok, %Merchants_device{}}

      iex> delete_merchants_device(merchants_device)
      {:error, %Ecto.Changeset{}}

  """
  def delete_merchants_device(%Merchants_device{} = merchants_device) do
    Repo.delete(merchants_device)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking merchants_device changes.

  ## Examples

      iex> change_merchants_device(merchants_device)
      %Ecto.Changeset{data: %Merchants_device{}}

  """
  def change_merchants_device(%Merchants_device{} = merchants_device, attrs \\ %{}) do
    Merchants_device.changeset(merchants_device, attrs)
  end

  alias Loanmanagementsystem.Merchants.Merchants_document

  @doc """
  Returns the list of tbl_merchant_and_agent_doc.

  ## Examples

      iex> list_tbl_merchant_and_agent_doc()
      [%Merchants_document{}, ...]

  """
  def list_tbl_merchant_and_agent_doc do
    Repo.all(Merchants_document)
  end

  @doc """
  Gets a single merchants_document.

  Raises `Ecto.NoResultsError` if the Merchants document does not exist.

  ## Examples

      iex> get_merchants_document!(123)
      %Merchants_document{}

      iex> get_merchants_document!(456)
      ** (Ecto.NoResultsError)

  """
  def get_merchants_document!(id), do: Repo.get!(Merchants_document, id)

  @doc """
  Creates a merchants_document.

  ## Examples

      iex> create_merchants_document(%{field: value})
      {:ok, %Merchants_document{}}

      iex> create_merchants_document(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_merchants_document(attrs \\ %{}) do
    %Merchants_document{}
    |> Merchants_document.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a merchants_document.

  ## Examples

      iex> update_merchants_document(merchants_document, %{field: new_value})
      {:ok, %Merchants_document{}}

      iex> update_merchants_document(merchants_document, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_merchants_document(%Merchants_document{} = merchants_document, attrs) do
    merchants_document
    |> Merchants_document.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a merchants_document.

  ## Examples

      iex> delete_merchants_document(merchants_document)
      {:ok, %Merchants_document{}}

      iex> delete_merchants_document(merchants_document)
      {:error, %Ecto.Changeset{}}

  """
  def delete_merchants_document(%Merchants_document{} = merchants_document) do
    Repo.delete(merchants_document)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking merchants_document changes.

  ## Examples

      iex> change_merchants_document(merchants_document)
      %Ecto.Changeset{data: %Merchants_document{}}

  """
  def change_merchants_document(%Merchants_document{} = merchants_document, attrs \\ %{}) do
    Merchants_document.changeset(merchants_document, attrs)
  end

  # Loanmanagementsystem.Merchants.get_merchants_device(1)

  def list_all_momo_merchants() do
    Merchant
    |> join(:left, [mC], mCD in "tbl_merchant_dir", on: mC.id == mCD.merchantId)
    |> join(:left, [mC, mCD], doc in "tbl_merchant_and_agent_doc", on: mC.id == doc.companyID)
    # |> join(:left, [mC, mCD, doc], dev in "tbl_merchant_device", on: mC.id == dev.merchantId)
    |> where([mC, mCD, doc, _dev], mC.merchantType == "MOBILEMONEY")
    |> select([mC, mCD, doc, _dev], %{
      id: mC.id,
      merchantType: mC.merchantType,
      bankId: mC.bankId,
      companyName: mC.companyName,
      businessName: mC.businessName,
      businessNature: mC.businessNature,
      companyPhone: mC.companyPhone,
      registrationNumber: mC.registrationNumber,
      taxno: mC.taxno,
      contactEmail: mC.contactEmail,
      createdByUserId: mC.createdByUserId,
      createdByUserRoleId: mC.createdByUserRoleId,
      merchantstatus: mC.status,
      approval_trail: mC.approval_trail,
      authLevel: mC.authLevel,
      companyRegistrationDate: mC.companyRegistrationDate,
      companyAccountNumber: mC.companyAccountNumber,
      dirFirstName: mCD.firstName,
      dirLastName: mCD.lastName,
      dirOtherName: mCD.otherName,
      dirDirectorIdentificationnNumber: mCD.directorIdentificationnNumber,
      dirDirectorIdType: mCD.directorIdType,
      dirMobileNumber: mCD.mobileNumber,
      dirEmailAddress: mCD.emailAddress,
      dirStatus: mCD.status,
      dirMerchantType: mCD.merchantType,
      dirMerchantId: mCD.merchantId,
      # dev_status: dev.status,
      # deviceName: dev.deviceName,
      # deviceType: dev.deviceType,
      # deviceModel: dev.deviceModel,
      # deviceAgentLine: dev.deviceAgentLine,
      # deviceIMEI: dev.deviceIMEI,
      # dev_merchantId: dev.merchantId,
      docName: doc.docName,
      userID: doc.userID,
      companyID: doc.companyID,
      taxNo: doc.taxNo,
      docType: doc.docType,
      status: doc.status,
      path: doc.path
    })
    |> Repo.all()
  end

  def get_merchants_device(merchantId) do
    Loanmanagementsystem.Merchants.Merchants_device
    |> join(:left, [dev], mC in "tbl_merchant_dir", on: dev.merchantId == mC.id)
    |> where([dev, mC], dev.merchantId == ^merchantId)
    |> select([dev, mC], %{
      dev_status: dev.status,
      deviceName: dev.deviceName,
      deviceType: dev.deviceType,
      deviceModel: dev.deviceModel,
      deviceAgentLine: dev.deviceAgentLine,
      deviceIMEI: dev.deviceIMEI,
      dev_merchantId: dev.merchantId
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Merchants.list_merchants_agent()
  def list_merchants_agent() do
    Merchant
    |> join(:left, [mC], mCD in "tbl_merchant_dir", on: mC.id == mCD.merchantId)
    # |> join(:left, [mC, mCD], doc in "tbl_merchant_and_agent_doc", on: mC.id == doc.companyID)
    |> join(:left, [mC, mCD, doc], uR in "tbl_user_roles", on: mC.user_id == uR.userId)
    |> join(:left, [mC, mCD, doc, uR], uBD in "tbl_user_bio_data", on: mC.user_id == uBD.userId)
    |> join(:left, [mC, mCD, doc, uR, uBD], aD in "tbl_address_details", on: mC.user_id == uBD.userId)
    |> join(:left, [mC, mCD, doc, uR, uBD, aD], bD in "tbl_banks", on: mC.bankId == bD.id)
    # |> join(:left, [mC, mCD, doc], dev in "tbl_merchant_device", on: mC.id == dev.merchantId)
    |> where([mC, mCD, uR, uBD, aD, bD], uR.userId == mC.user_id)
    |> select([mC, mCD, uR, uBD, aD, bD], %{
      id: mC.id,
      roleType: uR.roleType,

      bankName: bD.bankName,

      user_id: uR.userId,
      merchantType: mC.merchantType,
      bankId: mC.bankId,
      companyName: mC.companyName,
      businessName: mC.businessName,
      businessNature: mC.businessNature,
      companyPhone: mC.companyPhone,
      registrationNumber: mC.registrationNumber,
      taxno: mC.taxno,
      contactEmail: mC.contactEmail,
      createdByUserId: mC.createdByUserId,
      createdByUserRoleId: mC.createdByUserRoleId,
      merchantstatus: mC.status,
      approval_trail: mC.approval_trail,
      authLevel: mC.authLevel,
      companyRegistrationDate: mC.companyRegistrationDate,
      companyAccountNumber: mC.companyAccountNumber,
      dirFirstName: mCD.firstName,
      dirLastName: mCD.lastName,
      dirOtherName: mCD.otherName,
      dirDirectorIdentificationnNumber: mCD.directorIdentificationnNumber,
      dirDirectorIdType: mCD.directorIdType,
      dirMobileNumber: mCD.mobileNumber,
      dirEmailAddress: mCD.emailAddress,
      dirStatus: mCD.status,
      dirMerchantType: mCD.merchantType,
      dirMerchantId: mCD.merchantId,
      dirTitle: mCD.title,
      dirHouse_number: mCD.house_number,
      dirStreet_name: mCD.street_name,
      dirArea: mCD.area,
      dirTown: mCD.town,
      dirProvince: mCD.province,
      dirAccomodation_status: mCD.accomodation_status,
      dirYears_at_current_address: mCD.years_at_current_address,
      dirDate_of_birth: mCD.date_of_birth,
      dirGender: mCD.gender,
      rep_dateOfBirth: uBD.dateOfBirth,
      rep_emailAddress: uBD.emailAddress,
      rep_firstName: uBD.firstName,
      rep_lastName: uBD.lastName,
      rep_otherName: uBD.otherName,
      rep_gender: uBD.gender,
      rep_meansOfIdentificationNumber: uBD.meansOfIdentificationNumber,
      rep_title: uBD.title,
      rep_mobileNumber: uBD.mobileNumber,
      rep_bank_id: uBD.bank_id,
      rep_bank_account_number: uBD.bank_account_number,
      addr_accomodation_status: aD.accomodation_status,
      addr_area: aD.area,
      addr_house_number: aD.house_number,
      addr_street_name: aD.street_name,
      addr_town: aD.town,
      addr_year_at_current_address: aD.year_at_current_address,
      addr_province: aD.province,

      # dev_status: dev.status,
      # deviceName: dev.deviceName,
      # deviceType: dev.deviceType,
      # deviceModel: dev.deviceModel,
      # deviceAgentLine: dev.deviceAgentLine,
      # deviceIMEI: dev.deviceIMEI,
      # dev_merchantId: dev.merchantId,
      # docName: doc.docName,
      # userID: doc.userID,
      # companyID: doc.companyID,
      # taxNo: doc.taxNo,
      # docType: doc.docType,
      # status: doc.status,
      # path: doc.path
    })
    |> Repo.all()
  end

  alias Loanmanagementsystem.Merchants.Merchant_account

  @doc """
  Returns the list of tbl_merchant_account.

  ## Examples

      iex> list_tbl_merchant_account()
      [%Merchant_account{}, ...]

  """
  def list_tbl_merchant_account do
    Repo.all(Merchant_account)
  end

  @doc """
  Gets a single merchant_account.

  Raises `Ecto.NoResultsError` if the Merchant account does not exist.

  ## Examples

      iex> get_merchant_account!(123)
      %Merchant_account{}

      iex> get_merchant_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_merchant_account!(id), do: Repo.get!(Merchant_account, id)

  @doc """
  Creates a merchant_account.

  ## Examples

      iex> create_merchant_account(%{field: value})
      {:ok, %Merchant_account{}}

      iex> create_merchant_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_merchant_account(attrs \\ %{}) do
    %Merchant_account{}
    |> Merchant_account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a merchant_account.

  ## Examples

      iex> update_merchant_account(merchant_account, %{field: new_value})
      {:ok, %Merchant_account{}}

      iex> update_merchant_account(merchant_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_merchant_account(%Merchant_account{} = merchant_account, attrs) do
    merchant_account
    |> Merchant_account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a merchant_account.

  ## Examples

      iex> delete_merchant_account(merchant_account)
      {:ok, %Merchant_account{}}

      iex> delete_merchant_account(merchant_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_merchant_account(%Merchant_account{} = merchant_account) do
    Repo.delete(merchant_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking merchant_account changes.

  ## Examples

      iex> change_merchant_account(merchant_account)
      %Ecto.Changeset{data: %Merchant_account{}}

  """
  def change_merchant_account(%Merchant_account{} = merchant_account, attrs \\ %{}) do
    Merchant_account.changeset(merchant_account, attrs)
  end

  # Loanmanagementsystem.Merchants.get_merchant_documents(105)
  def get_merchant_documents(userID) do
    Merchants_document
    |> where([doc], doc.userID == ^userID)
    |> select([doc], %{
      id: doc.id,
      docName: doc.docName,
      docPath: doc.path,
      docStatus: doc.status,
      docType: doc.docType,
      file: doc.file,
      taxNo: doc.taxNo,
      companyID: doc.companyID,
      inserted_at: doc.inserted_at
    })
    |> Repo.all()
  end

end
