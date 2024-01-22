defmodule LoanSavingsSystem.Jobs.LoanRepayment do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Loan
  alias LoanSavingsSystem.Workers.LoanRepaymentViaMnos

  def loanrepayment_via_tingg do
    url = "https://api-dev.tingg.africa/v1/oauth/token/request"
    auth_params = Poison.encode!(prepare_tingg_auth_params())

    headers = %{
      "Content-Type" => "application/json",
      "apikey" => "vgbFeE2EJhPLCcXOpq6GasFcsdTVvrV9"
    }

    options = [
      ssl: [{:versions, [:"tlsv1.2"]}],
      timeout: 30_000,
      recv_timeout: 50_000,
      hackney: [:insecure]
    ]

    url
    |> HTTPoison.post(auth_params, headers, options)
    |> case do
      {:ok, response} ->
        results = response.body |> Poison.decode!()

        case response.status_code do
          200 ->
            {:ok, "SUCCESS"}
            LoanRepaymentViaMnos.send_via_mnos(results["access_token"])

          _ ->
            {:ok, "FAILED"}
        end

      {:error, reason} ->
        {:error, "No Internet Connection"}
    end
  end

  defp prepare_tingg_auth_params do
    %{
      "grant_type" => "client_credentials",
      "client_id" => "nullKvyGosPjDL1652085569681",
      "client_secret" => "IOPZnGfV9zRmIOP2U6UWMcDm7RJYWG2286IOhccJz"
    }
  end
end
