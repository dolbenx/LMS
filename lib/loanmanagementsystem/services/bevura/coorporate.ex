defmodule Loanmanagement.Services.Bevura.Coorperate do

  @base_url_staging "http://136.244.113.153/Api/V1/MerchantTransfers"
  @auth_token "RzsppPgmkhrTcwflwynu8dFxgdZmrjstqXvcfx7AwNEdjnsbfwEEvPCnGcAxKwedJVb8qdyrb3wbl2Qrarrz5njsndmew2axBh6quzrHRMxtKMs5"
  @security "boImF1xhNyFnO+RD0EDFF5s8t/BkRVFwJaWC75rpKyI="


  # Loanmanagement.Services.Bevura.Coorperate.customer_lookup
  def customer_lookup(params) do

    xml = %{
      data: %{
        transaction: %{
          mobile: params["mobile"]
        }
      }
    }
    xml = Jason.encode!(xml)
    headers = [
      {"Content-Type", "application/json"},
      {"Accept", "*/*"},
      {"auth_token", @auth_token},
      {"security", @security}
    ]

    url = @base_url_staging <> "/CustomerLookup"

    case HTTPoison.request(:post, url, xml, headers) do

      {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
          IO.inspect "000000000000000000"
          IO.inspect reason

      {:ok, struct} ->
        IO.inspect "This is the struct"
        bodyStruct =  Jason.decode!(struct.body)
        IO.inspect bodyStruct
        # IO.inspect struct
    end

  end
  # Loanmanagement.Services.Paygo.Airtel.Airtel.disbursements
  def disbursements(params) do
    xml = %{
            username: params.username,
            password: params.password,
            serviceid: params.serviceid,
            clientid: params.clientid,
            amount: params.amount,
            accountno: params.accountno,
            msisdn: params.msisdn,
            currencycode: params.currencycode,
            transactionid: params.transactionid,
            timestamp: Timex.now,
              payload: %{
              narration: "collections for #{params.accountno}" ,
              country: params.country
              }
          }


    xml = Jason.encode!(xml)

    url = @base_url_staging <> "/ServiceLayer/request/postRequest"

    case HTTPoison.request(:get, url, xml, @headers) do
      {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
          IO.inspect "000000000000000000"
          IO.inspect reason

      {:ok, struct} ->
        IO.inspect "This is the struct"
        bodyStruct =  Jason.decode!(struct.body)
        IO.inspect bodyStruct
        # IO.inspect struct
    end
  end
  # Loanmanagement.Services.Paygo.Airtel.Airtel.account_balance
  def account_balance(params) do
    xml = %{
      username: params.username,
      password: params.password,
      serviceid: params.serviceid,
      clientid: params.clientid,
      requesttype: params.requesttype,
        payload: %{
        stage: params.stage
        }
      }


    xml = Jason.encode!(xml)

    url = @base_url_staging <> "/ServiceLayer/request/postRequest"

    case HTTPoison.request(:get, url, xml, @headers) do
      {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
          IO.inspect "000000000000000000"
          IO.inspect reason

      {:ok, struct} ->
        IO.inspect "This is the struct"
        bodyStruct =  Jason.decode!(struct.body)
        IO.inspect bodyStruct
        # IO.inspect struct
    end
  end
  # Loanmanagement.Services.Paygo.Airtel.Airtel.check_customer_info
  def check_customer_info(params) do
    xml = %{
            username: params.username ,
            password: params.password ,
            serviceid: params.serviceid,
            clientid: params.clientid,
            requesttype: params.requesttype,
                  payload: %{
                  stage: params.stage,
                  phonenumber: params.phonenumber
                  }
          }


    xml = Jason.encode!(xml)

    url = @base_url_staging <> "/ServiceLayer/request/postRequest"

    case HTTPoison.request(:get, url, xml, @headers) do
      {:error, %HTTPoison.Error{id: nil, reason: reason}} ->
          IO.inspect "000000000000000000"
          IO.inspect reason

      {:ok, struct} ->
        IO.inspect "This is the struct"
        bodyStruct =  Jason.decode!(struct.body)
        IO.inspect bodyStruct
        # IO.inspect struct
    end
  end

end
