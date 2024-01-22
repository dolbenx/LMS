defmodule LoanSavingsSystem.Accounts.User do
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
    field :password_fail_count, :integer
    field :auto_password, :string
	field :securityQuestionId, :integer
	field :securityQuestionAnswer, :string
	field :security_question_fail_count, :integer

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:security_question_fail_count, :username, :password, :clientId, :createdByUserId, :status, :canOperate, :ussdActive, :pin, :password_fail_count, :auto_password, :securityQuestionId, :securityQuestionAnswer])

    |> validate_length(:password, min: 8, max: 40, message: " should be atleast 8 to 40 characters")
    |> validate_format(:password, ~r/[0-9]+/, message: "Password must contain a number") # has a number
    |> validate_format(:password, ~r/[A-Z]+/, message: "Password must contain an upper-case letter") # has an upper case letter
    |> validate_format(:password, ~r/[a-z]+/, message: "Password must contain a lower-case letter") # has a lower case letter
    |> validate_format(:password, ~r/[#\!\?&@\$%^&*\(\)]+/, message: "Password must contain a special character") # Has a symbol
    |> unique_constraint(:username, name: :unique_username, message: " User Name already exists")
    |> put_pass_hash
  end


  def changesetforupdate(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :clientId, :createdByUserId, :status, :canOperate, :ussdActive, :pin, :password_fail_count, :securityQuestionId, :securityQuestionAnswer])
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

# LoanSavingsSystem.Accounts.create_user(%{username: "admininitiator@probasegroup.com", password: "Password@06", status: "ACTIVE", createdByUserId: "1", auto_password: "Y", clientId: "1",  inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})

# LoanSavingsSystemWeb.UserController.create_user(%{username: "admininitiator@probasegroup.com", password: "Password@06", status: "ACTIVE", createdByUserId: "1", auto_password: "Y", clientId: "1",  inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})

# LoanSavingsSystemWeb.UserController.create_user("username => admininitiator@probasegroup.com", "password =>Password@06", "status => ACTIVE", "createdByUserId => 1", auto_password: "Y", "clientId => 1",  "inserted_at => NaiveDateTime.utc_now", "updated_at => NaiveDateTime.utc_now")

# LoanSavingsSystemWeb.UserController.create_user(%{username: "davies@probasegroup.com"}, %{password: "Password@06", username: "assd@djkds.com", clientId: "1", createdByUserId: "1", auto_password: "Y", status: "ACTIVE"}, "assd@djkds.com")
