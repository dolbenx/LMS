
defmodule Loanmanagementsystem.Auth do
  @spec confirm_password(%{:password => any, optional(any) => any}, any) ::
          {:error, <<_::192>>} | {:ok, %{:password => any, optional(any) => any}}
  def confirm_password(%{password: password_hash} = user, password) do
    case Base.encode16(:crypto.hash(:sha512, password)) do
      pwd when pwd == password_hash ->
        {:ok, user}

      _ ->
        {:error, "password/email not match"}
    end
  end
end
