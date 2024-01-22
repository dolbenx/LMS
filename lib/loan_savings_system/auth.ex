defmodule LoanSavingsSystem.Auth do
    def confirm_password(%{password: password_hash} = user, password) do
      case Base.encode16(:crypto.hash(:sha512, password)) do
        pwd when pwd == password_hash ->
          {:ok, user}

        _ ->
          {:error, "Password does not match"}
      end
    end
  end
