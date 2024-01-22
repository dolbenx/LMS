defmodule Savings.Service.Momo.MtnServices do

  @base_url_staging "https://sandbox.momodeveloper.mtn.com"
  @auth "f1548409-2a89-4d2d-9911-5bd148d856c8:31d9a1db13c44f61a842c19e4ed3581d" |> Base.encode64()
  @x_Target_Environment "sandbox"
  @ocp_Apim_Subscription_Key "558950feda1c414fad27611c17271897"



  # Savings.Service.Momo.MtnServices.get_bearer_token
  def get_bearer_token do

    xml = %{}
    xml = Jason.encode!(xml)

    headers = [
      {"Content-Type", "application/text"},
      {"Authorization", "Basic #{@auth}"},
      {"X-Target-Environment", @x_Target_Environment},
      {"Ocp-Apim-Subscription-Key", "#{@ocp_Apim_Subscription_Key}"},
  ]

    url = @base_url_staging <> "/collection/token/"

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

  # Savings.Service.Momo.AirtelServices.customer_push(%{})
  def customer_push(params) do

    getToken = Savings.Service.Momo.MtnServices.get_bearer_token
    statusCode = getToken.status_code

      case statusCode do

        200 ->

          bearerBody = getToken.body
          bearerBody =  Jason.decode!(bearerBody)
          IO.inspect "[[[[[[[[[[[[[000000000]]]]]]]]]]]]]]"
          IO.inspect bearerBody
          bearer = bearerBody["access_token"]
          IO.inspect bearer


          transaction_ref = params.transaction_ref

          xml = %{
              amount: "#{params.enterdAmount}",
              currency: "EUR",
              externalId: "135791226",
                payer: %{
                    partyIdType: "MSISDN",
                    partyId: params.mobile_number
                },
                payerMessage: "Submitted",
                payeeNote: "accepted"
          }
          xml = Jason.encode!(xml)

          headers = [
            {"Content-Type", "application/json"},
            {"X-Reference-Id", transaction_ref},
            {"Authorization", "Bearer #{bearer}"},
            {"X-Target-Environment", @x_Target_Environment},
            {"Ocp-Apim-Subscription-Key", @ocp_Apim_Subscription_Key}
            ]

          url = @base_url_staging <> "/collection/v1_0/requesttopay"

          case HTTPoison.request(:post, url, xml, headers) do
              {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
                  IO.inspect "000000000000000000"
                  IO.inspect reason

              {:ok, struct} ->
                IO.inspect "This is the struct"
                # bodyStruct =  Jason.decode!(struct.body)

                # IO.inspect "LETS PARTY MAN"
                  IO.inspect struct

                # IO.inspect bodyStruct
                # IO.inspect struct
          end

        _->
          data = getToken.body |> Poison.decode!()
            case getToken.status_code do
              400 -> {:error, data["error_description"], data}
              401 -> {:error, data["message"], data}
              404 -> {:error, data["message"], data}
              408 -> {:error, data["status_code"], data}
            end

    end
  end

  # Savings.Service.Momo.MtnServices.transaction_inquiry
  def transaction_inquiry(transactionRef) do

    getToken = Savings.Service.Momo.MtnServices.get_bearer_token
    statusCode = getToken.status_code

      case statusCode do

        200 ->

          bearerBody = getToken.body
          bearerBody =  Jason.decode!(bearerBody)
          IO.inspect "[[[[[[[[[[[[[000000000]]]]]]]]]]]]]]"
          IO.inspect bearerBody
          bearer = bearerBody["access_token"]
          IO.inspect bearer


          transaction_ref = UUID.uuid4()

          xml = %{}
          xml = Jason.encode!(xml)

          headers = [
            {"Content-Type", "application/json"},
            {"X-Reference-Id", transaction_ref},
            {"Authorization", "Bearer #{bearer}"},
            {"X-Target-Environment", @x_Target_Environment},
            {"Ocp-Apim-Subscription-Key", @ocp_Apim_Subscription_Key}
            ]

          url = @base_url_staging <> "/collection/v1_0/requesttopay/#{transactionRef}"

          case HTTPoison.request(:get, url, xml, headers) do
              {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
                  IO.inspect "000000000000000000"
                  IO.inspect reason

              {:ok, struct} ->
                IO.inspect "This is the struct tnx"
                bodyStruct =  Jason.decode!(struct.body)

                # IO.inspect "LETS PARTY MAN"
                  IO.inspect struct

                # IO.inspect bodyStruct
                # IO.inspect struct
          end

        _->
          data = getToken.body |> Poison.decode!()
            case getToken.status_code do
              400 -> {:error, data["error_description"], data}
              401 -> {:error, data["message"], data}
              404 -> {:error, data["message"], data}
              408 -> {:error, data["status_code"], data}
            end


    end
  end

end
