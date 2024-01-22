defmodule Loanmanagementsystem.Accounts do


  @moduledoc """
  The Accounts context.


  # Loanmanagementsystem.Accounts.get_current_user_by_bio_data(41) get_current_user_by_bio_data
  """

  #
  # Loanmanagementsystem.Accounts.get_loan_customer_individual()
  # Loanmanagementsystem.Accounts.get_system_admin
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Accounts.Role
  # Loanmanagementsystem.Accounts.get_user_email("admin@probasegroup.com")
  def get_user_email(username) do
    User
    |> where([u], u.username == ^username)
    |> select([u], %{
      username: u.username
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Accounts.get_user_for_otp("admin@probasegroup.com")
  def get_user_for_otp(username) do
    User
    |> join(:left, [u], uB in "tbl_user_bio_data", on: u.id == uB.userId)
    |> where([u, uB], u.username == ^username)
    |> select([u, uB], %{
      username: u.username,
      mobile: uB.mobileNumber,
      name: uB.firstName,
      last_name: uB.lastName,
      email: uB.emailAddress,
    })
    |> Repo.one()
  end


   def get_role!(id), do: Repo.get!(Role, id)

  # Loanmanagementsystem.Accounts.get_logged_user_details()
  def get_logged_admin_user_details do
    employer = "EMPLOYER"
    employee = "EMPLOYEE"
    sme = "SME"
    offtaker = "OFFTAKER"

    User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> where([uA, uB, uR], uR.roleType != ^employer and uR.roleType != ^employee and uR.roleType != ^sme and uR.roleType != ^offtaker)
    |> select([uA, uB, uR], %{
      id: uA.id,
      status: uA.status,
      username: uA.username,
      firstname: uB.firstName,
      lastname: uB.lastName,
      othername: uB.otherName,
      dateofbirth: uB.dateOfBirth,
      meansofidentificationtype: uB.meansOfIdentificationType,
      meansofidentificationnumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobilenumber: uB.mobileNumber,
      emailaddress: uB.emailAddress,
      roletype: uR.roleType,
      company_id: uA.company_id,
      classification_id: uA.classification_id
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Accounts.get_logged_user_details()
  def get_logged_user_details do
    role = "ADMIN"

    User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> where([uA, uB, uR], is_nil(uA.company_id) == false and uR.roleType != ^role)
    |> select([uA, uB, uR], %{
      id: uA.id,
      status: uA.status,
      username: uA.username,
      firstname: uB.firstName,
      lastname: uB.lastName,
      othername: uB.otherName,
      dateofbirth: uB.dateOfBirth,
      meansofidentificationtype: uB.meansOfIdentificationType,
      meansofidentificationnumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobilenumber: uB.mobileNumber,
      emailaddress: uB.emailAddress,
      roletype: uR.roleType,
      company_id: uA.company_id,
      classification_id: uA.classification_id
    })
    |> Repo.all()
  end

  #  Loanmanagementsystem.Accounts.get_logged_user_details(1)
  def get_logged_user_details(id) do
    User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uX in "tbl_address_details", on: uA.id == uX.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> join(:left, [uA], uS in "tbl_employee", on: uA.id == uS.userId)
    |> join(:left, [uA], uT in "tbl_employment_details", on: uA.id == uT.userId)
    |> where([uA, uB, uX, uR, uS, uT], uA.company_id == ^id and uR.roleType == ^"EMPLOYEE")
    |> select([uA, uB, uX, uR, uS, uT], %{
      id: uA.id,
      company_id: uA.company_id,
      status: uA.status,
      username: uA.username,

      roletype: uR.roleType,
      bio_id: uB.userId,
      role_id: uR.userId,

      bio_data_id: uB.id,
      firstname: uB.firstName,
      lastname: uB.lastName,
      othername: uB.otherName,
      dateofbirth: uB.dateOfBirth,
      meansofidentificationtype: uB.meansOfIdentificationType,
      meansofidentificationnumber: uB.meansOfIdentificationNumber,
      bio_title: uB.title,
      nationality: uB.nationality,
      gender: uB.gender,
      marital_status: uB.marital_status,
      number_of_dependants: uB.number_of_dependants,
      mobilenumber: uB.mobileNumber,
      emailaddress: uB.emailAddress,

      accomodation_status: uX.accomodation_status,
      area: uX.area,
      house_number: uX.house_number,
      street_name: uX.street_name,
      town: uX.town,
      year_at_current_address: uX.year_at_current_address,
      province: uX.province,

      nrc_image: uS.nrc_image,

      mobile_network_operator: uT.mobile_network_operator,
      registered_name_mobile_number: uT.registered_name_mobile_number

    })
    |> distinct(true)
    |> Repo.all()
  end
 #  Loanmanagementsystem.Accounts.get_user_by_bio_data
  def get_user_by_bio_data(customer_id) do
    UserBioData
    |> where([uB], uB.userId == ^customer_id)
    |> select([uB], %{
      id: uB.id,
      userId: uB.userId,
      firstName: uB.firstName,
      lastName: uB.lastName,
      otherName: uB.otherName,
      dateOfBirth: uB.dateOfBirth,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobileNumber: uB.mobileNumber,
      emailAddress: uB.emailAddress
    })
    |> Repo.all()
  end


  #  the function below is for the admin employers on the employer side
  def get_admin_logged_user_details(id) do
    User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uX in "tbl_address_details", on: uA.id == uX.userId)
    |> join(:left, [uA], uT in "tbl_employee_maintenance", on: uA.id == uT.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> where(
      [uA, uB, uX,  uT, uR],
      (uA.company_id == ^id and uR.roleType == ^"ADMIN_EMPLOYER_INITATOR") or
        uR.roleType == ^"ADMIN_EMPLOYER_APPROVER"
    )
    |> select([uA, uB, uX, uT, uR], %{
      id: uA.id,
      status: uA.status,
      username: uA.username,

      firstname: uB.firstName,
      lastname: uB.lastName,
      othername: uB.otherName,
      dateofbirth: uB.dateOfBirth,
      meansofidentificationtype: uB.meansOfIdentificationType,
      meansofidentificationnumber: uB.meansOfIdentificationNumber,
      bio_title: uB.title,
      nationality: uB.nationality,
      gender: uB.gender,
      marital_status: uB.marital_status,
      number_of_dependants: uB.number_of_dependants,
      mobilenumber: uB.mobileNumber,
      emailaddress: uB.emailAddress,

      accomodation_status: uX.accomodation_status,
      area: uX.area,
      house_number: uX.house_number,
      street_name: uX.street_name,
      town: uX.town,
      year_at_current_address: uX.year_at_current_address,
      province: uX.province,

      mobile_network_operator: uT.mobile_network_operator,
      registered_name_mobile_number: uT.registered_name_mobile_number,

      roletype: uR.roleType
    })
    |> Repo.all()
  end

  @doc """
  Returns the list of tbl_users.

  ## Examples

      iex> list_tbl_users()
      [%User{}, ...]

  """
  # Loanmanagementsystem.Accounts.list_tbl_users
  def list_tbl_users do
    Repo.all(User)
  end


  def list_tbl_funder_users do
    User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uX in "tbl_address_details", on: uA.id == uX.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> where([uA, uB, uX, uR], uR.roleType == ^"FUNDER")
    |> select([uA, uB, uX, uR], %{
      id: uA.id,
      company_id: uA.company_id,
      status: uA.status,
      username: uA.username,

      roletype: uR.roleType,
      bio_id: uB.userId,
      role_id: uR.userId,

      bio_data_id: uB.id,
      firstname: uB.firstName,
      lastname: uB.lastName,
      othername: uB.otherName,
      dateofbirth: uB.dateOfBirth,
      meansofidentificationtype: uB.meansOfIdentificationType,
      meansofidentificationnumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      nationality: uB.nationality,
      gender: uB.gender,
      marital_status: uB.marital_status,
      number_of_dependants: uB.number_of_dependants,
      mobilenumber: uB.mobileNumber,
      emailaddress: uB.emailAddress,

      accomodation_status: uX.accomodation_status,
      area: uX.area,
      house_number: uX.house_number,
      street_name: uX.street_name,
      town: uX.town,
      year_at_current_address: uX.year_at_current_address,
      province: uX.province

    })
    |> Repo.all()
  end



  # def batch_users do
  #   Repo.all(from n in UserRole, [where: n.roleType == "ADMIN"])
  # end

  def batch_users do
    Repo.all(
      from p in UserBioData,
        join: c in UserRole,
        on: c.userId == p.userId,
        where: c.roleType == "ADMIN"
    )
  end

  def get_client_users(company_id) do
    Company
    |> join(:left, [c], u in "tbl_users", on: c.company_id == u.company_id)
    |> where([c, u], c.company_id == ^company_id)
    |> select([c, u], %{
      company_name: c.company_name,
      first_name: u.first_name,
      id: u.id,
      status: u.status,
      last_name: u.last_name,
      id: u.id,
      company_id: u.company_id,
      email: u.email,
      phone: u.phone,
      address: u.address,
      id_no: u.id_no,
      age: u.age,
      sex: u.sex,
      id_type: u.id_type,
      user_role: u.user_role
    })
    |> Repo.all()
  end

  def get_loan_customer_details do
    User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> where([uA, uB, uR], uR.roleType != "BANKOFFICE_ADMIN")
    |> select([uA, uB, uR], %{
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
      userId: uR.userId
    })
    |> Repo.all()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  # Loanmanagementsystem.Accounts.pending_student_user
  def pending_student_user() do
    status = "PENDING"
    # query = from au in Loanmanagementsystem.Accounts.User,
    # 	where: au.status == ^status,
    # 	select: au
    # students = Repo.all(query)
    # students

    query =
      User
      |> join(:left, [u], uB in "tbl_user_bio_data", on: u.studentID == uB.idNo)
      |> join(:left, [u], uR in "tbl_user_roles", on: u.studentID == uR.studentID)
      |> where([u, uB, uR], u.status == ^status)
      |> select([u, uB, uR], %{
        id: u.id,
        studentID: u.studentID
      })

    user_students = Repo.all(query)
    user_students
  end

  def to_update(ids) do
    where(User, [s], s.id in ^ids)
    # |> Repo.all()
  end

  def pending_sms() do
    status = "PENDING_SMS"

    query =
      from au in Loanmanagementsystem.Accounts.User,
        where: au.status == type(^status, :string),
        select: au

    transactions = Repo.all(query)
    transactions
  end

  def to_update_user(ids) do
    where(User, [s], s.id in ^ids)
    # |> Repo.all()
  end

  # Loanmanagementsystem.Accounts.get_user!(8)
  def get_user!(id), do: Repo.get!(User, id)

  def get_users!(userId), do: Repo.get!(UserRole, userId)
  # Loanmanagementsystem.Accounts.get_userss!(122)
  def get_userRole!(userId), do: Repo.get!(UserRole, userId)
 # Loanmanagementsystem.Accounts.get_userRole_by_userId(8)
  def get_userRole_by_userId(userId), do: Repo.get_by(UserRole, userId: userId)

  def get_userRole_details(userId), do: Repo.get!(UserRole, userId)

  def get_userss!(userId) do
    UserRole
    |> join(:left, [c], u in "tbl_users", on: c.userId == u.id)
    |> where([c, u], c.userId == ^userId)
    |> select([c], %{
      roleType: c.roleType
    })
    |> Repo.get!(UserRole, userId)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Loanmanagementsystem.Accounts.UserRole

  @doc """
  Returns the list of tbl_user_roles.

  ## Examples

      iex> list_tbl_user_roles()
      [%UserRole{}, ...]

  """
  def list_tbl_user_roles do
    Repo.all(UserRole)
  end

  @doc """
  Gets a single user_role.

  Raises `Ecto.NoResultsError` if the User role does not exist.

  ## Examples

      iex> get_user_role!(123)
      %UserRole{}

      iex> get_user_role!(456)
      ** (Ecto.NoResultsError)

  """
  # Loanmanagementsystem.Accounts.get_user_role!(121)
  def get_user_role!(id), do: Repo.get!(UserRole, id)

  # Loanmanagementsystem.Accounts.get_user_role_by_user_id(10)

  # Loanmanagementsystem.Accounts.get_user_role_by_user_id(121)
  def get_user_role_by_user_id(id), do: Repo.get_by(UserRole, userId: id)

  # Loanmanagementsystem.Accounts.get_user_user_id(8)
  def get_user_user_id(id) do
    Repo.all(
      from(
        u in User,
        where: u.id == ^id,
        select: u
      )
    )
  end

  @doc """
  Creates a user_role.

  ## Examples

      iex> create_user_role(%{field: value})
      {:ok, %UserRole{}}

      iex> create_user_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_role(attrs \\ %{}) do
    %UserRole{}
    |> UserRole.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_role.

  ## Examples

      iex> update_user_role(user_role, %{field: new_value})
      {:ok, %UserRole{}}

      iex> update_user_role(user_role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_role(%UserRole{} = user_role, attrs) do
    user_role
    |> UserRole.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_role.

  ## Examples

      iex> delete_user_role(user_role)
      {:ok, %UserRole{}}

      iex> delete_user_role(user_role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_role(%UserRole{} = user_role) do
    Repo.delete(user_role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_role changes.

  ## Examples

      iex> change_user_role(user_role)
      %Ecto.Changeset{source: %UserRole{}}

  """
  def change_user_role(%UserRole{} = user_role) do
    UserRole.changeset(user_role, %{})
  end

  alias Loanmanagementsystem.Accounts.UserBioData

  def user_logs do
    Repo.all(UserBioData)
  end

  def student_logs(search_params, page, size) do
    UserBioData
    |> handle_report_filter(search_params)
    |> order_by([a], desc: a.id)
    |> compose_report_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def student_logs(_source, search_params) do
    UserBioData
    |> handle_report_filter(search_params)
    |> order_by([a], desc: a.id)
    |> compose_report_select()
  end

  defp handle_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    # |> handle_gender_filter(search_params)
    |> handle_id_filter(search_params)

    # |> handle_phone_filter(search_params)
    # |> handle_city_filter(search_params)
    # |> handle_email_filter(search_params)
    # |> handle_name_filter(search_params)
  end

  defp handle_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_isearch_filter(query, search_term)
  end

  defp handle_phone_filter(query, %{"myStreet1" => myStreet1})
       when myStreet1 == "" or is_nil(myStreet1),
       do: query

  defp handle_name_filter(query, %{"myStreet1" => myStreet1}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.myStreet1, ^"%#{myStreet1}%"))
  end

  defp handle_name_filter(query, %{"nameFirst" => nameLast})
       when nameLast == "" or is_nil(nameLast),
       do: query

  defp handle_name_filter(query, %{"nameFirst" => nameLast}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.nameLast, ^"%#{nameLast}%"))
  end

  defp handle_name_filter(query, %{"nameFirst" => nameFirst})
       when nameFirst == "" or is_nil(nameFirst),
       do: query

  defp handle_name_filter(query, %{"nameFirst" => nameFirst}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.nameFirst, ^"%#{nameFirst}%"))
  end

  # defp handle_gender_filter(query, %{"commbyMobile_Home" => commbyMobile_Home})
  #      when commbyMobile_Home == "" or is_nil(commbyMobile_Home),
  #      do: query

  # defp handle_gender_filter(query, %{"gender" => commbyMobile_Home}) do
  #   where(query, [a], fragment("lower(?) LIKE lower(?)", a.commbyMobile_Home, ^"%#{commbyMobile_Home}%"))
  # end

  defp handle_id_filter(query, %{"meansOfIdentificationType" => meansOfIdentificationType})
       when meansOfIdentificationType == "" or is_nil(meansOfIdentificationType),
       do: query

  defp handle_id_filter(query, %{"meansOfIdentificationType" => meansOfIdentificationType}) do
    where(
      query,
      [a],
      fragment(
        "lower(?) LIKE lower(?)",
        a.meansOfIdentificationType,
        ^"%#{meansOfIdentificationType}%"
      )
    )
  end

  defp handle_city_filter(query, %{"myCity" => myCity})
       when myCity == "" or is_nil(myCity),
       do: query

  defp handle_city_filter(query, %{"myCity" => myCity}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.myCity, ^"%#{myCity}%"))
  end

  defp handle_email_filter(query, %{"pref_Email" => pref_Email})
       when pref_Email == "" or is_nil(pref_Email),
       do: query

  defp handle_email_filter(query, %{"pref_Email" => pref_Email}) do
    where(query, [a], fragment("lower(?) LIKE lower(?)", a.pref_Email, ^"%#{pref_Email}%"))
  end

  defp compose_isearch_filter(query, search_term) do
    query
    |> where(
      [a],
      fragment("lower(?) LIKE lower(?)", a.firstName, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.lastName, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.userId, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.otherName, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.dateOfBirth, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.meansOfIdentificationType, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.meansOfIdentificationNumber, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.mobileNumber, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.emailAddress, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.inserted_at, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.title, ^search_term)
    )
  end

  defp compose_report_select(query) do
    query
    |> where([a], a.userId == 1)
    |> select(
      [a],
      %{
        id: a.id,
        firstName: a.firstName,
        lastName: a.lastName,
        userId: a.userId,
        otherName: a.otherName,
        dateOfBirth: a.dateOfBirth,
        dateBirthday: a.dateBirthday,
        meansOfIdentificationType: a.meansOfIdentificationType,
        meansOfIdentificationNumber: a.meansOfIdentificationNumber,
        mobileNumber: a.mobileNumber,
        emailAddress: a.emailAddress,
        inserted_at: a.inserted_at,
        updated_at: a.updated_at
      }
    )
  end

  ##################### End OF Student Lookup ############################
  # Loanmanagementsystem.Accounts.get_loan_customer_individual
  def get_loan_customer_individual do
    UserBioData
    |> join(:left, [uB], uR in "tbl_user_roles", on: uB.userId == uR.userId)
    |> join(:left, [uB, uR], uS in "tbl_users", on: uB.userId == uS.id and uS.id == uR.userId)
    |> where([uB, uR, uS], uR.roleType == "INDIVIDUAL" or is_nil(uS.company_id) == false)
    # |> where([uB, uR, uS], uR.roleType == "INDIVIDUALS")
    |> select([uB, uR, uS], %{

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
      roleType: uR.roleType,
      username: uS.username,
      company_id: uS.company_id,
      user_role_id: uR.id,
      classification_id: uS.classification_id
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

  # Loanmanagementsystem.Accounts.get_details(48)

  def get_details(userId) do
    UserBioData
    |> join(:left, [uB], uR in "tbl_users", on: uB.userId == uR.id)
    |> join(:left, [uB], role in "tbl_user_roles", on: uB.userId == role.id)
    |> where([uB, uR, role], uR.id == ^userId)
    |> select([uB, uR, role], %{
      id: uB.id,
      userId: uB.userId,
      # clientid: uB.clientId,
      status: uR.status,
      username: uR.username,
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
      emailAddress: uB.emailAddress,
      company_id: uR.company_id,
      roleType: role.roleType
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Accounts.e_money_details()
  def e_money_details() do
    User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> where([uA, uB, uR, uC], uR.roleType == "E-MONEY-ISSUER")
    |> select([uA, uB, uR], %{
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

  # Loanmanagementsystem.Accounts.loan_details() bank_account_number
  def loan_details() do
    User
    |> join(:left, [uA], uB in "tbl_loans", on: uA.id == uB.customer_id)
    |> join(:left, [uA, uB], uR in "tbl_user_bio_data", on: uA.id == uR.userId)
    |> join(:left, [uA, uB, uR], cA in Loanmanagementsystem.Accounts.Customer_account,
      on: uA.id == cA.user_id
    )
    |> join(:left, [uA, uB, uR], cB in Loanmanagementsystem.Maintenance.Bank,
      on: uR.bank_id == cB.id
    )
    |> where([uA, uB, uR], uA.id == uB.customer_id)
    |> select([uA, uB, uR, cA, cB], %{
      id: uA.id,
      customer_id: uB.customer_id,
      account_no: cA.account_number,
      bank_details: fragment("concat(?, concat('-', ?))", cB.acronym, uR.bank_account_number),
      account_name: fragment("concat(?, concat(' ', ?))", uR.firstName, uR.lastName),
      bank_name: uB.bank_name,
      loan_status: uB.loan_status,
      disbursedon_date: uB.disbursedon_date,
      currency_code: uB.currency_code,
      interest_charged_derived: uB.interest_charged_derived,
      principal_outstanding_derived: uB.principal_outstanding_derived,
      principal_amount: uB.principal_amount,
      loan_status: uB.loan_status,
      firstName: uR.firstName,
      lastName: uR.lastName,
      otherName: uR.otherName,
      mobileNumber: uR.mobileNumber,
      emailAddress: uR.emailAddress,
      dateOfBirth: uR.dateOfBirth,
      meansOfIdentificationType: uR.meansOfIdentificationType,
      meansOfIdentificationNumber: uR.meansOfIdentificationNumber,
      title: uR.title,
      gender: uR.gender,
      userId: uR.userId,
      loan_id: uB.id,
      interest_outstanding: uB.interest_outstanding_derived,
      total_outstanding: uB.principal_outstanding_derived,
      disbursedon_date: uB.disbursedon_date
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Accounts.corporate_buyer()
  def corporate_buyer() do
    User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> where([uA, uB, uR, uC], uR.roleType == "CORPORATE-BUYER")
    |> select([uA, uB, uR], %{
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
      permissions: uR.permissions,
      userId: uR.userId
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Accounts.loan_details()
  def loan_details() do
    User
    |> join(:left, [uA], uB in "tbl_loans", on: uA.id == uB.customer_id)
    |> join(:left, [uA], uR in "tbl_user_bio_data", on: uA.id == uR.userId)
    |> where([uA, uB, uR], uA.id == uB.customer_id)
    |> select([uA, uB, uR], %{
      id: uA.id,
      customer_id: uB.customer_id,
      account_no: uB.account_no,
      account_name: uB.account_name,
      bank_name: uB.bank_name,
      branch_name: uB.branch_name,
      loan_status: uB.loan_status,
      disbursedon_date: uB.disbursedon_date,
      currency_code: uB.currency_code,
      interest_charged_derived: uB.interest_charged_derived,
      principal_outstanding_derived: uB.principal_outstanding_derived,
      principal_amount: uB.principal_amount,
      loan_status: uB.loan_status,
      firstName: uR.firstName,
      lastName: uR.lastName,
      otherName: uR.otherName,
      mobileNumber: uR.mobileNumber,
      emailAddress: uR.emailAddress,
      dateOfBirth: uR.dateOfBirth,
      meansOfIdentificationType: uR.meansOfIdentificationType,
      meansOfIdentificationNumber: uR.meansOfIdentificationNumber,
      title: uR.title,
      gender: uR.gender,
      userId: uR.userId,
      loan_id: uB.id
    })
    |> Repo.all()
  end

  def loan_edit_details() do
    User
    |> join(:left, [uA], uB in "tbl_loans", on: uA.id == uB.customer_id)
    |> join(:left, [uA], uR in "tbl_user_bio_data", on: uA.id == uR.userId)
    |> where([uA, uB, uR], uA.id == uB.customer_id)
    |> select([uA, uB, uR], %{
      id: uA.id,
      account_no: uB.account_no,
      account_name: uB.account_name,
      bank_name: uB.bank_name,
      branch_name: uB.branch_name,
      disbursedon_date: uB.disbursedon_date,
      currency_code: uB.currency_code,
      interest_charged_derived: uB.interest_charged_derived,
      principal_outstanding_derived: uB.principal_outstanding_derived,
      principal_amount: uB.principal_amount,
      loan_status: uB.loan_status,
      firstName: uR.firstName,
      lastName: uR.lastName,
      otherName: uR.otherName,
      mobileNumber: uR.mobileNumber,
      emailAddress: uR.emailAddress,
      dateOfBirth: uR.dateOfBirth,
      meansOfIdentificationType: uR.meansOfIdentificationType,
      meansOfIdentificationNumber: uR.meansOfIdentificationNumber,
      title: uR.title,
      gender: uR.gender,
      userId: uR.userId
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Accounts.current_user_details(15)
  def current_user_details(userId) do
    UserBioData
    |> join(:left, [uB], uR in "tbl_users", on: uB.userId == uR.id)
    |> where([uB, uR], uR.id == ^userId)
    |> select([uB, uR], %{
      id: uR.id,
      userId: uB.userId,
      # clientid: uB.clientId,
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
      company_id: uR.company_id
    })
    |> Repo.one()
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
  # Loanmanagementsystem.Accounts.get_user_bio_data!(28)
  def get_user_bio_data!(userId), do: Repo.get!(UserBioData, userId)
  # Loanmanagementsystem.Accounts.get_user_bio_data_by_user_id!(1)
  def get_user_bio_data_by_user_id!(userId), do: Repo.get_by!(UserBioData, userId: userId)

  @doc """
  Creates a user_bio_data.

  ## Examples

      iex> create_user_bio_data(%{field: value})
      {:ok, %UserBioData{}}

      iex> create_user_bio_data(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  # Loanmanagementsystem.Accounts.get_user_boi_data_by_user_id(8)
  def get_user_boi_data_by_user_id(id) do
    UserBioData
    |> where([uB], uB.userId == ^id)
    |> select([uB], %{
      dateOfBirth: uB.dateOfBirth,
      emailAddress: uB.emailAddress,
      firstName: uB.firstName,
      gender: uB.gender,
      lastName: uB.lastName,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      mobileNumber: uB.mobileNumber,
      otherName: uB.otherName,
      title: uB.title,
      userId: uB.userId
    })
    |> Repo.all()
  end

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

  # Loanmanagementsystem.Accounts.get_all_administartion_users

  def get_all_administartion_users() do
    UserBioData
    |> join(:left, [uB], uR in "tbl_users", on: uB.userId == uR.id)
    |> join(:left, [uB, uR], user_r in "tbl_user_roles", on: uB.userId == user_r.userId)
    |> where([uB, uR, user_r], user_r.roleType != ^"INDIVIDUALS" and is_nil(uR.company_id))
    |> select([uB, uR, user_r], %{
      id: uB.id,
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
      emailAddress: uB.emailAddress,
      userrole: user_r.roleType,
      username: uR.username,
      user_idd: uB.userId
    })
    |> Repo.all()
  end

  def get_system_admin do
    UserBioData
    |> join(:left, [uB], uR in "tbl_users", on: uB.userId == uR.id)
    |> join(:left, [uB, uR], user_r in "tbl_user_roles", on: uB.userId == user_r.userId)
    |> where([uB, uR, user_r], user_r.roleType == "ADMIN")
    |> select([uB, uR, user_r], %{
      id: uB.id,
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
      emailAddress: uB.emailAddress,
      userrole: user_r.roleType,
      username: uR.username,
      user_idd: uB.userId
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Accounts.otc_user_lookup("1010/10/11")

  def otc_user_lookup(meansOfIdentificationNumber) do
    UserBioData
    |> join(:left, [uB], uR in "tbl_users", on: uB.userId == uR.id)
    |> join(:left, [uB, uR], uRo in "tbl_user_roles", on: uR.id == uRo.userId)
    |> where([uB, uR, uRo], uB.meansOfIdentificationNumber == ^meansOfIdentificationNumber)
    |> select([uB, uR, uRo], %{
      id: uB.id,
      userId: uB.userId,
      # clientid: uB.clientId,
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
      userrole: uRo.roleType
    })
    |> Repo.all()
  end

  alias Loanmanagementsystem.Accounts.Account

  @doc """
  Returns the list of tbl_users.

  ## Examples

      iex> list_tbl_users()
      [%User{}, ...]

  """

  #  Loanmanagementsystem.Accounts.list_tbl_accounts
  # Loanmanagementsystem.Accounts.list_tbl_accounts()

  def list_tbl_accounts do
    Repo.all(Account)
  end

  # def get_all_pending() do
  #   Repo.all(from x in User, where: x.approval_status == ^"PENDING_APPROVAL")
  #   end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  # def get_pending_all() do
  #  Repo.all(from x in User, where: x.approval_status == ^"PENDING_ACTIVATION")
  # end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end

  # Loanmanagementsystem.Accounts.get_my_current_user(28)

  def get_user_username(username) do
    User
    |> where([u], u.username == ^username)
    |> join(:left, [u], user_r in "tbl_user_roles", on: u.id == user_r.userId)
    |> select([u, user_r], %{
      username: u.username,
      pin: u.pin,
      status: u.status,
      roleType: user_r.roleType,
      role_id: user_r.id
    })
    |> Repo.one()
  end

  def get_my_current_user(user_id) do
    User
    |> where([u], u.id == ^user_id)
    |> join(:left, [u], user_r in "tbl_user_roles", on: u.id == user_r.userId)
    |> join(:left, [u], user_bio in "tbl_user_bio_data", on: u.id == user_bio.userId)
    |> select([u, user_r, user_bio], %{
      username: u.username,
      pin: u.pin,
      status: u.status,
      roleType: user_r.roleType,
      role_id: user_r.id,
      dateOfBirth: user_bio.dateOfBirth,
      emailAddress: user_bio.emailAddress,
      firstName: user_bio.firstName,
      gender: user_bio.gender,
      lastName: user_bio.lastName,
      meansOfIdentificationNumber: user_bio.meansOfIdentificationNumber,
      meansOfIdentificationType: user_bio.meansOfIdentificationType,
      mobileNumber: user_bio.mobileNumber,
      otherName: user_bio.otherName,
      title: user_bio.title,
      idNo: user_bio.idNo,
      bank_id: user_bio.bank_id,
      bank_account_number: user_bio.bank_account_number,
      userId: user_bio.userId
    })
    |> Repo.one()
  end

  alias Loanmanagementsystem.Accounts.SecurityQuestions

  @doc """
  Returns the list of tbl_security_questions.

  ## Examples

      iex> list_tbl_security_questions()
      [%SecurityQuestions{}, ...]

  """
  def list_tbl_security_questions do
    Repo.all(SecurityQuestions)
  end

  @doc """
  Gets a single security_questions.

  Raises `Ecto.NoResultsError` if the Security questions does not exist.

  ## Examples

      iex> get_security_questions!(123)
      %SecurityQuestions{}

      iex> get_security_questions!(456)
      ** (Ecto.NoResultsError)

  """
  def get_security_questions!(id), do: Repo.get!(SecurityQuestions, id)

  @doc """
  Creates a security_questions.

  ## Examples

      iex> create_security_questions(%{field: value})
      {:ok, %SecurityQuestions{}}

      iex> create_security_questions(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_security_questions(attrs \\ %{}) do
    %SecurityQuestions{}
    |> SecurityQuestions.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a security_questions.

  ## Examples

      iex> update_security_questions(security_questions, %{field: new_value})
      {:ok, %SecurityQuestions{}}

      iex> update_security_questions(security_questions, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_security_questions(%SecurityQuestions{} = security_questions, attrs) do
    security_questions
    |> SecurityQuestions.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a security_questions.

  ## Examples

      iex> delete_security_questions(security_questions)
      {:ok, %SecurityQuestions{}}

      iex> delete_security_questions(security_questions)
      {:error, %Ecto.Changeset{}}

  """
  def delete_security_questions(%SecurityQuestions{} = security_questions) do
    Repo.delete(security_questions)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking security_questions changes.

  ## Examples

      iex> change_security_questions(security_questions)
      %Ecto.Changeset{source: %SecurityQuestions{}}

  """
  def change_security_questions(%SecurityQuestions{} = security_questions) do
    SecurityQuestions.changeset(security_questions, %{})
  end

  alias Loanmanagementsystem.Accounts.RoleDescription

  @doc """
  Returns the list of tbl_role_description.

  ## Examples

      iex> list_tbl_role_description()
      [%RoleDescription{}, ...]

  """
  def list_tbl_role_description do
    Repo.all(RoleDescription)
  end

  @doc """
  Gets a single role_description.

  Raises `Ecto.NoResultsError` if the Role description does not exist.

  ## Examples

      iex> get_role_description!(123)
      %RoleDescription{}

      iex> get_role_description!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role_description!(id), do: Repo.get!(RoleDescription, id)

  @doc """
  Creates a role_description.

  ## Examples

      iex> create_role_description(%{field: value})
      {:ok, %RoleDescription{}}

      iex> create_role_description(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role_description(attrs \\ %{}) do
    %RoleDescription{}
    |> RoleDescription.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role_description.

  ## Examples

      iex> update_role_description(role_description, %{field: new_value})
      {:ok, %RoleDescription{}}

      iex> update_role_description(role_description, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role_description(%RoleDescription{} = role_description, attrs) do
    role_description
    |> RoleDescription.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a role_description.

  ## Examples

      iex> delete_role_description(role_description)
      {:ok, %RoleDescription{}}

      iex> delete_role_description(role_description)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role_description(%RoleDescription{} = role_description) do
    Repo.delete(role_description)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role_description changes.

  ## Examples

      iex> change_role_description(role_description)
      %Ecto.Changeset{data: %RoleDescription{}}

  """
  def change_role_description(%RoleDescription{} = role_description, attrs \\ %{}) do
    RoleDescription.changeset(role_description, attrs)
  end

  alias Loanmanagementsystem.Accounts.Customer_account

  @doc """
  Returns the list of tbl_customer_accounts.

  ## Examples

      iex> list_tbl_customer_accounts()
      [%Customer_account{}, ...]

  """
  def list_tbl_customer_accounts do
    Repo.all(Customer_account)
  end

  @doc """
  Gets a single customer_account.

  Raises `Ecto.NoResultsError` if the Customer account does not exist.

  ## Examples

      iex> get_customer_account!(123)
      %Customer_account{}

      iex> get_customer_account!(456)
      ** (Ecto.NoResultsError)

  """
  #  Loanmanagementsystem.Accounts.get_account_by_user_id!(121)
  # Loanmanagementsystem.Accounts.get_customer_account!()
  def get_customer_account!(id), do: Repo.get!(Customer_account, id)
   def get_customer_account(userId), do: Repo.get_by(Customer_account, user_id: userId)
  #    # Loanmanagementsystem.Accounts.get_customer_account_loan_officer_id
  #  def get_customer_account_loan_officer_id(userId), do: Repo.get_by(Customer_account, loan_officer_id: userId)


  def get_account_by_user_id!(userId), do: Repo.get_by!(Customer_account, user_id: userId)

    # Loanmanagementsystem.Accounts.get_customer_account_loan_officer_id
  def get_customer_account_loan_officer_id(userId) do
    Repo.all(
      from c in Customer_account,
        where: c.loan_officer_id == ^userId
    )
  end
  @doc """
  Creates a customer_account.

  ## Examples

      iex> create_customer_account(%{field: value})
      {:ok, %Customer_account{}}

      iex> create_customer_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_customer_account(attrs \\ %{}) do
    %Customer_account{}
    |> Customer_account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a customer_account.

  ## Examples

      iex> update_customer_account(customer_account, %{field: new_value})
      {:ok, %Customer_account{}}

      iex> update_customer_account(customer_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_customer_account(%Customer_account{} = customer_account, attrs) do
    customer_account
    |> Customer_account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a customer_account.

  ## Examples

      iex> delete_customer_account(customer_account)
      {:ok, %Customer_account{}}

      iex> delete_customer_account(customer_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_customer_account(%Customer_account{} = customer_account) do
    Repo.delete(customer_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking customer_account changes.

  ## Examples

      iex> change_customer_account(customer_account)
      %Ecto.Changeset{data: %Customer_account{}}

  """
  def change_customer_account(%Customer_account{} = customer_account, attrs \\ %{}) do
    Customer_account.changeset(customer_account, attrs)
  end

  # Loanmanagementsystem.Accounts.get_client_and_rm(nil, 1, 10)

  #  Loanmanagementsystem.Accounts.get_customer_account!()

  def get_client_and_rm(search_params, page, size) do
    Customer_account
    # |> handle_product_filter(search_params)
    |> order_by([cust, usB, loanOfficer], desc: cust.inserted_at)
    |> compose_client_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def get_client_and_rm(_source, search_params) do
    Customer_account
    # |> handle_product_filter(search_params)
    |> order_by([cust, usB, loanOfficer], desc: cust.inserted_at)
    |> compose_client_list()
  end

  defp compose_client_list(query) do
    query
    |> join(:left, [cust], usB in Loanmanagementsystem.Accounts.UserBioData,
      on: cust.user_id == usB.userId
    )
    |> join(:left, [cust], loanOfficer in Loanmanagementsystem.Accounts.UserBioData,
      on: cust.loan_officer_id == loanOfficer.userId
    )
    |> where([cust, usB, loanOfficer], cust.status == "ACTIVE")
    |> select(
      [cust, usB, loanOfficer],
      %{
        id: cust.id,
        loan_officer_id: cust.loan_officer_id,
        cutomer_userid: cust.user_id,
        cutomer_account_number: cust.account_number,
        cutomer_status: cust.status,
        cutomernames: fragment("CONCAT(?, ' ',?)", usB.firstName, usB.lastName),
        cutomer_id_no: usB.meansOfIdentificationNumber,
        cutomer_id_type: usB.meansOfIdentificationType,
        loanofficernames:
          fragment("CONCAT(?, ' ',?)", loanOfficer.firstName, loanOfficer.lastName),
        loanofficerfirstnames: loanOfficer.firstName,
        loanofficerlastnames: loanOfficer.lastName,
        loanofficer_idtype: loanOfficer.meansOfIdentificationType,
        loanofficer_userid: loanOfficer.userId,
        loanofficer_idnumber: loanOfficer.meansOfIdentificationNumber,
        loanofficer_idnumber_type:
          fragment(
            "CONCAT(?, ' - ',?)",
            loanOfficer.meansOfIdentificationType,
            loanOfficer.meansOfIdentificationNumber
          ),
        inserted_at: cust.inserted_at,
        updated_at: cust.updated_at
      }
    )
  end

  # Loanmanagementsystem.Accounts.client_relationship_managers()
  def client_relationship_managers() do
    User
    |> where([u], u.status == "ACTIVE")
    |> join(:left, [u], user_r in "tbl_user_roles", on: u.id == user_r.userId)
    |> join(:left, [u], user_bio in "tbl_user_bio_data", on: u.id == user_bio.userId)
    |> select([u, user_r, user_bio], %{
      username: u.username,
      pin: u.pin,
      status: u.status,
      roleType: user_r.roleType,
      role_id: user_r.id,
      dateOfBirth: user_bio.dateOfBirth,
      emailAddress: user_bio.emailAddress,
      firstName: user_bio.firstName,
      gender: user_bio.gender,
      lastName: user_bio.lastName,
      meansOfIdentificationNumber: user_bio.meansOfIdentificationNumber,
      meansOfIdentificationType: user_bio.meansOfIdentificationType,
      mobileNumber: user_bio.mobileNumber,
      otherName: user_bio.otherName,
      title: user_bio.title,
      idNo: user_bio.idNo,
      bank_id: user_bio.bank_id,
      bank_account_number: user_bio.bank_account_number,
      userId: user_bio.userId
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Accounts.client_relationship_manager_lookup("342243/10/1")

  def client_relationship_manager_lookup(userId) do
    UserBioData
    |> join(:left, [uB], uR in "tbl_users", on: uB.userId == uR.id)
    |> join(:left, [uB, uR], uRo in "tbl_user_roles", on: uR.id == uRo.userId)
    |> where(
      [uB, uR, uRo],
      uB.userId == ^userId
    )
    |> select([uB, uR, uRo], %{
      id: uB.id,
      userId: uB.userId,
      # clientid: uB.clientId,
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
      userrole: uRo.roleType
    })
    |> Repo.all()
  end

  alias Loanmanagementsystem.Maintenance.Qfin_Brance_maintenance
  alias Loanmanagementsystem.Employment.Employee_Maintenance

  # Loanmanagementsystem.Accounts.client_relationship_manager_bulk_lookup()
    def client_relationship_manager_bulk_lookup(userId) do
    UserBioData
    |> join(:left, [uB], uR in "tbl_users", on: uB.userId == uR.id)
    |> join(:left, [uB, uR], uRo in "tbl_user_roles", on: uR.id == uRo.userId)
    |> join(:left,[uB, uR, uRo] , eM in Employee_Maintenance, on: uB.userId == eM.userId)
    |> join(:left, [uB, uR, uRo, eM] , qF in Qfin_Brance_maintenance, on: eM.branchId == qF.id)
    |> where(
      [uB, uR, uRo, eM, qF],
      uB.userId == ^userId
    )
    |> select([uB, uR, uRo, eM, qF], %{
      id: uB.id,
      userId: uB.userId,
      # clientid: uB.clientId,
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
      userrole: uRo.roleType,
      branch: qF.name
    })
    |> Repo.all()
  end

  alias Loanmanagementsystem.Accounts.Address_Details

  @doc """
  Returns the list of tbl_address_details.

  ## Examples

      iex> list_tbl_address_details()
      [%Address_Details{}, ...]

  """
  def list_tbl_address_details do
    Repo.all(Address_Details)
  end

  @doc """
  Gets a single address__details.

  Raises `Ecto.NoResultsError` if the Address  details does not exist.

  ## Examples

      iex> get_address__details!(123)
      %Address_Details{}

      iex> get_address__details!(456)
      ** (Ecto.NoResultsError)

  """
  def get_address__details!(id), do: Repo.get!(Address_Details, id)

  # Loanmanagementsystem.Accounts.get_address__details_by_userId
  def get_address__details_by_userId(userId), do: Repo.get_by(Address_Details, userId: userId)

  @doc """
  Creates a address__details.

  ## Examples

      iex> create_address__details(%{field: value})
      {:ok, %Address_Details{}}

      iex> create_address__details(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_address__details(attrs \\ %{}) do
    %Address_Details{}
    |> Address_Details.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a address__details.

  ## Examples

      iex> update_address__details(address__details, %{field: new_value})
      {:ok, %Address_Details{}}

      iex> update_address__details(address__details, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_address__details(%Address_Details{} = address__details, attrs) do
    address__details
    |> Address_Details.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a address__details.

  ## Examples

      iex> delete_address__details(address__details)
      {:ok, %Address_Details{}}

      iex> delete_address__details(address__details)
      {:error, %Ecto.Changeset{}}

  """
  def delete_address__details(%Address_Details{} = address__details) do
    Repo.delete(address__details)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking address__details changes.

  ## Examples

      iex> change_address__details(address__details)
      %Ecto.Changeset{data: %Address_Details{}}

  """
  def change_address__details(%Address_Details{} = address__details, attrs \\ %{}) do
    Address_Details.changeset(address__details, attrs)
  end

# Loanmanagementsystem.Accounts.count_users()

  def count_users() do
    Loanmanagementsystem.Accounts.User
    |> select([uR], %{
      user_count: count(uR.id)
    })
    |> Repo.one()

  end


  # client_role = Loanmanagementsystem.Accounts.get_client_by_nrc("100101/101/1")

  # my_client_role = Loanmanagementsystem.Accounts.get_user_role!(client_role.role_id)

  # Loanmanagementsystem.Accounts.update_user_role(my_client_role, %{otp: "1234"})

  def get_client_by_line(nrc) do
    UserBioData
    |> join(:left, [c], u in Loanmanagementsystem.Accounts.UserRole, on: c.userId == u.userId)
    |> where([c, u], c.meansOfIdentificationNumber == ^nrc)
    |> select([c, u], %{
      role_id: c.id
    })
    |> Repo.one()
  end


  # Loanmanagementsystem.Accounts.get_client_by_user_number()
  def get_client_by_user_number(user_id) do
    UserBioData
    |> join(:left, [c], u in Loanmanagementsystem.Accounts.UserRole, on: c.userId == u.userId)
    |> join(:left, [c], emp in Loanmanagementsystem.Employment.Employment_Details, on: c.userId == emp.userId)
    |> join(:left, [c], inv in Loanmanagementsystem.Employment.Income_Details, on: c.userId == inv.userId)
    |> where([c, u], c.userId == ^user_id)
    |> select([c, u, emp, inv], %{
      firstName: c.firstName,
      lastName: c.lastName,
      userId: c.userId,
      otherName: c.otherName,
      dateOfBirth: c.dateOfBirth,
      meansOfIdentificationType: c.meansOfIdentificationType,
      meansOfIdentificationNumber: c.meansOfIdentificationNumber,
      title: c.title,
      gender: c.gender,
      mobileNumber: c.mobileNumber,
      emailAddress: c.emailAddress,
      role_id: u.id,
      marital_status: c.marital_status,
      nationality: c.nationality,
      employer: emp.employer,
      employee_number: emp.employee_number,
      net_pay: inv.net_pay,
      pay_day: inv.pay_day,
      company_id: emp.company_id
    })
    |> Repo.one()
  end

  def get_client_by_line!(client_line) do
    UserRole
    |> join(:left, [c], u in Loanmanagementsystem.Accounts.UserBioData, on: c.userId == u.userId)
    |> where([c, u], u.mobileNumber == ^client_line)
    |> select([c, u], %{
      role_id: c.id
    })
    |> Repo.one()
  end

  def get_client_loan_by_line(client_line) do
    UserRole
    |> join(:left, [c], u in Loanmanagementsystem.Accounts.UserBioData, on: c.userId == u.userId)
    |> where([c, u], u.mobileNumber == ^client_line)
    |> select([c, u], %{
      role_id: c.id
    })
    |> Repo.one()
  end

  # Loanmanagementsystem.Accounts.get_client_by_nrc("3703242/51/11311")
  def get_client_by_nrc(nrc) do
    UserBioData
    |> join(:left, [c], u in Loanmanagementsystem.Accounts.UserRole, on: c.userId == u.userId)
    |> join(:left, [c], emp in Loanmanagementsystem.Employment.Employment_Details, on: c.userId == emp.userId)
    |> join(:left, [c], inv in Loanmanagementsystem.Employment.Income_Details, on: c.userId == inv.userId)
    |> where([c, u], c.meansOfIdentificationNumber == ^nrc)
    |> select([c, u, emp, inv], %{
      firstName: c.firstName,
      lastName: c.lastName,
      userId: c.userId,
      otherName: c.otherName,
      dateOfBirth: c.dateOfBirth,
      meansOfIdentificationType: c.meansOfIdentificationType,
      meansOfIdentificationNumber: c.meansOfIdentificationNumber,
      title: c.title,
      gender: c.gender,
      mobileNumber: c.mobileNumber,
      emailAddress: c.emailAddress,
      role_id: u.id,
      marital_status: c.marital_status,
      nationality: c.nationality,
      employer: emp.employer,
      employee_number: emp.employee_number,
      net_pay: inv.net_pay,
      pay_day: inv.pay_day,
      company_id: emp.company_id
    })
    |> Repo.one()
  end

  alias Loanmanagementsystem.Accounts.Address_Details

  def get_client_address_details(customer_id) do
    UserBioData
    |> join(:left, [c], u in Address_Details, on: c.userId == u.userId)
    |> where([c, u], u.userId == ^customer_id)
    |> select([c, u], %{
      accomodation_status: u.accomodation_status,
      area: u.area,
      userId: c.userId,
      house_number: u.house_number,
      street_name: u.street_name,
      town: u.town,
      year_at_current_address: u.year_at_current_address,
      province: u.province,
    })
    |> limit(1)
    |> Repo.one()
  end

  alias Loanmanagementsystem.Accounts.Role

  @doc """
  Returns the list of tbl_roles.


  ## Examples

      iex> list_tbl_roles()
      [%Role{}, ...]

  =======

  ## Examples

      iex> list_tbl_roles()
      [%Role{}, ...]


  """
  def list_tbl_roles do
    Repo.all(Role)
  end

  @doc """
  Gets a single role.


  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  =======

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)


  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.


  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  =======

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}


  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.


  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  =======

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}


  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a role.


  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  =======

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}


  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.


  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}
  Ussdsystem.Accounts.customer_report_view(nil, 1, 10)

  =======

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}
  Ussdsystem.Accounts.customer_report_view(nil, 1, 10)


  """
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end



  alias Loanmanagementsystem.Accounts.Nextofkin

  @doc """
  Returns the list of tbl_next_of_kin.

  ## Examples

      iex> list_tbl_next_of_kin()
      [%Nextofkin{}, ...]

  """
  def list_tbl_next_of_kin do
    Repo.all(Nextofkin)
  end

  @doc """
  Gets a single nextofkin.

  Raises `Ecto.NoResultsError` if the Nextofkin does not exist.

  ## Examples

      iex> get_nextofkin!(123)
      %Nextofkin{}

      iex> get_nextofkin!(456)
      ** (Ecto.NoResultsError)

  """
  def get_nextofkin!(id), do: Repo.get!(Nextofkin, id)

  @doc """
  Creates a nextofkin.

  ## Examples

      iex> create_nextofkin(%{field: value})
      {:ok, %Nextofkin{}}

      iex> create_nextofkin(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_nextofkin(attrs \\ %{}) do
    %Nextofkin{}
    |> Nextofkin.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a nextofkin.

  ## Examples

      iex> update_nextofkin(nextofkin, %{field: new_value})
      {:ok, %Nextofkin{}}

      iex> update_nextofkin(nextofkin, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_nextofkin(%Nextofkin{} = nextofkin, attrs) do
    nextofkin
    |> Nextofkin.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a nextofkin.

  ## Examples

      iex> delete_nextofkin(nextofkin)
      {:ok, %Nextofkin{}}

      iex> delete_nextofkin(nextofkin)
      {:error, %Ecto.Changeset{}}

  """
  def delete_nextofkin(%Nextofkin{} = nextofkin) do
    Repo.delete(nextofkin)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking nextofkin changes.

  ## Examples

      iex> change_nextofkin(nextofkin)
      %Ecto.Changeset{data: %Nextofkin{}}

  """
  def change_nextofkin(%Nextofkin{} = nextofkin, attrs \\ %{}) do
    Nextofkin.changeset(nextofkin, attrs)
  end




  alias Loanmanagementsystem.Accounts.Client_Documents
  @doc """
  Returns the list of list_tbl_client_details.

  ## Examples

      iex> list_tbl_client_details()
      [%Client_Details{}, ...]

  """
  def list_tbl_client_details do
    Repo.all(Client_Documents)
  end

  @doc """
  Gets a single client_details.

  Raises `Ecto.NoResultsError` if the client_details does not exist.

  ## Examples

      iex> get_client_details!(123)
      %Client_Details{}

      iex> get_client_details!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client_details!(id), do: Repo.get!(Client_Documents, id)

  @doc """
  Creates a client_documents.

  ## Examples

      iex> create_client_details(%{field: value})
      {:ok, %Client_Details{}}

      iex> create_client_details(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client_documents(attrs \\ %{}) do
    %Client_Documents{}
    |> Client_Documents.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client_documents.

  ## Examples

      iex> update_client_documents(client_documents, %{field: new_value})
      {:ok, %Client_Documents{}}

      iex> update_client_documents(client_documents, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client_documents(%Client_Documents{} = client_documents, attrs) do
    client_documents
    |> Client_Documents.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a client_documents.

  ## Examples

      iex> delete_client_documents(client_documents)
      {:ok, %Client_Documents{}}

      iex> delete_client_documents(client_documents)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client_documents(%Client_Documents{} = client_documents) do
    Repo.delete(client_documents)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client_documents changes.

  ## Examples

      iex> change_client_documents(client_documents)
      %Ecto.Changeset{data: %client_documents{}}

  """
  def change_client_documents(%Client_Documents{} = client_documents, attrs \\ %{}) do
    Client_Details.changeset(client_documents, attrs)
  end


  alias Loanmanagementsystem.Accounts.Client_reference

  @doc """
  Returns the list of tbl_client_reference.

  ## Examples

      iex> list_tbl_client_reference()
      [%Client_reference{}, ...]

  """
  def list_tbl_client_reference do
    Repo.all(Client_reference)
  end

  @doc """
  Gets a single client_reference.

  Raises `Ecto.NoResultsError` if the Client reference does not exist.

  ## Examples

      iex> get_client_reference!(123)
      %Client_reference{}

      iex> get_client_reference!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client_reference!(id), do: Repo.get!(Client_reference, id)

  @doc """
  Creates a client_reference.

  ## Examples

      iex> create_client_reference(%{field: value})
      {:ok, %Client_reference{}}

      iex> create_client_reference(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client_reference(attrs \\ %{}) do
    %Client_reference{}
    |> Client_reference.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client_reference.

  ## Examples

      iex> update_client_reference(client_reference, %{field: new_value})
      {:ok, %Client_reference{}}

      iex> update_client_reference(client_reference, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client_reference(%Client_reference{} = client_reference, attrs) do
    client_reference
    |> Client_reference.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a client_reference.

  ## Examples

      iex> delete_client_reference(client_reference)
      {:ok, %Client_reference{}}

      iex> delete_client_reference(client_reference)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client_reference(%Client_reference{} = client_reference) do
    Repo.delete(client_reference)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client_reference changes.

  ## Examples

      iex> change_client_reference(client_reference)
      %Ecto.Changeset{data: %Client_reference{}}

  """
  def change_client_reference(%Client_reference{} = client_reference, attrs \\ %{}) do
    Client_reference.changeset(client_reference, attrs)
  end

  def get_current_user_by_bio_data(user_id) do
    UserBioData
    |>join(:left, [uB], uS in User, on: uB.userId == uS.id)
    |>join(:left, [uB, uS], r in Role, on: uS.role_id == r.id)
    |> where([uB, uS, r], uB.userId == ^user_id)
    |> select([uB, uS, r], %{
      id: uB.id,
      userId: uB.userId,
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

      role_desc: r.role_desc,
      role_group: r.role_group,
    })
    |> Repo.one()
  end


  # def get_current_user_by_bio_data(user_id) do
  #   UserBioData
  #   |> where([uB], uB.userId == ^user_id)
  #   |> select([uB], %{
  #     id: uB.id,
  #     userId: uB.userId,
  #     firstName: uB.firstName,
  #     lastName: uB.lastName,
  #     otherName: uB.otherName,
  #     dateOfBirth: uB.dateOfBirth,
  #     meansOfIdentificationType: uB.meansOfIdentificationType,
  #     meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
  #     title: uB.title,
  #     gender: uB.gender,
  #     mobileNumber: uB.mobileNumber,
  #     emailAddress: uB.emailAddress
  #   })
  #   |> Repo.one()
  # end

  # Loanmanagementsystem.Accounts.otp_validate_by_phone("0978242441")

  def otp_validate_by_phone(mobile) do
    User
    |> join(:left, [u], uB in "tbl_user_bio_data", on: u.id == uB.userId)
    |> join(:left, [u], uR in "tbl_user_roles", on: u.id == uR.userId)
    |> where([u, uB], uB.mobileNumber == ^mobile)
    |> select([u, uB, uR], %{
      username: u.username,
      mobile: uB.mobileNumber,
      name: uB.firstName,
      last_name: uB.lastName,
      email: uB.emailAddress,
      roleType: uR.roleType,
      role_id: uR.id,
      username_mobile: u.username_mobile

    })
    |> Repo.one()
  end

  # Loanmanagementsystem.Accounts.get_client_employee_details()
  def get_client_employee_details do
    User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uX in "tbl_address_details", on: uA.id == uX.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> join(:left, [uA], uS in "tbl_employee", on: uA.id == uS.userId)
    |> join(:left, [uA], uT in "tbl_employment_details", on: uA.id == uT.userId)
    |> where([uA, uB, uX, uR, uS, uT], uR.roleType == ^"EMPLOYEE")
    |> select([uA, uB, uX, uR, uS, uT], %{
      id: uA.id,
      company_id: uA.company_id,
      status: uA.status,
      username: uA.username,

      roletype: uR.roleType,
      bio_id: uB.userId,
      role_id: uR.userId,

      bio_data_id: uB.id,
      firstname: uB.firstName,
      lastname: uB.lastName,
      othername: uB.otherName,
      dateofbirth: uB.dateOfBirth,
      meansofidentificationtype: uB.meansOfIdentificationType,
      meansofidentificationnumber: uB.meansOfIdentificationNumber,
      bio_title: uB.title,
      nationality: uB.nationality,
      gender: uB.gender,
      marital_status: uB.marital_status,
      number_of_dependants: uB.number_of_dependants,
      mobilenumber: uB.mobileNumber,
      emailaddress: uB.emailAddress,

      accomodation_status: uX.accomodation_status,
      area: uX.area,
      house_number: uX.house_number,
      street_name: uX.street_name,
      town: uX.town,
      year_at_current_address: uX.year_at_current_address,
      province: uX.province,

      nrc_image: uS.nrc_image,

      mobile_network_operator: uT.mobile_network_operator,
      registered_name_mobile_number: uT.registered_name_mobile_number

    })
    |> distinct(true)
    |> Repo.all()
  end



  def parse_image(path) do
    path
    |> File.read!()
    |> Base.encode64()
  end

end
