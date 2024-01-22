defmodule Savings.Workers.Sms do
  alias Savings.Notifications
  alias Core.Constants
  alias Core.RunProcesses

  alias Savings.SystemSetting

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

  def send_via_mfz() do
    Enum.each(pending_sms(), fn sms ->
      sms_params = prepare_sms_params(sms)
      headers = [{"Content-Type", "application/x-www-form-urlencoded"}]

      options = [
        ssl: [{:versions, [:"tlsv1.2"]}],
        timeout: 50_000,
        recv_timeout: 60_000,
        hackney: [:insecure]
      ]

      url = SystemSetting.get_settings_by(Constants.sms_url())

      RunProcesses.fire_process(url, URI.encode_query(sms_params), headers, options)
      |> RunProcesses.recieve_process()
      |> update_sms(sms)
    end)
  end

  defp prepare_sms_params(sms) do
    %{
      message: sms.msg,
      msisdn: "#{String.trim(sms.mobile)}",
      senderid: SystemSetting.get_settings_by(Constants.sms_sender_id()),
      uname: SystemSetting.get_settings_by(Constants.sms_auth_name()),
      pwd: SystemSetting.get_settings_by(Constants.sms_auth_password())
    }
  end

  def update_sms(status, sms) do
    count = (String.to_integer(sms.msg_count) + 1) |> Integer.to_string()
    case status do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.inspect("BODYYYYYYYYYYYYYYY")
        body = Jason.decode!(body)
        IO.inspect body["status"]
        status = body["status"]
        case status do
          1 ->
            IO.inspect(
              Notifications.update_sms(sms, %{
                status: "SUCCESS",
                date_sent: date_time(),
                msg_count: count
              })
            )

          0 ->
            IO.inspect("FAILED TO SEND TEXT 00000000")

            Notifications.update_sms(sms, %{
              status: "FAILED",
              date_sent: date_time(),
              msg_count: count
            })

          _ ->
            IO.inspect("FAILED TO SEND TEXT 11111111")

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
    case response do
      %{"response" => [%{"message" => message, "status" => status}]} ->
        status
      _ ->
        # Handle the case when the response structure doesn't match
        # You can return a default value or raise an error, for example
        :error
    end
  end

  # Savings.Workers.Sms.send_sms_test
  def send_sms_test do
    xml = [
      {"uname", "zipake"},
      {"pwd", "$9pw3d"},
      {"msisdn", "260978242442"},
      {"message", "Message being sent"}
    ]
    # xml = Jason.encode!(xml)
    xml = URI.encode_query(xml)


    headers = [
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]
    options = [timeout: 9000]
    url = "192.168.218.75:8080/sms/api.php"

    case HTTPoison.request(:post, url, xml, headers, options) do
        {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
            IO.inspect "00000000----BEARER FAILED----0000000000"
            IO.inspect reason
          case reason do
            :timeout ->
              status_code = %{status_code: 500}
              IO.inspect status_code
            _ ->
              status_code = %{status_code: 500}
              IO.inspect status_code
          end

        {:ok, struct} ->
          IO.inspect "This is the struct"
          # bodyStruct =  Jason.decode!(struct.body)
          IO.inspect struct
          # IO.inspect struct
    end

  end

  defp date_time(), do: DateTime.to_iso8601(Timex.local()) |> to_string |> String.slice(0..22)
end
