defmodule SavingsWeb.ExportPDFController do
  use SavingsWeb, :controller
  alias SavingsWeb.ExportController
  alias Savings.Transactions

  def customer_view_pdf(conn, params) do
    Savings.Service.QueriesExport.customer_export()
    |> Savings.Service.ReportToPdf.get_customer_list()
    |> customer_process_pdf(conn)
  end

  defp customer_process_pdf(content, conn) do
    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=Customer_Report_#{Savings.Util.Time.local_time()}.pdf"
      )
      |> put_resp_content_type("text/pdf")

    send_resp(conn, 200, content)
  end

  #####################################################################################################################


  def tnx_fixed_deps_view_pdf(conn, params) do
    Savings.Service.QueriesExport.fix_dep_export()
    |> Savings.Service.ReportToPdf.get_tnx_fixed_deps_list()
    |> process_pdf(conn)
  end

  defp process_pdf(content, conn) do
    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=Fixed_Deposists_Report_#{Savings.Util.Time.local_time()}.pdf"
      )
      |> put_resp_content_type("text/pdf")

    send_resp(conn, 200, content)
  end

   #####################################################################################################################

   def partial_divestment_view_pdf(conn, params) do
    Savings.Service.QueriesExport.partial_divestment_export()
    |> Savings.Service.ReportToPdf.get_partial_divestment_list()
    |> partial_divestment_process_pdf(conn)
  end

  defp partial_divestment_process_pdf(content, conn) do
    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=Partial_Divestment_Report_#{Savings.Util.Time.local_time()}.pdf"
      )
      |> put_resp_content_type("text/pdf")

    send_resp(conn, 200, content)
  end

  #####################################################################################################################

  def full_divestment_view_pdf(conn, params) do
    Savings.Service.QueriesExport.full_divestment_export()
    |> Savings.Service.ReportToPdf.get_full_divestment_list()
    |> full_divestment_process_pdf(conn)
  end

  defp full_divestment_process_pdf(content, conn) do
    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=Full_Divestment#{Savings.Util.Time.local_time()}.pdf"
      )
      |> put_resp_content_type("text/pdf")

    send_resp(conn, 200, content)
  end

  #####################################################################################################################

  def mature_withdraw_view_pdf(conn, params) do
    Savings.Service.QueriesExport.mature_withdraw_export()
    |> Savings.Service.ReportToPdf.get_mature_withdraw_list()
    |> mature_withdraw_process_pdf(conn)
  end

  defp mature_withdraw_process_pdf(content, conn) do
    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=Mature_Withdraw_Report_#{Savings.Util.Time.local_time()}.pdf"
      )
      |> put_resp_content_type("text/pdf")

    send_resp(conn, 200, content)
  end

  #####################################################################################################################

  def all_transactions_view_pdf(conn, params) do
    Savings.Service.QueriesExport.all_transactions_export()
    |> Savings.Service.ReportToPdf.get_all_transactions_list()
    |> all_transactions_process_pdf(conn)
  end

  defp all_transactions_process_pdf(content, conn) do
    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=All_Transactions_Report_#{Savings.Util.Time.local_time()}.pdf"
      )
      |> put_resp_content_type("text/pdf")

    send_resp(conn, 200, content)
  end

  #####################################################################################################################


  def report_fixed_deps_view_pdf(conn, params) do
    Savings.Service.QueriesExport.fix_dep_report_export()
    |> Savings.Service.ReportToPdf.get_report_fixed_deps_list()
    |> process_report_pdf(conn)
  end

  defp process_report_pdf(content, conn) do
    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=Fixed_Deposists_Report_#{Savings.Util.Time.local_time()}.pdf"
      )
      |> put_resp_content_type("text/pdf")

    send_resp(conn, 200, content)
  end


  #####################################################################################################################

  def report_deposit_summury_view_pdf(conn, params) do
    Savings.Service.QueriesExport.report_deposit_summury_export()
    |> Savings.Service.ReportToPdf.get_report_deposit_summury_list()
    |> report_deposit_summury_process_pdf(conn)
  end

  defp report_deposit_summury_process_pdf(content, conn) do
    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=Report_Deposit_Summury#{Savings.Util.Time.local_time()}.pdf"
      )
      |> put_resp_content_type("text/pdf")

    send_resp(conn, 200, content)
  end


  #####################################################################################################################

  def report_deposit_interest_view_pdf(conn, params) do
    Savings.Service.QueriesExport.report_deposit_interest_export()
    |> Savings.Service.ReportToPdf.get_report_deposit_interest_list()
    |> report_deposit_interest_process_pdf(conn)
  end

  defp report_deposit_interest_process_pdf(content, conn) do
    conn =
      conn
      |> put_resp_header(
        "content-disposition",
        "attachment; filename=Report_Deposit_Interest#{Savings.Util.Time.local_time()}.pdf"
      )
      |> put_resp_content_type("text/pdf")

    send_resp(conn, 200, content)
  end

end
