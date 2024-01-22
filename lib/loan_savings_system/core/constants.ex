defmodule Core.Constants do
  @exception "EXCEPTION"
  @success "SUCCESS"
  @pending "PENDING"
  @sent "SENT"
  @failed "FAILED"
  @complete "COMPLETE"
  @pending_bank "PENDING_BANK_PAYMENT"
  @pending_verification "PENDING_VERIFICATION"
  @ready "READY"
  @probase_sms "PROBASE_SMS"
  @sms_auth_username "SMS_AUTH_USERNAME"
  @sms_auth_password "SMS_AUTH_PASSWORD"
  @sms_sender_id "SMS_SENDER_ID"
  @sms_max_attempt "SMS_MAXIMUM_ATTEMPTS"

  def complete(), do:  @complete
  def sent(), do: @sent
  def success(), do: @success
  def failed(), do: @failed
  def exception(), do: @exception
  def pending(), do: @pending
  def pending_bank(), do: @pending_bank
  def pending_verification(), do: @pending_verification
  def ready(), do: @ready
  def sms_url(), do: @probase_sms
  def sms_auth_name(), do: @sms_auth_username
  def sms_auth_password(), do: @sms_auth_password
  def sms_sender_id(), do: @sms_sender_id
  def sms_max_attempt(), do: @sms_max_attempt

end
