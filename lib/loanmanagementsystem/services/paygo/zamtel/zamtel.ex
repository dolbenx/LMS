defmodule Loanmanagemet.Services.Paygo.Zamtel.Zamtel do

  @base_url_staging ""
# Loanmanagemet.Services.Paygo.Zamtel.Zamtel.customer_account_details
  def customer_account_details(params) do

    xml = %{
            username: params.username,
            password: params.password,
            serviceid: params.serviceid,
            clientid: params.clientid,
            requesttype: params.requesttype,
            payload: %{mobile_number: params.mobile_number}
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
# Loanmanagemet.Services.Paygo.Zamtel.Zamtel.business_to_business
  def business_to_business(params) do

    xml = %{
          username: params.username,
          password: params.password,
          serviceid: params.serviceid,
          clientid: params.clientid,
          amount: params.amount,
          accountno: params.accountno,
          # -- customers mobile number
          msisdn: params.msisdn,
          # -- customers mobile number
          currencycode: params.currencycode,
          transactionid: params.transactionid,
          timestamp: Timex.now
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
# Loanmanagemet.Services.Paygo.Zamtel.Zamtel.customer_paybills
  def customer_paybills(params) do
    xml = %{
            username: params.username,
            password: params.password,
            serviceid: params.serviceid,
            #-- test service id
            clientid: params.clientid,
            amount: params.amount,
            accountno: params.accountno,
            #-- customers mobile number
            msisdn: params.msisdn,
            #-- customers mobile number
            currencycode: params.currencycode,
            transactionid: params.transactionid,
            #-- must be unique for every transaction
            timestamp: Timex.now
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
