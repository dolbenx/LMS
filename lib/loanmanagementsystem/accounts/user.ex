defmodule Loanmanagementsystem.Accounts.User do
  use Endon
  use Ecto.Schema
  import Ecto.Changeset

  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.UserRole
  # alias Loanmanagementsystem.Clients.Company

  @columns ~w(id auto_password classification_id external_id is_admin is_employee is_employer is_offtaker is_rm is_sme password
  password_fail_count pin status username role_id)a

  @derive {Jason.Encoder, only: @columns}
  @derive {Inspect, except: [:password]}

  schema "tbl_users" do
    field :auto_password, :string
    field :classification_id, :integer
    field :external_id, :integer
    field :is_admin, :boolean, default: false
    field :is_employee, :boolean, default: false
    field :is_employer, :boolean, default: false
    field :is_offtaker, :boolean, default: false
    field :is_rm, :boolean, default: false
    field :is_sme, :boolean, default: false
    field :password, :string
    field :password_fail_count, :integer
    field :pin, :string
    field :status, :string
    field :username, :string

    belongs_to :role, UserRole, foreign_key: :role_id, type: :id

    timestamps(type: :utc_datetime)
  end

  @doc false

  def registration_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, @columns)
    |> validate_field_sizes()
    |> validate_username()
    |> validate_password(opts)
  end

  def changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, @columns)
    |> validate_field_sizes()
    |> validate_username()
    |> validate_password(opts)
  end

  def login_changeset(user, attrs, _opts \\ []) do
    user
    |> cast(attrs, @columns)
    |> validate_required([:password, :username])
  end

  def change_password_changeset(user, attrs, _opts \\ []) do
    user
    |> cast(attrs, [:current_password, :new_password, :confirm_password])
    |> validate_required([:current_password, :new_password, :confirm_password])
  end

  def update_password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, @columns)
    |> validate_password(opts)
  end


  def update_changeset(user, attrs, _opts \\ []) do
    user
    |> cast(attrs, @columns)
    |> unique_constraint(:username)
    |> validate_username()
  end

  def approve_changeset(user, attrs, _opts \\ []) do
    user
    |> cast(attrs, [:status, :updated_by])
    |> validate_required(:status)
  end

  def validate_field_sizes(changeset) do
    changeset
    |> validate_required([:password, :username])
    |> validate_length(:username, max: 30)
  end


  defp validate_username(changeset) do
    changeset
    |> validate_required([:username])
    |> validate_length(:username, min: 3)
    |> unsafe_validate_unique(:username, Repo)
    |> unique_constraint(:username)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 6, max: 80)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      |> put_change(:password, Pbkdf2.hash_pwd_salt(password))
      # |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Pbkdf2.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%User{password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Pbkdf2.verify_pass(password, hashed_password)
  end

  def valid_password?(%{password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Pbkdf2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Pbkdf2.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end



  def change_password_validation(user,  password, new_pass, confirm_pwd) do
    case valid_password?(user, password) do
      true ->
        case valid_password?(user, new_pass) do
          false ->
            case compare_passwords(new_pass, confirm_pwd) do
              true -> {:ok, user}
              false ->
              {:error, "New password and password confirmation does not match."}
            end
          true ->
            {:error, "New password should be different from the current password."}
        end
      false ->
        {:error, "The current password is wrong, please enter the correct password."}
    end
  end


  def compare_passwords(new_pass, confirm_pwd) do
    new_pass_hash = Pbkdf2.hash_pwd_salt(new_pass)
    Pbkdf2.verify_pass(confirm_pwd, new_pass_hash)
  end
end
