defmodule Savings.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_users" do
    field :clientId, :integer
    field :createdByUserId, :integer
    field :password, :string
    field :status, :string
    field :username, :string
    field :canOperate, :boolean
    field :ussdActive, :integer
    field :pin, :string
    field :password_fail_count, :integer, default: 0
    field :auto_password, :string
    field :securityQuestionId, :integer
    field :securityQuestionAnswer, :string
    field :security_question_fail_count, :integer
    # field :role_id, :integer
    field :login_attempt, :integer, default: 0
    field :remote_ip, :string
    field :last_login_dt, :naive_datetime

    belongs_to :role, Savings.Accounts.Role, foreign_key: :role_id, type: :id

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :role_id,
      :login_attempt,
      :remote_ip,
      :last_login_dt,
      :security_question_fail_count,
      :username,
      :password,
      :clientId,
      :createdByUserId,
      :status,
      :canOperate,
      :ussdActive,
      :pin,
      :password_fail_count,
      :auto_password,
      :securityQuestionId,
      :securityQuestionAnswer
    ])
    |> validate_length(:password,
      min: 8,
      max: 40,
      message: " should be atleast 8 to 40 characters"
    )
    # has a number
    |> validate_format(:password, ~r/[0-9]+/, message: "Password must contain a number")
    # has an upper case letter
    |> validate_format(:password, ~r/[A-Z]+/,
      message: "Password must contain an upper-case letter"
    )
    # has a lower case letter
    |> validate_format(:password, ~r/[a-z]+/, message: "Password must contain a lower-case letter")
    # Has a symbol
    |> validate_format(:password, ~r/[#\!\?&@\$%^&*\(\)]+/,
      message: "Password must contain a special character"
    )
    |> unique_constraint(:username, name: :unique_username, message: " User Name already exists")
    |> put_pass_hash
  end


  def changesetforupdate(user, attrs) do
    user
    |> cast(attrs, [
      :username,
      :role_id,
      :password,
      :clientId,
      :createdByUserId,
      :status,
      :canOperate,
      :ussdActive,
      :pin,
      :password_fail_count,
      :securityQuestionId,
      :securityQuestionAnswer
    ])

  end

  def changeset_error_to_string(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "%{#{key}}", to_string(value))
      end)
    end)
    |> Enum.reduce("", fn {k, v}, acc ->
      joined_errors = Enum.join(v, "; ")
      "#{acc}#{k}: #{joined_errors}\n"
    end)
  end

  defp put_pass_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    Ecto.Changeset.put_change(changeset, :password, encrypt_password(password))
  end

  defp put_pass_hash(changeset), do: changeset

  @spec encrypt_password(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | byte,
              binary | []
            )
        ) :: binary
  def encrypt_password(password), do: Base.encode16(:crypto.hash(:sha512, password))


  def has_role?(%{role: roles}, module, action) when is_atom(action) and is_atom(module),
    do: get_in(roles, [module, action]) == "Y"

  def has_role?(%{role: roles}, modules, actions) when is_list(modules) and is_list(actions) do
    result =
      Enum.reduce(modules, [], fn module, acc ->
        case get_in(roles, [module]) do
          nil ->
            [false | acc]

          module ->
            result = Map.take(module, actions) |> Map.values() |> Enum.any?(&(&1 == "Y"))
            [result | acc]
        end
      end)

    Enum.any?(result, & &1)
  end

  def has_role?(_user, _module, _action), do: false

end

# Savings.Accounts.create_user(%{username: "admininitiator@probasegroup.com", password: "Password@06", status: "ACTIVE", createdByUserId: "1", auto_password: "Y", clientId: "1",  inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})

# SavingsWeb.UserController.create_user(%{username: "admininitiator@probasegroup.com", password: "Password@06", status: "ACTIVE", createdByUserId: "1", auto_password: "Y", clientId: "1",  inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})

# SavingsWeb.UserController.create_user("username => admininitiator@probasegroup.com", "password =>Password@06", "status => ACTIVE", "createdByUserId => 1", auto_password: "Y", "clientId => 1",  "inserted_at => NaiveDateTime.utc_now", "updated_at => NaiveDateTime.utc_now")

# SavingsWeb.UserController.create_user(%{username: "davies@probasegroup.com"}, %{password: "Password@06", username: "assd@djkds.com", clientId: "1", createdByUserId: "1", auto_password: "Y", status: "ACTIVE"}, "assd@djkds.com")
