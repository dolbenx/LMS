defmodule Loanmanagementsystem.Workers.Sms do
  @moduledoc false
  # Loanmanagementsystem.Workers.Sms.init()

  @header [{"Content-Type", "application/json"}]
  @options [
    ssl: [{:versions, [:"tlsv1.2"]}],
    timeout: 200_000,
    recv_timeout: 200_000,
    hackney: [:insecure]
  ]

  # Loanmanagementsystem.Workers.Sms.send()

  def send() do
    validate_phone = fn phone ->
      phone2 = phone |> String.slice(0..1)

      cond do
        phone2 |> String.contains?("26") or phone2 |> String.contains?("09") or
            phone2 |> String.contains?("9") ->
          phone |> to_string |> String.trim() |> String.pad_leading(12, "260")

        true ->
          phone
      end
    end

    binary_to_string = fn str ->
      if is_binary(str), do: Enum.join(for <<c::utf8 <- str>>, do: <<c::utf8>>), else: str
    end

    prepare_message = fn configurations, text ->
      %{
        message: binary_to_string.(text.msg),
        msg_ref: to_string(text.id),
        recipient: [validate_phone.(text.mobile)],
        source: "RHEMA",
        username: binary_to_string.(configurations.username),
        password: binary_to_string.(configurations.password),
        senderid: binary_to_string.(configurations.sender)
      }
      |> Poison.encode!()
    end

    send = fn body, link -> HTTPoison.post(link, body, @header, @options) end

    count = fn value ->
      case value do
        nil ->
          1

        data ->
          num = data |> to_string() |> String.to_integer()
          num + 1
      end
    end

    update_sms_table = fn message, struct, response ->
      changeset =
        Ecto.Changeset.change(struct, %{
          status:
            if message != "COMPLETE" do
              "FAILED"
            else
              "SUCCESS"
            end,
          date_sent: date_now()
        })

      Ecto.Multi.new()
      |> Ecto.Multi.update(:sms, changeset)
      |> Loanmanagementsystem.Repo.transaction()
    end

    check_response = fn response_body, struct ->
      case response_body do
        {:ok, response} ->
          case response.status_code do
            200 ->
              response.body |> IO.inspect()
              body = response.body |> Poison.decode!()

              case body do
                %{"response" => [%{"messagestatus" => "INVALID_MOBILE"} | _rest]} ->
                  update_sms_table.("INVALID MOBILE MESSAGE", struct, response)

                %{"response" => [%{"messagestatus" => "SUCCESS"} | _rest]} ->
                  update_sms_table.("COMPLETE", struct, response)

                %{"response" => "DUBLICATE_MSG_REF"} ->
                  update_sms_table.("COMPLETE", struct, response)

                %{"response" => "AUTHENTICATION_FAILED"} ->
                  update_sms_table.("AUTHENTICATION FAILED", struct, response)

                %{"response" => "ERROR_MISSING_RECIPIENT_PARAM"} ->
                  update_sms_table.("ERROR MISSING RECIPIENT PARAM", struct, response)

                _ ->
                  :ok
              end

            404 ->
              {:error, "SERVICE_NOT_AVAILABLE"}

            _ ->
              {:error, "SERVICE_NOT_AVAILABLE"}
          end

        {:error, response} ->
          IO.inspect(response, label: "SMS SERVER NOT RESPONDING")
      end
    end

    Loanmanagementsystem.SystemSetting.get_settings_by("ProBASE")
    |> case do
      nil ->
        :ok

      configurations ->
        Loanmanagementsystem.Notifications.sms_ready()
        |> Enum.reject(&is_nil(&1.id))
        |> Task.async_stream(
          fn text ->
            prepare_message.(configurations, text)
            |> send.(configurations.host)
            |> check_response.(text)
          end,
          max_concurrency: 20,
          timeout: 50_000,
          on_timeout: :kill_task
        )
        |> Stream.run()
    end
  end

  # Loanmanagementsystem.Workers.Sms.insert_sms()

  def insert_sms() do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(
      :sms_con,
      Loanmanagementsystem.SystemSetting.SystemSettings.changeset(
        %Loanmanagementsystem.SystemSetting.SystemSettings{},
        %{
          username: "smspbs@123$$",
          password: "pbs@sms123$$",
          sender: "ProBASE",
          host: "https://www.probasesms.com/text/multi/res/trns/sms?",
          max_attempts: "50"
        }
      )
    )
    |> Loanmanagementsystem.Repo.transaction()
  end

  defp date_now, do: Timex.now() |> NaiveDateTime.truncate(:second) |> Timex.to_naive_datetime()
end
