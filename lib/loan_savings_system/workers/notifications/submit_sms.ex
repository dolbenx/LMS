defmodule LoanSavingsSystem.Workers.Sms do
  alias LoanSavingsSystem.Notifications
  alias Core.Constants
  alias Core.RunProcesses

  alias LoanSavingsSystem.SystemSetting

  # def perform() do
  #   Notifications.sms_ready()
  #   |> Task.async_stream(&send/1, max_concurrency: 5, timeout: 30_000)
  #   |> Stream.run
  # end

  def pending_sms() do
    case Notifications.sms_ready(Constants.ready()) do
      [] ->
        IO.puts("\n <<<<<<<  NO PENDING SMS' WERE FOUND >>>>>>> \n")
        []

      sms ->
        List.wrap(sms)
    end
  end

  def send() do
    Enum.each(pending_sms(), fn sms ->
      sms_params = prepare_sms_params(sms)
      headers = [{"Content-Type", "application/json"}]

      options = [
        ssl: [{:versions, [:"tlsv1.2"]}],
        timeout: 50_000,
        recv_timeout: 60_000,
        hackney: [:insecure]
      ]

      url = SystemSetting.get_settings_by(Constants.sms_url())

      RunProcesses.fire_process(url, Poison.encode!(sms_params), headers, options)
      |> RunProcesses.recieve_process()
      |> update_sms(sms)
    end)
  end

  defp prepare_sms_params(sms) do
    %{
      message: sms.msg,
      recipient: ["#{String.trim(sms.mobile)}"],
      senderid: SystemSetting.get_settings_by(Constants.sms_sender_id()),
      username: SystemSetting.get_settings_by(Constants.sms_auth_name()),
      password: SystemSetting.get_settings_by(Constants.sms_auth_password())
    }
  end

  def update_sms(status, sms) do
    count = (String.to_integer(sms.msg_count) + 1) |> Integer.to_string()
    case status do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        case prepare_resp(Poison.decode!(body)) do
          "SUCCESS" ->
            IO.inspect(
              Notifications.update_sms(sms, %{
                status: "SUCCESS",
                date_sent: date_time(),
                msg_count: count
              })
            )

          _ ->
            IO.inspect("FAILED TO SEND TEXT")

            Notifications.update_sms(sms, %{
              status: "FAILED",
              date_sent: date_time(),
              msg_count: count
            })
        end

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "SERVICE_NOT_AVAILABLE"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def prepare_resp(response) do
    %{"response" => [%{"messagestatus" => status}]} = response
    status
  end

  defp date_time(), do: DateTime.to_iso8601(Timex.local()) |> to_string |> String.slice(0..22)
end
