defmodule Loanmanagementsystem.Security.JwtToken do
  defmodule UserAuth do
    use Joken.Config
    use Joken.Hooks
    alias Loanmanagementsystem.Notifications.Messages
    alias Loanmanagementsystem.UserContext
    alias Loanmanagementsystem.Accounts

    @impl true

    def before_generate(_hook_options, {token_config, extra_claims}) do
      {:cont,
       {token_config,
        Map.put(
          extra_claims,
          "exp",
          Timex.now() |> Timex.shift(hours: 1, minutes: 0) |> Timex.to_unix()
        )}}
    end

    def token(struct) do
      extra_claims = %{
        "id" => struct.id,
        "name" => struct.username
      }

      generate_and_sign!(extra_claims)
    end

    def token do
      extra_claims = %{"user_id" => 1, "name" => "admin", "salt" => "johnmfula360@gmail.com"}
      generate_and_sign!(extra_claims)
    end

    def verify_token(auth_token, conn) do
      verify_and_validate(auth_token)
      |> case do
        {:error, :signature_error} ->
          {:error, %{status: 700, success: false, message: "The token provided is invalid"}}

        {:error, [message: _, claim: _, claim_val: _]} ->
          {:error, %{message: "Session Expired", success: false, status: 700}}

        {:ok, claims} ->
          Accounts.get_user!(claims["id"])
          |> case do
            nil ->
              {:error, %{status: 700, success: false, message: "The token provided is invalid"}}

            user ->
              # if claims["key"] == user.device do
                args = %{:current_user => user}
                conn = Map.update(conn, :assigns, args, &Map.merge(&1, args))
                {:ok, claims, conn}
              # else
              #   {:error, Messages.device_in_use()}
              # end
          end
      end
    end
  end

  defmodule Token do
    use Joken.Config
    use Joken.Hooks

    def gen_token(key, extra_claims \\ %{}) do
      signer = Joken.Signer.create("HS256", key)

      generate_and_sign!(
        Map.put(
          extra_claims,
          "exp",
          Timex.shift(Timex.now(), hours: 0, minutes: 5, seconds: 30) |> Timex.to_unix()
        ),
        signer
      )
    end

    def check_token(key, token) do
      signer = Joken.Signer.create("HS256", key)
      verify_and_validate(token, signer)
    end
  end
end
