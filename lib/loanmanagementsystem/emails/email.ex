defmodule Loanmanagementsystem.Emails.Email do
  import Bamboo.Email
  # alias Bamboo.Attachment
  use Bamboo.Phoenix, view: LoanmanagementsystemWeb.EmailView
  alias Loanmanagementsystem.Emails.Mailer
  # alias Proxy.Notifications
  alias Loanmanagementsystem.EmailConfig

  # def send_email_notification(attr) do
  #   Notifications.list_tbl_email_logs()
  #   |> Task.async_stream(&(email_alert(&1.email, attr) |> Mailer.deliver_now()),
  #     max_concurrency: 10,
  #     timeout: 30_000
  #   )
  #   |> Stream.run()
  # end

  def password_alert(email, password) do
    password(email, password) |> Mailer.deliver_later()
  end

  # def confirm_password_reset(email, otp) do
  #   send_otp(email, otp) |> Mailer.deliver_later()
  # end

  def password(email, password) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{email}")
    |> put_html_layout({LoanmanagementsystemWeb.LayoutView, "email.html"})
    |> subject("Proxy Password")
    |> assign(:password, password)
    # # |> assign(:user_credentials)
    #   %{password: password, username: username}
    |> render("password_content.html")
  end

  def send_otp(email, otp) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{email}")
    |> put_html_layout({LoanmanagementsystemWeb.LayoutView, "email.html"})
    |> subject("Password Reset OTP")
    |> assign(:otp, otp)
    |> render("send_otp.html")
    |> Mailer.deliver_later()
  end

  def send_email(emailAddress, password) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{emailAddress}")
    |> subject("Account Creation")
    |> put_html_layout({LoanmanagementsystemWeb.EmailView, "profile_creation.html"})
    |> subject("Customer Account Creation")
    |> assign(:password, password)
    |> render("profile_creation.html")
    |> Mailer.deliver_later()
  end

  def compose_email(recipient, subject, body) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{recipient}")
    |> subject("#{subject}")
    |> text_body("#{body}")
    |> Mailer.deliver_later()
  end

  def notify_customer(email_address, password, customer_no) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{email_address}")
    |> put_html_layout({LoanmanagementsystemWeb.LayoutView, "email.html"})
    |> subject("Customer Account Creation")
    |> assign(:password, password)
    |> assign(:customer_no, customer_no)
    |> render("profile_creation.html")
    |> Mailer.deliver_later()
  end

  def eod(recipient, company_loans_info) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to(recipient)
    |> put_html_layout({LoanmanagementsystemWeb.LayoutView, "email.html"})
    |> subject("End of day Report")
    |> assign(:company_loans_info, company_loans_info)
    |> render("send_eoc.html")
    |> Mailer.deliver_later()
  end

  def sod(items, recipient) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to(recipient)
    |> subject("Start Of Day Report as at #{Timex.now()}")
    |> render("send_eoc.html", items: items)
    |> Mailer.deliver_later()
  end

  def eom(items, recipient) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to(recipient)
    |> subject("End of Month Report as at #{Timex.now()}")
    |> render("send_eoc.html", items: items)
    |> Mailer.deliver_later()
  end

  def eoy(items, recipient) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to(recipient)
    |> subject("End of Year Report as at #{Timex.now()}")
    |> render("send_eoc.html", items: items)
    |> Mailer.deliver_later()
  end

  def estate(email_address) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("#{email_address}")
    |> put_html_layout({LoanmanagementsystemWeb.LayoutView, "email.html"})
    |> subject("End of Day Statement Report as at #{Timex.now()}")
    |> render("estatement.html")
    |> Mailer.deliver_later()
  end

  def eoy(items, recipient) do
    new_email()
    |> from("johnmfula360@gmail.com")
    |> to("kabumbwerussell@gmail.com")
    |> subject("End of day #{Timex.now()}")
    |> render("send_eoc.html", items: items)
    |> Mailer.deliver_later()
  end

  # def send_monthly_report() do
  #   new_email()
  #   |> from("johnmfula360@gmail.com")
  #   |> to("kabumbwerussell@gmail.com")
  #   |> put_html_layout({LoanmanagementsystemWeb.LayoutView, "email.html"})
  #   |> subject("Monthly Loans Report")
  #   |> assign(:monthly_loans, monthly_loans)
  #   |> give("monthly_reports.html", monthly_loans: monthly_loans)
  #   |> Mailer.deliver_later()
  # end

  def send_monthly_report(recipient, monthly_loans) do
    sender = EmailConfig.list_tbl_email_sender() |> List.first()

    new_email()
    # |> from("johnmfula360@gmail.com")
    |> from(sender.email)
    |> to(recipient.email)
    |> put_html_layout({LoanmanagementsystemWeb.LayoutView, "email.html"})
    |> subject("Monthly Loan Report")
    |> assign(:monthly_loans, monthly_loans)
    |> render("monthly_reports.html")
    |> Mailer.deliver_later()
  end

  def send_daily_report(recipient, daily_loans) do
    sender = EmailConfig.list_tbl_email_sender() |> List.first()

    new_email()
    # |> from("johnmfula360@gmail.com")
    |> from(sender.email)
    |> to(recipient.email)
    |> put_html_layout({LoanmanagementsystemWeb.LayoutView, "email.html"})
    |> subject("Daily Loan Report")
    |> assign(:daily_loans, daily_loans)
    |> render("daily_reports.html")
    |> Mailer.deliver_later()
  end

  # For no transactions
  def send_monthly_notice(recipient, monthly_loans) do
    sender = EmailConfig.list_tbl_email_sender() |> List.first()

    new_email()
    # |> from("johnmfula360@gmail.com")
    |> from(sender.email)
    |> to(recipient.email)
    |> put_html_layout({LoanmanagementsystemWeb.LayoutView, "email.html"})
    |> subject("Monthly Loan Report")
    |> assign(:monthly_loans, monthly_loans)
    |> render("monthly__no_txn_reports.html")
    |> Mailer.deliver_later()
  end

  def send_daily_notice(recipient, daily_loans) do
    sender = EmailConfig.list_tbl_email_sender() |> List.first()

    new_email()
    # |> from("johnmfula360@gmail.com")
    |> from(sender.email)
    |> to(recipient.email)
    |> put_html_layout({LoanmanagementsystemWeb.LayoutView, "email.html"})
    |> subject("Daily Loan Report")
    |> assign(:daily_loans, daily_loans)
    |> render("daily__no_txn_reports.html")
    |> Mailer.deliver_later()
  end

  # For no transactions

  def send_monthly_loans_summary(recipient) do
    sender = EmailConfig.list_tbl_email_sender() |> List.first()
    monthly_loans = Loanmanagementsystem.Loan.get_comp_monthly_loans_fragm()
    monthly_loans_by_company = Loanmanagementsystem.Loan.get_monthly_loans_by_companies()
    monthly_loans_totals = Loanmanagementsystem.Loan.get_monthly_loans_tatols()

    new_email()
    # |> from("johnmfula360@gmail.com")
    |> from(sender.email)
    |> to(recipient.email)
    |> put_html_layout({LoanmanagementsystemWeb.LayoutView, "email.html"})
    |> subject("Loan Summary Report")
    |> assign(:monthly_loans, monthly_loans)
    |> assign(:monthly_loans_by_company, monthly_loans_by_company)
    |> assign(:monthly_loans_totals, monthly_loans_totals)
    |> render("monthl_loan_summary_report.html")
    |> Mailer.deliver_later()
  end
end
