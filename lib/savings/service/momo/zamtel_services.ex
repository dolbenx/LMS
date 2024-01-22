defmodule Savings.Service.Momo.ZamtelServices do

  @base_url_staging "https://openapiuat.airtel.africa"
  @client_id "58be9103-d299-4142-8f28-8091edaf2825"
  @client_secret "39dec581-7e03-4251-98d9-b787fef4a54e"
  @grant_type "client_credentials"



  # Savings.Service.Airtel.AirtelServices.get_bearer_token
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

    url = @base_url_staging <> "/auth/oauth2/token"

    case HTTPoison.request(:post, url, xml, headers) do
        {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
            IO.inspect "000000000000000000"
            IO.inspect reason

        {:ok, struct} ->
          IO.inspect "This is the struct"
          # bodyStruct =  Jason.decode!(struct.body)
          IO.inspect struct
          # IO.inspect struct
    end

  end

  # Savings.Service.Airtel.AirtelServices.customer_push(%{})
  def customer_push(params) do

    getToken = Savings.Service.Airtel.AirtelServices.get_bearer_token
    statusCode = getToken.status_code

      case statusCode do

        201 ->
          []

        200 ->

          bearerBody = getToken.body
          bearerBody =  Jason.decode!(bearerBody)
          IO.inspect "[[[[[[[[[[[[[000000000]]]]]]]]]]]]]]"
          IO.inspect bearerBody
          bearer = bearerBody["access_token"]
          IO.inspect bearer


          random_int3 = to_string(Enum.random(11111111..99999999))

          xml = %{
            reference: "REA Test Transaction",
            subscriber: %{
                    country: "ZM",
                    currency: "ZMW",
                    msisdn: "#{params.airtel_mobile}"
                },
            transaction: %{
                    amount: "#{params.enterdAmount}",
                    country: "ZM",
                    currency: "ZMW",
                    id: random_int3
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

          url = @base_url_staging <> "/merchant/v1/payments/"

          case HTTPoison.request(:post, url, xml, headers) do
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

    end
  end

end
