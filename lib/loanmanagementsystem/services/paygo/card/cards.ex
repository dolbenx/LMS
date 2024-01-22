defmodule Loanmanagement.Services.Paygo.Card.Cards do

  @base_url_staging ""

  def api_requests(params) do

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
              resulturl: params.resulturl,
              timestamp: Timex.now,
              payload: rsaEncryptDataForCard(params.payload)
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



  def rsaEncryptDataForCard(data) do
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
