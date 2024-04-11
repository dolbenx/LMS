defmodule LoanSavingsSystem.Workers.LoanRepaymentViaMnos do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Loan

  def send_via_mnos(access_token) do
    with(repayment_details when repayment_details != [] <- Loan.pending_repayment_via_mnos()) do
      Loan.pending_repayment_via_mnos()
      |> Task.async_stream(fn loan -> handle_checkout_submission(loan, access_token) end,
        on_timeout: :kill_task,
        max_concurrency: 2,
        timeout: 60_000
      )
      |> Stream.run()
    else
      _ ->
        {:error, "No repayment transactions found."}
    end
  end

  defp handle_checkout_submission(loan, access_token) do
    loan_params = Poison.encode!(prepare_checkout_params(loan))
    checkout_url = "https://api-dev.tingg.africa/v3/checkout-api/checkout/request"

    headers = %{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{access_token}",
      "apikey" => "vgbFeE2EJhPLCcXOpq6GasFcsdTVvrV9"
    }

    options = [
      ssl: [{:versions, [:"tlsv1.2"]}],
      timeout: 30_000,
      recv_timeout: 50_000,
      hackney: [:insecure]
    ]

    checkout_url
    |> HTTPoison.post(loan_params, headers, options)
    |> update_msgloan_log(loan, access_token)
  end

  defp prepare_checkout_params(loan) do
    %{
      msisdn: "0975432237",
      account_number: "0975432237",
      callback_url: "",
      country_code: "ZMB",
      currency_code: "ZMW",
      customer_email: "johnmfula360@gmail.com",
      customer_first_name: "John",
      customer_last_name: "Mfula",
      due_date: "2022-05-12 15:03:00",
      fail_redirect_url: "",
      invoice_number: "00001",
      merchant_transaction_id: "1",
      raise_invoice: false,
      request_amount: 1,
      request_description: "test",
      service_code: "JOHNDOESERVICE123",
      success_redirect_url: "",
      extra_data: "test"
    }
  end

  def update_msgloan_log(response, msgloan_log, access_token) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        String.replace(body, ": ,", ": \"\",")
        |> IO.inspect()
        |> Poison.decode!()
        |> prepare_resp()
        |> case do
          "SUCCESS" ->
            handle_payment_charge(msgloan_log, access_token)

          _ ->
            Loan.update_loan_repayment(msgloan_log, %{
              status: "FAILED_CHECKOUT",
              dateOfRepayment: date_time()
            })

            {:ok, "FAILED"}
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "SERVICE_NOT_AVAILABLE"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def handle_payment_charge(msgloan_log, access_token) do
    loan_charge_params = Poison.encode!(prepare_payment_charge_params(msgloan_log))
    charge_url = "https://api-dev.tingg.africa/v3/checkout-api/charge/request"

    headers = %{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{access_token}",
      "apikey" => "vgbFeE2EJhPLCcXOpq6GasFcsdTVvrV9"
    }

    options = [
      ssl: [{:versions, [:"tlsv1.2"]}],
      timeout: 30_000,
      recv_timeout: 50_000,
      hackney: [:insecure]
    ]

    charge_url
    |> HTTPoison.post(loan_charge_params, headers, options)
    |> handle_charge_response(msgloan_log, access_token)
  end

  defp prepare_payment_charge_params(msgloan_log) do
    %{
      charge_msisdn: 254_700_000_000,
      charge_amount: 1,
      country_code: "KEN",
      currency_code: "KES",
      merchant_transaction_id: "787867001614",
      service_code: "JOHNDOEONLINESERVICE",
      payment_mode_code: "STK_PUSH",
      payment_option_code: "SAFKE"
    }
  end

  def handle_charge_response(response, msgloan_log, access_token) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case prepare_resp_on_charge(Poison.decode!(body)) do
          "SUCCESS" ->
            handle_payment_acknowledgement(msgloan_log, access_token)

          _ ->
            Loan.update_loan_repayment(msgloan_log, %{
              status: "FAILED_CHECKOUT_CHARGE",
              dateOfRepayment: date_time()
            })

            {:ok, "FAILED"}
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "SERVICE_NOT_AVAILABLE"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def handle_payment_acknowledgement(msgloan_log, access_token) do
    loan_acknowledgement_params =
      Poison.encode!(prepare_payment_acknowledgement_params(msgloan_log))

    acknowledgement_url = "https://api-dev.tingg.africa/v3/checkout-api/acknowledgement/request"

    headers = %{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{access_token}",
      "apikey" => "vgbFeE2EJhPLCcXOpq6GasFcsdTVvrV9"
    }

    options = [
      ssl: [{:versions, [:"tlsv1.2"]}],
      timeout: 30_000,
      recv_timeout: 50_000,
      hackney: [:insecure]
    ]

    acknowledgement_url
    |> HTTPoison.post(loan_acknowledgement_params, headers, options)
    |> handle_acknowledgement_response(msgloan_log, access_token)
  end

  defp prepare_payment_acknowledgement_params(msgloan_log) do
    %{
      acknowledgement_type: "full",
      acknowledgement_narration: "Test acknowledgement",
      acknowledgment_reference: "ACK80005",
      merchant_transaction_id: "336",
      service_code: "JOHNDOEONLINESERVICE",
      status_code: "183"
    }
  end

  def handle_acknowledgement_response(response, msgloan_log, access_token) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        String.replace(body, ":,", ": \"\",")
        |> String.replace(":\n", ": \"\"")
        |> Poison.decode!()
        |> IO.inspect()
        |> prepare_resp()
        |> case do
          "SUCCESS" ->
            Loan.update_loan_repayment(msgloan_log, %{
              status: "SUCCESS",
              dateOfRepayment: date_time()
            })

            {:ok, "SUCCESS"}

          _ ->
            Loan.update_loan_repayment(msgloan_log, %{
              status: "FAILED_CHECKOUT_ACKNOWLEDGEMENT",
              dateOfRepayment: date_time()
            })

            {:ok, "FAILED"}
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "SERVICE_NOT_AVAILABLE"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def handle_payment_refund(msgloan_log, access_token) do
    loan_refund_params = Poison.encode!(prepare_payment_refund_params(msgloan_log))
    refund_url = "https://api-dev.tingg.africa/v3/checkout-api/refund/request"

    headers = %{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer #{access_token}",
      "apikey" => "vgbFeE2EJhPLCcXOpq6GasFcsdTVvrV9"
    }

    options = [
      ssl: [{:versions, [:"tlsv1.2"]}],
      timeout: 30_000,
      recv_timeout: 50_000,
      hackney: [:insecure]
    ]

    refund_url
    |> HTTPoison.post(loan_refund_params, headers, options)
    |> handle_refund_response(msgloan_log, access_token)
  end

  defp prepare_payment_refund_params(msgloan_log) do
    %{
      merchant_transaction_id: "1635954852784",
      refund_type: "PARTIAL",
      refund_narration: "User refunded from portal",
      refund_reference: "PRF0018",
      service_code: "JOHNDOESERVICES",
      payment_id: "1234"
    }
  end

  def handle_refund_response(response, msgloan_log, access_token) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case prepare_resp_on_refund(Poison.decode!(body)) do
          "SUCCESS" ->
            {:ok, "SUCCESS"}

          _ ->
            {:ok, "FAILED"}
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "SERVICE_NOT_AVAILABLE"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def prepare_resp(response) do
    status_code = response["status"]["status_code"]

    case status_code do
      200 -> "SUCCESS"
      _any -> "FAILED"
    end
  end

  def prepare_resp_on_charge(response) do
    status_code = response["status"] || response["status"]["status_code"]

    case status_code do
      200 -> "SUCCESS"
      _any -> "FAILED"
    end
  end

  def prepare_resp_on_refund(response) do
    status_code = response["status"] || response["status"]["status_code"]

    case status_code do
      200 -> "SUCCESS"
      _any -> "FAILED"
    end
  end

  defp date_time(), do: to_string(Timex.today())
end
