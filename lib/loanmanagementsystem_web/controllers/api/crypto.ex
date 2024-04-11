defmodule LoanmanagementsystemWeb.Api.Crypto do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false

 @moduledoc false
  # 1 HOUR
  @default_ttl 1 * 60 * 60

  def encrypt(atom, any) do
    Plug.Crypto.encrypt(secret(), to_string(atom), any)
  end

  def decrypt(atom, ciphertext, max_age \\ @default_ttl) when is_binary(ciphertext) do
    Plug.Crypto.decrypt(secret(), to_string(atom), ciphertext, max_age: max_age)
  end

  defp secret(), do: "PaykeshoLoanManagementSystem"

end
