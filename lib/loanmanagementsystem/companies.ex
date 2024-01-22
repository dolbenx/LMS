defmodule Loanmanagementsystem.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Companies.{Company, Client_company_details}
  alias Loanmanagementsystem.Companies.Documents

  @doc """
  Returns the list of tbl_company.

  ## Examples

      iex> list_tbl_company()
      [%Company{}, ...]

  """
  # Loanmanagementsystem.Companies.list_tbl_company

  def list_all_company do
    Company
    |> where([c], c.isEmployer == true and c.status == "ACTIVE")
    |> select([c], %{
      id: c.id,
      companyName: c.companyName,
      companyPhone: c.companyPhone
    })
    |> Repo.all()
  end

  def list_tbl_company do
    Repo.all(Company)
  end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """

  # Loanmanagementsystem.Companies.get_company!(3)

  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  # Loanmanagementsystem.Accounts.get_user_role_by_user_id(3)
  def get_user_role_by_offtaker_id(id), do: Repo.get_by(UserRole, offtaker_id: id)

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{data: %Company{}}

  """
  def change_company(%Company{} = company, attrs \\ %{}) do
    Company.changeset(company, attrs)
  end

  alias Loanmanagementsystem.Companies.Employee

  #  Loanmanagementsystem.Companies.get_employee_by_user_id!(127)

  def get_employee_by_user_id!(userId), do: Repo.get_by!(Employee, userId: userId)

  @doc """
  Returns the list of tbl_employee.

  ## Examples

      iex> list_tbl_employee()
      [%Employee{}, ...]

  """
  def list_tbl_employee do
    Repo.all(Employee)
  end

  def list_employee_with_company_id(company_id) do
    Company
    |> join(:left, [c], u in "tbl_employee", on: c.company_id == u.company_id)
    |> where([c, u], c.company_id == ^company_id)
    |> select([c, u], %{
      company_name: c.company_name,
      first_name: u.first_name,
      last_name: u.last_name,
      other_name: u.other_name,
      id: u.id,
      status: u.status,
      last_name: u.last_name,
      id: u.id,
      company_id: u.company_id,
      email: u.email,
      phone: u.phone,
      id_no: u.id_no,
      status: u.status,
      city: u.city,
      country: u.country,
      staff_id: u.staff_id,
      id_type: u.id_type
    })
    |> Repo.all()
  end

  def get_employee_data do
    Company
    |> join(:left, [c], u in "tbl_employee", on: c.company_id == u.company_id)
    |> select([c, u], %{
      company_name: c.company_name,
      first_name: u.first_name,
      last_name: u.last_name,
      other_name: u.other_name,
      id: u.id,
      status: u.status,
      last_name: u.last_name,
      id: u.id,
      company_id: u.company_id,
      email: u.email,
      phone: u.phone,
      id_no: u.id_no,
      status: u.status,
      city: u.city,
      country: u.country,
      staff_id: u.staff_id,
      id_type: u.id_type
    })
    |> Repo.all()
  end


  def get_company_details(company_id) do
    Company
    |> where([c], c.id == ^company_id)
    |> select([c], %{
      companyName: c.companyName,
      companyPhone: c.companyPhone,
      contactEmail: c.contactEmail,
      registrationNumber: c.registrationNumber,
      companyRegistrationDate: c.companyRegistrationDate,
      taxno: c.taxno,
      companyAccountNumber: c.companyAccountNumber

    })
    |> Repo.all()
  end

  #  Loanmanagementsystem.Companies.list_tbl_sme_offtaker(2)
  def list_tbl_sme_offtaker(cid) do
    Loanmanagementsystem.Companies.SmeOfftaker
    |> join(:left, [uA], uL in "tbl_company", on: uA.offtakerId == uL.id)
    |> where([uA, uL], uA.smeId == ^cid)
    |> select([uA, uL], %{
      registrationNumber: uL.registrationNumber,
      companyRegistrationDate: uL.companyRegistrationDate,
      companyAccountNumber: uL.companyAccountNumber,
      offtaker_id: uA.offtakerId,
      companyName: uL.companyName,
      companyPhone: uL.companyPhone,
      taxno: uL.taxno,
      contactEmail: uL.contactEmail,
      status: uL.status,
      id: uL.id
      # smeId: uL.smeId,
      # offtakerId: uL.offtakerId
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Companies.get_client_company()
  def get_client_company do
    Company
    |> select([uL], %{
      registrationNumber: uL.registrationNumber,
      companyRegistrationDate: uL.companyRegistrationDate,
      companyAccountNumber: uL.companyAccountNumber,
      companyName: uL.companyName,
      companyPhone: uL.companyPhone,
      taxno: uL.taxno,
      contactEmail: uL.contactEmail,
      status: uL.status,
      id: uL.id
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Companies.list_get_company!(2)
  def list_get_company!(cid) do
    Company
    |> where([uT], uT.id == ^cid)
    |> select([uT], %{
      registrationNumber: uT.registrationNumber,
      companyRegistrationDate: uT.companyRegistrationDate,
      companyAccountNumber: uT.companyAccountNumber,
      companyName: uT.companyName,
      companyPhone: uT.companyPhone,
      taxno: uT.taxno,
      contactEmail: uT.contactEmail,
      status: uT.status,
      id: uT.id
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Companies.Documents.list_tbl_company_documents(2)
  # def list_tbl_company_documents(cid) do
  #   Loanmanagementsystem.Companies.Documents
  #     |> join(:left, [uA], uL in "tbl_company", on: uA.companyID == uL.id)
  #     |> where([uA, uL], uA.userID == ^cid)
  #     |> select([uA, uL], %{
  #       docName: uA.docName,
  #       docType: uA.docType,
  #       path: uA.path,
  #       userID: uA.userID,
  #       id: uL.id,
  #       taxno: uL.taxno,
  #       status: uL.status

  #     })
  #     |> Repo.all()
  # end

  @doc """
  Gets a single employee.

  Raises `Ecto.NoResultsError` if the Employee does not exist.

  ## Examples

      iex> get_employee!(123)
      %Employee{}

      iex> get_employee!(456)
      ** (Ecto.NoResultsError)

  """
  # Loanmanagementsystem.Companies.get_employee!(8)
  def get_employee!(id), do: Repo.get!(Employee, id)

  # Loanmanagementsystem.Companies.get_employee_by_userId
  def get_employee_by_userId(userId), do: Repo.get_by(Employee, userId: userId)

  @doc """
  Creates a employee.

  ## Examples

      iex> create_employee(%{field: value})
      {:ok, %Employee{}}

      iex> create_employee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employee(attrs \\ %{}) do
    %Employee{}
    |> Employee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a employee.

  ## Examples

      iex> update_employee(employee, %{field: new_value})
      {:ok, %Employee{}}

      iex> update_employee(employee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employee(%Employee{} = employee, attrs) do
    employee
    |> Employee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a employee.

  ## Examples

      iex> delete_employee(employee)
      {:ok, %Employee{}}

      iex> delete_employee(employee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employee(%Employee{} = employee) do
    Repo.delete(employee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employee changes.

  ## Examples

      iex> change_employee(employee)
      %Ecto.Changeset{source: %Employee{}}

  """
  def change_employee(%Employee{} = employee) do
    Employee.changeset(employee, %{})
  end

  alias Loanmanagementsystem.Companies.SmeOfftaker

  @doc """
  Returns the list of tbl_sme_offtaker.

  ## Examples

      iex> list_tbl_sme_offtaker()
      [%SmeOfftaker{}, ...]

  """
  def list_tbl_sme_offtaker do
    Repo.all(SmeOfftaker)
  end

  @doc """
  Gets a single sme_offtaker.

  Raises `Ecto.NoResultsError` if the Sme offtaker does not exist.

  ## Examples

      iex> get_sme_offtaker!(123)
      %SmeOfftaker{}

      iex> get_sme_offtaker!(456)
      ** (Ecto.NoResultsError)

  """
  def get_sme_offtaker!(id), do: Repo.get!(SmeOfftaker, id)

  @doc """
  Creates a sme_offtaker.

  ## Examples

      iex> create_sme_offtaker(%{field: value})
      {:ok, %SmeOfftaker{}}

      iex> create_sme_offtaker(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sme_offtaker(attrs \\ %{}) do
    %SmeOfftaker{}
    |> SmeOfftaker.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sme_offtaker.

  ## Examples

      iex> update_sme_offtaker(sme_offtaker, %{field: new_value})
      {:ok, %SmeOfftaker{}}

      iex> update_sme_offtaker(sme_offtaker, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sme_offtaker(%SmeOfftaker{} = sme_offtaker, attrs) do
    sme_offtaker
    |> SmeOfftaker.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sme_offtaker.

  ## Examples

      iex> delete_sme_offtaker(sme_offtaker)
      {:ok, %SmeOfftaker{}}

      iex> delete_sme_offtaker(sme_offtaker)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sme_offtaker(%SmeOfftaker{} = sme_offtaker) do
    Repo.delete(sme_offtaker)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sme_offtaker changes.

  ## Examples

      iex> change_sme_offtaker(sme_offtaker)
      %Ecto.Changeset{data: %SmeOfftaker{}}

  """
  def change_sme_offtaker(%SmeOfftaker{} = sme_offtaker, attrs \\ %{}) do
    SmeOfftaker.changeset(sme_offtaker, attrs)
  end

  @doc """
  Returns the list of tbl_company_documents.

  ## Examples

      iex> list_tbl_company_documents()
      [%Documents{}, ...]

  """
  def list_tbl_company_documents do
    Repo.all(Documents)
  end

  @doc """
  Gets a single documents.

  Raises `Ecto.NoResultsError` if the Documents does not exist.

  ## Examples

      iex> get_documents!(123)
      %Documents{}

      iex> get_documents!(456)
      ** (Ecto.NoResultsError)

  """
  def get_documents!(id), do: Repo.get!(Documents, id)

  @doc """
  Creates a documents.

  ## Examples

      iex> create_documents(%{field: value})
      {:ok, %Documents{}}

      iex> create_documents(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_documents(attrs \\ %{}) do
    %Documents{}
    |> Documents.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a documents.

  ## Examples

      iex> update_documents(documents, %{field: new_value})
      {:ok, %Documents{}}

      iex> update_documents(documents, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_documents(%Documents{} = documents, attrs) do
    documents
    |> Documents.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a documents.

  ## Examples

      iex> delete_documents(documents)
      {:ok, %Documents{}}

      iex> delete_documents(documents)
      {:error, %Ecto.Changeset{}}

  """
  def delete_documents(%Documents{} = documents) do
    Repo.delete(documents)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking documents changes.

  ## Examples

      iex> change_documents(documents)
      %Ecto.Changeset{data: %Documents{}}

  """
  def change_documents(%Documents{} = documents, attrs \\ %{}) do
    Documents.changeset(documents, attrs)
  end

  # Loanmanagementsystem.Companies.sme_lookup_offtaker(nil, 1, 10)

  def sme_lookup_offtaker(search_params, page, size) do
    Company
    |> handle_offtaker_filter(search_params)
    |> order_by([b], desc: b.inserted_at)
    |> compose_offtaker_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def sme_lookup_offtaker(_source, search_params) do
    Company
    |> handle_offtaker_filter(search_params)
    |> order_by([b], desc: b.inserted_at)
    |> compose_offtaker_select()
  end

  defp compose_offtaker_select(query) do
    query
    # |> where([a], a.studentInfosStatus == "Student")
    |> select(
      [b],
      %{
        id: b.id,
        companyName: b.companyName,
        companyPhone: b.companyPhone,
        registrationNumber: b.registrationNumber,
        taxno: b.taxno,
        contactEmail: b.contactEmail,
        status: b.status,
        companyRegistrationDate: b.companyRegistrationDate,
        companyAccountNumber: b.companyAccountNumber
      }
    )
  end

  defp handle_offtaker_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_registration_number_filter(search_params)
  end

  defp handle_registration_number_filter(query, %{"reg_number" => reg_number})
       when byte_size(reg_number) > 0 do
    query
    |> where(
      [b],
      fragment("lower(?) LIKE lower(?)", b.registrationNumber, ^reg_number)
    )
  end

  # Loanmanagementsystem.Companies.otc_company_details_lookup
  def otc_company_details_lookup(company_id) do
    Company
    |> where([p], p.id == ^company_id)
    |> select([p], %{
      company_id: p.id,
      approval_trail: p.approval_trail,
      auth_level: p.auth_level,
      companyName: p.companyName,
      companyPhone: p.companyPhone,
      contactEmail: p.contactEmail,
      createdByUserId: p.createdByUserId,
      createdByUserRoleId: p.createdByUserRoleId,
      isEmployer: p.isEmployer,
      isOfftaker: p.isOfftaker,
      isSme: p.isSme,
      registrationNumber: p.registrationNumber,
      status: p.status,
      taxno: p.taxno,
      companyRegistrationDate: p.companyRegistrationDate,
      companyAccountNumber: p.companyAccountNumber,
      bank_id: p.bank_id
    })
    |> Repo.all()
  end

  defp handle_registration_number_filter(query, _params), do: query

  alias Loanmanagementsystem.Companies.Department

  @doc """
  Returns the list of tbl_departments.

  ## Examples

      iex> list_tbl_departments()
      [%Department{}, ...]

  """
  # Loanmanagementsystem.Companies.list_tbl_departments
  def list_tbl_departments do
    Repo.all(Department)
  end

  @doc """
  Gets a single department.

  Raises `Ecto.NoResultsError` if the Department does not exist.

  ## Examples

      iex> get_department!(123)
      %Department{}

      iex> get_department!(456)
      ** (Ecto.NoResultsError)

  """

  # Loanmanagementsystem.Companies.get_department!()
  def get_department!(id), do: Repo.get!(Department, id)

  @doc """
  Creates a department.

  ## Examples

      iex> create_department(%{field: value})
      {:ok, %Department{}}

      iex> create_department(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_department(attrs \\ %{}) do
    %Department{}
    |> Department.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a department.

  ## Examples

      iex> update_department(department, %{field: new_value})
      {:ok, %Department{}}

      iex> update_department(department, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_department(%Department{} = department, attrs) do
    department
    |> Department.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a department.

  ## Examples

      iex> delete_department(department)
      {:ok, %Department{}}

      iex> delete_department(department)
      {:error, %Ecto.Changeset{}}

  """
  def delete_department(%Department{} = department) do
    Repo.delete(department)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking department changes.

  ## Examples

      iex> change_department(department)
      %Ecto.Changeset{data: %Department{}}

  """
  def change_department(%Department{} = department, attrs \\ %{}) do
    Department.changeset(department, attrs)
  end

  alias Loanmanagementsystem.Companies.Company_Branch

  @doc """
  Returns the list of tbl_company_branches.

  ## Examples

      iex> list_tbl_company_branches()
      [%Company_Branch{}, ...]

  """
  def list_tbl_company_branches do
    Repo.all(Company_Branch)
  end

  @doc """
  Gets a single company__branch.

  Raises `Ecto.NoResultsError` if the Company  branch does not exist.

  ## Examples

      iex> get_company__branch!(123)
      %Company_Branch{}

      iex> get_company__branch!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company__branch!(id), do: Repo.get!(Company_Branch, id)

  @doc """
  Creates a company__branch.

  ## Examples

      iex> create_company__branch(%{field: value})
      {:ok, %Company_Branch{}}

      iex> create_company__branch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company__branch(attrs \\ %{}) do
    %Company_Branch{}
    |> Company_Branch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company__branch.

  ## Examples

      iex> update_company__branch(company__branch, %{field: new_value})
      {:ok, %Company_Branch{}}

      iex> update_company__branch(company__branch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company__branch(%Company_Branch{} = company__branch, attrs) do
    company__branch
    |> Company_Branch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company__branch.

  ## Examples

      iex> delete_company__branch(company__branch)
      {:ok, %Company_Branch{}}

      iex> delete_company__branch(company__branch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company__branch(%Company_Branch{} = company__branch) do
    Repo.delete(company__branch)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company__branch changes.

  ## Examples

      iex> change_company__branch(company__branch)
      %Ecto.Changeset{data: %Company_Branch{}}

  """
  def change_company__branch(%Company_Branch{} = company__branch, attrs \\ %{}) do
    Company_Branch.changeset(company__branch, attrs)
  end

  alias Loanmanagementsystem.Companies.Client_company_details

  @doc """
  Returns the list of tbl_client_company_details.

  ## Examples

      iex> list_tbl_client_company_details()
      [%Client_company_details{}, ...]

  """
  def list_tbl_client_company_details do
    Repo.all(Client_company_details)
  end

  @doc """
  Gets a single client_company_details.

  Raises `Ecto.NoResultsError` if the Client company details does not exist.

  ## Examples

      iex> get_client_company_details!(123)
      %Client_company_details{}

      iex> get_client_company_details!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client_company_details!(id), do: Repo.get!(Client_company_details, id)

  def get_client_company_details_by_user_id!(createdByUserId), do: Repo.get_by!(Client_company_details, createdByUserId: createdByUserId)

  @doc """
  Creates a client_company_details.

  ## Examples

      iex> create_client_company_details(%{field: value})
      {:ok, %Client_company_details{}}

      iex> create_client_company_details(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client_company_details(attrs \\ %{}) do
    %Client_company_details{}
    |> Client_company_details.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client_company_details.

  ## Examples

      iex> update_client_company_details(client_company_details, %{field: new_value})
      {:ok, %Client_company_details{}}

      iex> update_client_company_details(client_company_details, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client_company_details(%Client_company_details{} = client_company_details, attrs) do
    client_company_details
    |> Client_company_details.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a client_company_details.

  ## Examples

      iex> delete_client_company_details(client_company_details)
      {:ok, %Client_company_details{}}

      iex> delete_client_company_details(client_company_details)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client_company_details(%Client_company_details{} = client_company_details) do
    Repo.delete(client_company_details)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client_company_details changes.

  ## Examples

      iex> change_client_company_details(client_company_details)
      %Ecto.Changeset{data: %Client_company_details{}}

  """
  def change_client_company_details(
        %Client_company_details{} = client_company_details,
        attrs \\ %{}
      ) do
    Client_company_details.changeset(client_company_details, attrs)
  end

  # Loanmanagementsystem.Companies.PDFReader("e:/Work/Elixir/GNC/gnc-loans/priv/static/individual_uploads/2023-2-10/fcc3f3bc-797f-42f9-b7a6-e7180a2c1dee_EASTERNPROVINCE.pdf")



end
