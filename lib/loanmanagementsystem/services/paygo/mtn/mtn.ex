defmodule Loanmanagement.Services.Paygo.Mtn.Mtn do

  @base_url_staging ""
# Loanmanagement.Services.Paygo.Mtn.Mtn.collections
  def collections(params) do

    xml = %{
      username: params.username,
      password: params.password,
      serviceid: 1,
      clientid: params.clientid,
      amount: params.amount,
      accountno: params.accountno,
      msisdn: params.msisdn,
      currencycode: params.currencycode,
      transactionid: params.transactionid,
      timestamp: Timex.now,
        payload: %{
          accounttype: params.accounttype,
          narration: "collections for - #{params.accountno}"
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
# Loanmanagement.Services.Paygo.Mtn.Mtn.disbursements
  def disbursements(params) do
    xml = %{
      username: params.username,
      password: params.password,
      serviceid: 2,
      clientid: params.clientid,
      amount: params.amount,
      accountno: params.accountno,
      msisdn: params.msisdn,
      currencycode: params.currencycode,
      transactionid: params.transactionid,
      timestamp: Timex.now,
        payload: %{
          accounttype: params.accounttype,
          narration: "disbursements for - #{params.accountno}"
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
# Loanmanagement.Services.Paygo.Mtn.Mtn.remittances
  def remittances(params) do
    xml = %{
      username: params.username,
      password: params.password,
      serviceid: 3,
      clientid: params.clientid,
      amount: params.amount,
      accountno: params.accountno,
      msisdn: params.msisdn,
      currencycode: params.currencycode,
      transactionid: params.transactionid,
      timestamp: Timex.now,
        payload: %{
          accounttype: params.accounttype,
          narration: "remittances for - #{params.accountno}"
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
