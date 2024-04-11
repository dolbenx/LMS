defmodule Loanmanagementsystem.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Workers.Utlis.NumberFunctions
  alias Loanmanagementsystem.Settings
  alias Loanmanagementsystem.Logs

  def get_user_by_auth_id(username) do
    User
    |> where([a], a.username == ^username)
    |> Repo.all()
    |> List.first
  end


  @doc """
  Returns the list of tbl_users.

  ## Examples

      iex> list_tbl_users()
      [%User{}, ...]

  """
  def list_tbl_users do
    Repo.all(User)
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
  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_id(id) do
    User
    |> where([a], a.company_id == ^id)
    |> select([a], a)
    |> preload([:role])
    |> Repo.one()
  end

  def get_user_details(id) do
    User
    |> where([a], a.company_id == ^id)
    |> select([a], a)
    |> preload([:role])
    |> Repo.all()
  end

  def get_emp_user(id) do
    em_id = String.to_integer(id)
    User
    |> join(:left, [a], b in "tbl_employee_accounts", on: a.id == b.employee_id)
    |> where([_a , b], b.employee_id == ^em_id)
    |> select([a], a)
    |> preload([:role])
    |> Repo.one()
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

  def register_user(attrs) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end


  def multi_update_user(user, attrs), do: User.update_changeset(user, attrs)

  def update_user_details(attrs, multiple \\ Ecto.Multi.new()) do
    Ecto.Multi.run(multiple, :user, fn _, _ -> {:ok, get_user!(attrs["id"])} end)
    |> Ecto.Multi.update(
         :update,
         fn %{user: user} ->
           multi_update_user(user, attrs)
         end
       )
    |> Repo.transaction()
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
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def login_user(%User{} = user, attrs \\ %{}) do
    User.login_changeset(user, attrs)
  end

  def password_changeset(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def change_user_registration(%User{} = user, attrs \\ %{}) do
    User.registration_changeset(user, attrs, hash_password: false)
  end

  def get_by_username(username) do
    User
    |> where([a], a.username == ^username)
    |> Repo.all()
    |> List.first
  end

  def get_user_by_username_and_password(conn, username, password)
    when is_binary(username) and is_binary(password) do
      get_by_username(username)
      |> case do
        nil ->
          {:error, "User not found, Please make sure you provide correct details."}
        user ->
          cond do
            user.status == "INACTIVE" ->
              {:error, "User Account Is Not Active. Please Contact System Administrator"}
            user.status == "BLOCKED" ->
              {:error, "User Account Blocked. Please contact system administrator"}
            user.status == "ACTIVE" ->
              case User.valid_password?(user, password) do
                true ->
                  {:ok, _} = Logs.create_user_logs(%{user_id: user.id, activity: "logged in"})
                  user

                false ->
                  Task.start(fn -> update_user_login_attempts(conn, user) end)
                  {:error, "Invalid Username or Password!!"}
              end
            true ->
              {:error, "Failed login, contact system administrator"}
      end
    end
  end


  defp update_user_login_attempts(_conn, user) do
    setting = Settings.get_setting_configuration("login_failed_attempts_max")
    failed_attempts = NumberFunctions.convert_to_int(setting.value)

    if user.password_fail_count == failed_attempts do
      Repo.update(User.update_changeset(user, %{status: "BLOCKED"}))
    else
      Repo.update(User.update_changeset(user, %{password_fail_count: (user.password_fail_count + 1)}))
    end
  end


  alias Loanmanagementsystem.Accounts.UserBioData

  @doc """
  Returns the list of tbl_user_bio_data.

  ## Examples

      iex> list_tbl_user_bio_data()
      [%UserBioData{}, ...]

  """
  def list_tbl_user_bio_data do
    Repo.all(UserBioData)
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
      %Ecto.Changeset{data: %UserBioData{}}

  """
  def change_user_bio_data(%UserBioData{} = user_bio_data, attrs \\ %{}) do
    UserBioData.changeset(user_bio_data, attrs)
  end

  alias Loanmanagementsystem.Accounts.Account

  @doc """
  Returns the list of tbl_account.

  ## Examples

      iex> list_tbl_account()
      [%Account{}, ...]

  """
  def list_tbl_account do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{data: %Account{}}

  """
  def change_account(%Account{} = account, attrs \\ %{}) do
    Account.changeset(account, attrs)
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
  def get_user_role!(id), do: Repo.get!(UserRole, id)

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
      %Ecto.Changeset{data: %UserRole{}}

  """
  def change_user_role(%UserRole{} = user_role, attrs \\ %{}) do
    UserRole.changeset(user_role, attrs)
  end

  alias Loanmanagementsystem.Accounts.Role

  @doc """
  Returns the list of tbl_roles.

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

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.

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

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}

  """
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end

  alias Loanmanagementsystem.Accounts.NextOfKin

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
      %Ecto.Changeset{data: %NextOfKin{}}

  """
  def change_next_of_kin(%NextOfKin{} = next_of_kin, attrs \\ %{}) do
    NextOfKin.changeset(next_of_kin, attrs)
  end

  alias Loanmanagementsystem.Accounts.AddressDetails

  @doc """
  Returns the list of tbl_address_details.

  ## Examples

      iex> list_tbl_address_details()
      [%AddressDetails{}, ...]

  """
  def list_tbl_address_details do
    Repo.all(AddressDetails)
  end

  @doc """
  Gets a single address_details.

  Raises `Ecto.NoResultsError` if the Address details does not exist.

  ## Examples

      iex> get_address_details!(123)
      %AddressDetails{}

      iex> get_address_details!(456)
      ** (Ecto.NoResultsError)

  """
  def get_address_details!(id), do: Repo.get!(AddressDetails, id)

  @doc """
  Creates a address_details.

  ## Examples

      iex> create_address_details(%{field: value})
      {:ok, %AddressDetails{}}

      iex> create_address_details(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_address_details(attrs \\ %{}) do
    %AddressDetails{}
    |> AddressDetails.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a address_details.

  ## Examples

      iex> update_address_details(address_details, %{field: new_value})
      {:ok, %AddressDetails{}}

      iex> update_address_details(address_details, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_address_details(%AddressDetails{} = address_details, attrs) do
    address_details
    |> AddressDetails.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a address_details.

  ## Examples

      iex> delete_address_details(address_details)
      {:ok, %AddressDetails{}}

      iex> delete_address_details(address_details)
      {:error, %Ecto.Changeset{}}

  """
  def delete_address_details(%AddressDetails{} = address_details) do
    Repo.delete(address_details)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking address_details changes.

  ## Examples

      iex> change_address_details(address_details)
      %Ecto.Changeset{data: %AddressDetails{}}

  """
  def change_address_details(%AddressDetails{} = address_details, attrs \\ %{}) do
    AddressDetails.changeset(address_details, attrs)
  end

  alias Loanmanagementsystem.Accounts.UserToken

  @doc """
  Returns the list of tbl_user_tokens.

  ## Examples

      iex> list_tbl_user_tokens()
      [%UserToken{}, ...]

  """
  def list_tbl_user_tokens do
    Repo.all(UserToken)
  end

  @doc """
  Gets a single user_token.

  Raises `Ecto.NoResultsError` if the User token does not exist.

  ## Examples

      iex> get_user_token!(123)
      %UserToken{}

      iex> get_user_token!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_token!(id), do: Repo.get!(UserToken, id)

  @doc """
  Creates a user_token.

  ## Examples

      iex> create_user_token(%{field: value})
      {:ok, %UserToken{}}

      iex> create_user_token(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_token(attrs \\ %{}) do
    %UserToken{}
    |> UserToken.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_token.

  ## Examples

      iex> update_user_token(user_token, %{field: new_value})
      {:ok, %UserToken{}}

      iex> update_user_token(user_token, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_token(%UserToken{} = user_token, attrs) do
    user_token
    |> UserToken.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_token.

  ## Examples

      iex> delete_user_token(user_token)
      {:ok, %UserToken{}}

      iex> delete_user_token(user_token)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_token(%UserToken{} = user_token) do
    Repo.delete(user_token)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_token changes.

  ## Examples

      iex> change_user_token(user_token)
      %Ecto.Changeset{data: %UserToken{}}

  """
  def change_user_token(%UserToken{} = user_token, attrs \\ %{}) do
    UserToken.changeset(user_token, attrs)
  end

  # ====================================== UserToken ============================

  def generate_user_session_token(user) do
    {token, user_token} = UserToken.build_session_token(user)
    Repo.insert!(user_token)
    # notify_subs({:ok, %{}}, :updated, @topic1)
    {}
    token
  end


  def delete_session_token(token) do
    Repo.delete_all(UserToken.token_and_context_query(token, "session"))
    |> case do
      {1, nil} ->
        # notify_subs({:ok, %{}}, :updated, @topic1)
        :ok

      _ ->
        :ok
    end

    :ok
  end

  def get_session_by_user_id(id) do
    UserToken
    |> where([a], a.user_id == ^id)
    |> Repo.all()
  end


  def get_user_by_session_token(token, type) do
    {:ok, query} = UserToken.verify_session_token_query(token, type)
    Repo.one(query)
  end


end
