defmodule LoanSavingsSystem.Emails.Email do
  import Bamboo.Email
  # alias Bamboo.Attachment
  use Bamboo.Phoenix, view: LoanSavingsSystemWeb.EmailView
  alias LoanSavingsSystem.Emails.Mailer
  # alias Proxy.Notifications


  # def send_email_notification(attr) do
  #   Notifications.list_tbl_email_logs()
  #   |> Task.async_stream(&(email_alert(&1.email, attr) |> Mailer.deliver_now()),
  #     max_concurrency: 10,
  #     timeout: 30_000
  #   )
  #   |> Stream.run()
  # end

  # def password_alert(email, password) do
  #   password(email, password) |> Mailer.deliver_later()
  # end

  # def confirm_password_reset(token, email) do
  #   confirmation_token(token, email) |> Mailer.deliver_later()
  # end

  # def password(email, password) do
  #   new_email()
  #   |> from("johnmfula360@gmail.com")
  #   |> to("#{email}")
  #   |> put_html_layout({LoanSavingsSystemWeb.LayoutView, "email.html"})
  #   |> subject("Proxy Password")
  #   |> assign(:password, password)
  #   # |> assign(:user_credentials, %{password: password, username: username})
  #   |> render("password_content.html")
  # end

  # def confirmation_token(token, email) do
  #   new_email()
  #   |> from("johnmfula360@gmail.com")
  #   |> to("#{email}")
  #   |> put_html_layout({LoanSavingsSystemWeb.LayoutView, "email.html"})
  #   |> subject("Proxy Password Reset")
  #   |> assign(:token, token)
  #   |> render("token_content.html")
  # end

  def send_email(email, password, firstName) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{email}")
    |> subject("Account Creation")
    |> put_html_layout({LoanSavingsSystemWeb.LayoutView, "email.html"})
    |> subject("Customer Account Creation")
    |> assign(:password, password)
    |> assign(:firstName, firstName)
    |> render("user_email.html")
    |> Mailer.deliver_later()
  end

  def walking_creation_email(email, firstName) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{email}")
    |> subject("Account Creation")
    |> put_html_layout({LoanSavingsSystemWeb.LayoutView, "email.html"})
    |> subject("Customer Account Creation")
    |> assign(:firstName, firstName)
    |> render("walking_creation_email.html")
    |> Mailer.deliver_later()
  end

  def send_statement_of_account(email, userBioData, client, pdfFile) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{email}")
	  |> put_attachment(pdfFile)
    |> put_html_layout({LoanSavingsSystemWeb.LayoutView, "email.html"})
    |> subject("ZIPAKE - Statement Of Account")
    |> assign(:userBioData, userBioData)
    |> assign(:client, client)
    |> render("statement_of_account.html")
    |> Mailer.deliver_later()
  end
end
