defmodule Loanmanagement.Services.Paygo.Airtel.Airtel do

  @base_url_staging ""


  # Loanmanagement.Services.Paygo.Airtel.Airtel.collections
  def collections(params) do

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
              narration: "collections for #{params.accountno}",
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
