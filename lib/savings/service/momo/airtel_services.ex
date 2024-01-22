defmodule Savings.Service.Momo.AirtelServices do

  @base_url_staging "https://openapi.airtel.africa"
  @client_id "402bffe8-eae6-45e9-92df-9053cfaa30e2"
  @client_secret "1fb2115f-243f-461f-ba96-eb4118c35c49"
  @grant_type "client_credentials"



  # Savings.Service.Momo.AirtelServices.get_bearer_token
  def get_bearer_token do
    xml = %{
      client_id: @client_id,
      client_secret: @client_secret,
      grant_type: @grant_type
      }
    xml = Jason.encode!(xml)

    headers = [
      {"Content-Type", "application/json"},
      {"Accept", "*/*"},
    ]
    options = [timeout: 60000, recv_timeout: 60000]
    url = @base_url_staging <> "/auth/oauth2/token"

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

  # Savings.Service.Momo.AirtelServices.customer_push(%{})
  def customer_push(params) do

    getToken = Savings.Service.Momo.AirtelServices.get_bearer_token
      statusCode = getToken.status_code
        case statusCode do
          200 ->

            bearerBody = getToken.body
            bearerBody =  Jason.decode!(bearerBody)
            IO.inspect "[[[[[[[[[[[[[000000000]]]]]]]]]]]]]]"
            IO.inspect bearerBody
            bearer = bearerBody["access_token"]
            IO.inspect bearer

            xml = %{
              reference: "MFZ Test Push Transaction",
              subscriber: %{
                      country: "ZM",
                      currency: "ZMW",
                      msisdn: "#{params.airtel_mobile}"
                  },
              transaction: %{
                      amount: "#{params.enterdAmount}",
                      country: "ZM",
                      currency: "ZMW",
                      id: params.random_int3
                  }
            }
            xml = Jason.encode!(xml)

            headers = [
                {"Content-Type", "application/json"},
                {"Accept", "*/*"},
                {"X-Country", "ZM"},
                {"X-Currency", "ZMW"},
                {"Authorization", "Bearer #{bearer}"}
              ]
            options = [timeout: 60000, recv_timeout: 60000]
            url = @base_url_staging <> "/merchant/v1/payments/"

            case HTTPoison.request(:post, url, xml, headers, options) do
                {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
                    IO.inspect "00000000----PIN PROMPT FAILED----0000000000"
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
                  bodyStruct =  Jason.decode!(struct.body)

                  # IO.inspect "LETS PARTY MAN"
                    IO.inspect struct

                  # IO.inspect bodyStruct
                  # IO.inspect struct
            end

        _->
          status_code = %{status_code: 400}
          IO.inspect status_code

      end
  end

  # Savings.Service.Momo.AirtelServices.customer_push_inquiry
  def customer_push_inquiry(transactionRef) do

    getToken = Savings.Service.Momo.AirtelServices.get_bearer_token
    statusCode = getToken.status_code

      case statusCode do

        200 ->

          bearerBody = getToken.body
          bearerBody =  Jason.decode!(bearerBody)
          IO.inspect "[[[[[[[[[[[[[000000000]]]]]]]]]]]]]]"
          IO.inspect bearerBody
          bearer = bearerBody["access_token"]
          IO.inspect bearer


          random_int3 = to_string(Enum.random(11111111..99999999))

          xml = %{}
          xml = Jason.encode!(xml)

          headers = [
              {"Content-Type", "application/json"},
              {"Accept", "*/*"},
              {"X-Country", "ZM"},
              {"X-Currency", "ZMW"},
              {"Authorization", "Bearer #{bearer}"}
            ]
            options = [timeout: 60000, recv_timeout: 60000]
          url = @base_url_staging <> "/standard/v1/payments/#{transactionRef}"

          case HTTPoison.request(:get, url, xml, headers, options) do
              {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
                  IO.inspect "000000000000000000"
                  IO.inspect reason

              {:ok, struct} ->
                IO.inspect "This is the struct"
                bodyStruct =  Jason.decode!(struct.body)

                # IO.inspect "LETS PARTY MAN"
                  IO.inspect struct

                # IO.inspect bodyStruct
                # IO.inspect struct
          end

        _->
          status_code = %{status_code: 400}
          IO.inspect status_code


    end
  end

  def customer_disbursment(params) do

    getToken = Savings.Service.Momo.AirtelServices.get_bearer_token
      statusCode = getToken.status_code
        case statusCode do
          200 ->

            bearerBody = getToken.body
            bearerBody =  Jason.decode!(bearerBody)
            IO.inspect "[[[[[[[[[[[[[000000000]]]]]]]]]]]]]]"
            IO.inspect bearerBody
            bearer = bearerBody["access_token"]
            IO.inspect bearer

            encryptedPin = rsaEncryptDataForAirtel("0122")
            xml = %{
              payee:
                %{
                  msisdn: "#{params.airtel_mobile}"
                },
              reference: params.orderRef,
              pin: encryptedPin,
              transaction:
                %{
                  amount: "#{params.enterdAmount}",
                  id: params.orderRef
                }
              }
            xml = Jason.encode!(xml)
            IO.inspect "xml -------------- DISBURSE"
            IO.inspect xml

            headers = [
                {"Content-Type", "application/json"},
                {"Accept", "*/*"},
                {"X-Country", "ZM"},
                {"X-Currency", "ZMW"},
                {"Authorization", "Bearer #{bearer}"}
              ]
            options = [timeout: 60000, recv_timeout: 60000]
            url = @base_url_staging <> "/standard/v1/disbursements/"

            case HTTPoison.request(:post, url, xml, headers, options) do
                {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
                    IO.inspect "00000000----DISBURSMENT FAILED----0000000000"
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
                  IO.inspect "DISBURSMENT WORKING"
                  bodyStruct =  Jason.decode!(struct.body)

                  # IO.inspect "LETS PARTY MAN"
                    IO.inspect struct

                  # IO.inspect bodyStruct
                  # IO.inspect struct
            end

        _->
          status_code = %{status_code: 400}
          IO.inspect status_code

      end
  end

  def disbursment_inquiry(transactionRef) do

    getToken = Savings.Service.Momo.AirtelServices.get_bearer_token
    statusCode = getToken.status_code

      case statusCode do

        200 ->

          bearerBody = getToken.body
          bearerBody =  Jason.decode!(bearerBody)
          IO.inspect "[[[[[[[[[[[[[000000000]]]]]]]]]]]]]]"
          IO.inspect bearerBody
          bearer = bearerBody["access_token"]
          IO.inspect bearer


          random_int3 = to_string(Enum.random(11111111..99999999))

          xml = %{}
          xml = Jason.encode!(xml)

          headers = [
              {"Content-Type", "application/json"},
              {"Accept", "*/*"},
              {"X-Country", "ZM"},
              {"X-Currency", "ZMW"},
              {"Authorization", "Bearer #{bearer}"}
            ]
          options = [timeout: 60000, recv_timeout: 60000]
          url = @base_url_staging <> "/standard/v1/payments/#{transactionRef}"

          case HTTPoison.request(:get, url, xml, headers, options) do
              {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
                  IO.inspect "000000000000000000"
                  IO.inspect reason

              {:ok, struct} ->
                IO.inspect "This is the struct"
                bodyStruct =  Jason.decode!(struct.body)

                # IO.inspect "LETS PARTY MAN"
                  IO.inspect struct

                # IO.inspect bodyStruct
                # IO.inspect struct
          end

        _->
          status_code = %{status_code: 400}
          IO.inspect status_code


    end
  end

  # Savings.Service.Momo.AirtelServices.customer_kyc(%{airtel_mobile: 978242442})
  def customer_kyc(params) do

    getToken = Savings.Service.Momo.AirtelServices.get_bearer_token
      statusCode = getToken.status_code
        case statusCode do
          200 ->

            bearerBody = getToken.body
            bearerBody =  Jason.decode!(bearerBody)
            IO.inspect "[[[[[[[[[[[[[000000000]]]]]]]]]]]]]]"
            IO.inspect bearerBody
            bearer = bearerBody["access_token"]
            IO.inspect bearer

            mobileNumberTruncated = params.airtel_mobile
            xml = %{}
            xml = Jason.encode!(xml)

            headers = [
                {"Content-Type", "application/json"},
                {"Accept", "*/*"},
                {"X-Country", "ZM"},
                {"X-Currency", "ZMW"},
                {"Authorization", "Bearer #{bearer}"}
              ]
            options = [timeout: 60000, recv_timeout: 60000]
            url = @base_url_staging <> "/standard/v1/users/#{mobileNumberTruncated}"

            case HTTPoison.request(:get, url, "", headers, options) do
                {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
                    IO.inspect "00000000----Customer KYC PROMPT FAILED----0000000000"
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
                  bodyStruct =  Jason.decode!(struct.body)

                  # IO.inspect "LETS PARTY MAN"
                    IO.inspect struct

                  # IO.inspect bodyStruct
                  # IO.inspect struct
            end

        _->
          status_code = %{status_code: 400}
          IO.inspect status_code

      end
  end

  # Savings.Service.Momo.AirtelServices.rsaEncryptDataForAirtel("0122")
  def rsaEncryptDataForAirtel(data) do
      pubkey = "-----BEGIN PUBLIC KEY-----\r\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCkq3XbDI1s8Lu7SpUBP+bqOs/MC6PKWz\r\n6n/0UkqTiOZqKqaoZClI3BUDTrSIJsrN1Qx7ivBzsaAYfsB0CygSSWay4iyUcnMVEDrNVO\r\nJwtWvHxpyWJC5RfKBrweW9b8klFa/CfKRtkK730apy0Kxjg+7fF0tB4O3Ic9Gxuv4pFkbQ\r\nIDAQAB\r\n-----END PUBLIC KEY----"
      IO.inspect pubkey
      [enc_p_key] = :public_key.pem_decode(pubkey)
      IO.inspect enc_p_key
      p_key = :public_key.pem_entry_decode(enc_p_key)
      IO.inspect p_key
      enc_msg = :public_key.encrypt_public(data, p_key)
      enc_msg = Base.encode64(enc_msg)
      IO.inspect enc_msg
      enc_msg
  end

end
